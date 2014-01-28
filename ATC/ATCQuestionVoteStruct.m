//
//  ATCQuestionVoteStruct.m
//  ATC
//
//  Created by CA on 12/14/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCQuestionVoteStruct.h"

@implementation ATCQuestionVoteStruct

-(id)initWithQuestionId:(NSUInteger)questionId alternativeId:(NSUInteger)alternativeId
{
    self = [super init];
    if (self) {
        self.questionId = questionId;
        self.alternativeId = alternativeId;
    }
    return self;
}

@end
