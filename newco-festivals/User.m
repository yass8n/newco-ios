//
//  User.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithName:(NSString *)name username:(NSString *)username id_:(NSString*)id_ avatar:(NSString*) avatar role:(NSString*)role company:(NSString*)company{
    self = [super init];
    if (self) {
        self.name = name;
        self.username = username;
        self.id_ = id_;
        self.avatar = avatar;
        self.role = role;
        self.company = company;
    }
    return self;
}

@end
