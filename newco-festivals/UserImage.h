//
//  UserImage.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserImage : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) NSDictionary* user;
@property (strong, nonatomic) NSString* type;

@end
