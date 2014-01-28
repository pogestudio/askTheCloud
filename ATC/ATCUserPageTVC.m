//
//  ATCUserPageTVC.m
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCUserPageTVC.h"
#import "ATCQuestion.h"
#import "ATCUserAuthHelper.h"

@interface ATCUserPageTVC ()

@end

#define USER_SETTINGS_SECTION 0
#define QUESTION_SECTION 1

@implementation ATCUserPageTVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self getQuestions];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return QUESTION_SECTION + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger amountOfRows = 0;
    switch (section) {
        case USER_SETTINGS_SECTION:
        {
            amountOfRows = 1;
            break;
        }
        case QUESTION_SECTION:
        {
            amountOfRows = [self.itemsToShow count];
            break;
        }
            
        default:
            NSAssert1(nil, @"should never be here. Wrong in numberOfRows >> userpage", nil);
            break;
    }
    // Return the number of rows in the section.
    return amountOfRows;
}

-(void)setUpCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case USER_SETTINGS_SECTION:
        {
            [self setUpLogoutCell:cell];
            break;
        }
        case QUESTION_SECTION:
        {
            [super setUpQuestionCell:cell forIndexPath:indexPath];
            break;
        }
            
        default:
            NSAssert1(nil, @"should never be here. Wrong in setUpCell >> userpage", nil);
            break;
    }
}

#pragma mark Tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            case USER_SETTINGS_SECTION:
            {
                [self logoutUser];
                [self.delegate showVotingView];
                break;
            }
            case QUESTION_SECTION:
            {
                [super tableView:tableView didSelectRowAtIndexPath:indexPath];
                break;
            }
            default:
                NSAssert1(nil, @"should never be here. Wrong in setUpCell >> userpage", nil);
                break;
        }
    }

#pragma mark Cell Setup
-(void)setUpLogoutCell:(UITableViewCell*)cell
{
    cell.textLabel.text = @"Logout User";
    cell.detailTextLabel.text = @"";
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ATCColorPalette imageFromColor:[ATCColorPalette color4]]];
}

#pragma mark User Stuff
-(void)logoutUser
{
    [[ATCUserAuthHelper sharedAuthHelper] logoutUser];
}

-(void)getQuestions
{
    ATCServerInterface *server = [ATCServerInterface sharedServerInterface];
    [server fetchUserQuestions:self];
}

#pragma Server Delegate
-(void)searchResultsWasReceived:(NSArray *)listOfResults withCompletion:(ServerResponse)pullResponse
{
    switch (pullResponse) {
        case ServerResponseSuccess:
        {
            //reverse list
            
            self.itemsToShow = [[listOfResults reverseObjectEnumerator] allObjects];
            [self.tableView reloadData];
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
            [self getQuestions];
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

#pragma mark Tableview data source
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == QUESTION_SECTION) {
        title = @"Your Questions";
    }
    return title;
}

@end
