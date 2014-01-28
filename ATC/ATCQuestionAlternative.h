//
//  ATCQuestionAlternative.h
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCQuestionAlternative : NSObject

@property (assign) NSUInteger alternativeId;                            //id of the alternative, used for voting
@property (assign) NSUInteger amountOfVotes;                            //amount of votes it has during fetch. Used presentation for user.
@property (strong) NSString *text;                                      //text of the alternative
@property (strong) UIImage *image;                                      //image of the alternative

-(id)initWithId:(NSNumber*)altId text:(NSString*)stringOrNil image:(UIImage*)imageOrNil votesOrNil:(NSNumber*)votes;  //data to use when initiating

@end
