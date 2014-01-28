//
//  ATCCustomSectionHeader.m
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCCustomSectionHeader.h"
#import "ATCCommonDrawing.h"

@implementation ATCCustomSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.opaque = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        self.titleLabel.textColor = [UIColor blackColor];
        //self.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:self.titleLabel];
        self.colorForView = [ATCColorPalette voteButtonRegular];
    }
    return self;
}

-(void) layoutSubviews
{
    CGFloat viewMargin = 9;
    CGFloat labelMargin = 6.0;
    CGFloat labelHeight = self.bounds.size.height - viewMargin - labelMargin;
    CGRect titleLabelFrame = CGRectMake(labelMargin,
                                 labelMargin,
                                 self.bounds.size.width-labelMargin*2,
                                 labelHeight);
    self.titleLabel.frame = titleLabelFrame;
    
    self.frameForBottomView = CGRectMake(viewMargin,
                                         CGRectGetMaxY(titleLabelFrame),
                                         self.bounds.size.width-viewMargin*2,
                                         self.bounds.size.height-CGRectGetMaxY(titleLabelFrame));
    
    self.titleLabel.frame = titleLabelFrame;    
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0
                                             blue:1.0 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2
                                              blue:0.2 alpha:0.5].CGColor;
    
    CGColorRef backgroundColor = CGColorRetain([ATCColorPalette lightBackgroundColor].CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor);
    CGContextFillRect(context, self.bounds);
    /*
    
    CGContextSetFillColorWithColor(context, whiteColor);
    CGContextFillRect(context, _paperRect);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGContextSetFillColorWithColor(context, lightColor);
    CGContextFillRect(context, _coloredBoxRect);
    CGContextRestoreGState(context);
    */
    
    /*
    CGContextSetFillColorWithColor(context, backgroundColor);
    CGContextFillRect(context, self.titleLabel.frame);
    */
    
    CGColorRef redColor = [UIColor colorWithRed:1.0 green:0.0
                                             blue:0.0 alpha:1.0].CGColor;
    CGColorRef greenColor = [UIColor colorWithRed:0.0 green:1.0
                                             blue:0.0 alpha:1.0].CGColor;
    
    CGContextSaveGState(context);
    CGMutablePathRef arcPath = createArcPathFromTopOfRect(self.frameForBottomView, 8);
    CFRetain(arcPath);
    CGContextAddPath(context, arcPath);
    CGContextSetFillColorWithColor(context, self.colorForView.CGColor);
    CGContextFillPath(context);
    //CGContextClip(context);
    CGContextRestoreGState(context);
    CFRelease(arcPath);
    CGColorRelease(backgroundColor);
}

@end
