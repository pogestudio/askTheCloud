//
//  ATCCustomCellBackground.m
//  ATC
//
//  Created by CA on 12/9/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCCustomCellBackground.h"

@implementation ATCCustomCellBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
 // Uncomment drawRect and replace the contents with the following:
    CGColorRef backgroundColor = CGColorRetain([ATCColorPalette createQuestionAlternativeCell].CGColor);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef lightGrayColor = CGColorRetain([UIColor colorWithRed:230.0/255.0 green:230.0/255.0
                                                               blue:230.0/255.0 alpha:1.0].CGColor);
    
    CGRect cellRect = self.bounds;
    CGContextSetFillColorWithColor(context, backgroundColor);
    CGContextFillRect(context, cellRect);
    
    //drawLinearGradient(context, cellRect, color1, color2);
    
    // Add down at the bottom
    /*
    CGRect strokeRect = cellRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);
    
    CGContextSetStrokeColorWithColor(context, color1);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
    */
    
    //BOTTOM LINE
    
    // Add at bottom
    CGPoint startPoint = CGPointMake(cellRect.origin.x,
                                     cellRect.origin.y + cellRect.size.height - 1);
    CGPoint endPoint = CGPointMake(cellRect.origin.x + cellRect.size.width - 1,
                                   cellRect.origin.y + cellRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, lightGrayColor);
    
    CGColorRelease(backgroundColor);
    CGColorRelease(lightGrayColor);
}
@end
