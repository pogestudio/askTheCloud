//
//  UILabel+sizeToFit.m
//  ATC
//
//  Created by CA on 11/18/12.
//
//

#import "UILabel+sizeToFit.h"

@implementation UILabel (sizeToFit)

-(void)sizeFontToFitCurrentFrameStartingAt:(CGFloat)startingSizeFont
{
    [self sizeFontToFitFrame:self.frame startingAt:startingSizeFont];
    
}

-(void)sizeFontToFitFrame:(CGRect)frame startingAt:(CGFloat)startingSizeFont
{
    UILabel *label = self;
    CGRect labelRect = frame;
    // Set the frame of the label to the targeted rectangle
    
    //DEBUG
    NSString *stringInLabel = self.text;
    
    label.frame = labelRect;
    
    NSString *fontname = self.font.fontName;
    // Try all font sizes from largest to smallest font size
    CGFloat fontSize = startingSizeFont;
    CGFloat minFontSize = label.minimumFontSize;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(labelRect.size.width, 400);
    
    do {
        // Set current font size
        label.font = [UIFont fontWithName:fontname size:fontSize];
        
        // Find label size for current font size
        CGSize labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:constraintSize];
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
    
}

-(void)addShadow
{
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
}
@end
