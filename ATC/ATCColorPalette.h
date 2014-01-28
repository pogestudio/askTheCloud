//
//  ATCColorPalette.h
//  ATC
//
//  Created by CA on 12/5/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCColorPalette : NSObject

+ (UIImage *) imageFromColor:(UIColor *)color;

//BACKGOUND
+(UIColor*)lightBackgroundColor;

//BUTTONS
+(UIColor*)alternativeColorForId:(NSUInteger)index;
+(UIColor*)voteButtonRegular;

+(UIColor*)accessoryButton;
+(UIColor*)topBarButton;
+(UIColor*)topBarButtonHighlighted;

+(UIColor*)navBarRightButton;
+(UIColor*)navBarCancelButton;

//TOP MENUS
+(UIColor*)navigationBar;
+(UIColor*)topMenu;

+(UIColor*)createQuestionAlternativeCell;

//Font Colors
+(UIColor*)createQuestionFont;
+(UIColor*)questionFont;
+(UIColor*)questionFontShadow;
+(UIColor*)alternativeFont;
+(UIColor*)accessoryButtonFont;
+(UIColor*)topBarButtonFont;
+(UIColor*)surroundingDataFont;

//CELLS
+(UIColor*)loginCellBackgroundColor;
+(UIColor*)loginCellFontColor;


//THE COLORS
+(UIColor*)color1;
+(UIColor*)color2;
+(UIColor*)color3;
+(UIColor*)color4;

@end
