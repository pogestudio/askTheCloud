//
//  ATCTopMenuVC.m
//  ATC
//
//  Created by CA on 11/24/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCTopMenuVC.h"
#import "ATCUserAuthHelper.h"
#import "UIView+addShadow.h"
#import "UILabel+sizeToFit.h"


@interface ATCTopMenuVC ()

@end

@implementation ATCTopMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [ATCColorPalette topMenu];
    
    self.questionsButton.backgroundColor = [UIColor clearColor];
    self.createQuestionButton.backgroundColor = [UIColor clearColor];
    self.searchButton.backgroundColor = [UIColor clearColor];
    self.userButton.backgroundColor = [UIColor clearColor];
    
    self.questionsButton.titleLabel.textColor = [ATCColorPalette topBarButtonFont];
    self.createQuestionButton.titleLabel.textColor = [ATCColorPalette topBarButtonFont];
    self.searchButton.titleLabel.textColor = [ATCColorPalette topBarButtonFont];
    self.userButton.titleLabel.textColor = [ATCColorPalette topBarButtonFont];
    
    
    [self.questionsButton.titleLabel addShadow];
    [self.createQuestionButton.titleLabel addShadow];
    [self.searchButton.titleLabel addShadow];
    [self.userButton.titleLabel addShadow];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSurroundingShadowWithRadius:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createQuestion:(id)sender
{
    ATCUserAuthHelper *authHelper = [ATCUserAuthHelper sharedAuthHelper];
    if (![authHelper userIsLoggedIn]) {
        [authHelper showLoginView];
    } else {
    [self.delegate createAQuestion];
    }
}

-(IBAction)loadAQuestion:(id)sender
{
    [self.delegate showVotingView];
    
}

-(IBAction)showSearchView:(id)sender
{
    [self.delegate showSearchView];
    
}

-(IBAction)showUserMenu:(id)sender
{
    ATCUserAuthHelper *authHelper = [ATCUserAuthHelper sharedAuthHelper];
    if (![authHelper userIsLoggedIn]) {
        [authHelper showLoginView];
    } else {
        [self.delegate showUserPage];
    }
    
}

- (void)viewDidUnload {
    [self setQuestionsButton:nil];
    [self setCreateQuestionButton:nil];
    [self setSearchButton:nil];
    [self setUserButton:nil];
    [super viewDidUnload];
}
@end
