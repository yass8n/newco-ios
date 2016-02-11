//
//  SessionDetailViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SignInViewController.h"
#import "UserInitial.h"

@interface SessionDetailViewController ()
#import "constants.h"
@property (weak, readwrite, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *statusContainer;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *presenterName;
@property (weak, nonatomic) IBOutlet UIView *presenterView;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UIView *regionColor;
@property (weak, nonatomic) IBOutlet UIButton *allAttendees;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
- (IBAction)callSignIn:(id)sender;
- (IBAction)allAttendees:(id)sender;
@end

@implementation SessionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = self.session.color;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
- (void)setInvisibleRightButton{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.jpg"] landscapeImagePhone:[UIImage imageNamed:@"back.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(null)];
    item.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
}

- (void) adjustUI{
    [self setBackButton];
    [self setInvisibleRightButton]; //to take up extra space so title is centered
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 17.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = self.session.title;
    self.navigationItem.titleView = label;
    self.status.text = self.session.status;
    self.region.text = self.session.note1;
    self.date.text = self.session.worded_date;
    NSString* time = [self.session.start_time and @" - " ];
    self.time.text = [time and self.session.end_time];
    self.address.text = self.session.address;
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    [self.loginButton setTitle:@" Login or Register to Attend " forState:UIControlStateNormal]; // To set the title
    
    [ApplicationViewController setBorder:self.loginButton width:1.0 radius:1 color:[UIColor grayColor]];
    [ApplicationViewController setBorder:self.statusContainer width:1.0 radius:3 color:[UIColor blackColor]];
    
    self.regionColor.layer.cornerRadius = self.regionColor.frame.size.height/2;
    self.regionColor.layer.masksToBounds = YES;
    self.regionColor.backgroundColor = self.session.color;
    
    self.presenterView.layer.cornerRadius = self.presenterView.frame.size.height/2;
    self.presenterView.layer.masksToBounds = YES;
    
    self.companyView.layer.cornerRadius =  self.companyView.frame.size.height/2;
    self.companyView.layer.masksToBounds = YES;
    
    UserInitial * speakInitial = [[UserInitial alloc] initWithFrame:CGRectMake(0, 0, self.presenterView.frame.size.width, self.presenterView.frame.size.height)];
    [speakInitial.text.titleLabel setFont:[UIFont systemFontOfSize:20]];
    NSDictionary *speaker = [self.session.speakers objectAtIndex:0];
    speakInitial.username = [speaker objectForKey:@"username"];
    [speakInitial.text setTitle: [[[speaker objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
    [self.presenterView addSubview: speakInitial];

    UserInitial *compInitial = [[UserInitial alloc] initWithFrame:CGRectMake(0, 0, self.companyView.bounds.size.width, self.companyView.bounds.size.height)];
    [compInitial.text.titleLabel setFont:[UIFont systemFontOfSize:20]];
    NSDictionary *company = [self.session.companies objectAtIndex:0];
    compInitial.username = [company objectForKey:@"username"];
    [compInitial.text setTitle: [[[company objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
    [self.companyView addSubview: compInitial];
    
    //used in conjunction with linebreaks = 0
    self.presenterName.text = [speaker objectForKey:@"name"];
    self.presenterName.lineBreakMode = NSLineBreakByWordWrapping;
    self.companyName.text = [company objectForKey:@"name"];
    self.companyName.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.allAttendees.transform = CGAffineTransformMakeRotation(M_PI); //rotate it to point other direction
}


-(void)hideNavBar{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callSignIn:(id)sender {
    [self goToSignIn:sender];
}
- (IBAction)allAttendees:(id)sender {
    NSLog(@"get all attendees");
}
@end
