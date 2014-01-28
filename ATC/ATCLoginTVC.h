//
//  ATCLoginTVC.h
//  ATC
//
//  Created by CA on 12/16/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCServerInterface.h"

@interface ATCLoginTVC : UITableViewController <LoginToServerDelegate, UITextFieldDelegate>

@property (assign) BOOL areCurrentlyLoggingIn;

@end
