//
//  ATCUserAuthHelper.m
//  ATC
//
//  Created by CA on 12/16/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCUserAuthHelper.h"
#import "ATCLoginTVC.h"
#import "ATCServerInterface.h"
#import "NSDictionary+JSON.h"
#import "PDKeychainBindings.h"

@implementation ATCUserAuthHelper

static ATCUserAuthHelper *_sharedHelper;

+(ATCUserAuthHelper*)sharedAuthHelper
{
    if (_sharedHelper == nil) {
        _sharedHelper = [[ATCUserAuthHelper alloc] init];
    }
    return _sharedHelper;
}

-(id)init
{
    self = [super init];
    if (self)
    {
         
        //custom initialization.
    }
    return self;
}

-(BOOL)userIsLoggedIn
{
    BOOL userLoggedIn = NO;
    NSString *usertoken = [self getUserToken];
    if ([self getUserToken] && !([[self getUserToken] isEqualToString:@""])) {
        userLoggedIn = YES;
    }
    return userLoggedIn;
}

-(void)showLoginView
{
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    ATCLoginTVC *loginView = [[ATCLoginTVC alloc] init];
    UINavigationController *newNavCon = [[UINavigationController alloc] initWithRootViewController:loginView];
    [topVC presentModalViewController:newNavCon animated:YES];
}

#pragma mark Store/Load data
-(void)storeToken:(NSString *)userToken
{
    PDKeychainBindings *keyChainBindings = [PDKeychainBindings sharedKeychainBindings];
    [keyChainBindings setObject:userToken forKey:@"token"];
}

-(NSString *)getUserToken
{
    PDKeychainBindings *keyChainBindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *userToken = [keyChainBindings objectForKey:@"token"];
    return userToken;
}

-(void)storeLoginInformation:(NSDictionary*)dictWithLogin
{
    PDKeychainBindings *keyChainBindings = [PDKeychainBindings sharedKeychainBindings];
    
    NSString *uName = [dictWithLogin objectForKey:@"username"];
    NSString *pWord = [dictWithLogin objectForKey:@"password"];
    
    [keyChainBindings setObject:uName forKey:@"username"];
    [keyChainBindings setObject:pWord forKey:@"password"];
}
-(NSDictionary*)getUserLoginInformation
{
    PDKeychainBindings *keyChainBindings = [PDKeychainBindings sharedKeychainBindings];
    
    NSString *uName = [keyChainBindings objectForKey:@"username"];
    NSString *pWord = [keyChainBindings objectForKey:@"password"];
    
    NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:uName,
                               @"username",
                               pWord,
                               @"password", nil];
    return loginInfo;
}

-(void)logoutUser
{
    [self storeToken:@""];
}
@end
