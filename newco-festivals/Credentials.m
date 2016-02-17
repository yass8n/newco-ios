//
//  Credentials.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 Newco. All rights reserved.
//


@implementation Credentials

@synthesize currentUser, ApiKey, ApiUrl, festival;

static Credentials *sharedCredentials = nil;

+ (Credentials *)sharedCredentials
{
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
        festival = [[NSDictionary alloc] init];
    }
    return self;
}
-(NSDictionary*) currentUser{
    if (!currentUser || [currentUser count] == 0){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        NSDictionary *myUser = [prefs dictionaryForKey:@"user"];
        if (myUser){
            currentUser = [[NSDictionary alloc] init];
            currentUser = myUser;
        }
    }
    return currentUser;
}
-(NSDictionary*) festival{
    if (!festival || [festival count] == 0){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        NSDictionary *myFestival = [prefs dictionaryForKey:@"festival"];
        if (myFestival){
            festival = [[NSDictionary alloc] init];
            festival = myFestival;
        }
    }
    return festival;
}

- (void)setCurrentUser:(NSDictionary*) user{
    currentUser = user;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:user forKey:@"user"];
}

- (void)setFestival:(NSDictionary *)theFestival{
    festival = theFestival;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    NSMutableDictionary* f = [theFestival mutableCopy];
    NSDictionary * keep = @{
                       @"name": @YES,
                       @"eventbrite_id": @YES,
                       @"needs_image_info": @YES,
                       @"city": @YES,
                       @"hero_image": @YES,
                       @"url": @YES,
                       @"event_type_is_location": @YES,
                       @"active": @YES,
                       @"api_key" : @YES};
    for(id attribute in theFestival) {
        if(![keep objectForKey:attribute]) {
            [f removeObjectForKey:attribute];
        }
    }
    NSDictionary * fest = [NSDictionary dictionaryWithDictionary:f];
    
    [prefs setObject:fest forKey:@"festival"];
}

-(void)logOut{
    currentUser =  nil;
    ApplicationViewController.rightNav = nil;
    [FestivalData sharedFestivalData].currentUserSessions = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:nil forKey:@"user"];
    [[FestivalData sharedFestivalData] enableAllSessions];
}
-(void)clearFestivalData{
    festival =  nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [prefs setObject:nil forKey:@"festival"];
    [[FestivalData sharedFestivalData] clearAllData];
    [self logOut];
}


@end
