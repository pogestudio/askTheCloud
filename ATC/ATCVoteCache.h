//
//  ATCVoteCache.h
//  ATC
//
//  Created by CA on 12/14/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATCQuestion;

typedef enum {
    VotingResultTimeout = 0,
    VotingResultMissing,
    VotingResultSuccess,
} VotingResult;

@interface ATCVoteCache : NSObject
{
    @private
    NSMutableArray *_votesToSend;
    CGFloat _amountOfFailuresToSendInARow;
}


-(void)voteOnQuestion:(ATCQuestion*)question withAlternativeId:(NSUInteger)alternativeId;
+(ATCVoteCache*)sharedVoteCache;                            //the shared static instance that all objects use.
-(void)resultFromVoteWithQuestionId:(NSUInteger)questionId result:(VotingResult)voteResult;

@end
