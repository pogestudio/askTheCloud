//
//  ATCPreviousQuestionVC.h
//  ATC
//
//  Created by CA on 11/25/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCQuestion.h"

@class ATCQuestionStatisticsVC;

@interface ATCPreviousQuestionMiniVC : UIViewController
{
    @private
    NSMutableArray *_voteBarViews;
    CGRect _defaultFrame;
    
    @private
    ATCQuestionStatisticsVC *_fullScreenPrevQVC;
    
}

@property (strong) ATCQuestion *questionToShow;
@property (strong) NSMutableArray *labels;
@property (strong) UILabel *voteLabel;

- (id)initWithFrame:(CGRect)frameTouse andQuestion:(ATCQuestion*)question;
-(void)setUpView;

@end
