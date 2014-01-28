//
//  ATCViewController.m
//  ATC
//
//  Created by CA on 11/19/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCViewController.h"
#import "ATCCreateQuestionVC.h"
#import "ATCCreateQuestionTVC.h"
#import "ATCSearchQuestionsTVC.h"
#import "ATCVoteContainerVC.h"
#import "ATCUserPageTVC.h"

typedef enum {
    ViewFrameTypeINVALID = 0,
    ViewFrameTypeMainContainerLeft,
    ViewFrameTypeMainContainerView,
    ViewFrameTypeMainContainerRight
} ViewFrameType;



@interface ATCViewController ()
- (void)transitionToViewController:(UIViewController *)toViewController type:(TypeOfVC)toType;

@end

@implementation ATCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUpView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_currentActiveVC == nil) {
        [self setUpInitialView];
    }
    
    [self layoutSubviews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Look Related
-(void)setUpView
{
    [self setUpMenuBar];
    [self setUpMainContainerView];
}

-(void)setUpMenuBar
{
    _menuBar = [[ATCTopMenuVC alloc] initWithNibName:@"ATCTopMenuVC" bundle:nil];
    //	menuBar.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _menuBar.delegate = self;


    _menuBarContainerView = [[UIView alloc] initWithFrame:_menuBar.view.frame];
	_menuBarContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_menuBarContainerView addSubview:_menuBar.view];
	[self.view addSubview:_menuBarContainerView];
    
}

-(void)setUpMainContainerView
{
    CGFloat topFrameHeight = _menuBarContainerView.frame.size.height;
    CGFloat yPos = topFrameHeight;
    CGRect mainContainerFrame = CGRectMake(0, yPos,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height - yPos);
    _mainContainerView = [[UIView alloc] initWithFrame:mainContainerFrame];
    _mainContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mainContainerView.backgroundColor = [UIColor blueColor];

    [self.view insertSubview:_mainContainerView belowSubview:_menuBarContainerView];
}


-(void)setUpInitialView
{
    ATCVoteContainerVC *voteContainer = [[ATCVoteContainerVC alloc] initWithframe:_mainContainerView.bounds];
    [self addChildViewController:voteContainer];
    [_mainContainerView addSubview:voteContainer.view];
    [voteContainer setUpView];
    _currentActiveVCType = TypeOfVCVote;
    _currentActiveVC = voteContainer;
}


-(void)layoutSubviews
{
    
}


#pragma mark -
#pragma mark View Navigation
- (void)transitionToViewController:(UIViewController *)toViewController type:(TypeOfVC)toType
{
    UIViewController *currentVC = _currentActiveVC;
    
    [_currentActiveVC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:toViewController];
    
    CGRect newVCStartFrame;
    CGRect oldVCEndFrame;
    if ( _currentActiveVCType <= toType) //slide to the left
    {
        newVCStartFrame = [self getNewFrameForView:ViewFrameTypeMainContainerRight];
        oldVCEndFrame = [self getNewFrameForView:ViewFrameTypeMainContainerLeft];
    } else //slide to the right
    {
        newVCStartFrame = [self getNewFrameForView:ViewFrameTypeMainContainerLeft];
        oldVCEndFrame = [self getNewFrameForView:ViewFrameTypeMainContainerRight];
    }
    
    CGRect newVCEndFrame = [self getNewFrameForView:ViewFrameTypeMainContainerView];               // 2
    toViewController.view.frame = newVCStartFrame;
    
    [self prepareReceiverView:toViewController ofType:toType];
    
    [self transitionFromViewController: currentVC toViewController: toViewController   // 3
                              duration: 0.5
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                toViewController.view.frame = newVCEndFrame;                       // 4
                                currentVC.view.frame = oldVCEndFrame;
                            }
                            completion:^(BOOL finished) {
                                [currentVC removeFromParentViewController];                   // 5
                                [toViewController didMoveToParentViewController:self];
                            }];
    _currentActiveVC = toViewController;
    _currentActiveVCType = toType;
}

-(CGRect)getNewFrameForView:(ViewFrameType)viewFrameType
{
    CGRect rectToReturn;
    switch (viewFrameType) {
        case ViewFrameTypeMainContainerLeft:
        {
            rectToReturn = CGRectMake(- _mainContainerView.bounds.size.width,
                                      0,
                                      _mainContainerView.frame.size.width,
                                      _mainContainerView.frame.size.height);
        }
            break;
        case ViewFrameTypeMainContainerView:
        {
            rectToReturn = _mainContainerView.bounds;
        }
            break;
        case ViewFrameTypeMainContainerRight:
        {
            rectToReturn = CGRectMake(_mainContainerView.frame.size.width,
                                      0,
                                      _mainContainerView.frame.size.width,
                                      _mainContainerView.frame.size.height);
        }
            break;
            
        default:
            NSAssert1(nil, @"should never be here. Something wrong in getframe in ATCVC", nil);
            break;
    }
    return rectToReturn;
}

-(void)prepareReceiverView:(UIViewController*)toViewController ofType:(TypeOfVC)toType
{
    switch (toType) {
        case TypeOfVCVote:
        {
            NSAssert1([toViewController isKindOfClass:[ATCVoteContainerVC class]], @"Fucked upp typeovcd typedef", nil);
            ATCVoteContainerVC *voteCVC = (ATCVoteContainerVC*)toViewController;
            [voteCVC setUpView];
            break;
            
        }
        case TypeOfVCCreateQuestion:
        {
            NSAssert1([toViewController isKindOfClass:[ATCCreateQuestionVC class]], @"Fucked upp typeovcd typedef", nil);
            ATCCreateQuestionVC *createQ = (ATCCreateQuestionVC*)toViewController;
            [createQ layoutSubviews];
            break;
            
        }
        case TypeOfVCSearchQuestion:
        {
            NSAssert1([toViewController isKindOfClass:[ATCListItemsTVC class]], @"Fucked upp typeovcd typedef", nil);
            ATCListItemsTVC *listItems = (ATCListItemsTVC*)toViewController;
            listItems.delegate = self;
            break;
            
        }
        case TypeOfVCUserPage:
        {
            NSAssert1([toViewController isKindOfClass:[ATCListItemsTVC class]], @"Fucked upp typeovcd typedef", nil);
            ATCListItemsTVC *listItems = (ATCListItemsTVC*)toViewController;
            listItems.delegate = self;
            break;
            
        }

        default:
            NSAssert1(nil, @"We have an error in the container view navigation. Wrong TypeOfVc?", nil);
            break;
    }
}

-(void)presentSearchQuestion
{
    ATCSearchQuestionsTVC *searchItemsTVC = [[ATCSearchQuestionsTVC alloc] initWithSearchBar:YES];
    searchItemsTVC.view.frame = _mainContainerView.bounds;
    [self transitionToViewController:searchItemsTVC type:TypeOfVCSearchQuestion];
    
}

-(void)presentVoteContainer
{
    ATCVoteContainerVC *voteContainer = [[ATCVoteContainerVC alloc] initWithframe:_mainContainerView.bounds];
    [self transitionToViewController:voteContainer type:TypeOfVCVote];
    
}

-(void)presentUserPage
{
    ATCUserPageTVC *userPage = [[ATCUserPageTVC alloc] initWithSearchBar:NO];
    userPage.view.frame = _mainContainerView.bounds;
    [self transitionToViewController:userPage type:TypeOfVCUserPage];
    
}

#pragma mark -
#pragma mark TopMenubar Delegate
-(void)createAQuestion
{
    ATCCreateQuestionTVC *ctvc = [[ATCCreateQuestionTVC alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:ctvc];
    [self presentModalViewController:navCon animated:YES];
}

-(void)showVotingView
{
    [self presentVoteContainer];
}

-(void)showSearchView
{
    [self presentSearchQuestion];
}

-(void)showUserPage
{
    [self presentUserPage];
}

#pragma mark -
#pragma mark CreateQuestion delegate
-(void)cancelledQuestion
{
    [self presentVoteContainer];
}

-(void)postedQuestion
{
    [self presentVoteContainer];
    
}


@end
