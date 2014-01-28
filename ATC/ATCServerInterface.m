//
//  ATCServerInterface.m
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCServerInterface.h"
#import "ATCQuestion.h"
#import "ATCUserAuthHelper.h"
#import "NSString+de_encoding.h"


#import "ATCVoteCache.h"
#import "NSDictionary+JSON.h"   

#define URL_BASE_ADDRESS [NSString stringWithFormat:@"http://atc.dflemstr.name/api"]


#define kNilOptions 0

typedef enum {
    TypeOfPostIsAuthentication = 0,
    TypeOfPostIsVote,
    TypeOfPostIsCreateQuestion,
    TypeOfPostIs,
} TypeOfPost;

@implementation ATCServerInterface

dispatch_queue_t queue;

static ATCServerInterface *sharedServerInterface;

-(id)init
{
    self = [super init];
    if (self) {
        queue = dispatch_queue_create("com.atc.queue", nil);
    }
    
    return self;
}

+(ATCServerInterface*)sharedServerInterface
{
    if (sharedServerInterface == nil) {
        sharedServerInterface = [[ATCServerInterface alloc] init];
    }
        
    return sharedServerInterface;
}

#pragma mark Sending data
-(void)createQuestionOnServerWithTitle:(NSString *)title alternatives:(NSArray *)alternatives callBackTo:(id<CreateQuestionDelegate>)delegate
{
    _temporaryCreateQuestionDelegate = delegate;
    
    NSString *currentToken = [[ATCUserAuthHelper sharedAuthHelper] getUserToken];
    NSDictionary *dictToPost = [NSDictionary dictionaryWithObjectsAndKeys:title,
                                @"question",
                                alternatives,
                                @"alternatives",
                                currentToken,
                                @"token", nil];
    NSString *urlToPostTo = [NSString stringWithFormat:@"%@/question/ask",URL_BASE_ADDRESS];
    [self postToServer:dictToPost toURL:urlToPostTo kindOfPost:TypeOfPostIsCreateQuestion];

}

-(void)voteOnQuestion:(NSUInteger)questionId alternative:(NSUInteger)alternativeId
{
    NSDictionary *dictToPost = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:questionId],
                                @"questionId",
                                [NSNumber numberWithInt:alternativeId],
                                @"alternativeId", nil];
    NSString *urlToPostTo = [NSString stringWithFormat:@"%@/question/%d/vote/%d",URL_BASE_ADDRESS,questionId,alternativeId];
    [self postToServer:dictToPost toURL:urlToPostTo kindOfPost:TypeOfPostIsVote];
}

-(void)postToServer:(NSDictionary*)dictToPost toURL:(NSString*)url kindOfPost:(TypeOfPost)typeOfPost
{
    NSLog(@"%@",dictToPost);
    dispatch_async(queue, ^{
        NSURL *postUrl = [NSURL URLWithString:url];
        NSData *JSONData = [dictToPost toJSON];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [JSONData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:JSONData];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary* resultFromServer;
        
        if (result != nil) {
            resultFromServer = [NSJSONSerialization
                                JSONObjectWithData:result
                                options:kNilOptions
                                error:nil];
        } else {
            resultFromServer = nil;
        }
        if (error != nil) {
            NSLog(@"ERROR: %@",error);
        }
        
        switch (typeOfPost) {
            case TypeOfPostIsCreateQuestion:
            {
#warning get authorization/re-auth!!
                [self interpretCreateResponse:resultFromServer withSentDict:dictToPost];
                break;
            }
            case TypeOfPostIsVote:
            {
                [self interpretVotingResponse:resultFromServer withSentDict:dictToPost];
                break;
            }
            case TypeOfPostIsAuthentication:
            {
                [self  interpretAuthResponse:resultFromServer withSentDict:dictToPost];
                break;
            }
            default:
                break;
        }
	});
}

#pragma mark -
#pragma mark User Related
-(void)initiateLoginUserName:(NSString*)uName passWord:(NSString*)pWord callBackTo:(id<LoginToServerDelegate>)delegate
{
    if (!uName) {
        uName = @"";
    }
    if (!pWord) {
        pWord = @"";
    }
    _temporaryLoginDelegate = delegate;
    NSDictionary *dictToPost = [NSDictionary dictionaryWithObjectsAndKeys:
                                uName, @"username",
                                pWord, @"password", nil];
    NSString *urlToPostTo = [NSString stringWithFormat:@"%@/authenticate/userpass",URL_BASE_ADDRESS];
    [self postToServer:dictToPost toURL:urlToPostTo kindOfPost:TypeOfPostIsAuthentication];
}

-(void)initiateLoginWithExistingUserDetailsWithCallBackTo:(id<LoginToServerDelegate>)delegate
{
    NSDictionary *dictWithObjects = [[ATCUserAuthHelper sharedAuthHelper] getUserLoginInformation];
    NSString *uName = [dictWithObjects objectForKey:@"username"];
    NSString *pWord = [dictWithObjects objectForKey:@"password"];
    
    [self initiateLoginUserName:uName passWord:pWord callBackTo:delegate];
}

#pragma mark -
#pragma mark Sending data within app
-(void)interpretVotingResponse:(NSDictionary*)responseDict withSentDict:(NSDictionary*)dictThatWasPosted
{
    NSUInteger questionId = [[dictThatWasPosted valueForKey:@"questionId"] intValue];
    
    NSString *response;
    if (responseDict != nil) {
        response = [responseDict valueForKey:@"status"];
    }
    
    VotingResult resultOfTry;
    if (response == nil) {
        resultOfTry = VotingResultTimeout;
    } else if([response isEqualToString:@"ok"])
    {
        resultOfTry = VotingResultSuccess;
    } else if ([response isEqualToString:@"404"]) {
        resultOfTry = VotingResultMissing;
    } else {
        NSAssert1(nil, @"Should never be here. Wrong result from server during vote?", nil);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[ATCVoteCache sharedVoteCache] resultFromVoteWithQuestionId:questionId result:resultOfTry];
    });
}

-(void)interpretAuthResponse:(NSDictionary*)responseDict withSentDict:(NSDictionary*)dictThatWasPosted
{
    NSString *status;
    if (responseDict != nil) {
        status = [responseDict valueForKey:@"status"];
    }
    
    ServerResponse loginResult;
    if (status == nil) {
        loginResult = ServerResponseTimeout;
    } else if([status isEqualToString:@"ok"])
    {
        [[ATCUserAuthHelper sharedAuthHelper] storeLoginInformation:dictThatWasPosted];
        [[ATCUserAuthHelper sharedAuthHelper] storeToken:[responseDict objectForKey:@"data"]];
        loginResult = ServerResponseSuccess;
    } else if ([status isEqualToString:@"unauthorized"]) {
        loginResult = ServerResponseUnauthorized;
    } else {
        NSAssert1(nil, @"Should never be here. Wrong result from server during login?", nil);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_temporaryLoginDelegate loginActionHasCompleted:loginResult];
    });
    
}

-(void)interpretCreateResponse:(NSDictionary*)responseDict withSentDict:(NSDictionary*)dictThatWasPosted
{
    NSString *status;
    if (responseDict != nil) {
        status = [responseDict valueForKey:@"status"];
    }
    
    ServerResponse createQuestionResult;
    if (status == nil) {
        createQuestionResult = ServerResponseTimeout;
    } else if([status isEqualToString:@"ok"])
    {
        createQuestionResult = ServerResponseSuccess;
    } else if ([status isEqualToString:@"unauthorized"]) {
        createQuestionResult = ServerResponseUnauthorized;
    } else {
        NSAssert1(nil, @"Should never be here. Wrong result from server during createQ?", nil);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_temporaryCreateQuestionDelegate createQuestionHasCompleted:createQuestionResult];
    });
    
}

#pragma mark -
#pragma mark Fetching data

-(ATCQuestion*)getASingleQuestionOfId:(NSUInteger)questionIdOr0ForRandom
{
    //if questionId is 0, get random!
    NSString *qId = questionIdOr0ForRandom == 0 ? @"random" : [NSString stringWithFormat:@"%d",questionIdOr0ForRandom];
    NSString *urlForPull = [NSString stringWithFormat:@"%@/question/%@",URL_BASE_ADDRESS,qId];
    NSDictionary *dictFromServer = [NSDictionary dictionaryWithContentsOfJSONURLString:urlForPull];
    
    ATCQuestion *questionToReturn = nil;
    if (dictFromServer != nil) {
        NSDictionary *dataDictionary = [dictFromServer objectForKey:@"data"];
        questionToReturn = [[ATCQuestion alloc] initWithDict:dataDictionary];
    }
    return questionToReturn;
}

-(void)fetchQuestionsTo:(id<QuestionFetchDelegate>)receiver amountOfQuestions:(NSUInteger)amountToFetch startingAtId:(NSUInteger)qIdOrZeroForRandom
{
    dispatch_async(queue, ^{
        NSMutableArray *questions = [NSMutableArray array];
        for (NSUInteger questionCount = 1;
             questionCount <= amountToFetch;
             questionCount++) {
            ATCQuestion *newQuestion = [self getASingleQuestionOfId:qIdOrZeroForRandom];
            if (newQuestion == nil)
            {
                break;
            }
            [questions addObject:newQuestion];
        }
        if ([questions count] == 0) {
            questions = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [receiver receivedQuestionsFromServer:questions];
        });
	});
}

-(void)fetchSearchResultTo:(id<SearchResultsDelegate>)receiver forQuery:(NSString *)query
{
    NSString *encodedQuery = [query urlencode];
    NSString *urlForPull = [NSString stringWithFormat:@"%@/questions/search?q=%@",URL_BASE_ADDRESS,encodedQuery];
    [self fetchQuestionsFromUrl:urlForPull to:receiver];
}

-(void)fetchUserQuestions:(id<SearchResultsDelegate,LoginToServerDelegate>)receiver
{
    NSString *currentToken = [[ATCUserAuthHelper sharedAuthHelper] getUserToken];
    NSString *urlForPull = [NSString stringWithFormat:@"%@/questions/own?token=%@",URL_BASE_ADDRESS,currentToken];
    [self fetchQuestionsFromUrl:urlForPull to:receiver];
}

-(void)fetchQuestionsFromUrl:(NSString*)encodedUrl to:(id<SearchResultsDelegate,LoginToServerDelegate>)receiver
{
    dispatch_async(queue, ^{
        NSDictionary *dictFromServer = [NSDictionary dictionaryWithContentsOfJSONURLString:encodedUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self interpretPulledResults:dictFromServer andSendToReceiver:receiver];
        });
	});
}

-(void)interpretPulledResults:(NSDictionary*)dictFromServer andSendToReceiver:(id<SearchResultsDelegate,LoginToServerDelegate>)receiver
{
    ServerResponse response = [dictFromServer serverResponseFromStatusField];
   
    NSArray *questions;
    if (dictFromServer != nil) {
        NSArray *allQuestions = [dictFromServer objectForKey:@"data"];
        questions = [ATCQuestion skeletonQuestionsFromArray:allQuestions];
    }
    [receiver searchResultsWasReceived:questions withCompletion:response];
}

-(void)dealloc {
    dispatch_release(queue);
}



@end
