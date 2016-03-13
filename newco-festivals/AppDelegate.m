//
//  AppDelegate.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Mapbox/Mapbox.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[MGLAccountManager class]]];
    [MGLAccountManager setAccessToken:@"pk.eyJ1IjoieWFzczhuIiwiYSI6ImNpbHB6aThyMTA4cXF1bGtuYWZ5bjZ2enUifQ.OqPml3rb_MKDcpACe_s6sA"];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    self.webservice = [[WebService alloc] init];
    [self.webservice addInternetMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInternetConnectivity) name:@"checkInternetConnectivity" object:nil];
    Credentials *credentials = [Credentials sharedCredentials];
    NSDictionary * festival = credentials.festival;
    if (!festival || [festival count] == 0){
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Festivals"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        
        self.window.rootViewController = navigation;
    }
    [Fabric with:@[[Crashlytics class]]];
    // Override point for customization after application launch.
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[FestivalData sharedFestivalData] initEventColorsArray];
    [FBSDKAppEvents activateApp];
    if ([Credentials sharedCredentials].festival){
        if ([[Credentials sharedCredentials].currentUser count] > 0){
            [self.webservice registerTimeStamp:[[Credentials sharedCredentials].currentUser objectForKey:@"id"]];
        }else{
            [self.webservice registerTimeStamp:@"0"];
        }
    }

}
-(void)checkInternetConnectivity{
    [self.webservice showLowInternetBannerIfNotReachable];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)changeRootViewController:(UIViewController*)viewController animSize:(double)size {
    
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    self.window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(size, size, size);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

@end
