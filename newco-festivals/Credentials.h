//
//  Credentials.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Credentials : NSObject

@property (nonatomic, retain) NSString * ApiKey;
@property (nonatomic, retain) NSString * ApiUrl;
@property (nonatomic, retain) NSDictionary* currentUser;
@property (nonatomic, retain) NSDictionary* festival;
- (void)logOut;
+ (Credentials *) sharedCredentials;
-(void)clearFestivalData;

@end
