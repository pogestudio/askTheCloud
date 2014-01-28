//
//  UIView+addShadow.m
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "UIView+addShadow.h"

@implementation UIView (addShadow)

-(void)addStandardShadow
{
    [self addShadowWithOffset:CGSizeMake(5, 5)];
}

-(void)addShadowWithOffset:(CGSize)offSet
{
    CALayer *layer  = self.layer;
    [layer setShadowOffset:offSet];
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.5];
}

-(void)addSurroundingShadowWithRadius:(CGFloat)radius
{
    CALayer *layer  = self.layer;
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:1];
    [layer setShadowRadius:radius];
}

@end
