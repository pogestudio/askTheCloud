//
//  ATCVoteContainerVC.m
//  ATC
//
//  Created by CA on 11/25/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCVoteContainerVC.h"
#import "ATCQuestionVC.h"

#define PREVIOUS_QUESTION_HEIGHT 0
#define ANIMATION_LENGTH 0.25f

typedef enum {
    ViewFrameTypeINVALID = 0,
    ViewFrameTypeQuestionContainerLeft,
    ViewFrameTypeQuestionContainerRight,
    ViewFrameTypeQuestionContainerDown,
    ViewFrameTypeQuestionContainerUp,
    ViewFrameTypePreviousQContainerLeft,
    ViewFrameTypePreviousQContainerRight,
    ViewFrameTypePreviousQContainerUp,
    ViewFrameTypePreviousQContainerDown,
} ViewFrameType;


typedef enum {
    ContentFrameINVALID = 0,
    ContentFrameQuestionVoteLeft,
    ContentFrameQuestionVoteRight,
    ContentFrameQuestionVoteDown,
    ContentFrameQuestionVoteUp,
    ContentFramePreviousQLeft,
    ContentFramePreviousQRight,
    ContentFramePreviousQUp,
    ContentFramePreviousQDown,
} ContentFrameSize;

@interface ATCVoteContainerVC ()

@end

@implementation ATCVoteContainerVC


-(id)initWithframe:(CGRect)frameForView// delegate:(id<ATCQuestionVoteDelegate>)delegate
{
    self = [super init];
    if (self){
        self.view = [[UIView alloc] initWithFrame:frameForView];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currentQuestionVC == nil) {
        [self setUpInitialView];
    }
}

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

#pragma mark -
#pragma mark Initialising view
-(void)setUpView
{
    [self addSwipeRecognizer];
    [self setUpInitialView];
}

-(void)setUpInitialView
{
    //initial question container
    ATCQuestionVC *qVote = [[ATCQuestionVC alloc] initWithNibName:@"ATCQuestionVC" frame:[self frameForContainer:ViewFrameTypeQuestionContainerUp] delegate:self];
    
    [self addChildViewController:qVote];
    [self.view addSubview:qVote.view];
    [qVote setUpView];
    _currentQuestionVC = qVote;
    
    
    //previous question!
    ATCPreviousQuestionMiniVC *previousQuestion = [[ATCPreviousQuestionMiniVC alloc] initWithFrame:[self frameForContainer:ViewFrameTypePreviousQContainerUp] andQuestion:_currentQuestionVC.questionToShow];
    [self addChildViewController:previousQuestion];
    [self.view addSubview:previousQuestion.view];
    [previousQuestion setUpView];
    _currentPreviousQuestionVC = previousQuestion;

}


#pragma mark -
#pragma mark Look Related
-(CGRect)standardPreviousQContainerViewFrame
{
    CGRect frameForContainer = CGRectMake(0,
                                          0,
                                          self.view.frame.size.width,
                                          PREVIOUS_QUESTION_HEIGHT);
    return frameForContainer;
}

-(CGRect)standardQuestionVoteContainerViewFrame
{
    CGFloat yPos = PREVIOUS_QUESTION_HEIGHT;
    CGRect frameForContainer =      CGRectMake(0,
                                               yPos,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height - yPos);
    return frameForContainer;
}

-(CGRect)standardPreviousQViewFrame
{
    //same stuff as container for now, since we're in the top of the view.
    return [self standardPreviousQContainerViewFrame];
}

-(CGRect)standardQuestionVoteViewFrame
{
    CGRect frameForView = CGRectMake(0, PREVIOUS_QUESTION_HEIGHT,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - PREVIOUS_QUESTION_HEIGHT);
    return frameForView;
}


#pragma mark -
#pragma mark Question
-(void)presentNewQuestion
{
    ATCQuestionVC *qVote = [[ATCQuestionVC alloc] initWithNibName:@"ATCQuestionVC" frame:[self frameForContainer:ViewFrameTypeQuestionContainerDown] delegate:self];
    [self transitionToQuestion:qVote];
}

-(void)presentPreviousQuestionResults
{
    ATCPreviousQuestionMiniVC *previousQuestion = [[ATCPreviousQuestionMiniVC alloc] initWithFrame:[self frameForContent:ContentFramePreviousQDown] andQuestion:_currentQuestionVC.questionToShow];
    [self transitionToPreviousQuestion:previousQuestion];
}

#pragma mark -
#pragma mark ATCQuestionVoteDelegate
-(void)presentNextQuestion
{
    //[self presentPreviousQuestionResults];
    [self presentNewQuestion];
    
}


#pragma mark -
#pragma mark View Navigation
- (void)transitionToQuestion:(ATCQuestionVC *)toViewController
{
    UIViewController *currentVC = _currentQuestionVC;


    [currentVC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:toViewController];
    
    CGRect newVCStartFrame;
    CGRect oldVCEndFrame;
    
    //if we're supposed to animate it, animate from the right.
    //if not, just present it right away.
    
    newVCStartFrame = [self frameForContent:ContentFrameQuestionVoteRight];
    oldVCEndFrame = [self frameForContent:ContentFrameQuestionVoteLeft];

    
    CGRect newVCEndFrame = [self frameForContent:ContentFrameQuestionVoteDown];               // 2
    toViewController.view.frame = newVCStartFrame;
    
    [toViewController setUpView];
    
    [self transitionFromViewController: currentVC toViewController: toViewController   // 3
                              duration: ANIMATION_LENGTH
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                toViewController.view.frame = newVCEndFrame;                       // 4
                                currentVC.view.frame = oldVCEndFrame;
                            }
                            completion:^(BOOL finished) {
                                [currentVC removeFromParentViewController];                   // 5
                                [toViewController didMoveToParentViewController:self];
                            }];
    
    _currentQuestionVC = toViewController;
}

- (void)transitionToPreviousQuestion:(ATCPreviousQuestionMiniVC *)toViewController
{
    
    UIViewController *currentVC = _currentPreviousQuestionVC;
    
    
    [currentVC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:toViewController];
    
    CGRect newVCStartFrame;
    CGRect oldVCEndFrame;
    
    //if we're supposed to animate it, animate from the right.
    //if not, just present it right away.
    
    newVCStartFrame = [self frameForContent:ContentFramePreviousQRight];
    oldVCEndFrame = [self frameForContent:ContentFramePreviousQLeft];
    
    CGRect newVCEndFrame = [self frameForContent:ContentFramePreviousQDown];               // 2
    toViewController.view.frame = newVCStartFrame;
    
    [toViewController setUpView];
    
    [self transitionFromViewController: currentVC toViewController: toViewController   // 3
                              duration: ANIMATION_LENGTH
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                toViewController.view.frame = newVCEndFrame;                       // 4
                                currentVC.view.frame = oldVCEndFrame;
                            }
                            completion:^(BOOL finished) {
                                [currentVC removeFromParentViewController];                   // 5
                                [toViewController didMoveToParentViewController:self];
                            }];
    
    _currentPreviousQuestionVC = toViewController;
}

-(CGRect)frameForContainer:(ViewFrameType)viewFrameType
{
    CGRect rectToReturn;
    switch (viewFrameType) {
        case ViewFrameTypeQuestionContainerLeft:
        {
            rectToReturn = [self standardQuestionVoteContainerViewFrame];
            rectToReturn = CGRectMake(-rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ViewFrameTypeQuestionContainerRight:
        {
            rectToReturn = [self standardQuestionVoteContainerViewFrame];
            rectToReturn = CGRectMake(rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ViewFrameTypeQuestionContainerDown:
        {
            rectToReturn = [self standardQuestionVoteContainerViewFrame];
            break;
        }
        case ViewFrameTypeQuestionContainerUp:
        {
            rectToReturn = [self standardQuestionVoteContainerViewFrame];
            rectToReturn = CGRectMake(rectToReturn.origin.x,
                                      rectToReturn.origin.y - PREVIOUS_QUESTION_HEIGHT,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height + PREVIOUS_QUESTION_HEIGHT);
            break;
        }
        case ViewFrameTypePreviousQContainerLeft:
        {
            rectToReturn = [self standardPreviousQContainerViewFrame];
            rectToReturn = CGRectMake(-rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ViewFrameTypePreviousQContainerUp:
        {
            rectToReturn = [self standardPreviousQContainerViewFrame];
            rectToReturn = CGRectMake(rectToReturn.origin.x,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      0);
            break;
        }
        case ViewFrameTypePreviousQContainerDown:
        {
            rectToReturn = [self standardPreviousQContainerViewFrame];
            break;
        }
        case ViewFrameTypePreviousQContainerRight:
        {
            rectToReturn = [self standardPreviousQContainerViewFrame];
            rectToReturn = CGRectMake(rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        default:
            NSAssert1(nil, @"should never be here. Something wrong in getframe in ATCVC", nil);
            break;
    }
    return rectToReturn;
}

-(CGRect)frameForContent:(ContentFrameSize)layoutType
{
    CGRect rectToReturn;
    switch (layoutType) {
      case ContentFrameQuestionVoteLeft:
        {
            rectToReturn = [self standardQuestionVoteViewFrame];
            rectToReturn = CGRectMake(-rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ContentFrameQuestionVoteRight:
        {
            rectToReturn = [self standardQuestionVoteViewFrame];
            rectToReturn = CGRectMake(rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ContentFrameQuestionVoteDown:
        {
            rectToReturn = [self standardQuestionVoteViewFrame];
            break;
        case ContentFrameQuestionVoteUp:
        {
            rectToReturn = [self standardQuestionVoteViewFrame];
            rectToReturn = CGRectMake(rectToReturn.origin.x,
                                      rectToReturn.origin.y - PREVIOUS_QUESTION_HEIGHT,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height + PREVIOUS_QUESTION_HEIGHT);
            break;
        } }
        case ContentFramePreviousQLeft:
        {
            rectToReturn = [self standardPreviousQViewFrame];
            rectToReturn = CGRectMake(-rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        case ContentFramePreviousQUp:
        {
            rectToReturn = [self standardPreviousQViewFrame];
            rectToReturn = CGRectMake(rectToReturn.origin.x,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      0);
            break;
        }
        case ContentFramePreviousQDown:
        {
            rectToReturn = [self standardPreviousQViewFrame];
            break;
        }
        case ContentFramePreviousQRight:
        {
            rectToReturn = [self standardPreviousQViewFrame];
            rectToReturn = CGRectMake(rectToReturn.size.width,
                                      rectToReturn.origin.y,
                                      rectToReturn.size.width,
                                      rectToReturn.size.height);
            break;
        }
        default:
            NSAssert1(nil, @"should never be here. Something wrong in getframe in ATCVC", nil);
            break;
    }
    return rectToReturn;
}

#pragma mark Swipe recognizer
-(void)addSwipeRecognizer
{
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(presentNextQuestion)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gesture];
}


@end
