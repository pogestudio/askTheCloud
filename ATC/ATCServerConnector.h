//
//  ATCServerConnector.h
//  ATC
//
//  Created by August Bonds on 11/19/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCServerConnector : NSObject <NSURLConnectionDelegate>

@property NSMutableData *dataToBeLoaded;
@property NSURLConnection *connection;

-(void)getQuestions; //TODO think it shouldn't return void
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connectiondidReceiveData:(NSData *)data;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
