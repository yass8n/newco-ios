//
//  WebService.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Credentials.h"
#import "ShareModalView.h"
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
- (void)editProfile:(NSDictionary *)params callback:(void (^)(NSDictionary * status)) callback;
-(void)removeAvatar;
-(void)changeUserName:(NSDictionary*)params callback:(void (^)(NSDictionary* user)) callback;
-(void) showPageLoader; //forward decleration of private method
-(void) hidePageLoader; //forward decleration of private method

#pragma Mark-Connectivity Detection
-(void)showLowInternetBannerIfNotReachable;
-(void)addInternetMonitor;

#pragma Mark-Firebase
-(void)registerViewedSession:(NSString*)sessionTitle userId:(NSString*)userId;
- (void)fetchFestivals:(void (^)(NSArray * activeFestivalsArray, NSArray* inactiveFestivalsArray)) callback;
-(void)registerSharedSession:(NSString*)sessionTitle note:(NSString*)note userId:(NSString*)userId;
-(void)registerTimeStamp:(NSString*)userId;
//-(void)setToFirebase:(NSArray*)festivals;

@end