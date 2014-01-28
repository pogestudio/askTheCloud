//
//  ATCCreateQuestionTVC.h
//  ATC
//
//  Created by CA on 12/7/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCServerInterface.h"

@interface ATCCreateQuestionTVC : UITableViewController <UITextViewDelegate, CreateQuestionDelegate, LoginToServerDelegate>
{
    @private
    UITextView *_questionTitle;
}

@property (strong) NSMutableArray *alternativeTextViews;

@end
