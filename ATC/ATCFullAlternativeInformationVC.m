//
//  ATCFullAlternativeInformationViewController.m
//  ATC
//
//  Created by CA on 12/1/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCFullAlternativeInformationVC.h"
#import "ATCVoteCountBar.h"
#import "UILabel+sizeToFit.h"

#define STAT_BAR_HEIGHT self.view.frame.size.height
#define PERCENT_LABEL_FRACTION_WIDTH_OF_VIEW 0.3

@interface ATCFullAlternativeInformationVC ()

@end

@implementation ATCFullAlternativeInformationVC

@synthesize percentage = _percentage;


- (id)initWithFrame:(CGRect)frame percentage:(CGFloat)percentage alternativeId:(NSUInteger)alternativeId
{
    self = [super init];
    if (self) {
        self.percentage = percentage;
        self.alternativeId = alternativeId;
        self.view = [[UIView alloc] initWithFrame:frame];
        self.colorForAlternative = [ATCColorPalette alternativeColorForId:alternativeId];
        [self setUpInitialLayout];
        _isCurrentlyAnimating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setVotebar:nil];
    [self setAlternativeText:nil];
    [self setPercentLabel:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark SetUp

-(void)setUpPercentLabel
{
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width * PERCENT_LABEL_FRACTION_WIDTH_OF_VIEW;
    CGFloat xPos = self.view.frame.size.width;
    CGFloat yPos = 5;
    CGRect labelFrame = CGRectMake(xPos, yPos, width, height);
    self.percentLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.textColor = [ATCColorPalette surroundingDataFont];
    self.percentLabel.text = @"99%";
    self.percentLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.percentLabel.numberOfLines = 0;
    [self.percentLabel sizeFontToFitCurrentFrameStartingAt:40];
    [self.view addSubview:self.percentLabel];
}

-(void)setUpVoteBar
{
    CGRect frameForBar = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.votebar = [[ATCVoteCountBar alloc] initWithFrame:frameForBar andColor:self.colorForAlternative];
    [self.view addSubview:self.votebar];
}

-(void)setUpTextFrame
{
    CGRect rectForLabel = self.view.bounds;
    self.alternativeText = [[ATCLabel alloc] initWithFrame:rectForLabel];
    /*
    self.alternativeText.drawGradient = NO;
    self.alternativeText.drawOutline = NO;
    self.alternativeText.outlineColor = self.colorForAlternative;
    */
    self.alternativeText.numberOfLines = 0;
    self.alternativeText.textAlignment = UITextAlignmentCenter;
    self.alternativeText.lineBreakMode = UILineBreakModeWordWrap;
    self.alternativeText.minimumFontSize = 5.0;
    self.alternativeText.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
    self.alternativeText.backgroundColor = [UIColor clearColor];
    [self.alternativeText setTextColor:[ATCColorPalette alternativeFont]];
    [self.view addSubview:self.alternativeText];
}
#pragma mark -
#pragma mark Layout
-(void)setUpInitialLayout
{
    [self setUpVoteBar];
    [self setUpTextFrame];
    [self setUpPercentLabel];
}

-(void)adjustWidthOfBarAndPercentage
{
    _isCurrentlyAnimating = YES;
    
    CGRect currentFrame = self.votebar.frame;
    CGFloat maxWidth = [self calculateMaxWidth];
    CGRect newBarFrame = CGRectMake(currentFrame.origin.x,
                                    currentFrame.origin.y,
                                    maxWidth * self.percentage,
                                    currentFrame.size.height);
    
    CGRect percentageFrame = self.percentLabel.frame;
    CGRect newPercentageFrame = CGRectMake(self.view.frame.size.width - percentageFrame.size.width + 10,
                                           percentageFrame.origin.y,
                                           percentageFrame.size.width,
                                           percentageFrame.size.height);
    
    [self animateTextInAndOutIfNeeded];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.votebar.frame = newBarFrame;
                         self.percentLabel.frame = newPercentageFrame;
                     } completion:^(BOOL finished) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             _isCurrentlyAnimating = NO;
                         });                        
                     }];
    
}

-(void)animateTextInAndOutIfNeeded
{
    if (self.alternativeText.frame.size.width < self.view.frame.size.width * 0.9) {
        //if we have already animated, don't do it again.
        return;
    }
    CGRect currentText = self.alternativeText.frame;
    CGFloat xPadding = 8;
    CGRect newText = CGRectMake(xPadding,
                                currentText.origin.y,
                                currentText.size.width * (1 - PERCENT_LABEL_FRACTION_WIDTH_OF_VIEW) - xPadding,
                                currentText.size.height);
    UILabel *oldLabel = self.alternativeText;
    UILabel *newLabel = [[UILabel alloc] initWithFrame:newText];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = oldLabel.font;
    newLabel.text = oldLabel.text;
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.lineBreakMode = UILineBreakModeWordWrap;
    newLabel.numberOfLines = 0;
    newLabel.textColor = oldLabel.textColor;
    [newLabel sizeFontToFitCurrentFrameStartingAt:oldLabel.font.pointSize];
    newLabel.alpha = 0;
    self.alternativeText = newLabel;
    [self.view addSubview:self.alternativeText];
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         oldLabel.alpha = 0;
                     } completion:^(BOOL finished){
                         
                         [oldLabel removeFromSuperview];
                         
                         [UIView animateWithDuration:0.15
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.alternativeText.alpha = 1;
                                          } completion:nil];
                     }];
    
}

-(CGFloat)adjustFontSize
{
    [self.alternativeText sizeFontToFitCurrentFrameStartingAt:MAX_ALTERNATIVE_FONT_SIZE];
    CGFloat calculatedSize = self.alternativeText.font.pointSize;
    return calculatedSize;
}

-(void)adjustToFitCurrentStatistics
{
    if (_isCurrentlyAnimating) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self adjustToFitCurrentStatistics];
        });
        return;
    }
    [self adjustWidthOfBarAndPercentage];
    self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%",self.percentage * 100];
}

-(CGFloat)calculateMaxWidth
{
    CGFloat maxWidth = self.view.bounds.size.width;
    return maxWidth;
}

#pragma mark Custom getter and setter
-(void)setPercentage:(CGFloat)percentage
{
    _percentage = percentage;
}

-(CGFloat)percentage
{
    CGFloat percentageToReturn = MAX(0,_percentage);
    percentageToReturn = MIN(100,_percentage);
    return percentageToReturn;
}



@end
