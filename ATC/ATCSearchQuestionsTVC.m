//
//  ATCSearchQuestionsTVC.m
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCSearchQuestionsTVC.h"
#import "ATCQuestion.h"

@interface ATCSearchQuestionsTVC ()

@end

@implementation ATCSearchQuestionsTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchWithTextFromSearchBar:(NSString*)searchText
{
    ATCServerInterface *server = [ATCServerInterface sharedServerInterface];
    [server fetchSearchResultTo:self forQuery:searchText];
}

-(void)setUpCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [self setUpQuestionCell:cell forIndexPath:indexPath];
}

@end
