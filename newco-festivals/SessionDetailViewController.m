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
#import "UserImage.h"
#import "CustomUIView.h"
#import "PageLoader.h"
#import "Helper.h"


@interface SessionDetailViewController ()
#import "constants.h"
@property (strong, readwrite, nonatomic) NSLayoutConstraint *statusContainerConstraint;
@property (weak, nonatomic) IBOutlet UILabel *status;
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
@property (weak, nonatomic) IBOutlet UIButton *addToScheduleButton;
@property (weak, nonatomic) IBOutlet UILabel *attendeesLabel;
- (IBAction)callSignIn:(id)sender;
- (IBAction)allAttendees:(id)sender;
@property (weak, nonatomic) IBOutlet CustomUIView *checkMarkView;
@property (strong, nonatomic) IBOutlet UIView *superView;
- (IBAction)addToSchedule:(id)sender;
@end

@implementation SessionDetailViewController

static NSString* UN_ATTEND = @" Remove ";
static NSString* ATTEND = @" Attend ";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    WebService * webService = [[WebService alloc] initWithView:self.view];
    [webService setAttendeesForSession:self.session.id_ callback:^(NSArray *jsonArray) {
        self.users = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [jsonArray count]; i++){
            NSDictionary * user = [[FestivalData sharedFestivalData].attendeesDict objectForKey:[[jsonArray objectAtIndex:i] objectForKey:@"username"]];
            if (user && ![user isEqual:[NSNull null]]){
                [self.users setObject:user forKey:[user objectForKey:@"username"]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupScrollView];
        });
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.session.color;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    ApplicationViewController.currentVC = enumSessionDetail;
    [self.superView removeConstraint:self.statusContainerConstraint];
    if ([[Credentials sharedCredentials].currentUser count] > 0){
        [self.loginButton setHidden:YES];
        [self.checkMarkView setHidden:NO];
        [self.addToScheduleButton setHidden:NO];
        self.statusContainerConstraint = [self alignLeftToCheckMark];
        [self.superView addConstraint:self.statusContainerConstraint];
        if (self.session.picked){
            [self setSessionPickedUI:YES];
        }
    } else {
        [self.loginButton setHidden:NO];
        [self.checkMarkView setHidden:YES];
        [self.addToScheduleButton setHidden:YES];
        self.statusContainerConstraint = [self alignCenterToLogin];
        [self.superView addConstraint:self.statusContainerConstraint];
    }
    
}
- (void)setSessionPickedUI:(BOOL) attending{
    if (attending){
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:self.checkMarkView.bounds];
        imgView.image = [UIImage imageNamed:@"check.png"];
        [self.addToScheduleButton setTitle:UN_ATTEND forState:UIControlStateNormal];
        [self.checkMarkView addSubview:imgView];
    }else{
        [self.addToScheduleButton setTitle:ATTEND forState:UIControlStateNormal];
        NSArray * subviews = self.checkMarkView.subviews;
        for (UIView* subview in subviews){
            [subview removeFromSuperview];
        }
    }
}
-(NSLayoutConstraint*)alignCenterToLogin{
    NSLayoutConstraint * c = [NSLayoutConstraint
                              constraintWithItem:self.statusContainer
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.loginButton
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0];
    c.priority = 1000;
    return c;
}
-(NSLayoutConstraint*)alignLeftToCheckMark{
    NSLayoutConstraint * c = [NSLayoutConstraint
                              constraintWithItem:self.statusContainer
                              attribute:NSLayoutAttributeLeftMargin
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.checkMarkView
                              attribute:NSLayoutAttributeLeftMargin
                              multiplier:1
                              constant:24];
    c.priority = 1000;
    return c;
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
    
    [Helper setBorder:self.loginButton width:1.0 radius:1 color:[UIColor grayColor]];
    [Helper setBorder:self.statusContainer width:1.0 radius:3 color:[UIColor blackColor]];
    
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
        NSUInteger count = [users count];
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
    NSDictionary *speaker = [[FestivalData sharedFestivalData].presentersDict objectForKey:[speakerTemp objectForKey:@"username"]];
    NSString * speakerAvatar = [speaker objectForKey:@"avatar"];
    if ([speakerAvatar isEqual:[NSNull null]] || [speakerAvatar  isEqual: @""]){
        
        [self setUserInitial:rect withFont:20 withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }else {
        [self setUserImage:rect withAvatar:speakerAvatar withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }
    
    NSDictionary *companyTemp = [self.session.companies objectAtIndex:0];
    NSDictionary *company = [[FestivalData sharedFestivalData].companiesDict objectForKey:[companyTemp objectForKey:@"username"]];
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
    [self goToProfileTable: self.users withTitle:self.session.title withSession:self.session withType:@"attendee"];
}

- (IBAction)addToSchedule:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    if ([resultButton.currentTitle isEqual:UN_ATTEND]){
        WebService * webService = [[WebService alloc] initWithView:self.view];
        [webService removeSessionFromSchedule:self.session.id_ callback:^(NSString *response) {
            UIAlertView *alert;
            if ([response rangeOfString:@"ERR"].location != NSNotFound){
                alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"Failed to remove because event doesn't exist."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
                
            }else if ([response rangeOfString:@"Removed event"].location != NSNotFound){
                [[FestivalData sharedFestivalData] updateSessionsValidity:[[NSArray alloc] initWithObjects:self.session.event_key, nil] invalidateSessions:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setSessionPickedUI:NO];
                });
                
            } else {
                alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"Something went wrong."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            }
            if (alert){
                [alert show];
            }
            
        }];
            }else{
        if (!self.session.enabled){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You are already attending a session at this time."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            WebService * webService = [[WebService alloc] initWithView:self.view];
            [webService addSessionToSchedule:self.session.id_ callback:^(NSString *response) {
                UIAlertView *alert;
                if ([response rangeOfString:@"expired"].location != NSNotFound){
                    alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                       message:@"Sorry, this event is already expired."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                } else if ([response rangeOfString:@"noticket"].location != NSNotFound){
                    alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                       message:@"You need to purchase a ticket before attending a session."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                    
                    
                } else if ([response rangeOfString:@"ERR"].location != NSNotFound){
                    alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                       message:@"Event doesn't exist."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                    
                    
                    
                }else if ([response rangeOfString:@"Adding event"].location != NSNotFound){
                    [[FestivalData sharedFestivalData].currentUserSessions setObject:@"YES" forKey:self.session.event_key];
                    [[FestivalData sharedFestivalData] updateSessionsValidity:[[NSArray alloc] initWithObjects:self.session.event_key, nil] invalidateSessions:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setSessionPickedUI:YES];
                    });
                } else {
                    alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                       message:@"Something went wrong."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                    
                }
                if (alert){
                    [alert show];
                }
                
            }];
        }
    }
}

@end
