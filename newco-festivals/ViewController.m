//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss 
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ViewController.h"
#import "SessionCell.h"

@interface ViewController ()

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
             dispatch_async(dispatch_get_main_queue(), ^{ [self->sessionTableView reloadData];});
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
        NSString* description = [session_ objectForKey:@"description"];
        NSString* event_key = [session_ objectForKey:@"event_key"];
        NSString* name = [session_ objectForKey:@"name"];
        NSString* address = [session_ objectForKey:@"address"];
        NSString* event_start = [session_ objectForKey:@"event_start"];
        NSString* event_end = [session_ objectForKey:@"event_end"];
        NSString* location = [session_ objectForKey:@"event_type"];
        NSString* id_ = [session_ objectForKey:@"id"];
        NSArray* speakers = [session_ objectForKey:@"speakers"];
        NSArray* artists = [session_ objectForKey:@"artists"];
        NSString* status = [session_ objectForKey:@"seats-title"];
        NSString* audience = [session_ objectForKey:@"audience"];
        
        if (![self.locationColorHash objectForKey:location]){
            [self.locationColorHash setObject:[self findFreeColor] forKey:location];
        }

        
        session *s = [[session alloc] initWithTitle: name
                                          event_key: event_key
                                         event_type: location
                                                id_: id_
                                             status: status
                                              note1: location
                                              color: [self.locationColorHash objectForKey:location]
                                        event_start: event_start];
        [array addObject: s];
    }
}


- (void) adjustUI{
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self->sessionTableView.estimatedRowHeight = 120.0;
    self->sessionTableView.rowHeight = UITableViewAutomaticDimension;
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
    SessionCell * session_cell = [tableView dequeueReusableCellWithIdentifier:@"session_cell"];
    session_cell.status.text = [self.sessionsArray[indexPath.row] status];
    session_cell.time.text = [self.sessionsArray[indexPath.row] time];
    session_cell.title.text = [self.sessionsArray[indexPath.row] title];
    session_cell.note1.text = [self.sessionsArray[indexPath.row] note1];
    session_cell.outerContainer.backgroundColor = [self.sessionsArray[indexPath.row]color];
    session_cell.innnerContainer.backgroundColor = [self.sessionsArray[indexPath.row]color];
    
    session_cell.title.lineBreakMode = NSLineBreakByWordWrapping; //used in conjunction with linebreaks = 0
    session_cell.note1.lineBreakMode = NSLineBreakByWordWrapping;
    
    [session_cell layoutIfNeeded]; //fixes issue where the first cells that are initially showing are not wrapping content for note1
    
    [ApplicationViewController setBorder:session_cell.outerContainer width:1.0 radius:8 color:[UIColor whiteColor]];
    [ApplicationViewController setBorder:session_cell.statusContainer width:1.0 radius:4 color:[UIColor blackColor]];
    return session_cell;
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sessionsArray count];
}

@end
