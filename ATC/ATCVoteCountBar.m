//
//  ATCVoteCountBar.m
//  ATC
//
//  Created by CA on 11/30/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCVoteCountBar.h"
#import "ATCColorPalette.h"

#define CORNER_RADIUS 3

@implementation ATCVoteCountBar

- (id)initWithFrame:(CGRect)frame andColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
    }
    return self;
}

@end
