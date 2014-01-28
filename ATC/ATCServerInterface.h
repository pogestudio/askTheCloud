//
//  ATCServerInterface.h
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATCQuestion;

@protocol QuestionFetchDelegate

-(void)receivedQuestionsFromServer:(NSMutableArray*)receivedObjects;

@end

typedef enum {
    ServerResponseTimeout = 0,
    ServerResponseUnauthorized,
    ServerResponseSuccess,
} ServerResponse;

@protocol LoginToServerDelegate

-(void)loginActionHasCompleted:(ServerResponse)loginResponse;

@end

@protocol CreateQuestionDelegate

-(void)createQuestionHasCompleted:(ServerResponse)createQResponse;

@end

@protocol SearchResultsDelegate

-(void)searchResultsWasReceived:(NSArray*)listOfResults withCompletion:(ServerResponse)pullResponse;

@end


@interface ATCServerInterface : NSObject
{
    id<LoginToServerDelegate> _temporaryLoginDelegate;
    id<CreateQuestionDelegate> _temporaryCreateQuestionDelegate;
}

+(ATCServerInterface*)sharedServerInterface;                                //the shared server connection which all objects use
-(void)voteOnQuestion:(NSUInteger)questionId alternative:(NSUInteger)alternatives;      //vote on a question

#pragma Mark fetch
-(void)fetchQuestionsTo:(id<QuestionFetchDelegate>)receiver amountOfQuestions:(NSUInteger)amountToFetch startingAtId:(NSUInteger)qIdOrZeroForRandom;
-(ATCQuestion*)getASingleQuestionOfId:(NSUInteger)questionIdOr0ForRandom;               //get the info of a specific ID. give 0 for a random question!
-(void)fetchSearchResultTo:(id<SearchResultsDelegate>)receiver forQuery:(NSString*)query;
-(void)fetchUserQuestions:(id<SearchResultsDelegate,LoginToServerDelegate>)receiver;

#pragma mark Create
-(void)createQuestionOnServerWithTitle:(NSString*)title alternatives:(NSArray*)alternatives callBackTo:(id<CreateQuestionDelegate>)createQDelegate;

#pragma mark Authentication
-(void)initiateLoginUserName:(NSString*)uName passWord:(NSString*)passWord callBackTo:(id<LoginToServerDelegate>)delegate;
-(void)initiateLoginWithExistingUserDetailsWithCallBackTo:(id<LoginToServerDelegate>)delegate;
@end
