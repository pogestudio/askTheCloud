//
//  ATCViewController.h
//  ATC
//
//  Created by CA on 11/19/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATCTopMenuVC.h"
#import "ATCListItemsTVC.h"
#import "ATCCreateQuestionVC.h"

typedef enum {
    TypeOfVCINVALID = 0,
    TypeOfVCVote,
    TypeOfVCCreateQuestion,
    TypeOfVCSearchQuestion,
    TypeOfVCUserPage,
} TypeOfVC;

@interface ATCViewController : UIViewController <TopMenuDelegate, CreateQuestionDelegate,ListQuestionsDelegate>
{
    @private
    UIView *_menuBarContainerView;
    UIView *_mainContainerView;
    
    
    ATCTopMenuVC *_menuBar;
    UIViewController *_currentActiveVC;
    TypeOfVC _currentActiveVCType;
}

@end
