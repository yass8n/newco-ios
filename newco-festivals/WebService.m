//
//  WebService.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//
#include "SVProgressHUD.h"
#import "WebService.h"
@interface WebService()
-(void) showPageLoader; //forward decleration of private method
-(void) hidePageLoader; //forward decleration of private method
@end

@implementation WebService{
    UIView * view;
};

- (id)initWithView: (UIView*) superView
{
    self = [super init];
    if (self) {
        self.credentials = [Credentials sharedCredentials];
        self->view = superView;
    }
    [self showPageLoader];
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.credentials = [Credentials sharedCredentials];
        self-> view = nil;
    }
    
    return self;
}

-(void) showPageLoader {
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD show];
        });
}
-(void) hidePageLoader {
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
}
- (void)removeSessionFromSchedule:(NSString*)id_ callback:(void (^)(NSString *response)) callback{
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/going/del?api_key=%@&session=%@&sessions=%@&by=id", self.credentials.ApiUrl, self.credentials.ApiKey, [[Credentials sharedCredentials].currentUser objectForKey:@"auth"], id_];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            dispatch_async(completion_que, ^{
                callback( (NSString*) response);
            });
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN removeSession");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
}

- (void)addSessionToSchedule:(NSString*)id_ callback:(void (^)(NSString* response))callback{
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/going/add?api_key=%@&session=%@&sessions=%@", self.credentials.ApiUrl, self.credentials.ApiKey, [[Credentials sharedCredentials].currentUser objectForKey:@"auth"], id_];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            dispatch_async(completion_que, ^{
                callback( (NSString*) response);
            });
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN addSession");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
    
}
- (void)setAttendeesForSession:(NSString *)id_ callback:(void (^)(NSArray *))callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/session/seats?api_key=%@&type=all&format=json&id=%@&by=id&fields=username,name,privacy_mode,avatar", self.credentials.ApiUrl, self.credentials.ApiKey, id_];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                dispatch_async(completion_que, ^{
                    callback( (NSArray*) responseObject);
                });
            }
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN setAttendeesFor...");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
}

- (void)fetchSessions:(void (^)(NSArray *allSessionTransactions))callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/session/export?api_key=%@&format=json&fields=description,event_key,name,address,event_start,event_end,event_type,id,speakers,artists,seats,audience", self.credentials.ApiUrl, self.credentials.ApiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                dispatch_async(completion_que, ^{
                    callback( (NSArray*) responseObject);
                });
            }
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN fetchSessions");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
}
- (void)fetchUsers:(void (^)(NSArray *jsonArray))callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/user/list?api_key=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,lastactive,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", self.credentials.ApiUrl, self.credentials.ApiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                dispatch_async(completion_que, ^{
                    callback( (NSArray*) responseObject);
                });
            }
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN fetchUsers");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
}
- (void)fetchSesionsForUser:(void (^)(NSArray *jsonArray))callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/user/sessions?api_key=%@&format=json", self.credentials.ApiUrl, self.credentials.ApiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                dispatch_async(completion_que, ^{
                    callback( (NSArray*) responseObject);
                });
            }
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN fetchSesionsForUser");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
    
}
- (void)loginAPIWithUsername:username andPassword:password callback:(void (^)(NSString *response)) callback{
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/auth/login?api_key=%@&username=%@&password=%@", self.credentials.ApiUrl, self.credentials.ApiKey, username, password];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            dispatch_async(completion_que, ^{
                callback( (NSString*) response);
            });
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN login");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
}
- (void)findByUsername:username withAuthToken:(NSString*)auth callback:(void (^)(NSDictionary* user)) callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/user/get?api_key=%@&by=username&term=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", self.credentials.ApiUrl, self.credentials.ApiKey, username];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
                dispatch_async(completion_que, ^{
                NSDictionary* user = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject options:kNilOptions error:nil];
                    if (user) [self hidePageLoader];
                    callback(user);
                });
        } else {
            [self hidePageLoader];
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN findByUsername");
        }
    }];
    [dataTask resume];
    
}
- (void)fetchCurrentUserSessions:username withAuthToken:(NSString*)auth callback:(void (^)(NSArray * user)) callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/going/list?api_key=%@&session=%@&username=%@", self.credentials.ApiUrl, self.credentials.ApiKey, auth, username];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                dispatch_async(completion_que, ^{
                    callback( (NSArray*) responseObject);
                });
            }
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN fetchCurrentUserSessions...");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
    
}
- (void)findByEmail:email withAuthToken:(NSString*)auth callback:(void (^)(NSDictionary* user)) callback{
    dispatch_queue_t completion_que = dispatch_queue_create("", NULL);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/user/get?api_key=%@&by=email&term=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", self.credentials.ApiUrl, self.credentials.ApiKey, email];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            dispatch_async(completion_que, ^{
                callback((NSDictionary*)responseObject);
            });
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"ERROR IN findByUsername");
        }
        [self hidePageLoader];
    }];
    [dataTask resume];
    
}


@end
