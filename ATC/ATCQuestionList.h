//
//  ATCQuestionList.h
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATCQuestion;

@interface ATCQuestionList : NSObject

@property (weak) ATCQuestionList *previous;                     //previous questionList
@property (strong) ATCQuestion *question;                       //content of this ListObject
@property (strong) ATCQuestionList *next;                       //next questionlist

-(ATCQuestionList*)lastQuestionList;
-(NSUInteger)count;


@end
