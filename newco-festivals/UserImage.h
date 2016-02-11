//
//  UserImage.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserImage : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) NSDictionary* user;
@property (strong, nonatomic) NSString* type;

@end
