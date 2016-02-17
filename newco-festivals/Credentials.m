//
//  Credentials.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//


@implementation Credentials

@synthesize currentUser;

+ (Credentials *)sharedCredentials
{
    static Credentials *sharedCredentials = nil;
    if (!sharedCredentials) {
        sharedCredentials = [[Credentials alloc] init];
    }
    return sharedCredentials;
}

- (id)init
{
    self = [super init];
    if (self) {
        currentUser = [[NSDictionary alloc] init];
        ApiUrl = [[NSString alloc] init];
        ApiKey = [[NSString alloc] init];
    }
    return self;
}
-(NSDictionary*) currentUser{
    if ([currentUser count] == 0){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        NSDictionary *myUser = [prefs dictionaryForKey:@"user"];
        if (myUser){
            currentUser = [[NSDictionary alloc] init];
            currentUser = myUser;
        }
    }
    return currentUser;
}
-(NSString*) ApiKey{
    if (![self->ApiKey isEqualToString:@""]){
        return self->ApiKey;
    }else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        NSString * apiKey = [prefs objectForKey:@"apiKey"];
        self->ApiKey = apiKey;
        return self->ApiKey;
    }
}
-(NSString*) ApiUrl{
    if (![self->ApiUrl isEqualToString:@""]){
        return self->ApiUrl;
    }else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        NSString * apiUrl = [prefs objectForKey:@"apiUrl"];
        self->ApiUrl = apiUrl;
        return self->ApiUrl;
    }
}

-(void) setApiKey:(NSString *)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:key forKey:@"apiKey"];
    self->ApiKey = key;
}

-(void) setApiUrl:(NSString *)url{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:url forKey:@"apiUrl"];
    self->ApiUrl = url;
}

- (void)setCurrentUser:(NSDictionary*) user{
    currentUser = user;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:user forKey:@"user"];
}

-(void)logOut{
    currentUser = [[NSDictionary alloc] init];
    [FestivalData sharedFestivalData].currentUserSessions = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:nil forKey:@"user"];
    [[FestivalData sharedFestivalData] enableAllSessions];
}


@end
