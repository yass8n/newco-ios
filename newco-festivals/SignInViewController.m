//
//  SignInViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "SignInViewController.h"
#import "ScheduleViewController.h"
#import "ScheduleViewController.h"
#import "PageLoader.h"

@interface SignInViewController ()
    @property (weak, nonatomic) IBOutlet UIView *topView;
    @property (weak, nonatomic) IBOutlet UILabel *forgotpasswordField;
    @property (weak, nonatomic) IBOutlet UILabel *wantToAttend;
    - (IBAction)logIn:(id)sender;
    @property (weak, nonatomic) IBOutlet UIView *bottomView;
    @property (weak, nonatomic) IBOutlet UIButton *logIn;
    @property (weak, nonatomic) IBOutlet UITextField *usernameField;
    @property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIView *superView;
    @property (weak, nonatomic) IBOutlet UILabel *registerEventbrite;
@end

@implementation SignInViewController
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

- (void)loginAPIWithUsername:username andPassword:password {
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/auth/login?api_key=%@&username=%@&password=%@", ApplicationViewController.API_URL, ApplicationViewController.API_KEY, username, password ];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSString* response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
             if ([response rangeOfString:@"ERR"].location != NSNotFound){
                 if ([response rangeOfString:@"denied"].location != NSNotFound) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Username or Email does not exist."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Wrong password."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self removePageLoaderFromView:self.superView];

                 });
             } else{
                 [self findByUsername:username withAuthToken:response];
             }
         }else {
             [self showBadConnectionAlert];
         }
     }];
}
- (void)findByUsername:username withAuthToken:(NSString*)auth{
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/user/get?api_key=%@&by=username&term=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", ApplicationViewController.API_URL, ApplicationViewController.API_KEY, username];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError* error;
             NSDictionary *user = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                        error:&error];
             if (!error || [error isEqual:[NSNull null]]){
                 [self processLogin:user withAuthToken:auth];
             }else {
                 [self findByEmail:username withAuthToken:auth];
             }

              dispatch_async(dispatch_get_main_queue(), ^{
                  [self removePageLoaderFromView:self.superView];
              });
         }else {
             [self showBadConnectionAlert];
         }
     }];
}
- (void)findByEmail:email withAuthToken:(NSString*)auth{
    NSString* fullURL = [NSString stringWithFormat:@"%@/api/user/get?api_key=%@&by=email&term=%@&format=json&fields=username,name,email,twitter_uid,fb_uid,position,location,company,sessions,url,about,privacy_mode,role,phone,avatar,id", ApplicationViewController.API_URL, ApplicationViewController.API_KEY, email];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError* error;
             NSDictionary *user = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:&error];
             if (!error || [error isEqual:[NSNull null]]){
                 [self processLogin:user withAuthToken:auth];
             }else {
                 [self showBadConnectionAlert];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self removePageLoaderFromView:self.superView];
             });
             
         }else {
             [self showBadConnectionAlert];
         }
     }];
}
-(void) processLogin:(NSDictionary*)user withAuthToken:(NSString*)auth{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    NSMutableDictionary* mutableUser = [user mutableCopy];
    [mutableUser setObject:auth forKey:@"auth"];
    user = [mutableUser copy];
    [prefs setObject:user forKey:@"user"];
    ApplicationViewController.currentUser = [[NSDictionary alloc]init];
    ApplicationViewController.currentUser = user;
    [self removePageLoaderFromView:self.superView];
    [self goBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    self.passwordField.secureTextEntry = YES;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    ApplicationViewController.currentVC = enumSignin;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustUI{

    
    [ApplicationViewController setBorder:self.usernameField width:1.0 radius:5 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.passwordField width:1.0 radius:5 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.bottomView width:1.0 radius:8 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.topView width:1.0 radius:5 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.logIn width:1.0 radius:5 color:[UIColor blackColor]];
    [super setBackButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)logIn:(id)sender {
    NSString* username = [self.usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* password = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.view endEditing:YES];
    if ([username isEqual:@""] || [password isEqual:@""]){
        NSString* isEmpty = @"Password";
        if ([username isEqual:@""]){
            isEmpty = @"Username";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                        message:[NSString stringWithFormat:@"Can't leave %@ blank.", isEmpty]
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
        [alert show];
    }else {
        [self showPageLoaderInView:self.superView];
        dispatch_queue_t que = dispatch_queue_create("login", NULL);
        dispatch_async(que, ^{[self loginAPIWithUsername:username andPassword:password];});
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[self.usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self.usernameField becomeFirstResponder];
    }else {
        [self.passwordField becomeFirstResponder];
    }
}

//code for keyboard and views adjusting when focused on text view
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
