//
//  ATCQuestionVoteStruct.h
//  ATC
//
//  Created by CA on 12/14/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCQuestionVoteStruct : NSObject

@property (assign) NSUInteger questionId;
@property (assign) NSUInteger alternativeId;

-(id)initWithQuestionId:(NSUInteger)questionId alternativeId:(NSUInteger)alternativeId;

@end
