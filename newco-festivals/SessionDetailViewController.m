//
//  SessionDetailViewController.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SignInViewController.h"
#import "UserInitial.h"
#import "UserImage.h"
#import "CustomUIView.h"
#import "Helper.h"
#import "NSString+NSStringAdditions.h"
#import "ConfirmationModalView.h"
#import "TTTAttributedLabel.h"
#import "CustomUILabel.h"
#import "ModalView.h"


@interface SessionDetailViewController ()
#import "constants.h"
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (strong, readwrite, nonatomic) NSLayoutConstraint *statusContainerConstraint;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *statusContainer;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet CustomUILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *presenterName;
@property (weak, nonatomic) IBOutlet UIView *presenterView;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UIView *regionColor;
@property (weak, nonatomic) IBOutlet CustomUIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIButton *allAttendees;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UILabel *desc;

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
    // Do any additional setup after loading the view.
}
-(void)getAttendees:(UIView*)loaderInView{
    
    WebService * webService;
    if (loaderInView != nil){
       webService = [[WebService alloc] initWithView:loaderInView];
    }else{
        webService = [[WebService alloc] init];
    }
    [webService setAttendeesForSession:self.session.id_ callback:^(NSArray *jsonArray) {
        self.users = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [jsonArray count]; i++){
            NSDictionary * user = [[FestivalData sharedFestivalData].attendeesDict objectForKey:[[jsonArray objectAtIndex:i] objectForKey:@"username"]];
            if (user && ![user isEqual:[NSNull null]]){
                [self.users setObject:user forKey:[user objectForKey:@"username"]];
            }
        }
        NSDictionary* user = [Credentials sharedCredentials].currentUser;
        if ([[user objectForKey:@"privacy_mode"] isEqualToString:@"Y"]
            || [[user objectForKey:@"privacy_mode"] isEqualToString:@"1"]){
            [self.users removeObjectForKey:[user objectForKey:@"username"]];
        }else if (self.session.picked){
            [self.users setObject:user forKey:[user objectForKey:@"username"]];
        }else if([user objectForKey:@"username"]) {
            [self.users removeObjectForKey:[user objectForKey:@"username"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupScrollView];
        });
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.session.color;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //[self.superView removeConstraint:self.statusContainerConstraint];
    //self.statusContainer.translatesAutoresizingMaskIntoConstraints = YES;

    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count] > 0){
        [self.loginButton setHidden:YES];
        [self.checkMarkView setHidden:NO];
        [self.addToScheduleButton setHidden:NO];
        //self.statusContainer.frame = CGRectMake(self.checkMarkView.frame.origin.x, self.loginButton.frame.origin.y, self.statusContainer.frame.size.width, self.statusContainer.frame.size.height);
        //self.statusContainerConstraint = [self alignLeftToCheckMark];
        //[self.superView addConstraint:self.statusContainerConstraint];
        if (self.session.picked){
            [self setSessionPickedUI:YES];
        }else{
            [self setSessionPickedUI:NO];
        }
    } else {
        [self.loginButton setHidden:NO];
        [self.checkMarkView setHidden:YES];
        [self.addToScheduleButton setHidden:YES];
        //self.statusContainerConstraint = [self alignCenterToLogin];
        //[self.superView addConstraint:self.statusContainerConstraint];
    }
    WebService * webservice = [[WebService alloc]init];
    NSString* userId = [[Credentials sharedCredentials].currentUser count] > 0 ? [[Credentials sharedCredentials].currentUser objectForKey:@"id"] : @"0";
    [webservice registerViewedSession:self.session.title userId:userId];
    [self getAttendees:self.view];
    
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
                              constant:0];
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
    [self.loginButton setTitle:@" Login to Attend " forState:UIControlStateNormal]; // To set the title
    
    [Helper setBorder:self.loginButton width:1.0 radius:1 color:[UIColor grayColor]];
    [Helper setBorder:self.statusContainer width:1.0 radius:3 color:[UIColor blackColor]];
    
    self.region.text = self.session.note1;
    self.region.lineBreakMode = NSLineBreakByWordWrapping;
    self.regionColor.layer.cornerRadius = self.regionColor.frame.size.height/2;
    self.regionColor.layer.masksToBounds = YES;
    self.regionColor.backgroundColor = self.session.color;
    
    
    [self setSpeakerAndCompany];
    
    self.allAttendees.transform = CGAffineTransformMakeRotation(M_PI); //rotate it to point other direction
    
    self.address.userInteractionEnabled = YES;
    UIColor* currentAddressColor = self.address.textColor;
    self.address.highlightTextColor = [UIColor lightGrayColor];
    self.address.unHighlightTextColor = currentAddressColor;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddressTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = YES;
    [self.address addGestureRecognizer:singleTapGestureRecognizer];
    
}

-(void) setupScrollView {
    
    self.attendeesLabel.text = [@"Attendees (" and [NSString stringWithFormat:@"%lu", (unsigned long)[self.users count] ] ];
    self.attendeesLabel.text = [self.attendeesLabel.text and @")"];
    if ([self.users count] == 0){
        [self.allAttendees removeFromSuperview];
        self.scrollViewHeight.constant = 0;
    } else{
        CompletionBlock block = ^{
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
            [[self.scrollView subviews]
             makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSUInteger count = [users count];
            if (count > 24) { count = 24; };
            for (i = 0; i < count; i++) {
                NSDictionary * user = [users objectAtIndex:i];
                if (user){
                    CGFloat xOrigin = i * 35;
                    NSString * avatar = [user objectForKey:@"avatar"];
                    CGRect rect = CGRectMake(xOrigin,0,30,30);
                    if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""]){
                        UIView * initial = [self setUserInitial:rect withFont:rect.size.width/2 withUser:user intoView:self.scrollView withType:@"attendee"];
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
                        UIImageView * imageContainer = [[UIImageView alloc] init];
                        [self setUserImage:rect withAvatar:avatar withUser:user intoView:imageContainer withType:@"attendee"];
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
            
        };
        if (self.scrollViewHeight.constant == 0){
            [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.scrollViewHeight.constant = 50;
            }completion:^(BOOL finished) {
                block();
            }];
        }else{
            block();
        }
        
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
    self.companyView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.companyView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.companyView];

    
    
    CGRect presenterRect = CGRectMake(0, 0, self.presenterView.frame.size.width, self.presenterView.frame.size.height);
    CGRect companyRect = CGRectMake(0, 0, self.companyView.frame.size.width, self.companyView.frame.size.height);
    NSDictionary *speakerTemp = [self.session.speakers objectAtIndex:0];
    NSDictionary *speaker = [[FestivalData sharedFestivalData].presentersDict objectForKey:[speakerTemp objectForKey:@"username"]];
    NSString * speakerAvatar = [speaker objectForKey:@"avatar"];
    if ([speakerAvatar isEqual:[NSNull null]] || [speakerAvatar  isEqual: @""] || speakerAvatar == nil){
        
        [self setUserInitial:presenterRect withFont:presenterRect.size.width/2 withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }else {
        [self setUserImage:presenterRect withAvatar:speakerAvatar withUser:speaker intoView:self.presenterView withType:@"speaker"];
    }
    
    NSDictionary *companyTemp = [self.session.companies objectAtIndex:0];
    NSDictionary *company = [[FestivalData sharedFestivalData].companiesDict objectForKey:[companyTemp objectForKey:@"username"]];
    NSString * companyAvatar = [company objectForKey:@"avatar"];
    if ([companyAvatar isEqual:[NSNull null]] || [companyAvatar  isEqual: @""] || companyAvatar == nil){
        if (company == nil){
            company = @{@"name" : self.session.title};
        }
        [self setUserInitial:companyRect withFont:companyRect.size.width/2 withUser:company intoView:self.companyView withType:@"company"];
    }else {
        [self setUserImage:companyRect withAvatar:companyAvatar withUser:company intoView:self.companyView withType:@"company"];
        self.companyView.layer.borderColor = self.session.color.CGColor;
        self.companyView.layer.cornerRadius = self.companyView.frame.size.width/2;
        self.companyView.layer.borderWidth = 1;
    }
    
    //used in conjunction with linebreaks = 0
    self.presenterName.text = [speaker objectForKey:@"name"];
    self.presenterName.lineBreakMode = NSLineBreakByWordWrapping;
//    self.companyName.text = [company objectForKey:@"name"];
//    self.companyName.lineBreakMode = NSLineBreakByWordWrapping;
    self.bottomContainer.backgroundColor = [UIColor whiteColor];
    self.bottomContainer.layer.cornerRadius = 4;
    self.bottomContainer.layer.borderWidth = 1;
    self.bottomContainer.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.addToScheduleButton.backgroundColor = [UIColor whiteColor];
    self.addToScheduleButton.layer.cornerRadius = 2.0;
    self.addToScheduleButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    
    self.checkMarkView.layer.cornerRadius = self.checkMarkView.frame.size.width/2;
    self.addToScheduleButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.addToScheduleButton.layer.borderWidth = 1;

    
    self.loginButton.backgroundColor = [UIColor whiteColor];
    self.loginButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.loginButton.layer.cornerRadius = 2.0;
    
    self.shareButton.backgroundColor = [UIColor whiteColor];
    self.shareButton.layer.cornerRadius = 2.0;
    self.shareButton.layer.borderWidth = 1.0;
    self.shareButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    
    self.dateView.backgroundColor =[UIColor whiteColor];
    self.addressView.backgroundColor = [UIColor whiteColor];
    self.addressView.passTouchesToSubViews = YES;
    self.superView.backgroundColor = [Helper getUIColorObjectFromHexString:@"ece4e1" alpha:1.0];
    if ([[[Credentials sharedCredentials].festival objectForKey:@"share"]boolValue]){
        UIButton *share =  [UIButton buttonWithType:UIButtonTypeCustom];
        [share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(showSocialShareDialog) forControlEvents:UIControlEventTouchUpInside];
        [share setFrame:CGRectMake(0, 0, 25, 25)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:share];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
  
    
    self.desc.text = [self.session.desc stringByStrippingHTML];
    self.desc.lineBreakMode = NSLineBreakByWordWrapping;
    self.desc.numberOfLines = 0;

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
- (IBAction)shareButtonClicked:(id)sender {
    [self goToProfileTable: self.users withTitle:self.session.title withSession:self.session withType:@"attendee"];
}
- (IBAction)addToSchedule:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    [Helper buttonTappedAnimation:resultButton];
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self getAttendees:nil];
                    });
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
            Session * conflictingSession = [[FestivalData sharedFestivalData] getConflictingSession:self.session];
            CGRect modalFrame = CGRectMake(30, 150, self.view.frame.size.width - 60, 160);
            
            NSString *modalTitle = @"You have a time conflict with ";
            
            UIColor *modalTitleColor =  [Helper getUIColorObjectFromHexString:@"#34495e" alpha:1.0];
            UIFont *proximaBold = [UIFont fontWithName: @"ProximaNova-Bold" size: 18];
            NSDictionary *boldDict = [NSDictionary dictionaryWithObject:proximaBold forKey:NSFontAttributeName];
            UIFont *proximaSemi = [UIFont fontWithName: @"ProximaNova-Semibold" size: 18];
            NSDictionary *regular = [NSDictionary dictionaryWithObject: proximaSemi forKey:NSFontAttributeName];
            NSMutableAttributedString *regularString = [[NSMutableAttributedString alloc] initWithString:modalTitle attributes: regular];
            [regularString addAttribute:NSForegroundColorAttributeName value:modalTitleColor range:(NSMakeRange(0, [regularString length]))];
            NSString * sessionName = conflictingSession.title;
            
            NSMutableAttributedString *boldString = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@", [sessionName capitalizedString]] attributes:boldDict];
            [boldString addAttribute:NSForegroundColorAttributeName value:modalTitleColor range:(NSMakeRange(0, [boldString length]))];

            [regularString appendAttributedString:boldString];

            
            NSMutableAttributedString *addition = [[NSMutableAttributedString alloc] initWithString:@". Would you like to swap?" attributes: regular];
             [addition addAttribute:NSForegroundColorAttributeName value:modalTitleColor range:(NSMakeRange(0, [addition length]))];
            [regularString appendAttributedString:addition];

            ConfirmationModalView* modalView =  [[ConfirmationModalView alloc] initWithFrame:modalFrame title:regularString yesText:@"Swap" noText:@"Cancel" imageColor:self.session.color conflictingSession:conflictingSession];
            modalView.confirmationModalDelegate = self;
            UIView * topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
            [topView.window addSubview:modalView];
            modalView.baseModalDelegate = self;
            [modalView showModalAtTop:YES];
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
                    [self showNeedTicketModal];
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self getAttendees:nil];
                        });
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
-(void)linkTapped:(TTTAttributedLabel*)label modal:(ConfirmationModalView*)modal{
    [modal hideModal];
    Session * conflictingSession = [[FestivalData sharedFestivalData] getConflictingSession:self.session];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
    [vc setSession:conflictingSession];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)yesButtonClicked:(ConfirmationModalView*)modal{
    if ([modal.modalType isEqualToString:@"ticket"]){
        [super yesButtonClicked:modal];
        return;
    }
    Session * conflictingSession = [[FestivalData sharedFestivalData] getConflictingSession:self.session];
    
    [[modal.modalImageContainer subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIView * v = [[UIView alloc]initWithFrame:modal.modalImageContainer.bounds];
    v.backgroundColor = [UIColor whiteColor];
    [v addSubview:activityView];
    activityView.center=v.center;
    [activityView startAnimating];
    [modal.modalImageContainer addSubview:v];
//    if (self.session.goers >= self.session.seats){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [modal hideModal];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                NSString* message = @"Sorry, the session you tried to add is already full.";
//                            if ([[[Credentials sharedCredentials].festival objectForKey:@"name"] isEqualToString:@"utopia"]){
//                                message = @"Sorry, this session is not ready. Please try again later.";
//                            }
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swap failed"
//                                                                message:message
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//            });
//        });
//        return;
//    }
        WebService * webService = [[WebService alloc] init];
        [webService removeSessionFromSchedule:conflictingSession.id_ callback:^(NSString *response) {
            UIAlertView *alert;
            if ([response rangeOfString:@"ERR"].location != NSNotFound){
                alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"Failed to swap because event doesn't exist."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
                
            }else if ([response rangeOfString:@"Removed event"].location != NSNotFound){
                [[FestivalData sharedFestivalData] updateSessionsValidity:[[NSArray alloc] initWithObjects:conflictingSession.event_key, nil] invalidateSessions:NO];
                [webService addSessionToSchedule:self.session.id_ callback:^(NSString *response) {
                    UIAlertView *alert;
                    if ([response rangeOfString:@"expired"].location != NSNotFound){
                        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Sorry, this event is already expired."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
                    } else if ([response rangeOfString:@"noticket"].location != NSNotFound){
                        [self showNeedTicketModal];
                        
                    } else if ([response rangeOfString:@"ERR"].location != NSNotFound){
                        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Event doesn't exist."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
                        
                        
                        
                    }else if ([response rangeOfString:@"Adding event"].location != NSNotFound){
                        [[FestivalData sharedFestivalData].currentUserSessions setObject:@"YES" forKey:self.session.event_key];
                        [[FestivalData sharedFestivalData] updateSessionsValidity:[[NSArray alloc] initWithObjects:self.session.event_key, nil] invalidateSessions:YES];
                        UIView * v = [[UIView alloc]initWithFrame:modal.modalImageContainer.bounds];
                        v.backgroundColor = [UIColor whiteColor];
                        
                       UIImageView *modalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
                        modalImageView.center = v.center;
                        modalImageView.image = [[UIImage imageNamed:@"check_plain"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        [modalImageView setTintColor:self.session.color];
                        modalImageView.layer.cornerRadius = modalImageView.frame.size.width/2;
                        modalImageView.layer.masksToBounds = YES;
                        
                        [v addSubview:modalImageView];
                        [modal.modalImageContainer addSubview:v];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [modal hideModal];
                            [self setSessionPickedUI:YES];
                            [self getAttendees:nil];
                        });
                 
                    } else {
                        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Something went wrong."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
                        
                    }
                }];
                
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
- (void)noButtonClicked:(ConfirmationModalView*)modal{
    [modal hideModal];
}
#pragma Mark-social sharing
-(void) showSocialShareDialog{
    CGRect modalFrame = CGRectMake(10, 100, self.view.frame.size.width - 20, 160);
    NSString *modalTitle = @"Let others know about this session";

    ShareModalView *modalView = [[ShareModalView alloc] initWithFrame:modalFrame title:modalTitle oneLineTitle:YES sharedBy:sharedByChoice];
    [self.view.window addSubview:modalView];
    modalView.shareModalDelegate = self;
    modalView.baseModalDelegate = self;
    modalView.session = self.session;
    [modalView showModalAtTop:YES];
}
#pragma Mark-gesture recognizer delegate
- (IBAction)handleAddressTap:(id)sender {
    CGRect modalFrame = CGRectMake(10, 100, self.view.frame.size.width - 20, 140);
    ShareModalView *modalView = [[ShareModalView alloc]initMapShareWithFrame:modalFrame];
    [self.view.window addSubview:modalView];
    modalView.shareModalDelegate = self;
    modalView.baseModalDelegate = self;
    modalView.session = self.session;
    [modalView showModalAtTop:YES];
}

#pragma Mark-Map Share
-(void)mapModalGone:(shareEnum)result session:(Session *)session {
    double window_width = self.view.frame.size.width;
    double window_height = self.view.frame.size.height;
    if (session){
        CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
        if (result == copy){
            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@", session.address];
            ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [modalView showSuccessModal:@"Address Copied!" onWindow:self.view.window];
            });
        }else {
            if (result == map){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSString* address = session.address;
                    NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@",
                                     [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
                });
            }else if (result == mail){
                NSString *emailTitle = @"";
                // Email Content
                NSString *messageBody = session.address;
                // To address
                NSArray *toRecipents = [[NSArray alloc]init];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];
            }
        }
    }
}
#pragma Mark-Mail composer delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    double window_width = self.view.frame.size.width;
    double window_height = self.view.frame.size.height;
    
    if (result == MFMailComposeResultCancelled){
        
    }else if (result == MFMailComposeResultFailed){
        NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        UIAlertView * alert =  [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                    message:@"Something went wrong."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [alert show];
    }else if (result == MFMailComposeResultSaved){
        
    }else if (result == MFMailComposeResultSent){
        CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
        ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [modalView showSuccessModal:@"Mail sent!" onWindow:self.view.window];
        });
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
