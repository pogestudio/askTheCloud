//
//  ATCLoadingIndicator.m
//  ATC
//
//  Created by CA on 12/12/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCLoadingIndicator.h"

typedef enum {
    ViewSlideDirectionRight = 0,
    ViewSlideDirectionDown,
    ViewSlideDirectionLeft,
    ViewSlideDirectionUp,
    ViewSlideDirectionMAX,
} ViewSlideDirection;

@implementation ATCLoadingIndicator

- (id)init
{
    self = [super init];
    if (self) {
        [self fillSequenceWithRandomColors];
        _previousDirection = 0;
        _colorIndex = 0;
        self.animationDelay = 0;
        self.animationDuration = 0.5;
    }
    return self;
}

-(void)fillSequenceWithRandomColors
{
    NSMutableArray *allColors = [NSMutableArray arrayWithObjects:
                                 [ATCColorPalette color1],
                                 [ATCColorPalette color2],
                                 [ATCColorPalette color3],
                                 [ATCColorPalette color4],nil];
    
    NSMutableArray *randomized = [[NSMutableArray alloc] init];
    NSUInteger randomIndex;
    while ([allColors count] != 0) {
        randomIndex = rand() % [allColors count];
        UIColor *randomColor = [allColors objectAtIndex:randomIndex];
        [randomized addObject:randomColor];
        [allColors removeObject:randomColor];
    }
    self.colorSequence = randomized;
}

-(UIColor*)getNextColor
{
    _colorIndex++;
    if (_colorIndex >= [self.colorSequence count]) {
        _colorIndex = 0;
    }
    UIColor *nextColor = [self.colorSequence objectAtIndex:_colorIndex];
    
    return nextColor;
}

-(ViewSlideDirection)nextDirection
{
    _previousDirection++;
    if (_previousDirection == ViewSlideDirectionMAX) {
        _previousDirection = ViewSlideDirectionRight;
    }
    return _previousDirection;
}

-(void)startAnimation
{
    _shouldStop = NO;
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.height/2;
    _slidingOverView = [[UIView alloc] init];
    [self addSubview:_slidingOverView];
    [self performAnimation];
}

-(CGRect)getStartFrameFor:(ViewSlideDirection)direction
{
    CGFloat currentWidth = self.frame.size.width;
    CGFloat currentHeight = self.frame.size.height;
    
    CGRect startRect;
    switch (direction) {
        case ViewSlideDirectionDown:
        {
            startRect = CGRectMake(0, -currentHeight, currentWidth, currentHeight);
            break;
        }
        case ViewSlideDirectionLeft:
        {
            startRect = CGRectMake(currentWidth, 0, currentWidth, currentHeight);
            break;
        }
        case ViewSlideDirectionRight:
        {
            startRect = CGRectMake(-currentWidth,0, currentWidth, currentHeight);
            break;
        }
        case ViewSlideDirectionUp:
        {
            startRect = CGRectMake(0, currentHeight, currentWidth, currentHeight);
            break;
        }
            
        default:
        {
            NSAssert1(nil,@"Should never be here! wrong frame in loading ind",nil);
        }
            break;
    }
    
    return startRect;
    
}

-(void)performAnimation
{
    
    ViewSlideDirection nextSlide = [self nextDirection];
    CGRect startFrameForNextSlide = [self getStartFrameFor:nextSlide];
    _slidingOverView.frame = startFrameForNextSlide;
    _slidingOverView.layer.cornerRadius = _slidingOverView.frame.size.height/2;
    _slidingOverView.backgroundColor = [self getNextColor];
    _slidingOverView.alpha = 0;

    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         _slidingOverView.layer.cornerRadius = _slidingOverView.frame.size.height/2;
                         _slidingOverView.frame = self.bounds;
                         _slidingOverView.alpha = 1;
                     } completion:^(BOOL finished){
                         self.backgroundColor = _slidingOverView.backgroundColor;
                         _slidingOverView.layer.cornerRadius = _slidingOverView.frame.size.height/2;
                         self.layer.cornerRadius = self.frame.size.height/2;

                         if (!_shouldStop) {
                             [self performAnimation];
                         }
                     }];
    
}

-(void)stopAnimation
{
    _shouldStop = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
