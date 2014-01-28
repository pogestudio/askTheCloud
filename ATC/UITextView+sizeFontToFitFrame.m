//
//  UITextView+sizeFontToFitFrame.m
//  ATC
//
//  Created by CA on 12/7/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "UITextView+sizeFontToFitFrame.h"

@implementation UITextView (sizeFontToFitFrame)

-(void)sizeFontToFitCurrentFrameStartingAt:(CGFloat)startingSizeFont
{
    CGRect frameToFit = self.frame;
    // Set the frame of the label to the targeted rectangle
    NSString *fontname = self.font.fontName;
    // Try all font sizes from largest to smallest font size
    CGFloat fontSize = startingSizeFont;
    CGFloat minFontSize = 9;
    
    CGSize constraintSize = CGSizeMake(frameToFit.size.width, 800);
    UIFont *newFont;
    NSString *textToFit = [NSString stringWithFormat:@"%@ extra",self.text];
    do {
        // Set current font size
         newFont = [UIFont fontWithName:fontname size:fontSize];
        
        // Find label size for current font size
        CGSize newsize = [textToFit sizeWithFont:newFont
                                  constrainedToSize:constraintSize];
        
        // Done, if created label is within target size
        if( newsize.height <= frameToFit.size.height-5 )
        {
            self.font = newFont;
            break;
        }
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
}

@end
