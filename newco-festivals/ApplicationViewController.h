//
//  ApplicationViewController.h
//  newco-IOS
//
//  Created by yassen aniss 
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colors.h"

@interface ApplicationViewController : UIViewController
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
@property (nonatomic, strong) NSMutableDictionary* EVENT_COLOR_HASH;
@property (nonatomic, strong) NSMutableArray *sessionsArray;
@property (nonatomic, strong) NSMutableDictionary* locationColorHash;
- (UIColor *) findFreeColor;

@end
