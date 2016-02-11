//
//  ProfileViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserImage.h"
#import "UserInitial.h"

@interface ProfileViewController ()
    @property (weak, nonatomic) IBOutlet UITableView *sessionTableView;
    @property (strong, nonatomic) NSMutableArray * sessionsArray;
    @property (strong, nonatomic) NSMutableDictionary* datesDict;
    @property (strong, nonatomic) NSMutableDictionary* orderOfInsertedDatesDict;
    #import "constants.h"
@end

@implementation ProfileViewController
- (void)fetchSesionsForUser:(NSString*)username {
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/user/sessions?api_key=%@&format=json", ApplicationViewController.API_URL, ApplicationViewController.API_KEY];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *allSessionTransactions = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
        self.sessionsArray = [[NSMutableArray alloc] init];
             for (int i =0; i < [allSessionTransactions count]; i++){
                 NSMutableDictionary* sessionTransaction = [allSessionTransactions objectAtIndex:i];
                 if ([[sessionTransaction objectForKey:@"username"] isEqual:username]){
                     [self.sessionsArray addObject:[ApplicationViewController.sessionsDict objectForKey:[sessionTransaction objectForKey:@"event_key"]]];
                 }
             }
        [self sortAndSetSessionObjects];
         }else {
             [self showBadConnectionAlert];
         }
     }];
}
- (BOOL)checkIfPersonInArray:(NSArray*)array person:(NSString*)username {
    for (int i = 0; i < [array count]; i ++){
        NSDictionary * user = [array objectAtIndex:i];
        if ([[user objectForKey:@"username" ]  isEqual: username]){
            return YES;
        }
    }
    return NO;
}
- (void)fetchSessionForUser:(NSString*)username forType:(NSString*)type{
    self.sessionsArray = [[NSMutableArray alloc] init];
    for (int i =0; i < [ApplicationViewController.sessionsArray count]; i++){
        Session * session = [ApplicationViewController.sessionsArray objectAtIndex:i];
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
}
-(void)sortAndSetSessionObjects{
    [self setDatesDict:self.datesDict setOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict forSessions:self.sessionsArray];
    
    NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
    
    [self.sessionsArray sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableView];
        [UIApplication sharedApplication].
        networkActivityIndicatorVisible = NO;
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self allocateMemory];
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
    
    dispatch_queue_t que = dispatch_queue_create("getSessions", NULL);
    if ([self.type isEqual:@"speaker"] || [self.type isEqual:@"company"] ){
        dispatch_async(que, ^{[self fetchSessionForUser:[self.user objectForKey:@"username"] forType:self.type];});
    } else {
        dispatch_async(que, ^{[self fetchSesionsForUser:[self.user objectForKey:@"username"]];});
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
    self.name.text = name;
    NSMutableString* positionAndCompany = [@"" mutableCopy];
    positionAndCompany = [self.user objectForKey:@"position"];
    if (![[self.user objectForKey:@"company"]  isEqual: @""]){
        positionAndCompany = [[positionAndCompany and @" @ "] mutableCopy];
        positionAndCompany = [[positionAndCompany and [self.user objectForKey:@"company"]] mutableCopy];
    }
    self.positionAndCompany.text = positionAndCompany;
    self.navigationItem.title = name;
    NSString* avatar = [self.user objectForKey:@"avatar"];
    CGRect rect = CGRectMake(0, 0, self.profileImage.bounds.size.width, self.profileImage.bounds.size.height);

    if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""]){
        [self setUserInitial:rect withFont:50 withUser:self.user intoView:self.profileImage withType:self.type];
    }else {
        [self setUserImage:rect withAvatar:avatar withUser:self.user intoView:self.profileImage withType:self.type];
    }
    if ([[self.user objectForKey:@"url"]  isEqual: @""]){
        [self.website removeFromSuperview];
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
    return [self setupSessionCellforTableVew:tableView withIndexPath:indexPath withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectSessionInTableView:tableView atIndexPath:indexPath withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.datesDict allKeys] count];
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowsInSection:section forTableView:tableView withDatesDict:self.datesDict withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self viewForHeaderInSection:section forTableView:tableView withOrderOfInsertedDatesDict:self.orderOfInsertedDatesDict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SESSION_HEADER_HEIGHT;
}

- (IBAction)goToWebsite:(id)sender {
}

@end
