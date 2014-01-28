//
//  ATCVoteCache.m
//  ATC
//
//  Created by CA on 12/14/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCVoteCache.h"
#import "ATCQuestion.h"
#import "ATCQuestionVoteStruct.h"
#import "ATCServerInterface.h"

#import "NSMutableArray+FIFO.h"

@implementation ATCVoteCache

static ATCVoteCache *_sharedCache;

+(ATCVoteCache*)sharedVoteCache
{
    if (_sharedCache == nil) {
        _sharedCache = [[ATCVoteCache alloc] init];
    }
    return _sharedCache;
}

-(id)init
{
    self = [super init];
    if (self) {
        _votesToSend = [[NSMutableArray alloc] init];
        _amountOfFailuresToSendInARow = 0;
    }
    
    return self;
}

-(void)voteOnQuestion:(ATCQuestion *)question withAlternativeId:(NSUInteger)alternativeId
{
    ATCQuestionVoteStruct *newStruct = [[ATCQuestionVoteStruct alloc] initWithQuestionId:question.questionId alternativeId:alternativeId];
    [_votesToSend addObject:newStruct];
    [self sendNextVoteToServer];
}

-(void)sendNextVoteToServer
{
    ATCQuestionVoteStruct *firstVote = [_votesToSend firstObject];
    if (firstVote == nil) {
        return;
    }
    [[ATCServerInterface sharedServerInterface] voteOnQuestion:firstVote.questionId alternative:firstVote.alternativeId];
}

-(void)resultFromVoteWithQuestionId:(NSUInteger)questionId result:(VotingResult)voteResult
{
    if (voteResult == VotingResultSuccess) {
        [_votesToSend removeFirstObject];
    }
    
    switch (voteResult) {
        case VotingResultSuccess:
        {
            _amountOfFailuresToSendInARow = 0;
            [self removeQuestionWithId:questionId];
            [self sendNextVoteToServer];
            break;
        }
        case VotingResultTimeout:
        {
            [self sleepAndTryAgain];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark Reaction to server response
-(void)removeQuestionWithId:(NSUInteger)questionId
{
    ATCQuestionVoteStruct *qVoteToRemove;
    for (ATCQuestionVoteStruct *qVote in _votesToSend) {
        if (qVote.questionId == questionId) {
            qVoteToRemove = qVote;
            break;
        }
    }
    
    [_votesToSend removeObject:qVoteToRemove];
}

-(void)sleepAndTryAgain
{
    _amountOfFailuresToSendInARow++;
    int64_t delayInSeconds = pow(2, _amountOfFailuresToSendInARow);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self sendNextVoteToServer];
    });
    
}

-(void)reloadAllQuestionsInDatabase
{
    
}

@end
