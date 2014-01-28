//
//  NSString+addPlural.m
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "NSString+boolAppender.h"

@implementation NSString (boolAppender)

-(NSString*)append:(NSString *)stringToAppend if:(BOOL)weShouldAppend
{
    NSString *stringToReturn;
    if (weShouldAppend) {
        stringToReturn = [NSString stringWithFormat:@"%@%@",self,stringToAppend];
    } else {
        stringToReturn = self;
    }
    return stringToReturn;
}

@end
