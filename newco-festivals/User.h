//
//  User.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *role;
@property (nonatomic, weak) NSString *company;
@property (nonatomic, weak) NSString *avatar;
@property (nonatomic, weak) NSString *username;
@property (nonatomic, weak) NSString *id_;

//@property (nonatomic, weak) NSString *about;
//@property (nonatomic, weak) NSString *url;
//@property (nonatomic, weak) NSString *phone;
//@property (nonatomic, weak) NSString *position;
//@property (nonatomic, weak) NSString *auth;
//@property (nonatomic, weak) NSString *location;
//@property (nonatomic, weak) NSString *privacy_mode;
//@property (nonatomic, weak) NSString *twitter_uid;
//@property (nonatomic, weak) NSString *email;
//@property (nonatomic, weak) NSString *fb_uid;
//@property (nonatomic, weak) NSString *tickets;

-(id)initWithName:(NSString *)name username:(NSString *)username id_:(NSString*)id_ avatar:(NSString*) avatar role:(NSString*)role company:(NSString*)company;

@end
