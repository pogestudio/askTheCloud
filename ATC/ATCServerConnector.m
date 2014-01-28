//
//  ATCServerConnector.m
//  ATC
//
//  Created by August Bonds on 11/19/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCServerConnector.h"

@implementation ATCServerConnector

-(void)getQuestions
{
    /*
    NSString *url = @"http://home.dflemstr.name:9000/api/questions";
    
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
    
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    */
    
    self.dataToBeLoaded = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://home.dflemstr.name:9000/api/questions"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Have just initiated NSURLConnection!");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Connection did receive data!!");
    NSLog([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    [self.dataToBeLoaded appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
/*    NSLog(@"connection did finish loading, dataToBeLoaded has length: %d",[self.dataToBeLoaded length]);
    NSString *answer = [[NSString alloc] initWithData:self.dataToBeLoaded encoding:NSASCIIStringEncoding];
    NSLog(@"%@",answer);*/
}

@end
