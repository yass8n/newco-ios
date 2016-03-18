//
//  AppDelegate.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) WebService *webservice;

@property (strong, nonatomic) UIWindow *window;
- (void)changeRootViewController:(UIViewController*)viewController animSize:(double)size;


@end

