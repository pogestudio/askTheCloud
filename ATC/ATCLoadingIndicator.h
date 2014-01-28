//
//  ATCLoadingIndicator.h
//  ATC
//
//  Created by CA on 12/12/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LOADING_INDICATOR_VIEW_TAG 897

@interface ATCLoadingIndicator : UIView
{
    @private
    NSUInteger _colorIndex;
    NSUInteger _previousDirection;
    UIView *_slidingOverView;
    BOOL _shouldStop;
    
}

@property (strong) NSArray *colorSequence;
@property (assign) CGFloat animationDuration;
@property (assign) CGFloat animationDelay;

-(void)startAnimation;
-(void)stopAnimation;

@end
