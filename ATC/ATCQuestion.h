//
//  ATCQuestion.h
//  ATC
//
//  Created by CA on 11/18/12.
//
//

/*
 
 This is the object that will be used by the app.
 
 It should contain knowledge (by aggregation) of how to
    connect
    create question
    upload data
    download data
 */
#import <Foundation/Foundation.h>
#import "ATCQuestionAlternative.h"
#import "ATCServerInterface.h"

@interface ATCQuestion : NSObject <QuestionFetchDelegate>

@property (strong, nonatomic) NSString *title;                  //the title of the question
@property (assign) BOOL questionIsText;                         //set to YES if the question is text based
@property (strong, nonatomic) NSArray *alternatives;            //contains all alternatives, which contains more info
//@property (strong, nonatomic) NSArray *tags;                  //all tags of question
@property (assign) NSInteger currentVote;                       //what the current user has voted on
@property (strong, nonatomic) NSDate *dateOfCreation;

//SERVER RELATED
@property (assign) NSUInteger questionId;


//PRESENTATION RELATED
-(CGFloat)percentageForAlternative:(ATCQuestionAlternative*)alternative;

-(void)voteOn:(NSInteger)alternative;                  //called during voting. Called whenever user changes something (votes or removes vote).

-(id)initWithDict:(NSDictionary*)dict;                          //init with this dictionary to give it some data! It's the "data" dictionary from the server.
-(id)initWithSkeletonDict:(NSDictionary*)dict;                          //init with this dictionary to give it some data! It's the "data" dictionary from the server.
-(NSString*)ageOfQuestion;


-(NSUInteger)totalAmountOfVotes;
-(void)fillSelfWithCurrentInfo;

+(NSArray*)skeletonQuestionsFromArray:(NSArray*)array;
+(NSDateFormatter*)parserDateFormatter;
@end
