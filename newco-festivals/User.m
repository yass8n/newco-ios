//
//  User.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
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

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;
    _name = [coder decodeObjectForKey:@"name"];
    _username = [coder decodeObjectForKey:@"username"];
    _id_ = [coder decodeObjectForKey:@"id_"];
    _avatar = [coder decodeObjectForKey:@"avatar"];
    _role = [coder decodeObjectForKey:@"role"];
    _company = [coder decodeObjectForKey:@"company"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.name != nil)  [coder encodeObject:self.name forKey:@"name"];
    if (self.username != nil)  [coder encodeObject:self.username forKey:@"username"];
    if (self.id_ != nil) [coder encodeObject:self.id_ forKey:@"id_"];
    if (self.avatar != nil)  [coder encodeObject:self.avatar forKey:@"avatar"];
    if (self.role != nil)  [coder encodeObject:self.role forKey:@"role"];
    if (self.company != nil)  [coder encodeObject:self.company forKey:@"company"];
}

@end
