//
//  PageLoader.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageLoader : UIView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
