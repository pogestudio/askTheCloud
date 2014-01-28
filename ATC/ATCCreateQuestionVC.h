//
//  ATCCreateQuestionVC.h
//  ATC
//
//  Created by Carl-Arvid Ewerbring on 11/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
 The VC which handles the question making. It handles input for common input to every question, including the alternatives.
 
 */
#import <UIKit/UIKit.h>
#import "ATCChooseDataVC.h"

@protocol CreateQuestionDelegate

-(void)postedQuestion;
-(void)cancelledQuestion;

@end

@interface ATCCreateQuestionVC : UIViewController <UITextViewDelegate>
{
@private;
    NSMutableArray *_alternativeNumberButtons;                     //The buttons to set the number of alternatives
    UIButton *_postQuestion;                                       //bottom buttons for posting
    UIButton *_cancelPost;                                         //bottom button for cancelling post
}
@property (strong, nonatomic) UITextView *questionTitle;           //The input for the main question
@property (assign) NSUInteger amountOfAlternatives;                 //Used to decide how many alternatives should be shown in the view
@property (strong, nonatomic) NSMutableArray *alternatives;         //All alternatives
@property (weak) id <CreateQuestionDelegate> delegate;              //called when question has been cancelled or posted

-(void)changeAllDataTypesTo:(AlternativeType)alternativeType;       //Change datatypes of all alternatives.
-(void)layoutSubviews;                                              //lays out all the views currently presented. can be called after rotation swap.



@end
