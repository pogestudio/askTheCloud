//
//  ATCQuestionList.m
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCQuestionList.h"

@implementation ATCQuestionList

-(ATCQuestionList*)lastQuestionList
{
    ATCQuestionList *last;
    if (self.next != nil) {
        last = [self.next lastQuestionList];
    } else {
        last = self;
    }
    return last;
}

-(NSUInteger)count
{
    NSUInteger count = 1;
    if (self.next != nil){
        count = count + [self.next count];
    }
    return count;
}


@end
