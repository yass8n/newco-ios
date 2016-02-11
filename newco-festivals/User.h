//
//  User.h
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"

@interface User : NSObject

@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *role;
@property (nonatomic, weak) NSString *company;
@property (nonatomic, weak) NSString *avatar;
@property (nonatomic, weak) NSString *username;
@property (nonatomic, weak) NSString *id_;

-(id)initWithName:(NSString *)name username:(NSString *)username id_:(NSString*)id_ avatar:(NSString*) avatar role:(NSString*)role company:(NSString*)company;

@end
