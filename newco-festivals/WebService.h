//
//  WebService.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Credentials.h"
@interface WebService : NSObject

@property (nonatomic, strong) Credentials *credentials;

- (id)initWithView: (UIView*) superView;
- (void)fetchUsers:(void (^)(NSArray *jsonArray))callback;
- (void)fetchSessions:(void (^)(NSArray *jsonArray))callback;
- (void)fetchSesionsForUser:(void (^)(NSArray *allSessionTransactions))callback;
- (void)setAttendeesForSession:(NSString*)id_ callback:(void (^)(NSArray *response)) callback;
- (void)addSessionToSchedule:(NSString*)id_ callback:(void (^)(NSString *response)) callback;
- (void)removeSessionFromSchedule:(NSString*)id_ callback:(void (^)(NSString *response)) callback;
- (void)fetchCurrentUserSessions:username withAuthToken:(NSString*)auth callback:(void (^)(NSArray * user)) callback;
- (void)loginAPIWithUsername:username andPassword:password callback:(void (^)(NSString *response)) callback;
- (void)findByUsername:username withAuthToken:(NSString*)auth callback:(void (^)(NSDictionary * user)) callback;
- (void)findByEmail:email withAuthToken:(NSString*)auth callback:(void (^)(NSDictionary* user)) callback;

@end