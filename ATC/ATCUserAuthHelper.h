//
//  ATCUserAuthHelper.h
//  ATC
//
//  Created by CA on 12/16/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h> 

@class ATCLoginTVC;


@interface ATCUserAuthHelper : NSObject
{
    NSString *_userCurrentlyLoggedIn;
}


-(void)showLoginView;
-(BOOL)userIsLoggedIn;
-(void)storeToken:(NSString *)userToken;
-(NSString *)getUserToken;
-(void)storeLoginInformation:(NSDictionary*)dictWithLogin;
-(NSDictionary*)getUserLoginInformation;
-(void)logoutUser;

+(ATCUserAuthHelper*)sharedAuthHelper;

@end
