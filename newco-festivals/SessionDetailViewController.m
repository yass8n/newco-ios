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
#import "UserImage.h"


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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (weak, nonatomic) IBOutlet UILabel *attendeesLabel;
- (IBAction)callSignIn:(id)sender;
- (IBAction)allAttendees:(id)sender;
@end

@implementation SessionDetailViewController
- (void)setAttendeesForSession:(NSString*)id_{
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
    NSString *fullURL=[NSString stringWithFormat:@"%@/api/session/seats?api_key=%@&type=all&format=json&id=%@&by=id&fields=username,name,privacy_mode,avatar", ApplicationViewController.API_URL, ApplicationViewController.API_KEY, id_];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             self.users = [[NSMutableDictionary alloc] init];
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
             for (int i = 0; i < [jsonArray count]; i++){
                 NSDictionary * user = [ApplicationViewController.attendeesDict objectForKey:[[jsonArray objectAtIndex:i] objectForKey:@"username"]];
                 if (user && ![user isEqual:[NSNull null]]){
                     [self.users setObject:user forKey:[user objectForKey:@"username"]];
                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self setupScrollView];
             });
             
         }else {
             [self showBadConnectionAlert];
         }
     }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    dispatch_queue_t que = dispatch_queue_create("getAttendeesForSession", NULL);
    dispatch_async(que, ^{[self setAttendeesForSession:[self.session id_]];});
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.session.color;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    ApplicationViewController.currentVC = enumSessionDetail;

}
- (void) adjustUI{
    [self setupNavBar];
    
    self.status.text = self.session.status;
    self.date.text = self.session.worded_date;
    NSString* time = [self.session.start_time and @" - " ];
    self.time.text = [time and self.session.end_time];
    self.address.text = self.session.address;
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    [self.loginButton setTitle:@" Login or Register to Attend " forState:UIControlStateNormal]; // To set the title
    
    [ApplicationViewController setBorder:self.loginButton width:1.0 radius:1 color:[UIColor grayColor]];
    [ApplicationViewController setBorder:self.statusContainer width:1.0 radius:3 color:[UIColor blackColor]];
    
    self.region.text = self.session.note1;
    self.region.lineBreakMode = NSLineBreakByWordWrapping;
    self.regionColor.layer.cornerRadius = self.regionColor.frame.size.height/2;
    self.regionColor.layer.masksToBounds = YES;
    self.regionColor.backgroundColor = self.session.color;

    
    [self setSpeakerAndCompany];
    
    self.allAttendees.transform = CGAffineTransformMakeRotation(M_PI); //rotate it to point other direction
    
}
-(void) setupScrollView {
 
    self.attendeesLabel.text = [@"Attendees (" and [NSString stringWithFormat:@"%lu", (unsigned long)[self.users count] ] ];
    self.attendeesLabel.text = [self.attendeesLabel.text and @")"];
    if ([self.users count] == 0){
        [self.allAttendees removeFromSuperview];
        [self.scrollView removeFromSuperview];
    } else{
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allAttendees:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        singleTapGestureRecognizer.enabled = YES;
        singleTapGestureRecognizer.cancelsTouchesInView = YES;
        [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];

        [self.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
        int i;
        NSArray * users = [self.users allValues];
        int count = [users count];
        if (count > 8) { count = 8; };
        for (i = 0; i < count; i++) {
            NSDictionary * user = [users objectAtIndex:i];
            if (user){
                CGFloat xOrigin = i * 35;
                NSString * avatar = [user objectForKey:@"avatar"];
                CGRect rect = CGRectMake(xOrigin,0,30,30);
                if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""]){
                    UIView * initial = [self setUserInitial:rect withFont:20 withUser:user intoView:self.scrollView withType:@"attendee"];
                    initial.layer.borderColor = [UIColor myLightGray].CGColor;
                    initial.layer.borderWidth = 1;
                    initial.layer.cornerRadius = 15;
                    initial.clipsToBounds = YES;
                    initial.frame = rect;
                    [initial setUserInteractionEnabled:NO];

                }else {
                    if ([[avatar substringToIndex:2]  isEqual: @"//"]){
                        avatar = [@"https:" and avatar];
                    }
                    NSURL * imageURL = [NSURL URLWithString:avatar];
                    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                    UIImage * image = [UIImage imageWithData:imageData];
                    UIImageView * imageContainer = [[UIImageView alloc] initWithImage: image];
                    imageContainer.layer.borderColor = [UIColor myLightGray].CGColor;
                    imageContainer.layer.borderWidth = 1;
                    imageContainer.layer.cornerRadius = 15;
                    imageContainer.clipsToBounds = YES;
                    imageContainer.frame = rect;
                    [self.scrollView addSubview:imageContainer];
                }
            }else {
                break;
            }
            [UIApplication sharedApplication].
            networkActivityIndicatorVisible = NO;
        }
        self.scrollView.contentSize = CGSizeMake(i * 30, 0);
    }
}
- (void)setupNavBar{
    [self setBackButton];
    [self setMultiLineTitle: self.session.title fontColor: [UIColor blackColor]];
}
- (void)setSpeakerAndCompany{
    self.presenterView.layer.cornerRadius = self.presenterView.frame.size.height/2;
    self.presenterView.layer.masksToBounds = YES;
    
    self.companyView.layer.cornerRadius =  self.companyView.frame.size.height/2;
    self.companyView.layer.masksToBounds = YES;
    
    
    CGRect rect = CGRectMake(0, 0, self.presenterView.frame.size.width, self.presenterView.frame.size.height);
    NSDictionary *speakerTemp = [self.session.speakers objectAtIndex:0];
    NSDictionary *speaker = [ApplicationViewController.presentersDict objectForKey:[speakerTemp objectForKey:@"username"]];
    NSString * speakerAvatar = [speaker objectForKey:@"avatar"];
    if ([speakerAvatar isEqual:[NSNull null]] || [speakerAvatar  isEqual: @""]){

        [self setUserInitial:rect withFont:20 withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }else {
        [self setUserImage:rect withAvatar:speakerAvatar withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }
    
    NSDictionary *companyTemp = [self.session.companies objectAtIndex:0];
    NSDictionary *company = [ApplicationViewController.companiesDict objectForKey:[companyTemp objectForKey:@"username"]];
    NSString * companyAvatar = [company objectForKey:@"avatar"];
    if ([companyAvatar isEqual:[NSNull null]] || [companyAvatar  isEqual: @""]){
        [self setUserInitial:rect withFont:20 withUser:company intoView:self.companyView withType:@"company"];
    }else {
        [self setUserImage:rect withAvatar:companyAvatar withUser:company intoView:self.companyView withType:@"company"];
    }
    
    //used in conjunction with linebreaks = 0
    self.presenterName.text = [speaker objectForKey:@"name"];
    self.presenterName.lineBreakMode = NSLineBreakByWordWrapping;
    self.companyName.text = [company objectForKey:@"name"];
    self.companyName.lineBreakMode = NSLineBreakByWordWrapping;
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
    [self goToProfileTable: self.users withTitle:[self.session.title and @" Attendees"] withSession:self.session withType:@"attendee"];
}
@end
