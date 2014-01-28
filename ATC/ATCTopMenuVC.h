//
//  ATCTopMenuVC.h
//  ATC
//
//  Created by CA on 11/24/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TopMenuDelegate

-(void)createAQuestion;
-(void)showVotingView;
-(void)showSearchView;
-(void)showUserPage;

@end

@interface ATCTopMenuVC : UIViewController


@property (weak) id <TopMenuDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *questionsButton;
@property (strong, nonatomic) IBOutlet UIButton *createQuestionButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *userButton;

@end
