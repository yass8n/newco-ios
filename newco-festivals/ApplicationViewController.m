//
//  ApplicationViewController.m
//  newco-IOS
//
//  Created by yassen aniss 
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.EVENT_COLOR_HASH = nil;
    self.locationColorHash =  [[NSMutableDictionary alloc] init];
    self.EVENT_COLOR_HASH = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [UIColor myRed],@"red",
                                        [UIColor myGreen],@"green",
                                        [UIColor myBlue],@"blue",
                                        [UIColor myOrange],@"orange",
                                        [UIColor myPurple],@"purple",
                                        [UIColor myTeal],@"teal",
                                        [UIColor myYellow],@"yellow",
                                        [UIColor myPink],@"pink",
                                        [UIColor myDarkBlue],@"dark_blue",
                                        [UIColor myDarkRed],@"dark_red",
                                         nil];
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
    NSArray *values = [self.EVENT_COLOR_HASH allValues];
    NSLog(@"count = %lu and values = %lu", (unsigned long)count, (unsigned long)[values count]);
    return [values objectAtIndex:count];
}


@end
