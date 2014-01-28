//
//  ATCQuestionStorage.m
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCQuestionStorage.h"
#import "ATCQuestion.h"


#define STORAGE_SIZE 3

@implementation ATCQuestionStorage

static ATCQuestionStorage *_sharedStorage;
+(ATCQuestionStorage*)sharedStorage
{
    if (_sharedStorage == nil) {
        _sharedStorage = [[ATCQuestionStorage alloc] init];
    }
    return _sharedStorage;
}

+(ATCQuestionStorage*)sharedStorageWithArrayOfQuestions:(NSArray*)questions
{
    _sharedStorage = [[ATCQuestionStorage alloc] init];
    _sharedStorage.theQuestionList = [NSMutableArray arrayWithArray:questions];
    return _sharedStorage;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.hasQuestionsToGiveAway = NO;
        self.isCurrentlyFetching = NO;
        _indexOfLastAccessedQuestion = -1;
        self.theQuestionList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(ATCQuestion*)deliverNextQuestion
{
    if (![self listHasEnoughItems]) {
        [self getMoreQuestions];
    }
    
    [self makeSureEngouhQuestionsHaveAlternatives];
    
    ATCQuestion *nextQ;
    BOOL thereIsEnoughItemsInList = ([self.theQuestionList count] > _indexOfLastAccessedQuestion + 1);
    
    if (thereIsEnoughItemsInList) {
        nextQ = [self.theQuestionList objectAtIndex:++_indexOfLastAccessedQuestion];
        NSLog(@"AC: %d",[nextQ.alternatives count]);
        if ([nextQ.alternatives count] == 0) {
            [nextQ fillSelfWithCurrentInfo];
        }
    }
    
    if ([self.theQuestionList count] == _indexOfLastAccessedQuestion + 1) {
        self.hasQuestionsToGiveAway = NO;
    }
    
    return nextQ;
}

-(void)getMoreQuestions
{
    if (self.isCurrentlyFetching == YES) {
        return;
    }

    self.isCurrentlyFetching = YES;
    NSUInteger amountOfQuestionToGet = STORAGE_SIZE;
    ATCServerInterface *sharedServer = [ATCServerInterface sharedServerInterface];
    [sharedServer fetchQuestionsTo:self amountOfQuestions:amountOfQuestionToGet startingAtId:0];
}

-(void)receivedQuestionsFromServer:(NSMutableArray *)receivedObjects
{
    self.isCurrentlyFetching = NO;
    
    //if we receive nil, server timed out
    if (receivedObjects == nil) {
        [self sleepAndTryAgain];
        return;
    } else {
        _amountOfFailuresToFetchInARow = 0;
    }
    
    [self.theQuestionList addObjectsFromArray:receivedObjects];
    
    self.hasQuestionsToGiveAway = YES;
    
    NSLog(@"Number of questions in questionlist after append: %d",[self.theQuestionList count]);
}

-(void)sleepAndTryAgain
{
    _amountOfFailuresToFetchInARow++;
    int64_t delayInSeconds = pow(2, _amountOfFailuresToFetchInARow);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getMoreQuestions];
    });
    
}

-(BOOL)listHasEnoughItems
{
    NSUInteger numberOfItemsInArray = [self.theQuestionList count];
    NSUInteger numberOfUnvotedItems = numberOfItemsInArray - MAX(0, _indexOfLastAccessedQuestion);
    BOOL doesStorageSizeExist = numberOfUnvotedItems >= STORAGE_SIZE;
    
    return doesStorageSizeExist;
}

-(void)makeSureEngouhQuestionsHaveAlternatives
{
    NSUInteger amount = 3 * STORAGE_SIZE;
    for (NSUInteger index = _indexOfLastAccessedQuestion ;
         index < _indexOfLastAccessedQuestion + amount && index < [self.theQuestionList count] ;
         index++)
    {
        ATCQuestion *aQ = [self.theQuestionList objectAtIndex:index];
        if ([aQ.alternatives count] == 0) {
            [aQ fillSelfWithCurrentInfo];
        }
    }
}
@end
