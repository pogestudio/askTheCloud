//
//  ATCColorPalette.m
//  ATC
//
//  Created by CA on 12/5/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCColorPalette.h"

@implementation ATCColorPalette

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//alt 1 and 3, pale with green or red http://colorschemedesigner.com/#2U22L1BsOw0w0
//alt 4, crazy purple http://colorschemedesigner.com/#4m62fw0w0w0w0

#pragma mark -
#pragma mark Buttons
+(UIColor*)color1
{
    //GREEN
    return [UIColor colorWithRed:00/255.0 green:175/255.0 blue:100/255.0 alpha:1]; //The original color1.
    //return [UIColor colorWithRed:54/255.0 green:215/255.0 blue:146/255.0 alpha:1]; //more white

}

+(UIColor*)color2
{
    //BLUE
    return [UIColor colorWithRed:63/255.0 green:146/255.0 blue:210/255.0 alpha:1]; //original
    //return [UIColor colorWithRed:102/255.0 green:163/255.0 blue:210/255.0 alpha:1]; //more white
}

+(UIColor*)color3
{
    //ORANGE
    return [UIColor colorWithRed:245/255.0 green:173/255.0 blue:64/255.0 alpha:1]; //original
    //return [UIColor colorWithRed:255/255.0 green:173/255.0 blue:112/255.0 alpha:1]; //more white
}

+(UIColor*)color4
{
    //RED
    return [UIColor colorWithRed:255/255.0 green:118/255.0 blue:64/255.0 alpha:1]; //original
    //return [UIColor colorWithRed:255/255.0 green:155/255.0 blue:115/255.0 alpha:1]; //more white
}


/*
 Returns the appropriate color for vote button. 0-indexed.
 */
+(UIColor*)alternativeColorForId:(NSUInteger)index
{
    UIColor* chosenColor;
    switch (index) {
        case 1:
        {
            chosenColor = [ATCColorPalette color1];

            break;
        }
        case 2:
        {
            chosenColor = [ATCColorPalette color4];
            break;
        }
        case 3:
        {
            chosenColor = [ATCColorPalette color2];
            break;
        }
        case 4:
        {
            chosenColor = [ATCColorPalette color3];
            break;
        }
        default:
        {
            NSAssert1(nil, @"Something went wrong in picking button color. Wrong id?",nil);
        }
    }
    return chosenColor;
}

+(UIColor*)voteButtonRegular
{
    //return [UIColor colorWithRed:149/255.0 green:80/255.0 blue:71/255.0 alpha:1]; //alt 1, pale with red buttons
    //return [UIColor colorWithRed:53/255.0 green:111/255.0 blue:68/255.0 alpha:1.0]; //alt 2, shades of green
    //return [UIColor colorWithHue:218.0/360.0 saturation:0.44 brightness:0.80 alpha:1]; // alt 3, pale with blue buttons
    //return [UIColor colorWithRed:206/255.0 green:0/255.0 blue:113/255.0 alpha:1]; //alt 4, crazy purple
    return [UIColor grayColor]; //alt 5, white and green
    
}

+(UIColor*)accessoryButton
{
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 1, pale with red buttons
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 3, pale with blue buttons
    //return [UIColor colorWithRed:71/255.0 green:17/255.0 blue:174/255.0 alpha:1]; //alt 4, crazy purple
    return [UIColor colorWithRed:97/255.0 green:153/255.0 blue:0/255.0 alpha:1]; //alt 5, white and green


}

+(UIColor*)topBarButton
{
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 1, pale with red buttons
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 3, pale with blue buttons
    //return [UIColor colorWithRed:71/255.0 green:17/255.0 blue:174/255.0 alpha:1]; //alt 4, crazy purple
    //return [UIColor colorWithRed:97/255.0 green:153/255.0 blue:0/255.0 alpha:1]; //alt 5, white and green
    return [UIColor colorWithRed:32/255.0 green:178/255.0 blue:170/255.0 alpha:1];
}

+(UIColor*)navBarRightButton
{
    return [ATCColorPalette color1];
}

+(UIColor*)navBarCancelButton
{
    return [ATCColorPalette color3];
}

#pragma mark Backgrounds
+(UIColor*)lightBackgroundColor
{
    //return [UIColor colorWithRed:205/255.0 green:213/255.0 blue:207/255.0 alpha:1.0]; alt 1, pale with red buttons
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1.0];
    //return [UIColor colorWithHue:158/360.0 saturation:0.24 brightness:0.9 alpha:1];
    //return [UIColor colorWithRed:144/255.0 green:108/255.0 blue:215/255.0 alpha:1]; //alt 4, crazy purple
    //return [UIColor colorWithRed:220/255.0 green:240/255.0 blue:219/255.0 alpha:1]; // alt 5, white(pale green) and green
    return [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
}

#pragma mark Framework items
+(UIColor*)navigationBar
{
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 1, pale with red buttons
    //return [UIColor colorWithRed:149/255.0 green:236/255.0 blue:0/255.0 alpha:1]; //alt 5, white and green
    //return [ATCColorPalette voteButtonRegular];
    return [UIColor colorWithRed:63/255.0 green:146/255.0 blue:210/255.0 alpha:1]; //original BLUE

}

+(UIColor*)topMenu
{
    //return [UIColor colorWithRed:163/255.0 green:172/255.0 blue:165/255.0 alpha:1]; //alt 1, pale with red buttons
    //return [ATCColorPalette voteButtonRegular];
    //return [UIColor colorWithRed:71/255.0 green:17/255.0 blue:174/255.0 alpha:1]; //alt 4, crazy purple
    //return [UIColor colorWithRed:97/255.0 green:153/255.0 blue:0/255.0 alpha:1]; //alt 5, white and green
    //return [UIColor colorWithRed:32/255.0 green:178/255.0 blue:170/255.0 alpha:1]; dentist green, as in logo
    return [ATCColorPalette navigationBar];


}

+(UIColor*)createQuestionAlternativeCell
{
    return [ATCColorPalette color1];
}


#pragma mark -
#pragma mark Font Colors

+(UIColor*)createQuestionFont
{
    return [UIColor whiteColor];
}

+(UIColor*)questionFont
{
    //return [UIColor whiteColor]; //alt 1, pale with green buttons
    //return [UIColor colorWithHue:218.0/360.0 saturation:1 brightness:0.9 alpha:1]; //disgusting blue
    return [ATCColorPalette alternativeFont];
}

+(UIColor*)questionFontShadow
{
    return [UIColor blackColor];
}

+(UIColor*)alternativeFont
{
    return [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1]; //original 
}
+(UIColor*)accessoryButtonFont
{
    return [UIColor whiteColor]; //alt 1, pale with green buttons
    //return [UIColor colorWithHue:218.0/360.0 saturation:1 brightness:0.9 alpha:1]; //disgusting blue
    
}

+(UIColor*)topBarButtonFont
{
    return [UIColor whiteColor]; //alt 1, pale with green buttons
    return [UIColor colorWithHue:218.0/360.0 saturation:1 brightness:0.9 alpha:1]; //disgusting blue
    
}

+(UIColor*)surroundingDataFont
{
    return [UIColor darkGrayColor];
}

#pragma mark CELLs
+(UIColor*)loginCellBackgroundColor
{
    UIColor *chosenColor = [UIColor colorWithRed:63/255.0 green:146/255.0 blue:210/255.0 alpha:1];
    return chosenColor;
}

+(UIColor*)loginCellFontColor
{
    UIColor *chosenColor = [UIColor whiteColor];
    return chosenColor;
}
@end
