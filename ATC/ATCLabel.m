//
//  ATCLabel.m
//  ATC
//
//  Created by CA on 12/18/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCLabel.h"

@implementation ATCLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    // Draw the text without an outline
    [super drawTextInRect:rect];
    
    CGImageRef alphaMask = NULL;
    
    if (self.drawGradient) {
        // Create a mask from the text
        alphaMask = CGBitmapContextCreateImage(context);
        
        // clear the image
        CGContextClearRect(context, rect);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        
        // invert everything because CoreGraphics works with an inverted coordinate system
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Clip the current context to our alphaMask
        CGContextClipToMask(context, rect, alphaMask);
        
        // Create the gradient with these colors
        CGFloat colors [] = {
            22.0f/255.0f, 107.0f/255.0f, 168.0f/255.0f, 1.0,
            71.0f/255.0f, 160.0f/255.0f, 220.0f/255.0f, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        // Draw the gradient
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
    
    if (self.drawOutline) {
        // Create a mask from the text (with the gradient)
        alphaMask = CGBitmapContextCreateImage(context);
        
        // Outline width
        CGContextSetLineWidth(context, 1);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        // Set the drawing method to stroke
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        
        // Outline color
        self.textColor = self.outlineColor;
        
        // notice the +1 for the y-coordinate. this is to account for the face that the outline appears to be thicker on top
        [super drawTextInRect:CGRectMake(rect.origin.x, rect.origin.y+1, rect.size.width, rect.size.height)];
        
        // Draw the saved image over the outline
        // and invert everything because CoreGraphics works with an inverted coordinate system
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, rect, alphaMask);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
}

@end
