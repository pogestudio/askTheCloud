//
//  ATCFullScreenPreviousQuestionVC.m
//  ATC
//
//  Created by CA on 12/2/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCQuestionStatisticsVC.h"
#import "ATCFullAlternativeInformationVC.h"
#import "ATCQuestionAlternative.h"
#import "ATCQuestion.h"

#import "UILabel+sizeToFit.h"

@interface ATCQuestionStatisticsVC ()

@end

@implementation ATCQuestionStatisticsVC


-(id)initWithQuestion:(ATCQuestion *)question forFrame:(CGRect)frame withDelegate:(id<ATCQuestionPresenterDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.question = question;
        _fullscreenAlternatives = [[NSMutableArray alloc] init];
        self.view = [[UIView alloc] initWithFrame:frame];
        _isObservingQuestionAlternatives = NO;
        _presenterDelegate = delegate;
        [self setUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isObservingQuestionAlternatives) {
        [self.question removeObserver:self forKeyPath:@"alternatives"];
        _isObservingQuestionAlternatives = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark animation
-(void)animateView:(UIView*)view toFrame:(CGRect)newFrame
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.frame = newFrame; }
                     completion:nil];
}


#pragma mark -
#pragma mark layout
-(void)setUpView
{
    [self initAlternativeBoxes];
    [self addSingleTapGestureRecognizer];
    [self addDataLabels];
    [self updateDataLabelValues];
}

-(void)initAlternativeBoxes
{
    CGFloat maxFontSizeForAllBoxes = 100;
    
    for (ATCQuestionAlternative *alternative in self.question.alternatives)
    {
        CGFloat percentage = [self.question percentageForAlternative:alternative];
        CGRect frameForInfoBox = [self frameForAlternativeBoxWithAlternative:alternative];
        ATCFullAlternativeInformationVC *infoBox = [[ATCFullAlternativeInformationVC alloc] initWithFrame:frameForInfoBox percentage:percentage alternativeId:alternative.alternativeId];
        [_fullscreenAlternatives addObject:infoBox];
        [self.view addSubview:infoBox.view];
        infoBox.alternativeText.text = alternative.text;
        CGFloat maxSizeForAlternative = [infoBox adjustFontSize];
        
        //remember the minimum font size
        if (maxSizeForAlternative < maxFontSizeForAllBoxes) {
            maxFontSizeForAllBoxes = maxSizeForAlternative;
        }
    }
    [self setAllAlternativesToFont:maxFontSizeForAllBoxes];
    
}


-(CGRect)frameForAlternativeBoxWithAlternative:(ATCQuestionAlternative*)alternative
{
    NSUInteger numberOfObjects = [self.question.alternatives count];
    NSUInteger thisAlternativeIndex = [self.question.alternatives indexOfObject:alternative];
    
    //Trix. 0 extra padding if max number of alternatives, increased padding if less alternatives.
    CGFloat yPadding = 0;
    CGFloat xPadding = 0;
    
    CGFloat yStartPos = 30;
    CGFloat windowWidth = self.view.frame.size.width;
    CGFloat heightToUse = self.view.frame.size.height - yStartPos;
    CGFloat xStartPos = xPadding;
    CGFloat width = windowWidth - 2*xPadding;
    CGFloat height = (heightToUse - numberOfObjects*yPadding) / numberOfObjects;
    
    CGFloat currentYPos = yStartPos + thisAlternativeIndex * (height + yPadding);
    CGFloat currentXPos = xStartPos; //we're only listing them in a straight row;
    CGRect theFrame = CGRectMake(currentXPos, currentYPos, width, height);
    return theFrame;
}

-(void)adjustAlternativesLayoutToCurrentStatistics
{
    {
        NSUInteger count = 0;
        for (ATCFullAlternativeInformationVC *infoBox in _fullscreenAlternatives) {
            ATCQuestionAlternative *alternative = [self.question.alternatives objectAtIndex:count];
            CGFloat percentage = [self.question percentageForAlternative:alternative];
            infoBox.percentage = percentage;
            [infoBox adjustToFitCurrentStatistics];
            count++;
        }
    }
}

-(void)addDataLabels
{
    
    CGFloat widthOfAgeFrame = self.view.frame.size.width * 0.4;

    CGRect frameForAge = CGRectMake(10,
                                    self.view.frame.size.height,
                                    widthOfAgeFrame,
                                    30);
    self.ageOfPost = [[UILabel alloc] initWithFrame:frameForAge];
    self.ageOfPost.backgroundColor = [UIColor clearColor];
    self.ageOfPost.textColor = [ATCColorPalette surroundingDataFont];
    self.ageOfPost.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    [self.view addSubview:self.ageOfPost];
    
    CGRect frameForVotes = CGRectMake(frameForAge.origin.x + frameForAge.size.width + 10,
                                    self.view.frame.size.height,
                                    self.view.frame.size.width * 0.3,
                                    30);
    self.numberOfVotes = [[UILabel alloc] initWithFrame:frameForVotes];
    self.numberOfVotes.backgroundColor = [UIColor clearColor];
    self.numberOfVotes.textColor = [ATCColorPalette surroundingDataFont];
    self.numberOfVotes.font = [UIFont fontWithName:@"Helvetica" size:19];
    [self.view addSubview:self.numberOfVotes];
}

-(void)updateDataLabelValues
{
    NSString *age = [NSString stringWithFormat:@"%@ old",[self.question ageOfQuestion]];
    self.ageOfPost.text = age;

    NSString *amount = [NSString stringWithFormat:@"%d votes",[self.question totalAmountOfVotes]];
    self.numberOfVotes.text = amount;
}
#pragma mark Administration
-(void)addSingleTapGestureRecognizer
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

-(void)viewWasTapped:(id)sender
{
    NSAssert1([sender isKindOfClass:[UIGestureRecognizer class]], @"not a gesture rec calling tap-selector", nil);
    
    UIGestureRecognizer *gestureRec = (UIGestureRecognizer*)sender;
    CGPoint tappedPoint = [gestureRec locationInView:self.view];

    for (ATCFullAlternativeInformationVC *infoBox in _fullscreenAlternatives) {
        BOOL isInside = CGRectContainsPoint(infoBox.view.frame, tappedPoint);
        if (isInside) {
            [_presenterDelegate questionHasBeenVotedOn];
            [self adjustAlternativesLayoutToCurrentStatistics];
            [self.question voteOn:infoBox.alternativeId];
            [self updateValues];
            [self.view removeGestureRecognizer:gestureRec];
            break;
        }
    }
}


#pragma mark -
#pragma mark Update values
-(void)setAllAlternativesToFont:(CGFloat)fontSize
{
    UIFont *existingFont;
    UIFont *newFont;

    for (ATCFullAlternativeInformationVC *infoBox in _fullscreenAlternatives)
    {
        if (newFont == nil) {
            existingFont = infoBox.alternativeText.font;
            newFont = [UIFont fontWithName:existingFont.fontName size:fontSize];
        }
        infoBox.alternativeText.font = newFont;
    }
}

-(void)updateValues
{
    if (_isObservingQuestionAlternatives == NO) {
        [self.question addObserver:self forKeyPath:@"alternatives" options:NSKeyValueObservingOptionNew context:nil];
        [self.question fillSelfWithCurrentInfo];
        _isObservingQuestionAlternatives = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self adjustAlternativesLayoutToCurrentStatistics];
    [self updateDataLabelValues];
}

@end
