//
//  ATCCreateQuestionTVC.m
//  ATC
//
//  Created by CA on 12/7/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCCreateQuestionTVC.h"
#import "UITextView+sizeFontToFitFrame.h"
#import "ATCUserAuthHelper.h"

#import "ATCCustomSectionHeader.h"
#import "ATCCustomCellBackground.h"
#import "UIView+addShadow.h"
#import "UIBarButtonItem+customBackground.h"

//TableViewManaging
#define QUESTION_TITLE_SECTION 0
#define QUESTION_TITLE_ROW 0

#define ALTERNATIVE_TEXT_VIEW_TAG 98
#define QUESTION_TITLE_TAG 99

#define ALTERNATIVE_SECTION 1

//Question Managing
#define MAX_CHARACTERS_IN_QUESTION 140
#define MAX_CHARACTERS_IN_ALTERNATIVE 80

//Layout
#define CELL_Y_Padding 5
#define CELL_X_Padding 5
#define CELL_X_MARGIN 10
#define QUESTION_TITLE_DEFAULT_HEIGHT 80
#define ALTERNATIVE_DEFAULT_HEIGHT 50


@interface ATCCreateQuestionTVC ()

@end

@implementation ATCCreateQuestionTVC

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.alternativeTextViews = [[NSMutableArray alloc] init];
        [self insertTextViewsToAlternativeArray];
        [self insertTextViewsToAlternativeArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [ATCColorPalette lightBackgroundColor];
    self.tableView.backgroundView = nil;
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - Layout related
-(void)setUpNavBar
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    imageView.contentMode = UIViewContentModeLeft;
    [self.navigationController.navigationBar setBackgroundImage:[ATCColorPalette imageFromColor:[ATCColorPalette navigationBar]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
    [self.navigationController.navigationBar addSurroundingShadowWithRadius:5];
    self.navigationItem.title = @"Qreate";
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem customBackButtonWithTitle:@"Cancel" target:self selector:@selector(dismissView)];
    self.navigationItem.leftBarButtonItem  = cancelButton;
    
    
    UIBarButtonItem* login = [UIBarButtonItem customBarButtonWithTitle:@"Post" target:self selector:@selector(tryToPost)];
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
    NSInteger amountOfRows;
    switch (section) {
        case QUESTION_TITLE_SECTION:
            amountOfRows = 1;
            break;
        case ALTERNATIVE_SECTION:
        {
            amountOfRows = [self.alternativeTextViews count];
            break;
        }
        default:
            NSAssert1(nil, @"wrong in numberOfRowsINsection", nil);
            break;
    }
    // Return the number of rows in the section.
    return amountOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self clearCellFromOldRemnants:cell];
    
    
    switch (indexPath.section) {
        case QUESTION_TITLE_SECTION:
        {
            [self setUpTitleCell:cell];
            break;
        }
        case ALTERNATIVE_SECTION:
        {
            [self setUpAlternativeCell:cell forIndexPath:indexPath];
            break;
        }
        default:
            NSAssert1(nil, @"wrong in CellForRowAtIndexPath", nil);
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark Cell Setups

-(void)clearCellFromOldRemnants:(UITableViewCell*)cell
{
    
    cell.textLabel.text = @"";
    
    if ([cell viewWithTag:ALTERNATIVE_TEXT_VIEW_TAG])
    {
        [[cell viewWithTag:ALTERNATIVE_TEXT_VIEW_TAG] removeFromSuperview];
    }
    
    if ([cell viewWithTag:QUESTION_TITLE_TAG])
    {
        [[cell viewWithTag:QUESTION_TITLE_TAG] removeFromSuperview];
    }
    
}
-(void)setUpTitleCell:(UITableViewCell*)cell
{
    if (_questionTitle == nil) {
        CGRect newFrame = CGRectMake(CELL_X_MARGIN + CELL_X_Padding,
                                     CELL_Y_Padding,
                                     cell.frame.size.width - 2 * (CELL_X_Padding + CELL_X_MARGIN),
                                     QUESTION_TITLE_DEFAULT_HEIGHT);
        _questionTitle = [[UITextView alloc] initWithFrame:newFrame];
        _questionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        _questionTitle.textColor = [ATCColorPalette createQuestionFont];
        _questionTitle.delegate = self;
        _questionTitle.tag = QUESTION_TITLE_TAG;
        [_questionTitle setScrollEnabled:NO];
        _questionTitle.backgroundColor = [UIColor clearColor];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ATCColorPalette imageFromColor:[ATCColorPalette navigationBar]]];
    //[cell.backgroundView.layer setMasksToBounds:YES];
    //[cell.backgroundView.layer setCornerRadius:10];
    [cell addSubview:_questionTitle];
}

-(void)setUpAlternativeCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger alternativeIndex = indexPath.row;
    UITextView *textView = [self.alternativeTextViews objectAtIndex:alternativeIndex];
    textView.frame = CGRectMake(CELL_X_MARGIN + CELL_X_Padding,
                                CELL_Y_Padding,
                                cell.frame.size.width - 2 * (CELL_X_Padding + CELL_X_MARGIN),
                                ALTERNATIVE_DEFAULT_HEIGHT);
    textView.textColor = [ATCColorPalette createQuestionFont];
    textView.tag = ALTERNATIVE_TEXT_VIEW_TAG;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[ATCCustomCellBackground alloc] init];
    cell.selectedBackgroundView = [[ATCCustomCellBackground alloc] init];
    [cell addSubview:textView];
}

-(void)addAlternativeButtonToHeader:(ATCCustomSectionHeader*)header
{
    
    //add the + button!
    CGRect frameForButton = CGRectMake(240,0, 80, 45);
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = frameForButton;
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    UIColor *colorForText = header.titleLabel.textColor;
    [addButton setTitleColor:colorForText forState:UIControlEventAllEvents];
    [addButton setTitleColor:colorForText forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAlternative) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:addButton];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL shouldBeAbleToEdit = NO;
    if (indexPath.section == ALTERNATIVE_SECTION && [self.alternativeTextViews count] > 2) {
        shouldBeAbleToEdit = YES;
    }
    return shouldBeAbleToEdit;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger index = indexPath.row;
        [self.alternativeTextViews removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -
#pragma mark Data Logic
-(void)addAlternative
{
    
    if ([self.alternativeTextViews count] >= ALTERNATIVE_MAX) {
        return;
    }
    
    NSUInteger row = [self.alternativeTextViews count];
    NSUInteger section = ALTERNATIVE_SECTION;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView beginUpdates];
    [self insertTextViewsToAlternativeArray];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

-(void)insertTextViewsToAlternativeArray
{
    //textview does not exist. Create it
    UITextView *textView = [[UITextView alloc] init];
    CGFloat randomCrappyValue = 100;
    textView.frame = CGRectMake(CELL_X_MARGIN + CELL_X_Padding,
                                        CELL_Y_Padding,
                                        randomCrappyValue,
                                        ALTERNATIVE_DEFAULT_HEIGHT);
    textView.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
    textView.textColor = [ATCColorPalette questionFont];
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.tag = [self.alternativeTextViews count];
    [self.alternativeTextViews addObject:textView];
}

-(void)postQuestionToServer
{
    NSString *questionTitle = _questionTitle.text;
    NSMutableArray *alternativeArray = [NSMutableArray array];
    for (UITextView *alternative in self.alternativeTextViews) {
        if ([alternative.text isEqualToString:@""]) {
            continue;
        }
        [alternativeArray addObject:alternative.text];
    }
    ATCServerInterface *server = [ATCServerInterface sharedServerInterface];
    [server createQuestionOnServerWithTitle:questionTitle alternatives:alternativeArray callBackTo:self];

}


#pragma mark POST to server
-(void)tryToPost
{
    BOOL everythingIsOk = [self checkIfAllFieldsAreFilledIn];
    if (everythingIsOk) {
        [self postQuestionToServer];
    }
}

-(BOOL)checkIfAllFieldsAreFilledIn
{
    BOOL shouldPost = YES;
    if ([_questionTitle.text isEqualToString:@""]) {
        shouldPost = NO;
        [self popAlertWarningUserAboutIncorrectFieldsForField:0];
    } else
    {
        NSUInteger numberOfFilledInAlternatives = 0;
        for (UITextView *altTextView in self.alternativeTextViews) {
            if (![altTextView.text isEqualToString:@""]) {
                numberOfFilledInAlternatives++;
            }
        }
        
        NSUInteger minimumNumberOfAlternatives = 2;
        if (numberOfFilledInAlternatives < minimumNumberOfAlternatives) {
            shouldPost = NO;
            [self popAlertWarningUserAboutIncorrectFieldsForField:1];
        }
    }
    return shouldPost;
}

-(void)popAlertWarningUserAboutIncorrectFieldsForField:(NSUInteger)field
{
    //0 for title, otherwise alternatives
    NSString *fieldWithError;
    switch (field) {
        case 0:
            fieldWithError = @"enter a question in the top field.";
            break;
        default:
            fieldWithError = [NSString stringWithFormat:@"fill in at least two (2) alternatives."];
            break;
    }
    
    NSString *fullstring = [NSString stringWithFormat:@"The question was incorrectly filled in. Please %@",fieldWithError];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Question incorrectly entered"
                                                    message:fullstring
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
	[alert show];
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section) {
        case QUESTION_TITLE_SECTION:
        {
            height = QUESTION_TITLE_DEFAULT_HEIGHT + 2 * CELL_Y_Padding;
            break;
        }
        case ALTERNATIVE_SECTION:
        {
            if (indexPath.row < [self.alternativeTextViews count]) {
                height = ALTERNATIVE_DEFAULT_HEIGHT + 2 * CELL_Y_Padding;
            } else {
                height = 40;
            }
            break;
        }
        default:
            NSAssert1(nil, @"wrong in getHeightForCell", nil);
            break;
    }
    
    return height;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    switch (section) {
        case QUESTION_TITLE_SECTION:
        {
            header = @"Question";
            break;
        }
        case ALTERNATIVE_SECTION:
        {
            header = @"Alternatives";
            break;
        }
        default:
            NSAssert1(nil, @"wrong in headerInsection", nil);
            break;
    }
    return header;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATCCustomSectionHeader *header = [[ATCCustomSectionHeader alloc] init];

    switch (section) {
        case QUESTION_TITLE_SECTION:
        {
            header.titleLabel.text = @"Question";
            header.titleLabel.textColor = [ATCColorPalette navigationBar];
            header.colorForView = [ATCColorPalette navigationBar];
            break;
        }
        case ALTERNATIVE_SECTION:
        {
            header.titleLabel.text = @"Alternatives";
            header.titleLabel.textColor = [ATCColorPalette createQuestionAlternativeCell];
            header.colorForView = [ATCColorPalette createQuestionAlternativeCell];
            [self addAlternativeButtonToHeader:header];
            break;
        }
        default:
            NSAssert1(nil, @"wrong in headerInsection", nil);
            break;
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    switch (section) {
        case QUESTION_TITLE_SECTION:
        {
            height = 50;
            break;
        }
        case ALTERNATIVE_SECTION:
        {
            height = 50;
            break;
        }
        default:
            NSAssert1(nil, @"wrong in getHeightForCell", nil);
            break;
    }
    return height;
}

#pragma mark -
#pragma mark TextView Delegate
#warning REMOVE THIS if we're not using EDIT button as top right button!
/*
-(void)toggleEditMode
{

    if (self.tableView.isEditing) {
        self.navigationItem.rightBarButtonItem = _editButton;
    } else {
        self.navigationItem.rightBarButtonItem = _editDoneButton;
    }
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];

}
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger viewTag = textView.tag;
    
    BOOL shouldChange = YES;
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        shouldChange = NO;
    }
    
    NSString *stringInView = textView.text;
    NSUInteger lengthOfCurrentString = [stringInView length];
    NSUInteger lengthOfNewString = lengthOfCurrentString - range.length + [text length];
    
    NSUInteger maxNumberOfCharsInView = viewTag == QUESTION_TITLE_TAG ? MAX_CHARACTERS_IN_QUESTION : MAX_CHARACTERS_IN_ALTERNATIVE; //base it on question if we're in question view, otherwise alternative.
    
    //if we're above range and NOT removing, say no
    if (lengthOfNewString > maxNumberOfCharsInView && ![text isEqualToString:@""]) {
        shouldChange = NO;
    }
    
    [textView sizeFontToFitCurrentFrameStartingAt:50];
    return shouldChange;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

#pragma mark Navigation Related
-(void)dismissView
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Server Delegate
-(void)createQuestionHasCompleted:(ServerResponse)createQResponse
{    
    switch (createQResponse) {
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
            [[ATCServerInterface sharedServerInterface] initiateLoginWithExistingUserDetailsWithCallBackTo:self];
            break;
        }
            
        default:
            NSAssert1(nil, @"Should never behere, wrong loginaction typedef in loginview!",nil);
            break;
    }
}

-(void)loginActionHasCompleted:(ServerResponse)loginResponse
{
    switch (loginResponse) {
        case ServerResponseSuccess:
        {
            //if we are here, we
            [self tryToPost];
            break;
        }
        case ServerResponseTimeout:
        {
            [self showTimeOutAlert];
            break;
        }
        case ServerResponseUnauthorized:
        {
            [[ATCUserAuthHelper sharedAuthHelper] showLoginView];
            break;
        }
        default:
            NSAssert1(nil, @"Should never behere, wrong loginaction typedef in loginview!",nil);
            break;
    }
}

#pragma mark User Notification
-(void)showTimeOutAlert
{
    NSString *title = @"Timed out";
    NSString *message = @"The internet connection timed out. Please try again";
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


@end
