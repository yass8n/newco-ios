//
//  ProfileViewController.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserImage.h"
#import "UserInitial.h"
#import "NSString+NSStringAdditions.h"
#import "Helper.h"
#import "ProfileDetailCell.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *superView;
@property (weak, nonatomic) IBOutlet UITableView *sessionTableView;
@property (strong, nonatomic) NSMutableArray * sessionsArray;
@property (strong, nonatomic) NSMutableDictionary* datesDict;
@property (strong, nonatomic) NSMutableDictionary* orderOfInsertedDatesDict;
#import "constants.h"
@end

@implementation ProfileViewController
static const int numberOfNonSessionSections = 1;
- (BOOL)checkIfPersonInArray:(NSArray*)array person:(NSString*)username {
    for (int i = 0; i < [array count]; i ++){
        NSDictionary * user = [array objectAtIndex:i];
        if ([[user objectForKey:@"username" ]  isEqual: username]){
            return YES;
        }
    }
    return NO;
}
- (void)getSessionForUser:(NSString*)username forType:(NSString*)type{
    self.sessionsArray = [[NSMutableArray alloc] init];
    for (int i =0; i < [[FestivalData sharedFestivalData].sessionsArray  count]; i++){
        Session * session = [[FestivalData sharedFestivalData].sessionsArray  objectAtIndex:i];
        if ([type  isEqual: @"speaker"]){
            if ([self checkIfPersonInArray:session.speakers person:[self.user objectForKey:@"username"]]){
                [self.sessionsArray addObject:session];
            }
        } else{
            if ([self checkIfPersonInArray:session.companies person:[self.user objectForKey:@"username"]]){
                [self.sessionsArray addObject:session];
            }
        }
    }
    [self sortAndSetSessionObjects];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadTableView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
// 
//    });


}
-(void)sortAndSetSessionObjects{
    [[FestivalData sharedFestivalData] setDatesDict:self.datesDict setOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict forSessions:self.sessionsArray initializeEverything:NO];
    
    NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
    
    [self.sessionsArray sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableView];
        if ( [[self.datesDict allKeys] count] == 0){
            UILabel *tv = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
            tv.textAlignment = NSTextAlignmentCenter;
            
            [tv setText:@"No sessions to show"];
            [tv setAlpha:0.0];
            [tv setTextColor:[UIColor darkGrayColor]];
            [tv setBackgroundColor:[UIColor myLightOrange]];
            [self.view addSubview:tv];
            CGRect animateUpFrame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
            [UIView animateWithDuration:.5 animations:^{
                [tv setAlpha:1.0];
                [tv setFrame:animateUpFrame];
            }];
        }
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self allocateMemory];
    [self adjustUI];
    [self addDataToTable];
    
    // Do any additional setup after loading the view.
}
-(void)allocateMemory{
    self.datesDict = [[NSMutableDictionary alloc] init];
    self.orderOfInsertedDatesDict =[[NSMutableDictionary alloc] init];
}
- (void) addDataToTable{
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCell" bundle:nil]forCellReuseIdentifier:@"session_cell"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"SessionCellHeader" bundle:nil]forCellReuseIdentifier:@"session_cell_header"];
    [self.sessionTableView registerNib:[UINib nibWithNibName:@"ProfileDetailCell" bundle:nil]forCellReuseIdentifier:@"profile_detail_cell"];
    
    NSString * username = [self.user objectForKey:@"username"];
    if ([self.type isEqual:@"speaker"] || [self.type isEqual:@"company"] ){
        dispatch_async(dispatch_queue_create("", NULL), ^{[self getSessionForUser:username forType:self.type];});
        
    } else {
        WebService * webService = [[WebService alloc] initWithView:self.view];
        [webService fetchSesionsForUser:^(NSArray *allSessionTransactions) {
            self.sessionsArray = [[NSMutableArray alloc] init];
            for (int i =0; i < [allSessionTransactions count]; i++){
                NSMutableDictionary* sessionTransaction = [allSessionTransactions objectAtIndex:i];
                if ([[sessionTransaction objectForKey:@"username"] isEqual:username]){
                    [self.sessionsArray addObject:[[FestivalData sharedFestivalData].sessionsDict objectForKey:[sessionTransaction objectForKey:@"event_key"]]];
                }
            }
            [self sortAndSetSessionObjects];
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustUI{
    [self setBackButton];
    NSString * name = [self.user objectForKey:@"name"];
    self.navigationItem.title = name;
    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count] > 0){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logUserOut:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
}
-(void)reloadTableView
{
    [self.sessionTableView reloadData];
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
    if (indexPath.section == 0 && indexPath.row == 0){
        ProfileDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"profile_detail_cell"];
        NSMutableString* positionAndCompany = [@"" mutableCopy];
        positionAndCompany = [self.user objectForKey:@"position"];
        if (![[self.user objectForKey:@"company"]  isEqual: @""]){
            positionAndCompany = [[positionAndCompany and @" @ "] mutableCopy];
            positionAndCompany = [[positionAndCompany and [self.user objectForKey:@"company"]] mutableCopy];
        }
        cell.positionAndCompany.text = positionAndCompany;
 
        NSString* avatar = [self.user objectForKey:@"avatar"];
        CGRect rect = CGRectMake(0, 0, cell.profileImage.bounds.size.width, cell.profileImage.bounds.size.height);
        
        if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""]){
            [self setUserInitial:rect withFont:rect.size.width/2 withUser:self.user intoView:cell.profileImage withType:self.type];
        }else {
            [self setUserImage:rect withAvatar:avatar withUser:self.user intoView:cell.profileImage withType:self.type];
        }
        cell.website.backgroundColor = [UIColor myNavigationBarColor];
        cell.positionAndCompany.textColor =[UIColor myNavigationBarColor];
        cell.about.text =  [[self.user objectForKey:@"about"] stringByStrippingHTML];
        if ([[self.user objectForKey:@"url"]  isEqual: @""]){
            [cell.website removeFromSuperview];
            cell.website.hidden = YES;
        }else{
            cell.website.hidden = NO;
        }
        if ([cell.about.text length] > 0){
            cell.about.textColor = [UIColor myNavigationBarColor];
            cell.about.lineBreakMode = NSLineBreakByWordWrapping;
            cell.about.numberOfLines = 0;

        }else{
            [cell.about removeFromSuperview];
        }
        return cell;
    }else{
        NSIndexPath* iPath = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section-numberOfNonSessionSections];
           return [self setupSessionCellforTableVew:tableView withIndexPath:iPath withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        return;
    }
    [self didSelectSessionInTableView:tableView atIndexPath:indexPath withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.datesDict allKeys] count] + numberOfNonSessionSections;
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return numberOfNonSessionSections;
    }
    return [self numberOfRowsInSection:(section-numberOfNonSessionSections) forTableView:tableView withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return [[UIView alloc]init];
    }
    return [self viewForHeaderInSection:(section-numberOfNonSessionSections) forTableView:tableView withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }
    return SESSION_HEADER_HEIGHT;
}

- (IBAction)goToWebsite:(id)sender {
//    NSLog(@"GO TO WEBSITE");
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.user objectForKey:@"url"]]];
    [self showWebViewWithUrl:[self.user objectForKey:@"url"]];

}
- (IBAction)logUserOut:(id)sender {
    dispatch_queue_t que = dispatch_queue_create("logOut", NULL);
    dispatch_async(que, ^{
        //code executed in background
        [[Credentials sharedCredentials] logOut];
        //code to be executed on main thread when block is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setDefaultUserIcon];
            [self reloadTableView];
            [self setInvisibleRightButton];
        });
    });
}


- (IBAction)hideTopView:(id)sender {
    CGRect oldFrame = self.topView.frame;
    CGRect old1Frame = self.sessionTableView.frame;
    CGRect newFrame = CGRectMake(self.topView.frame.origin.x, -self.topView.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height);
    CGRect newTableFrame = CGRectMake(self.sessionTableView.frame.origin.x, 0, self.sessionTableView.frame.size.width, self.view.frame.size.height);

    [UIView animateWithDuration:.5 animations:^{
        self.topView.frame = newFrame;
        self.topView.alpha = 0;
        self.sessionTableView.frame = newTableFrame;
    } completion:^(BOOL finished) {
        [self.topView removeFromSuperview];
    }];
}
@end