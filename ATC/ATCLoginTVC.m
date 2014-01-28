//
//  ATCLoginTVC.m
//  ATC
//
//  Created by CA on 12/16/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCLoginTVC.h"
#import "ATCUserAuthHelper.h"
#import "UIView+addShadow.h"
#import "UIBarButtonItem+customBackground.h"

#define USER_INPUT_SECTION 0
#define USER_INPUT_UNAME_ROW 0
#define USER_INPUT_PWORD_ROW 1

#define USERNAME_TEXTVIEW_TAG 10
#define PASSWORD_TEXTVIEW_TAG 11

#define BACKGROUND_VIEW_TAG 98

#define POST_BUTTON_SECTION 1
#define POST_BUTTON_ROW 0


#define HEIGHT_OFFSET 200

@interface ATCLoginTVC ()

@end

@implementation ATCLoginTVC

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.areCurrentlyLoggingIn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.tableView.backgroundColor = [ATCColorPalette lightBackgroundColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(HEIGHT_OFFSET,0,0,0)];
    
    [self addBackgroundImage];
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Initial setup
-(void)addBackgroundImage
{
    UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    CGFloat xPos = self.view.frame.size.width/2 - width/2;
    CGFloat yPos = HEIGHT_OFFSET/2 - height/2;
    CGRect rectForImage = CGRectMake(xPos, yPos, width, height);
    imageView.frame = rectForImage;
    [imageView.layer setCornerRadius:15];
    imageView.layer.masksToBounds = YES;
    
    
    UIView *background = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.tag = BACKGROUND_VIEW_TAG;
    [background addSubview:imageView];
    self.tableView.backgroundView = background;
}

#pragma mark - Layout related
-(void)setUpNavBar
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    imageView.contentMode = UIViewContentModeLeft;
    [self.navigationController.navigationBar setBackgroundImage:[ATCColorPalette imageFromColor:[ATCColorPalette navigationBar]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
    [self.navigationController.navigationBar addSurroundingShadowWithRadius:5];
    self.navigationItem.title = @"Pollr";
    
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem customBackButtonWithTitle:@"Cancel" target:self selector:@selector(dismissView)];
    self.navigationItem.leftBarButtonItem  = cancelButton;
    
    
    UIBarButtonItem* login = [UIBarButtonItem customBarButtonWithTitle:@"Login" target:self selector:@selector(initiateLogin)];
    self.navigationItem.rightBarButtonItem = login;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger amountOfRows = 0;
    switch (section) {
        case USER_INPUT_SECTION:
        {
            amountOfRows = 2;
            break;
        }
        case POST_BUTTON_SECTION:
        {
            amountOfRows = 1;
            break;
        }
        default:
            NSAssert1(nil, @"Wrong sections in loginview", nil);
            break;
    }
    return amountOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == POST_BUTTON_SECTION) {
        [self setUpRegisterButton:cell];
    } else {
        switch (indexPath.row) {
            case USER_INPUT_UNAME_ROW:
            {
                [self setUpLoginCellCommonAttributes:cell asUserName:YES];
                [self setUpUserNameCell:cell];
                break;
            }
            case USER_INPUT_PWORD_ROW:
            {
                [self setUpLoginCellCommonAttributes:cell asUserName:NO];
                [self setUpPasswordCell:cell];
                break;
            }
            default:
                NSAssert1(nil, @"Wrong number of cells in loginview?", nil);
                break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setUpLoginCellCommonAttributes:(UITableViewCell*)cell asUserName:(BOOL)userNameOrNot
{
    CGRect adjustedFrameOfCell = CGRectInset(cell.bounds, 20, 10);
    UITextField *textField = [[UITextField alloc] initWithFrame:adjustedFrameOfCell];
    textField.textColor = [ATCColorPalette loginCellFontColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont fontWithName:@"Helvetica" size:22];
    textField.textColor = [ATCColorPalette loginCellFontColor];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.tag = userNameOrNot ? USERNAME_TEXTVIEW_TAG : PASSWORD_TEXTVIEW_TAG;
    textField.delegate = self;
    [cell addSubview:textField];
    cell.backgroundColor = [ATCColorPalette loginCellBackgroundColor];
}

-(void)setUpUserNameCell:(UITableViewCell*)cell
{
    UITextField *userName = (UITextField*)[cell viewWithTag:USERNAME_TEXTVIEW_TAG];
    [userName setPlaceholder:@"User name"];
    userName.returnKeyType = UIReturnKeyNext;
}

-(void)setUpPasswordCell:(UITableViewCell*)cell
{
    UITextField *password = (UITextField*)[cell viewWithTag:PASSWORD_TEXTVIEW_TAG];
    password.placeholder = @"Password";
    password.clearsOnBeginEditing = YES;
    password.secureTextEntry = YES;
}

-(void)setUpRegisterButton:(UITableViewCell*)cell
{
    cell.textLabel.text = @"Register";
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //make it invisible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel sizeToFit];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    switch (section) {
        case USER_INPUT_SECTION:
        {
            height = 30;
            break;
        }
        case POST_BUTTON_SECTION:
        {
            height = 30;
            break;
        }
        default:
            NSAssert1(nil, @"Wrong secions in loginview", nil);
            break;
    }
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == POST_BUTTON_SECTION) {
        [self openRegistration];
    }
    
}

#pragma mark Registration
-(void)openRegistration
{
    NSString* launchUrl = @"http://atc.dflemstr.name/signup";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

#pragma mark -
#pragma mark Login
-(void)initiateLogin
{
    NSIndexPath *uNameIP = [NSIndexPath indexPathForRow:USER_INPUT_UNAME_ROW inSection:USER_INPUT_SECTION];
    NSIndexPath *pWord = [NSIndexPath indexPathForRow:USER_INPUT_PWORD_ROW inSection:USER_INPUT_SECTION];
    NSString *userName = ((UITextField*)[[self.tableView cellForRowAtIndexPath:uNameIP] viewWithTag:USERNAME_TEXTVIEW_TAG]).text;
    NSString *passWord = ((UITextField*)[[self.tableView cellForRowAtIndexPath:pWord] viewWithTag:PASSWORD_TEXTVIEW_TAG]).text;
    [[ATCServerInterface sharedServerInterface] initiateLoginUserName:userName passWord:passWord callBackTo:self];

}

-(void)loginActionHasCompleted:(ServerResponse)loginResponse
{
    switch (loginResponse) {
        case ServerResponseSuccess:
        {
            [self dismissView];
            break;
        }
        case ServerResponseTimeout:
        {
            [self showTimeOutAlert];
            break;
        }
        case ServerResponseUnauthorized:
        {
            [self showWrongInputAlert];
            break;
        }
            
        default:
            NSAssert1(nil, @"Should never behere, wrong loginaction typedef in loginview!",nil);
            break;
    }
}

#pragma mark User Notification

#pragma mark -
#pragma mark LoginComplete responses
-(void)showTimeOutAlert
{
    NSString *title = @"Timed out";
    NSString *message = @"The internet connection timed out. Please try again";
    [self popAlertWithTitle:title message:message];
}
-(void)showWrongInputAlert
{
    NSString *title = @"Wrong input";
    NSString *message = @"No combination of that user name and password was found, please double check the input";
    [self popAlertWithTitle:title message:message];    
}

-(void)popAlertWithTitle:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
	[alert show];
}

#pragma mark
#pragma mark Navigation related
-(void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];    
}

#pragma mark TExtfield Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = NO;
    if (textField.tag == USERNAME_TEXTVIEW_TAG) {
        NSIndexPath *pWord = [NSIndexPath indexPathForRow:USER_INPUT_PWORD_ROW inSection:USER_INPUT_SECTION];
        UITextField *passWord = (UITextField*)[[self.tableView cellForRowAtIndexPath:pWord] viewWithTag:PASSWORD_TEXTVIEW_TAG];
        [passWord becomeFirstResponder];
        [self.tableView scrollToRowAtIndexPath:pWord atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        [textField resignFirstResponder];
        shouldReturn = YES;
    }
    return shouldReturn;
}

@end
