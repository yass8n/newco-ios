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
#import "constants.h"
@end

@implementation ScheduleViewController{
    IBOutlet UITableView *sessionTableView;
}

static const float MIN_CELL_HEIGHT = 130.0;


- (void)fetchSesions {
    NSURL *url = [NSURL URLWithString:@"http://newcocincinnati2015.sched.org/api/session/export?api_key=1753dd51c3a6d450ba8e7e12de70c4f6&format=json&fields=description,event_key,name,address,event_start,event_end,event_type,id,speakers,artists,seats,audience"];
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
             [self initializeSessionArray:ApplicationViewController.sessionsArray withData:jsonArray];
             NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
             
             [ApplicationViewController.sessionsArray sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self reloadTableView];
                [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
             });
         }else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                             message:@"You must be connected to the internet to use this app."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}
- (void)fetchUsers {
    NSURL *url = [NSURL URLWithString:@"http://newcocincinnati2015.sched.org/api/user/list?api_key=1753dd51c3a6d450ba8e7e12de70c4f6&format=json&fields=username,name,email,twitter_uid,fb_uid,lastactive,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id"];

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
             ApplicationViewController.attendeesDict = [[NSMutableDictionary alloc] init];
             ApplicationViewController.presentersDict = [[NSMutableDictionary alloc] init];
             ApplicationViewController.volunteersDict = [[NSMutableDictionary alloc] init];
             for (NSDictionary *user in jsonArray) {
                 NSString* role = [user objectForKey:@"role"];
                 if ([role rangeOfString:@"attendee"].location != NSNotFound) {
                     [ApplicationViewController.attendeesDict setObject:user forKey:[user objectForKey:@"username"]];
                 }
                 if ([role rangeOfString:@"volunteer"].location != NSNotFound) {
                     [ApplicationViewController.volunteersDict setObject:user forKey:[user objectForKey:@"username"]];
                 }
                 if ([role rangeOfString:@"speaker"].location != NSNotFound) {
                     [ApplicationViewController.presentersDict setObject:user forKey:[user objectForKey:@"username"]];
                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 ApplicationViewController.enableSegmentedControl = YES;});

         }else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                             message:@"You must be connected to the internet to use this app."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}
-(void) initializeSessionArray:(NSMutableArray*)array withData:(NSArray *) jsonArray{
    ApplicationViewController.companiesDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < jsonArray.count; i++){
        NSDictionary* session_ = [jsonArray objectAtIndex:i];
        NSString* description = [session_ objectForKey:@"description"];
        NSString* event_key = [session_ objectForKey:@"event_key"];
        NSString* name = [session_ objectForKey:@"name"];
        NSString* address = [session_ objectForKey:@"address"];
        NSDate* event_start = [ApplicationViewController UTCtoNSDate:[session_ objectForKey:@"event_start"]];
        NSDate* event_end = [ApplicationViewController UTCtoNSDate:[session_ objectForKey:@"event_end"]];
        NSString* location = [session_ objectForKey:@"event_type"];
        NSString* id_ = [session_ objectForKey:@"id"];
        NSArray* speakers = [session_ objectForKey:@"speakers"];
        NSArray* artists = [session_ objectForKey:@"artists"];
        [ApplicationViewController.companiesDict setObject:[artists objectAtIndex:0] forKey:[[artists objectAtIndex:0] objectForKey:@"username"]];
        NSString* status = [session_ objectForKey:@"seats-title"];
        NSString* audience = [session_ objectForKey:@"audience"];

        if (![ApplicationViewController.locationColorHash objectForKey:location]){
            [ApplicationViewController.locationColorHash setObject:[self findFreeColor] forKey:location];
        }
        Session *s = [[Session alloc] initWithTitle: name
                                          event_key: event_key
                                         event_type: location
                                                id_: id_
                                             status: status
                                              note1: location
                                              color: [ApplicationViewController.locationColorHash objectForKey:location]
                                        event_start: event_start
                                          event_end:event_end
                                            address: address
                                           audience: audience
                                           speakers: speakers
                                          companies: artists
                                        description: description];
        [array addObject: s];
        if (![ApplicationViewController.datesArray objectForKey:s.worded_date]){
            NSUInteger count =  [[ApplicationViewController.datesArray allKeys] count];
            NSNumber *count_object = [NSNumber numberWithInteger:count];
            [ApplicationViewController.orderOfInsertedDates setObject:s.worded_date forKey:count_object];
            [ApplicationViewController.datesArray setObject:[[NSMutableArray alloc] init] forKey:s.worded_date];
        }
        NSMutableArray * sessions_for_date = [ApplicationViewController.datesArray objectForKey:s.worded_date];
        [sessions_for_date addObject:s];
    }
}
- (void) adjustUI{
    self->sessionTableView.estimatedRowHeight = 120.0;
    self->sessionTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void) addDataToTable{
    dispatch_queue_t que = dispatch_queue_create("getSessions", NULL);
    dispatch_async(que, ^{[self fetchSesions];});
}
-(void)setUsers{
    dispatch_queue_t que = dispatch_queue_create("getUsers", NULL);
    dispatch_async(que, ^{[self fetchUsers];});
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
}
//native IOS controller functions
-(void)viewDidLoad {
    [super viewDidLoad];
    [self allocateMemory];
    [self adjustUI];
    [self addDataToTable];
    [self setUsers];
}
-(void)allocateMemory{
    ApplicationViewController.datesArray = [[NSMutableDictionary alloc] init];
    ApplicationViewController.locationColorHash =  [[NSMutableDictionary alloc] init];
    ApplicationViewController.orderOfInsertedDates =[[NSMutableDictionary alloc] init];
}
-(void)reloadTableView
{
    [self->sessionTableView reloadData];
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
        return MIN_CELL_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_CELL_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // this seems to do the trick because NSInteger is not an object and forKey expects an object
    NSUInteger section = indexPath.section;
    NSNumber *section_object = [NSNumber numberWithInteger:section];
    NSDate* date = [ApplicationViewController.orderOfInsertedDates objectForKey:section_object];
    
    SessionCell * session_cell = [tableView dequeueReusableCellWithIdentifier:@"session_cell"];
    Session * currentSession = [ApplicationViewController.datesArray objectForKey:date ][indexPath.row];
    session_cell.status.text = [currentSession status];
    NSString* time = [[currentSession start_time] and @" - " ];
    session_cell.time.text = [time and [currentSession end_time] ];
    session_cell.title.text = [currentSession title];
    session_cell.note1.text = [currentSession note1];
    session_cell.outerContainer.backgroundColor = [currentSession color];
    session_cell.innnerContainer.backgroundColor = session_cell.outerContainer.backgroundColor;
    
    session_cell.title.lineBreakMode = NSLineBreakByWordWrapping; //used in conjunction with linebreaks = 0
    session_cell.note1.lineBreakMode = NSLineBreakByWordWrapping;
    
    [session_cell layoutIfNeeded]; //fixes issue where the first cells that are initially showing are not wrapping content for note1
    
    [ApplicationViewController setBorder:session_cell.outerContainer width:1.0 radius:6 color:[UIColor whiteColor]];
    [ApplicationViewController setBorder:session_cell.statusContainer width:1.0 radius:3 color:[UIColor blackColor]];
    session_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [session_cell layoutIfNeeded];
    if (ApplicationViewController.sysVer < 8.00){
        session_cell.outerContainer.clipsToBounds = YES;
    }
 
    return session_cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
    
    NSNumber *section_object = [NSNumber numberWithInteger:indexPath.section];
     NSDate* date = [ApplicationViewController.orderOfInsertedDates objectForKey:section_object];
    [vc setSession:[ApplicationViewController.datesArray objectForKey:date ][indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];

}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[ApplicationViewController.datesArray allKeys] count];
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    NSNumber *section_object = [NSNumber numberWithInteger:section];
    NSString* date = [ApplicationViewController.orderOfInsertedDates objectForKey:section_object];

    return [[ApplicationViewController.datesArray objectForKey:date] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1. Dequeue the custom header cell
    SessionCellHeader* headerCell = [tableView dequeueReusableCellWithIdentifier:@"session_cell_header"];
    
    // 2. Set the various properties
    NSNumber *section_object = [NSNumber numberWithInteger:section];
    headerCell.date.text = [ApplicationViewController.orderOfInsertedDates objectForKey:section_object];
    [headerCell.date sizeToFit];
    
    // 3. And return
    return headerCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}
@end
