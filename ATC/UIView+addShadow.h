//
//  UIView+addShadow.h
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (addShadow)

-(void)addStandardShadow;
-(void)addShadowWithOffset:(CGSize)offSet;
-(void)addSurroundingShadowWithRadius:(CGFloat)radius;
@end
