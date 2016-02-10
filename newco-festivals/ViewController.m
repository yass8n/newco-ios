//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ViewController.h"
#import "SessionCell.h"
#import "SignInViewController.h"
#import "SessionCellHeader.h"
#import "SessionDetailViewController.h"

@interface ViewController ()
#import "constants.h"
@end

@implementation ViewController{
    IBOutlet UITableView *sessionTableView;
    IBOutlet UISegmentedControl *segmentedControl;
    float sysVer;
}

static const float MIN_CELL_HEIGHT = 130.0;


- (IBAction)fetchSesions {
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
             self.sessionsArray = [[NSMutableArray alloc] init];
             [self initializeSessionArray:self.sessionsArray withData:jsonArray];
             NSSortDescriptor *sortStart = [[NSSortDescriptor alloc] initWithKey:@"event_start" ascending:YES];
             
             [self.sessionsArray sortUsingDescriptors:[NSMutableArray arrayWithObjects:sortStart, nil]];
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
-(void) initializeSessionArray:(NSMutableArray*)array withData:(NSArray *) jsonArray{
    for (int i = 0; i < jsonArray.count; i++){
        NSDictionary* session_ = [jsonArray objectAtIndex:i];
//        NSString* description = [session_ objectForKey:@"description"];
        NSString* event_key = [session_ objectForKey:@"event_key"];
        NSString* name = [session_ objectForKey:@"name"];
//        NSString* address = [session_ objectForKey:@"address"];
        NSDate* event_start = [ApplicationViewController UTCtoNSDate:[session_ objectForKey:@"event_start"]];
        NSDate* event_end = [ApplicationViewController UTCtoNSDate:[session_ objectForKey:@"event_end"]];
        NSString* location = [session_ objectForKey:@"event_type"];
        NSString* id_ = [session_ objectForKey:@"id"];
//        NSArray* speakers = [session_ objectForKey:@"speakers"];
//        NSArray* artists = [session_ objectForKey:@"artists"];
        NSString* status = [session_ objectForKey:@"seats-title"];
//        NSString* audience = [session_ objectForKey:@"audience"];

        if (![self.locationColorHash objectForKey:location]){
            [self.locationColorHash setObject:[self findFreeColor] forKey:location];
        }
        Session *s = [[Session alloc] initWithTitle: name
                                          event_key: event_key
                                         event_type: location
                                                id_: id_
                                             status: status
                                              note1: location
                                              color: [self.locationColorHash objectForKey:location]
                                        event_start: event_start
                                          event_end:event_end];
        [array addObject: s];
        if (![self.datesArray objectForKey:s.worded_date]){
            int count =  [[self.datesArray allKeys] count];
            [self.orderOfInsertedDates setObject:s.worded_date forKey:[NSNumber numberWithInt:count]];
            [self.datesArray setObject:[[NSMutableArray alloc] init] forKey:s.worded_date];
        }
        NSMutableArray * sessions_for_date = [self.datesArray objectForKey:s.worded_date];
        [sessions_for_date addObject:s];
    }
}
-(IBAction)openMenu:(id)sender  {
    NSLog(@"open menu");
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}
- (IBAction)goToSignIn:(id)sender  {    
  [self performSegueWithIdentifier:@"goToSignIn" sender:self];
}


- (void) adjustUI{
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self->sessionTableView.estimatedRowHeight = 120.0;
    self->sessionTableView.rowHeight = UITableViewAutomaticDimension;
    
    UIButton *menu =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menu setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
    [user setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    [user addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [user setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
}
- (void) addDataToTable{
    dispatch_queue_t que = dispatch_queue_create("getSessions", NULL);
    dispatch_async(que, ^{[self fetchSesions];});
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
//native IOS controller functions
-(void)viewDidLoad {
    [super viewDidLoad];
    [sessionTableView setDataSource:self];
    [self adjustUI];
    [self addDataToTable];
    sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
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
    if (sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_CELL_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_CELL_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSDate* date = [self.orderOfInsertedDates objectForKey:[NSNumber numberWithInt:section]];
    

    SessionCell * session_cell = [tableView dequeueReusableCellWithIdentifier:@"session_cell"];
    Session * currentSession = [self.datesArray objectForKey:date ][indexPath.row];
    session_cell.status.text = [currentSession status];
    NSString* time = [[[self.datesArray objectForKey:date ][indexPath.row] start_time] and @" - " ];
    session_cell.time.text = [time and [[self.datesArray objectForKey:date ][indexPath.row] end_time] ];
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
 
    return session_cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *vc = (SessionDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
     NSDate* date = [self.orderOfInsertedDates objectForKey:[NSNumber numberWithInt:indexPath.section]];
    [vc setSession:[self.datesArray objectForKey:date ][indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];

}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.datesArray allKeys] count];
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    NSString* date = [self.orderOfInsertedDates objectForKey:[NSNumber numberWithInt:section]];

    return [[self.datesArray objectForKey:date] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1. Dequeue the custom header cell
    SessionCellHeader* headerCell = [tableView dequeueReusableCellWithIdentifier:@"session_cell_header"];
    
    // 2. Set the various properties
    headerCell.date.text = [self.orderOfInsertedDates objectForKey:[NSNumber numberWithInt:section]];
    [headerCell.date sizeToFit];
    
    // 3. And return
    return headerCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}



@end
