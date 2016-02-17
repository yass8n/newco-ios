//
//  Credentials.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Credentials : NSObject{
    NSString* ApiKey;
    NSString* ApiUrl;
    NSDictionary* currentUser;
}
@property (nonatomic, retain) NSString * ApiKey;
@property (nonatomic, retain) NSString * ApiUrl;
@property (nonatomic, retain) NSDictionary* currentUser;

-(NSString*) ApiUrl;
-(NSString*) ApiKey;
-(NSDictionary*) currentUser;
//- (BOOL)isLoggedIn;
//- (void)clearSavedCredentials;
- (void)setCurrentUser:(NSDictionary*) user;
- (void)setApiKey:(NSString *)key;
- (void)setApiUrl:(NSString *)url;
- (void)logOut;

+ (Credentials *) sharedCredentials;
@end
