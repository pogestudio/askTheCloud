//
//  NSString+addPlural.h
//  ATC
//
//  Created by CA on 12/17/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (boolAppender)

-(NSString*)append:(NSString*)stringToAppend if:(BOOL)weShouldAppend;

@end
