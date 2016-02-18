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
#import "FestivalCell.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *festivalImageTableView;

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
    self.sessionTableView.estimatedRowHeight = SESSION_HEADER_HEIGHT;
    self.sessionTableView.rowHeight = UITableViewAutomaticDimension;
    self.festivalImageTableView.scrollEnabled = NO;
    self.festivalImageTableView.userInteractionEnabled = NO;
}
- (void) registerTableCells{
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil]forCellReuseIdentifier:@"session_cell"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCellHeader" bundle:nil]forCellReuseIdentifier:@"session_cell_header"];
    [self.festivalImageTableView registerNib:[UINib nibWithNibName:@"FestivalCell" bundle:nil]forCellReuseIdentifier:@"festival_cell"];
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
    if (tableView == self.sessionTableView){
        
        if (ApplicationViewController.sysVer > 8.00) {
            return UITableViewAutomaticDimension;
        } else {
            return MIN_SESSION_HEIGHT;
        }
    }else{
        return FESTIVAL_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.sessionTableView){
        
        if (ApplicationViewController.sysVer > 8.00) {
            return UITableViewAutomaticDimension;
        } else {
            return MIN_SESSION_HEIGHT;
        }
    }else{
        return FESTIVAL_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.sessionTableView){
        return [self setupSessionCellforTableVew:tableView withIndexPath:indexPath withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
    }else{
        NSDictionary * festival = [Credentials sharedCredentials].festival;
        return [self cellForFestival:festival atIndexPath:indexPath forTableView:tableView backGroundColor:[UIColor whiteColor]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sessionTableView){
        
        [self didSelectSessionInTableView:tableView atIndexPath:indexPath withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.sessionTableView){
        
        return [[[FestivalData sharedFestivalData].datesDict allKeys] count];
    }else{
        return 1;
    }
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.sessionTableView){
        
        return [self numberOfRowsInSection:section forTableView:tableView withDatesDict:[FestivalData sharedFestivalData].datesDict withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.sessionTableView){
        return [self viewForHeaderInSection:section forTableView:tableView withOrderOfInsertedDatesDict:[FestivalData sharedFestivalData].orderOfInsertedDatesDict];
    }else{
        return [[UIView alloc]init];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.sessionTableView){
        return SESSION_HEADER_HEIGHT;
    }else{
        return 0;
    }
}
@end