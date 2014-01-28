//
//  NSDictionary+JSON.m
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    if (data == nil) {
        return nil;
    }
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil)
    {
        NSLog(@"AN ERROR WAS CAUGHT! %@",error);
     return nil;
    }
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(ServerResponse)serverResponseFromStatusField
{
    NSString *status = [self objectForKey:@"status"];
    ServerResponse result;
    if (status == nil) {
        result = ServerResponseTimeout;
    } else if([status isEqualToString:@"ok"])
    {
        result = ServerResponseSuccess;
    } else if ([status isEqualToString:@"unauthorized"]) {
        result = ServerResponseUnauthorized;
    } else {
        NSAssert1(nil, @"Should never be here. Wrong result from server during login?", nil);
    }
    return result;
}


@end
