//
//  UIBarButtonItem+customBackground.h
//  ATC
//
//  Created by CA on 12/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (customBackground)



+ (id) customBarButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (id) customBackButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

/*
+ (id) customBarButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector regularImage:(UIImage*)regularImage selectedImage:(UIImage*)selectedImage;
+ (id) customBarButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (id) customBackButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
*/
@end
