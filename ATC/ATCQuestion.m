//
//  ATCQuestion.m
//  ATC
//
//  Created by CA on 11/18/12.
//
//

#import "ATCQuestion.h"
#import "ATCVoteCache.h"
#import "ATCServerInterface.h"
#import "NSString+boolAppender.h"


@implementation ATCQuestion

@synthesize questionId = _questionId;

static NSDateFormatter *_dateFormatterForParsing;

+(NSArray*)skeletonQuestionsFromArray:(NSArray *)array
{
    NSMutableArray *questions = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *skeletonDict in array) {
        ATCQuestion *newQ = [[ATCQuestion alloc] initWithSkeletonDict:skeletonDict];
        [questions addObject:newQ];
    }
    return questions;
}

-(id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        NSDictionary *relevantInfo = [dict objectForKey:@"question"];
        NSNumber *questionId = [relevantInfo objectForKey:@"id"];
        self.questionId = [questionId intValue];
        self.currentVote = -1; //NO VOTE!
        self.questionIsText = YES;
        self.title = [relevantInfo objectForKey:@"question"];
        
        NSArray *alternatives = [dict objectForKey:@"alternatives"];
        [self setUpAlternativesAccordingToArray:alternatives];
        
        //
        NSString *date = [relevantInfo objectForKey:@"createdAt"];
        [self setDateFromString:date];
    }
    
    return self;
}

-(id)initWithSkeletonDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSNumber *questionId = [dict objectForKey:@"id"];
        self.questionId = [questionId intValue];
        self.currentVote = -1; //NO VOTE!
        self.questionIsText = YES;
        self.title = [dict objectForKey:@"question"];
        
        //NSLog(@"%@",alternatives);
        
        //
        NSString *date = [dict objectForKey:@"createdAt"];
        [self setDateFromString:date];
    }
    
    return self;
}

-(void)setUpAlternativesAccordingToArray:(NSArray*)alternatives
{
    NSMutableArray *createdAlternatives = [NSMutableArray array];
    for (NSDictionary *altDict in alternatives) {
        NSDictionary *votes = [altDict objectForKey:@"votes"];
        NSDictionary *values = [altDict objectForKey:@"alternative"];
        ATCQuestionAlternative *alternative = [[ATCQuestionAlternative alloc] initWithId:[values objectForKey:@"number"]
                                                                                    text:[values objectForKey:@"text"] image:nil
                                                                              votesOrNil:[votes objectForKey:@"count"]];
        [createdAlternatives addObject:alternative];
    }
    
    self.alternatives = [NSArray arrayWithArray:createdAlternatives];
}

-(void)setDateFromString:(NSString*)dateInISO8601Format
{
    //removing the millliseconds. Always three of them
    NSArray *seperatedByDots = [dateInISO8601Format componentsSeparatedByString:@"."];
    NSString *mostOfDate = [seperatedByDots objectAtIndex:0];
    NSString *theRest = [seperatedByDots objectAtIndex:1];
    NSString *timeZone = [theRest stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    NSString *completeStringToParse = [NSString stringWithFormat:@"%@%@",mostOfDate,timeZone];
    
    NSDateFormatter *theFormatter = [ATCQuestion parserDateFormatter];
    NSDate *theDate = [theFormatter dateFromString:completeStringToParse];
    self.dateOfCreation = theDate;
}


#pragma mark -
#pragma mark Server Related
-(void)pushVote:(NSUInteger)alternativeWhichWasVoted
{
    [[ATCVoteCache sharedVoteCache] voteOnQuestion:self withAlternativeId:alternativeWhichWasVoted];
}

-(void)fillSelfWithCurrentInfo
{
    [[ATCServerInterface sharedServerInterface] fetchQuestionsTo:self amountOfQuestions:1 startingAtId:self.questionId];
}
         
-(void)voteOn:(NSInteger)alternative
{
    [self pushVote:alternative];
}

#pragma mark -
#pragma mark QuestionFetchDelegate
-(void)receivedQuestionsFromServer:(NSMutableArray *)receivedObjects
{
    if (receivedObjects == nil) {
        return;
    }
    NSAssert1([receivedObjects count] > 0, @"We received an empty array from server. BAD!", nil);
    //now we would like to update our alternatives!
    
    ATCQuestion *receivedQUestion = [receivedObjects objectAtIndex:0];
    self.alternatives = receivedQUestion.alternatives;
}

#pragma mark -
#pragma mark Misc
-(NSUInteger)totalAmountOfVotes
{
    NSUInteger totalAmount = 0;
    for (ATCQuestionAlternative *alternative in self.alternatives) {
        NSUInteger thisAlternative = alternative.amountOfVotes;
        totalAmount += thisAlternative;
    }
    
    return totalAmount;
}

-(CGFloat)percentageForAlternative:(ATCQuestionAlternative *)alternative
{
    NSUInteger totalAmountOfVotes = [self totalAmountOfVotes];
    CGFloat allVotes = MAX(1,totalAmountOfVotes); //need float
    
    CGFloat alternativeVotes = alternative.amountOfVotes;
    CGFloat currentPercentage = alternativeVotes / allVotes;
    return currentPercentage;
}

-(NSString*)ageOfQuestion
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval ageOfPost = [currentDate timeIntervalSinceDate:self.dateOfCreation];
    
    NSString *age;
    NSTimeInterval anHour = 3600;
    NSTimeInterval aDay = 86400;
    NSTimeInterval aWeek = 604800;
    NSTimeInterval aMonth = 2592000;
    NSTimeInterval aYear = 31536000;
    
    //if younger than an hour, show minutes
    //if younger than 24 hrs, show hours,
    //if younger than 1 week, show days
    //if younger than 5 weeks, show weeks
    //if younger than a year, show months
    //else show years

    if (ageOfPost < anHour) {
        age = [NSString stringWithFormat:@"%.0f min",ageOfPost/60.0];
    } else if (ageOfPost < aDay) {
        age = [NSString stringWithFormat:@"%.0f hr",ageOfPost/anHour];
        age = [age append:@"s" if:(ageOfPost/anHour >= 2.0)];
    } else if (ageOfPost < aWeek) {
        age = [NSString stringWithFormat:@"%.0f day",ageOfPost/aDay];
        age = [age append:@"s" if:(ageOfPost/aDay >= 2.0)];
    } else if (ageOfPost < aMonth) {
        age = [NSString stringWithFormat:@"%.0f week",ageOfPost/aWeek];
        age = [age append:@"s" if:(ageOfPost/aWeek >= 2.0)];
    } else if (ageOfPost < aYear){
        age = [NSString stringWithFormat:@"%.0f month",ageOfPost/aMonth];
        age = [age append:@"s" if:(ageOfPost/aMonth >= 2.0)];
    } else {
        age = [NSString stringWithFormat:@"%.0f year",ageOfPost/aYear];
        age = [age append:@"s" if:(ageOfPost/aYear >= 2.0)];
    }
    return age;
}


+(NSDateFormatter*)parserDateFormatter
{
    if (_dateFormatterForParsing == nil) {
        _dateFormatterForParsing = [[NSDateFormatter alloc] init];
        [_dateFormatterForParsing setDateFormat:@"yyyyMMdd'T'HHmmssZZ"];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [_dateFormatterForParsing setTimeZone:gmt];
    }
    return _dateFormatterForParsing;
}

@end
