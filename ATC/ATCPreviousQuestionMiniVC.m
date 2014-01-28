//
//  ATCPreviousQuestionVC.m
//  ATC
//
//  Created by CA on 11/25/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCPreviousQuestionMiniVC.h"
#import "ATCVoteCountBar.h"
#import "ATCQuestionStatisticsVC.h"

@interface ATCPreviousQuestionMiniVC ()

@end

@implementation ATCPreviousQuestionMiniVC

- (id)initWithFrame:(CGRect)frameTouse andQuestion:(ATCQuestion*)question
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:frameTouse];
        _defaultFrame = frameTouse;
        self.questionToShow = question;
        self.labels = [NSMutableArray arrayWithCapacity:[question.alternatives count]];
        _voteBarViews = [[NSMutableArray alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.view.frame.size.height > 0) {
        //avoid to remove observer for the first view in queue, since that never had any previous question
        NSLog(@"Want to remove observer for prevQ question:%@",self.questionToShow.title);
        [self.questionToShow removeObserver:self forKeyPath:@"alternatives"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpView
{
    if (self.questionToShow != nil && self.view.frame.size.height > 0) {
        [self initiateLabels];
        [self initiateCountBars];
        [self setGestureRecognizers];
        [self updateView];
        [self initiateAsyncQuestionFetch];
    }
    
}

-(void)updateView
{
    if ([self viewIsUp]) {
        [self layoutBars];
        [self layoutLabels];
    }
    else if ([self viewIsDown])
    {
        //[_fullScreenPrevQVC updateView];
    }
}

#pragma mark -
#pragma mark Labels
-(void)initiateLabels
{
    NSUInteger count = 0;
    UIFont *fontForLabels = [UIFont fontWithName:@"Helvetica" size:12.0];
    for (ATCQuestionAlternative *alternative in self.questionToShow.alternatives )
    {
        CGRect barFrame = [self calculateFrameForHorizontalBarAlternative:count forFirstTime:YES];
        UILabel *newLabel = [[UILabel alloc] initWithFrame:barFrame];
        newLabel.text = [self stringToShowForAlternative:alternative];
        newLabel.font = fontForLabels;
        [self.labels addObject:newLabel];
        [self.view addSubview:newLabel];
        count++;
    }
    
    self.voteLabel = [[UILabel alloc] init];
    self.voteLabel.font = fontForLabels;
    self.voteLabel.text = [self getTextForVoteLabel];
    CGRect frameForVoteLabel = CGRectMake(self.view.frame.size.width, PREVIOUS_QUESTION_HEIGHT-10,10,10);
    self.voteLabel.frame = frameForVoteLabel;
    [self.view addSubview:self.voteLabel];
    
}

#warning one of these should be deleted
-(void)layoutLabels
{
    NSUInteger xPadding = 5;
    NSUInteger count = 0;
    for (UILabel* label in self.labels)
    {
        [label sizeToFit];
        CGRect correspondingBar = [self calculateFrameForHorizontalBarAlternative:count forFirstTime:NO];
        CGFloat xPos = correspondingBar.size.width + xPadding;
        CGFloat yPos = CGRectGetMidY(correspondingBar) - label.frame.size.height / 2;
        CGRect newFrame = CGRectMake(xPos, yPos, label.frame.size.width, label.frame.size.height);
        [self animateView:label toFrame:newFrame withDuration:0];
        count++;
    }
    
    //layout the votelabel
    self.voteLabel.text = [self getTextForVoteLabel];
    [self.voteLabel sizeToFit];
    CGRect currentFrame = self.voteLabel.frame;
    CGRect newframe = CGRectMake(self.view.frame.size.width - currentFrame.size.width,
                                 PREVIOUS_QUESTION_HEIGHT - currentFrame.size.height,
                                 currentFrame.size.width,
                                 currentFrame.size.height);
//    self.voteLabel.frame = newframe;
    [self animateView:self.voteLabel toFrame:newframe withDuration:0];
}

-(NSString*)getTextForVoteLabel
{
    NSUInteger amountOfVotes = [self.questionToShow totalAmountOfVotes];
    NSString *text = [NSString stringWithFormat:@"%d votes", amountOfVotes];
    return text;
}

#pragma mark -
#pragma mark Bars
-(void)initiateCountBars
{
    NSUInteger count = 0;
    for (ATCQuestionAlternative *alternative in self.questionToShow.alternatives )
    {
        /*
        CGRect barFrame;
        barFrame = [self calculateFrameForHorizontalBarAlternative:count forFirstTime:YES];
        ATCVoteCountBar *bar = [[ATCVoteCountBar alloc] initWithFrame:barFrame asAlternative:count];
        [self.view addSubview:bar];
        [_voteBarViews addObject:bar];
        count++;
         */
    }
    
}

-(void)layoutBars
{
    int count = 0;
    for (ATCQuestionAlternative *alternative in self.questionToShow.alternatives )
    {
        CGRect barFrame = [self calculateFrameForHorizontalBarAlternative:count forFirstTime:NO];
        ATCVoteCountBar *bar = [_voteBarViews objectAtIndex:count];
        [self animateView:bar toFrame:barFrame withDuration:0];
        count++;
    }
}
-(CGRect)calculateFrameForHorizontalBarAlternative:(NSUInteger)alternativeIndex forFirstTime:(BOOL)firstInit
{    
    CGFloat amountOfAlternatives = [self.questionToShow.alternatives count];
    CGFloat barHeightFractionOfViewWidth = 6;
    CGFloat barHeight = PREVIOUS_QUESTION_HEIGHT / barHeightFractionOfViewWidth;
    CGFloat padding = (PREVIOUS_QUESTION_HEIGHT - barHeight * amountOfAlternatives) / (amountOfAlternatives + 1);
    CGFloat insertFromTop = alternativeIndex * barHeight +  (alternativeIndex + 1) * padding;
    CGFloat width = 0;
    if (!firstInit) {
        ATCQuestionAlternative *alternative  = [self.questionToShow.alternatives objectAtIndex:alternativeIndex];
        CGFloat maxWidth = self.view.bounds.size.width * 0.7;
        width = maxWidth * [self.questionToShow percentageForAlternative:alternative];
    }
    CGRect barRect = CGRectMake(0,
                                insertFromTop,
                                width,
                                barHeight);
    return barRect;
}


#pragma mark -
#pragma mark Initiating
-(void)setGestureRecognizers
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
}

#pragma mark -
#pragma mark Layout

-(NSString*)stringToShowForAlternative:(ATCQuestionAlternative*)thisAlternative
{
//TODO doesn't it automatically add ...s if you make the frame shorter than the text?
    NSUInteger maxOfCharactersToShowFromAlternative = 10;
    NSUInteger numberOfCharactersToShow = MIN(maxOfCharactersToShowFromAlternative, [thisAlternative.text length]);
    NSString *textFromAlternative = [thisAlternative.text substringToIndex:numberOfCharactersToShow];
    if ([textFromAlternative length] < [thisAlternative.text length]) {
    textFromAlternative = [NSString stringWithFormat:@"%@...",textFromAlternative];
    }
    return textFromAlternative;
}


-(void)animateView:(UIView*)view toFrame:(CGRect)newFrame withDuration:(CGFloat)durationOrZeroForDefault
{
    CGFloat duration = 0.5;
    if (durationOrZeroForDefault != 0) {
        duration = durationOrZeroForDefault;
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.frame = newFrame; } completion:nil];
}

#pragma mark -
#pragma mark DealWithAsyncFetch
-(void)initiateAsyncQuestionFetch
{
    [self.questionToShow addObserver:self forKeyPath:@"alternatives" options:NSKeyValueObservingOptionNew context:nil];
    [self.questionToShow fillSelfWithCurrentInfo];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateView];
}

#pragma mark -
#pragma mark Gesture Recognizers
-(void)tapDetected:(id)sender
{
    if ([self viewIsUp]) {
        [self slideOutMiniContent];
        [self slideDownViewAndSlideInContent];
    } else if ([self viewIsDown]) {
        [self slideOutNewContentAndSlideUpView];
        [self slideInTheMiniContent];
    }
}

#pragma mark - 
#pragma mark Slide view up and down
-(void)slideDownViewAndSlideInContent
{
    CGRect parentViewRect = self.parentViewController.view.frame;
    CGFloat currentYPosition = self.view.frame.origin.y;
    CGFloat newHeight = parentViewRect.size.height - currentYPosition;
    CGRect newFrame = CGRectMake(self.view.frame.origin.y,
                                 self.view.frame.origin.x,
                                 self.view.frame.size.width,
                                 newHeight);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = newFrame; } completion:^(BOOL finished){ [self slideInNewContent];}];
    
    UIViewController *parentVC = self.parentViewController;
    [parentVC.view bringSubviewToFront:self.view];
}

-(void)slideUpView
{
    CGRect newFrame = _defaultFrame;
    [self animateViewToFrame:newFrame];
}

-(void)animateViewToFrame:(CGRect)newFrame
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = newFrame; } completion:nil];
    
    UIViewController *parentVC = self.parentViewController;
    [parentVC.view bringSubviewToFront:self.view];
}

-(BOOL)viewIsUp
{
    CGRect currentFrame = self.view.frame;
    CGRect upFrame = _defaultFrame;
    
    BOOL isViewUp;
    if (CGRectEqualToRect(currentFrame, upFrame)) {
        isViewUp =  YES;
    } else {
        isViewUp =  NO;
    }
    
    return isViewUp;
}

-(BOOL)viewIsDown
{
    CGRect currentFrame = self.view.frame;
    CGRect parentViewRect = self.parentViewController.view.frame;
    CGRect downFrame = CGRectMake(0, 0, self.view.frame.size.width, parentViewRect.size.height);
    
    BOOL isViewDown;
    if (CGRectEqualToRect(downFrame, currentFrame)) {
        isViewDown = YES;
    } else {
        isViewDown = NO;
    }
    
    return isViewDown;
}

#pragma mark - 
#pragma mark Clear and Insert content
-(void)slideOutMiniContent
{
    //1 slide bars to left
    //2 slide labels to right
    //3 slide votecount to right
    
    CGRect currentFrame = self.voteLabel.frame;
    CGRect newFrame = CGRectMake(2 * self.view.frame.size.width + currentFrame.size.width,
                                 currentFrame.origin.y,
                                 currentFrame.size.width,
                                 currentFrame.size.height);
    
    [self slideViews:self.labels outOfView:YES];
    [self slideViews:_voteBarViews outOfView:YES];
    [self animateView:self.voteLabel toFrame:newFrame withDuration:0];
    
}

-(void)slideInNewContent
{
    //_fullScreenPrevQVC = [[ATCQuestionStatisticsVC alloc] initWithNibName:@"ATCFullScreenPreviousQuestionVC" question:self.questionToShow];
    [self.view addSubview:_fullScreenPrevQVC.view];
    CGRect parentViewRect = self.parentViewController.view.frame;
    CGRect initFrame = CGRectMake(-self.view.frame.size.width,
                                  0,
                                  self.view.frame.size.width,
                                  parentViewRect.size.height);
    _fullScreenPrevQVC.view.frame = initFrame;
    CGRect frameInView = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width,
                                  parentViewRect.size.height);
    [self animateView:_fullScreenPrevQVC.view toFrame:frameInView withDuration:0.2];
    
}

-(void)slideOutNewContentAndSlideUpView
{
    CGRect currentRect = _fullScreenPrevQVC.view.frame;
    CGRect outsideFrame = CGRectMake(-600,
                                  currentRect.origin.y,
                                  currentRect.size.height,
                                  currentRect.size.width);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _fullScreenPrevQVC.view.frame = outsideFrame; } completion:^(BOOL finished){ [self slideUpView];}];
    

}

-(void)slideInTheMiniContent
{
    [self layoutBars];
    [self layoutLabels];
}


#pragma mark Slide out content
-(void)slideViews:(NSArray*)viewsToSlide outOfView:(BOOL)slideOutOrNot
{
    for (UIView *view in viewsToSlide) {
        CGRect newFrame = CGRectMake(self.view.frame.size.width,
                                     view.frame.origin.y,
                                     view.frame.size.width,
                                     view.frame.size.height);
        [self animateView:view toFrame:newFrame withDuration:0];
    }
}

@end
