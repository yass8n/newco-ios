//
//  RootViewController.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleViewController.h"
#import "SWRevealViewController.h"


@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSNumber* numberCompletedCalls;
@property (weak, atomic) IBOutlet UIActivityIndicatorView *loader;
- (IBAction)changedSegmentedControl:(id)sender;
@end

@implementation RootViewController
static NSRecursiveLock *calls_lock;
@synthesize numberCompletedCalls;

//waits until shceduleViewController has initialized the Directory variables before enabling the segmented control
-(void) setNumberCompletedCalls:(NSNumber *)newNumber{
    [calls_lock lock];
    numberCompletedCalls = newNumber;
    [calls_lock unlock];
    if (numberCompletedCalls == [NSNumber numberWithInt:2]){
        [self setViewControllerWithSegmentedControl:self.segmentedControl];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loader startAnimating];
    //    [self.loader setHidden:YES];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    ApplicationViewController.navItem = self.navigationItem; //saving current nav bar so we can change its contents later
    
    UIButton *menu =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [menu setFrame:CGRectMake(0, 0, 20, 20)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    ApplicationViewController.leftNav = menu;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    [self setRightNavButton];
    ApplicationViewController.sysVer = 0;
    [self importData];
    
}
-(void) importData{
    WebService * webService = [[WebService alloc] init];
    [webService fetchUsers:^(NSArray* jsonArray){
        for (NSDictionary *user in jsonArray) {
            NSString* role = [user objectForKey:@"role"];
            NSString* privacy = [user objectForKey:@"privacy_mode"];
            if ([privacy isEqual:@"N"]){
                if ([role rangeOfString:@"attendee"].location != NSNotFound) {
                    [[FestivalData sharedFestivalData].attendeesDict setObject:user forKey:[user objectForKey:@"username"]];
                }
                if ([role rangeOfString:@"volunteer"].location != NSNotFound) {
                    [[FestivalData sharedFestivalData].volunteersDict setObject:user forKey:[user objectForKey:@"username"]];
                }
                if ([role rangeOfString:@"speaker"].location != NSNotFound) {
                    [[FestivalData sharedFestivalData].presentersDict setObject:user forKey:[user objectForKey:@"username"]];
                }
                if ([role rangeOfString:@"artist"].location != NSNotFound) {
                    [[FestivalData sharedFestivalData].companiesDict setObject:user forKey:[user objectForKey:@"username"]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            int value = [self.numberCompletedCalls intValue];
            self.numberCompletedCalls = [NSNumber numberWithInt:value + 1];
        });
    }];
    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count] > 0){
        [webService findByUsername:[[Credentials sharedCredentials].currentUser objectForKey:@"username"] withAuthToken:[[Credentials sharedCredentials].currentUser objectForKey:@"auth"] callback:^(NSDictionary* user) {
            if (user) {
                NSMutableDictionary* mutableUser = [user mutableCopy];
                [mutableUser setObject:[[Credentials sharedCredentials].currentUser objectForKey:@"auth"] forKey:@"auth"];
                if ([[mutableUser objectForKey:@"avatar"]length] >= 2 &&
                    ![[[mutableUser objectForKey:@"avatar"] substringToIndex:4] isEqualToString:@"http"]
                    ){
                    NSString* avatar = [NSString stringWithFormat:@"http:%@", [mutableUser objectForKey:@"avatar"] ];
                    [mutableUser setValue:avatar forKey:@"avatar"];
                }
                NSLog(@"%@", [[user objectForKey:@"avatar"] substringToIndex:4]);
                user = [mutableUser copy];
                [Credentials sharedCredentials].currentUser = user;
                [self fetchSessions:webService];
        
            }else{
                [webService findByEmail:[[Credentials sharedCredentials].currentUser objectForKey:@"email"] withAuthToken:[[Credentials sharedCredentials].currentUser objectForKey:@"auth"] callback:^(NSDictionary* user) {
                    {
                        if (user) {
                            NSMutableDictionary* mutableUser = [user mutableCopy];
                            [mutableUser setObject:[[Credentials sharedCredentials].currentUser objectForKey:@"auth"] forKey:@"auth"];
                            user = [mutableUser copy];
                            [Credentials sharedCredentials].currentUser = user;
                            [self fetchSessions:webService];

                        }else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showBadConnectionAlert];
                                });
                            }
                    }
                    
                }];
            }
        }];
        
    }else{
        [self fetchSessions:webService];
    }
    
}
-(void)fetchSessions:(WebService*)webService{
    ApplicationViewController.rightNav = nil;
    [webService fetchSessions:^(NSArray* jsonArray){
        [[FestivalData sharedFestivalData] initializeSessionArrayWithData: jsonArray];
        NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
        
        [[FestivalData sharedFestivalData].sessionsArray  sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
        if ([Credentials sharedCredentials].currentUser == nil ||[[Credentials sharedCredentials].currentUser count] == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                int value = [self.numberCompletedCalls intValue];
                self.numberCompletedCalls = [NSNumber numberWithInt:value + 1];
            });
        } else {
            [ApplicationViewController fetchCurrentUserSessions:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                int value = [self.numberCompletedCalls intValue];
                self.numberCompletedCalls = [NSNumber numberWithInt:value + 1];
                if ([(NSArray*)[[Credentials sharedCredentials].currentUser objectForKey:@"tickets"]count] == 0){
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self showNeedTicketModal];
                    });
                }
            });
        }
        
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.numberCompletedCalls = 0;
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changedSegmentedControl:(id)sender {
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    [self changeViewController:index];
}


@end