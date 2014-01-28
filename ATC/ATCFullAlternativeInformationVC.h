//
//  ATCFullAlternativeInformationViewController.h
//  ATC
//
//  Created by CA on 12/1/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATCLabel.h"

#define MAX_ALTERNATIVE_FONT_SIZE 30

@interface ATCFullAlternativeInformationVC : UIViewController
{
    @private
    CGFloat _maxWidth;
    CGFloat _percentage;
    BOOL _isCurrentlyAnimating;
}
@property (strong, nonatomic) UIView *votebar;
@property (strong, nonatomic) UILabel *alternativeText;
@property (strong, nonatomic) UILabel *percentLabel;
@property (assign) CGFloat percentage;
@property (assign) CGFloat maxAlternativeTextFontSize;
@property (assign) NSUInteger alternativeId;
@property (strong) UIColor *colorForAlternative;

-(CGFloat)adjustFontSize;
-(void)adjustToFitCurrentStatistics;
-(id)initWithFrame:(CGRect)frame percentage:(CGFloat)percentage alternativeId:(NSUInteger)alternativeId;

@end
