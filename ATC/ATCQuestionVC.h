//
//  ATCQuestionView.h
//  ATC
//
//  Created by CA on 11/18/12.
//
//

/*
 
 Shows the ATCQuestions and gives an interface for voting. Sets up the alternatives as a grid of UIButtons.
 
 */

#import <UIKit/UIKit.h>
#import "ATCQuestionStatisticsVC.h"


@protocol ATCQuestionVoteDelegate

-(void)presentNextQuestion;

@end

@class ATCQuestion;
@class ATCQuestionHandlerVC;
@class ATCQuestionStatisticsVC;

@interface ATCQuestionVC : UIViewController <ATCQuestionPresenterDelegate>

@property (strong, nonatomic) ATCQuestion *questionToShow;              //The question to show. All buttons etc is allocated WHEN THIS IS SET.
@property (strong, nonatomic) IBOutlet UILabel *titleText;              //Title label
@property (strong, nonatomic) NSMutableArray *alternativeButtons;       //Array of all buttons.
@property (weak) id<ATCQuestionVoteDelegate> delegate;                  //that which is called when we have finished voting!
@property (assign) CGFloat maxFontSizeForAlternatives;

/* ACCESORIES BUTTONS */
@property (strong, nonatomic) IBOutlet UIButton *otherButton;

/* STATISTICS */
@property (strong) ATCQuestionStatisticsVC *statVC;

-(void)setUpView;                                                       //should be called before it's shown. fetches data, sets up view.
-(void)layoutSubviews;                                                  //correctly lays out the buttons. Should be called when needed (after view appears and rotation for example) 

-(id)initWithNibName:(NSString *)nibNameOrNil frame:(CGRect)frameForView delegate:(id<ATCQuestionVoteDelegate>)delegate;
@end
