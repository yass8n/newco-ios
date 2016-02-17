//
//  AppDelegate.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)changeRootViewController:(UIViewController*)viewController animSize:(double)size;


@end

