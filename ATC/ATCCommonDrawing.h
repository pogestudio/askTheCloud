//
//  ATCCommonDrawing.h
//  ATC
//
//  Created by CA on 12/10/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor,
                        CGColorRef  endColor);

CGRect rectFor1PxStroke(CGRect rect);


void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint,
                   CGColorRef color);

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createArcPathFromTopOfRect(CGRect rect, CGFloat arcHeight);