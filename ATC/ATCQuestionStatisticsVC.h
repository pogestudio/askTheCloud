//
//  ATCFullScreenPreviousQuestionVC.h
//  ATC
//
//  Created by CA on 12/2/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATCQuestion;

@protocol ATCQuestionPresenterDelegate

-(void)questionHasBeenVotedOn;

@end

@interface ATCQuestionStatisticsVC : UIViewController
{
@private
    NSMutableArray *_fullscreenAlternatives;
    BOOL _isObservingQuestionAlternatives;
    id<ATCQuestionPresenterDelegate> _presenterDelegate;

}
@property (strong) ATCQuestion *question;
@property (strong) UILabel *ageOfPost;
@property (strong) UILabel *numberOfVotes;


-(id)initWithQuestion:(ATCQuestion*)question forFrame:(CGRect)frame withDelegate:(id<ATCQuestionPresenterDelegate>)delegate;
-(void)updateValues;

@end
