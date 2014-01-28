//
//  ATCQuestionAlternative.m
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import "ATCQuestionAlternative.h"

@implementation ATCQuestionAlternative

-(id)initWithId:(NSNumber*)altId text:(NSString*)stringOrNil image:(UIImage*)imageOrNil votesOrNil:(NSNumber*)votes
{
    self = [super init];
    if (self) {
        self.amountOfVotes = ([votes intValue] > 0 ? [votes intValue] : 0);
        self.alternativeId = [altId intValue];
        self.text = stringOrNil;
        self.image = imageOrNil;
    }
    return self;
}


@end
