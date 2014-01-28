//
//  ATCListItemsTVC.h
//  ATC
//
//  Created by August Bonds on 12/15/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCServerInterface.h"

@protocol ListQuestionsDelegate

-(void)showVotingView;

@end

@interface ATCListItemsTVC : UITableViewController <UISearchBarDelegate, SearchResultsDelegate>
{
    @private
    BOOL _shouldShowSearchBar;
}

@property (strong) NSArray *itemsToShow;
@property (weak) id<ListQuestionsDelegate> delegate;



- (id)initWithSearchBar:(BOOL)searchBarNorNot;

-(void)setUpCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
-(void)searchWithTextFromSearchBar:(NSString*)searchText; //override with own function to send to server, which will respond according to SearchResultsDelegate protocol
-(void)setUpQuestionCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

@end
