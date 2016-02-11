//
//  SessionDetailViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SignInViewController.h"
#import "UserInitial.h"

@interface SessionDetailViewController ()
#import "constants.h"
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
    
    self.region_color.layer.cornerRadius = self.region_color.frame.size.height/2;
    self.region_color.clipsToBounds = YES;
    self.region_color.layer.masksToBounds = YES;
    self.region_color.backgroundColor = self.session.color;
    
    self.presenter_view.layer.cornerRadius = self.presenter_view.frame.size.height/2;
    self.presenter_view.clipsToBounds = YES;
    self.presenter_view.layer.masksToBounds = YES;
    
    self.company_view.layer.cornerRadius =  self.company_view.frame.size.height/2;
    self.company_view.clipsToBounds = YES;
    self.company_view.layer.masksToBounds = YES;
    
    UserInitial * speak_initial = [[UserInitial alloc] initWithFrame:CGRectMake(0, 0, self.presenter_view.frame.size.width, self.presenter_view.frame.size.height)];
    [speak_initial.text.titleLabel setFont:[UIFont systemFontOfSize:20]];
    NSDictionary *speaker = [self.session.speakers objectAtIndex:0];
    speak_initial.username = [speaker objectForKey:@"username"];
    [speak_initial.text setTitle: [[[speaker objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
    [self.presenter_view addSubview: speak_initial];

    UserInitial *comp_initial = [[UserInitial alloc] initWithFrame:CGRectMake(0, 0, self.company_view.frame.size.width, self.company_view.frame.size.height)];
    [comp_initial.text.titleLabel setFont:[UIFont systemFontOfSize:20]];
    NSDictionary *company = [self.session.companies objectAtIndex:0];
    comp_initial.username = [company objectForKey:@"username"];
    [comp_initial.text setTitle: [[[company objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
    [self.company_view addSubview: comp_initial];
    
    //used in conjunction with linebreaks = 0
    self.presenter_name.text = [speaker objectForKey:@"name"];
    self.presenter_name.lineBreakMode = NSLineBreakByWordWrapping;
    self.company_name.text = [company objectForKey:@"name"];
    self.company_name.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.all_attendees.transform = CGAffineTransformMakeRotation(M_PI);

}

-(void)hideNavBar{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSignIn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)allAttendees:(id)sender {
}
@end
