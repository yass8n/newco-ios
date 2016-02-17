//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss
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

- (void) adjustUI{
    self.sessionTableView.estimatedRowHeight = 120.0;
    self.sessionTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void) addDataToTable{
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil]forCellReuseIdentifier:@"session_cell"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCellHeader" bundle:nil]forCellReuseIdentifier:@"session_cell_header"];
    [self reloadTableView];
    WebService * webService = [[WebService alloc] initWithView:self.view];
    [webService fetchSessions:^(NSArray* jsonArray){
        [[FestivalData sharedFestivalData] initializeSessionArrayWithData: jsonArray];
        NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
        
        [[FestivalData sharedFestivalData].sessionsArray  sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
        if ([Credentials sharedCredentials].currentUser == nil ||[[Credentials sharedCredentials].currentUser count] == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTableView];
            });
        } else {
            [self fetchCurrentUserSessions:self.view];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTableView];
            });
        }
    }];
    
}
-(void)setUsers{
    [self reloadTableView];
    WebService * webService = [[WebService alloc] initWithView:self.view];
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
            [self reloadTableView];
        });
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ApplicationViewController.currentVC = enumSchedule;
    [self setRightNavButton];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//native IOS controller functions
-(void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self addDataToTable];
    [self setUsers];
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
    return [self setupSessionCellforTableVew:tableView withIndexPath:indexPath withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectSessionInTableView:tableView atIndexPath:indexPath withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[FestivalData sharedFestivalData].datesDict allKeys] count];
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowsInSection:section forTableView:tableView withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self viewForHeaderInSection:section forTableView:tableView withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SESSION_HEADER_HEIGHT;
}
@end
