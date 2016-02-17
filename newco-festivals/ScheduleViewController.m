//
//  ViewController.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
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

//static NSMutableArray * sessionsArray;
//static NSMutableDictionary * sessionsDict;
//static NSMutableDictionary* datesDict;
//static NSMutableDictionary* sessionsAtDateAndTime;
//static NSMutableDictionary* orderOfInsertedDatesDict;
//static NSMutableDictionary* locationColorDict;
//
//+ (NSMutableArray *) sessionsArray{
//    return sessionsArray;
//}
//+ (NSMutableDictionary*) sessionsDict{
//    return sessionsDict;
//}
//+ (NSMutableDictionary*) datesDict{
//    return datesDict;
//}
//+ (NSMutableDictionary*) sessionsAtDateAndTime{
//    return sessionsAtDateAndTime;
//}
//+ (NSMutableDictionary*) orderOfInsertedDatesDict{
//    return orderOfInsertedDatesDict;
//}
//+ (NSMutableDictionary*) locationColorDict{
//    return locationColorDict;
//}

- (void) adjustUI{
    self.sessionTableView.estimatedRowHeight = 120.0;
    self.sessionTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void) registerTableCells{
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil]forCellReuseIdentifier:@"session_cell"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCellHeader" bundle:nil]forCellReuseIdentifier:@"session_cell_header"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ApplicationViewController.currentVC = enumSchedule;
    [self setRightNavButton];
    [self reloadTableView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//native IOS controller functions
-(void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self registerTableCells];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRightNavButton) name:@"setRightNavButton" object:nil];
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