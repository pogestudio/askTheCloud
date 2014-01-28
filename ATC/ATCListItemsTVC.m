//
//  ATCListItemsTVC.m
//  ATC
//
//  Created by August Bonds on 12/15/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCListItemsTVC.h"
#import "ATCQuestion.h"
#import "ATCQuestionStorage.h"

#define SEARCH_DELAY 0.5

@interface ATCListItemsTVC ()

@end

@implementation ATCListItemsTVC

- (id)initWithSearchBar:(BOOL)searchBarNorNot
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.itemsToShow = [[NSArray alloc] init];
        _shouldShowSearchBar = searchBarNorNot;
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

    if (_shouldShowSearchBar) {
        UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        search.delegate = self;
        [search setBackgroundImage:[ATCColorPalette imageFromColor:self.tableView.backgroundColor]];
        self.tableView.tableHeaderView = search;
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.itemsToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    [self setUpCell:cell forIndexPath:indexPath];
    return cell;
}

-(void)setUpQuestionCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    ATCQuestion *questionForCell = [self.itemsToShow objectAtIndex:indexPath.row];
    [questionForCell fillSelfWithCurrentInfo];
    cell.textLabel.text = [questionForCell title];
    cell.detailTextLabel.text = [questionForCell ageOfQuestion];
    cell.backgroundView = nil;

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
    [self searchBarResignFirstResponder];
    
    NSUInteger currentIndex = indexPath.row;
    NSUInteger amountOfItems = [self.itemsToShow count];
    NSRange rangeOfFollowingItems = NSMakeRange(currentIndex, amountOfItems - currentIndex);
    NSIndexSet *followingItemsIndexes = [NSIndexSet indexSetWithIndexesInRange:rangeOfFollowingItems];
    NSArray *newArray = [self.itemsToShow objectsAtIndexes:followingItemsIndexes];
    [ATCQuestionStorage sharedStorageWithArrayOfQuestions:newArray];
    [self.delegate showVotingView];
    
    
}

#pragma mark - 
#pragma mark Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchDataAccordingToSearchInput) object:nil];
    
    [self performSelector:@selector(fetchDataAccordingToSearchInput:) withObject:searchBar afterDelay:SEARCH_DELAY];
    
}

#pragma mark -
#pragma mark Fetching more data to table view
-(void)fetchDataAccordingToSearchInput:(id)sender
{
    NSAssert1([sender isKindOfClass:[UISearchBar class]],@"Something other than searchbar was sent with search",nil);
    UISearchBar *searchBar = (UISearchBar*)sender;
    NSString *stringToSearch = searchBar.text;
    [self searchWithTextFromSearchBar:stringToSearch];
}

-(void)searchWithTextFromSearchBar:(NSString*)searchText
{
    ATCServerInterface *server = [ATCServerInterface sharedServerInterface];
    [server fetchSearchResultTo:self forQuery:searchText];
}

#pragma mark Search results delegate
-(void)searchResultsWasReceived:(NSArray*)listOfResults withCompletion:(ServerResponse)pullResponse
{
    self.itemsToShow = listOfResults;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarResignFirstResponder];
}

-(void)searchBarResignFirstResponder
{
    UISearchBar *theSearchBar = (UISearchBar*)self.tableView.tableHeaderView;
    [theSearchBar resignFirstResponder];
}

#pragma mark ScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self searchBarResignFirstResponder];
}
@end
