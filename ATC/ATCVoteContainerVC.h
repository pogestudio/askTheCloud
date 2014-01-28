//
//  ATCVoteContainerVC.h
//  ATC
//
//  Created by CA on 11/25/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCQuestionVC.h"
#import "ATCPreviousQuestionMiniVC.h"

@interface ATCVoteContainerVC : UIViewController <ATCQuestionVoteDelegate>
{
@private
    ATCQuestionVC *_currentQuestionVC;
    ATCPreviousQuestionMiniVC *_currentPreviousQuestionVC;
}

-(id)initWithframe:(CGRect)frameForView; // delegate:(id<ATCQuestionVoteDelegate>)delegate
-(void)showNewQuestionFromRightSide:(BOOL)fromRightOrNot;
-(void)setUpView;

@end
