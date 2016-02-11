//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SessionCell.h"
#import "SignInViewController.h"
#import "SessionCellHeader.h"
#import "SessionDetailViewController.h"
#import "DirectoryViewController.h"

@interface ScheduleViewController ()
    @property (weak, nonatomic) IBOutlet UITableView *sessionTableView;
    #import "constants.h"
@end

@implementation ScheduleViewController;


- (void)fetchSesions {
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/session/export?api_key=%@&format=json&fields=description,event_key,name,address,event_start,event_end,event_type,id,speakers,artists,seats,audience", ApplicationViewController.API_URL, ApplicationViewController.API_KEY];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             ApplicationViewController.sessionsArray = [[NSMutableArray alloc] init];
             [self initializeSessionArray:ApplicationViewController.sessionsArray withData:jsonArray withDatesDict:ApplicationViewController.datesDict withOrderOfInsertedDatesDict:ApplicationViewController.orderOfInsertedDatesDict initializeEverything:YES];
             NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
             
             [ApplicationViewController.sessionsArray sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
             if (!ApplicationViewController.currentUser){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self reloadTableView];
                 });
             } else {
                 [self fetchCurrentUserSessions];
             }
         }else {
             [self showBadConnectionAlert];
         }
     }];
}
- (void)fetchCurrentUserSessions{
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/going/list?api_key=%@&session=%@&username=%@", ApplicationViewController.API_URL, ApplicationViewController.API_KEY, [ApplicationViewController.currentUser objectForKey:@"auth"], [ApplicationViewController.currentUser objectForKey:@"username"]] ;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *sessionKeyArray = [NSJSONSerialization JSONObjectWithData:data
                options:0
                error:NULL];
             NSMutableDictionary* userSessions = [[NSMutableDictionary alloc]init];
             for (int i = 0; i < [sessionKeyArray count]; i++){
                 NSString* event_key = [sessionKeyArray objectAtIndex:i];
                 Session * s = [ApplicationViewController.sessionsDict objectForKey:event_key];
                  if (s && ![s isEqual:[NSNull null]]){
                      [userSessions setObject:@"YES" forKey:event_key];
                  }
             }
             ApplicationViewController.currentUserSessions = userSessions;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self reloadTableView];
             });
         }else {
             [self showBadConnectionAlert];
         }
     }];

}
- (void)fetchUsers {
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/user/list?api_key=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,lastactive,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", ApplicationViewController.API_URL, ApplicationViewController.API_KEY];
    NSURL *url = [NSURL URLWithString:fullURL];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection
     sendAsynchronousRequest:request
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response,
    NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             ApplicationViewController.attendeesDict = [[NSMutableDictionary alloc] init];
             ApplicationViewController.presentersDict = [[NSMutableDictionary alloc] init];
             ApplicationViewController.volunteersDict = [[NSMutableDictionary alloc] init];
             ApplicationViewController.companiesDict = [[NSMutableDictionary alloc] init];
             for (NSDictionary *user in jsonArray) {
                 NSString* role = [user objectForKey:@"role"];
                 NSString* privacy = [user objectForKey:@"privacy_mode"];
                 if ([privacy isEqual:@"N"]){
                     if ([role rangeOfString:@"attendee"].location != NSNotFound) {
                         [ApplicationViewController.attendeesDict setObject:user forKey:[user objectForKey:@"username"]];
                     }
                     if ([role rangeOfString:@"volunteer"].location != NSNotFound) {
                         [ApplicationViewController.volunteersDict setObject:user forKey:[user objectForKey:@"username"]];
                     }
                     if ([role rangeOfString:@"speaker"].location != NSNotFound) {
                         [ApplicationViewController.presentersDict setObject:user forKey:[user objectForKey:@"username"]];
                     }
                     if ([role rangeOfString:@"artist"].location != NSNotFound) {
                         [ApplicationViewController.companiesDict setObject:user forKey:[user objectForKey:@"username"]];
                     }
                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 ApplicationViewController.enableFullUserInteraction = YES;
                 [self reloadTableView];
                });

         }else {
             [self showBadConnectionAlert];
         }
     }];
}
- (void) adjustUI{
    self.sessionTableView.estimatedRowHeight = 120.0;
    self.sessionTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void) addDataToTable{
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil]forCellReuseIdentifier:@"session_cell"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCellHeader" bundle:nil]forCellReuseIdentifier:@"session_cell_header"];

    dispatch_queue_t que = dispatch_queue_create("getSessions", NULL);
    dispatch_async(que, ^{[self fetchSesions];});
}
-(void)setUsers{
    dispatch_queue_t que = dispatch_queue_create("getUsers", NULL);
    dispatch_async(que, ^{[self fetchUsers];});
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    ApplicationViewController.currentVC = enumSchedule;
    if (ApplicationViewController.currentUser){
        [self setUserNavBar:ApplicationViewController.currentUser];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadTableView];
}
//native IOS controller functions
-(void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self allocateMemory];
    [self addDataToTable];
    [self setUsers];
}
-(void)allocateMemory{
    ApplicationViewController.datesDict = [[NSMutableDictionary alloc] init];
    ApplicationViewController.locationColorDict =  [[NSMutableDictionary alloc] init];
    ApplicationViewController.orderOfInsertedDatesDict =[[NSMutableDictionary alloc] init];
}
-(void)reloadTableView
{
    [self.sessionTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView functions
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_SESSION_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_SESSION_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setupSessionCellforTableVew:tableView withIndexPath:indexPath withDatesDict:ApplicationViewController.datesDict withOrderOfInsertedDatesDict:ApplicationViewController.orderOfInsertedDatesDict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectSessionInTableView:tableView atIndexPath:indexPath withDatesDict:ApplicationViewController.datesDict withOrderOfInsertedDatesDict:ApplicationViewController.orderOfInsertedDatesDict];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[ApplicationViewController.datesDict allKeys] count];
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowsInSection:section forTableView:tableView withDatesDict:ApplicationViewController.datesDict withOrderOfInsertedDatesDict:ApplicationViewController.orderOfInsertedDatesDict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
       return [self viewForHeaderInSection:section forTableView:tableView withOrderOfInsertedDatesDict:ApplicationViewController.orderOfInsertedDatesDict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SESSION_HEADER_HEIGHT;
}
@end
