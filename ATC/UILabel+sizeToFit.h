//
//  UILabel+sizeToFit.h
//  ATC
//
//  Created by CA on 11/18/12.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (sizeToFit)

-(void)sizeFontToFitCurrentFrameStartingAt:(CGFloat)startingSizeFont;
-(void)sizeFontToFitFrame:(CGRect)frame startingAt:(CGFloat)startingSizeFont;

-(void)addShadow;

@end
