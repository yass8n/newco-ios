//
//  ApplicationViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datesArray = [[NSMutableDictionary alloc] init];
    self.locationColorHash =  [[NSMutableDictionary alloc] init];
    self.orderOfInsertedDates =[[NSMutableDictionary alloc] init];
    self.EVENT_COLORS_ARRAY = [[NSMutableArray alloc] initWithObjects:
                                  [UIColor myRed],
                                  [UIColor myGreen],
                                  [UIColor myBlue],
                                  [UIColor myOrange],
                                  [UIColor myPurple],
                                  [UIColor myTeal],
                                  [UIColor myYellow],
                                  [UIColor myPink],
                                  [UIColor myDarkBlue],
                                  [UIColor myDarkRed],
                                  nil];
}
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
- (void)setBackButton{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.jpg"] landscapeImagePhone:[UIImage imageNamed:@"back.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item;
}
-(IBAction)goBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col{
    obj.layer.borderColor = col.CGColor;
    obj.layer.borderWidth = wid;
    obj.layer.cornerRadius = rad;
}
- (UIColor *) findFreeColor{
    NSUInteger count = [[self.locationColorHash allKeys] count];
    return [self.EVENT_COLORS_ARRAY objectAtIndex:count];
}
+ (NSDate*) UTCtoNSDate:(NSString*)utc{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd HH:mm"];
        return [formatter dateFromString:utc];
}
+ (NSString*) myDateToFormat:(NSDate *)date withFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}


@end
