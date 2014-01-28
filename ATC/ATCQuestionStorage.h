//
//  ATCQuestionStorage.h
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATCServerInterface.h"

@interface ATCQuestionStorage : NSObject <QuestionFetchDelegate>
{
    @private
    NSInteger _indexOfLastAccessedQuestion;
    CGFloat _amountOfFailuresToFetchInARow;
}

@property (strong) NSMutableArray *theQuestionList;
@property (strong) NSEnumerator *theEnumerator;


@property (assign) BOOL isCurrentlyFetching;
@property (assign) BOOL hasQuestionsToGiveAway;
-(ATCQuestion*)deliverNextQuestion;                             //give the next question, and
-(void)getMoreQuestions;
+(ATCQuestionStorage*)sharedStorage;                            //the shared static instance that all objects use.
+(ATCQuestionStorage*)sharedStorageWithArrayOfQuestions:(NSArray*)questions;



@end
