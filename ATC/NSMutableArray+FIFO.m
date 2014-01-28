//
//  NSMutableArray+FIFO.m
//  ATC
//
//  Created by CA on 12/14/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "NSMutableArray+FIFO.h"

@implementation NSMutableArray (FIFO)


-(id)firstObject
{
    if ([self count] == 0) {
        return nil;
    }

    id firstObject = [self objectAtIndex:0];
    
    return firstObject;
}

-(id)removeFirstObject
{
    if ([self count] == 0) {
        return nil;
    }
    
    id firstObject = [self firstObject];
    [self removeObject:firstObject];
    return firstObject;
}

@end
