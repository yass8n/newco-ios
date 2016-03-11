//
//  SignUpViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/11/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
- (IBAction)whySignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *whySignUp;
- (IBAction)signUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *registerEvent;
@property (weak, nonatomic) IBOutlet CustomUIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *wantToAttend;

@end

@implementation SignUpViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    NSString* username = [self.usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* password = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* email = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.view endEditing:YES];
    if ([username isEqual:@""] || [password isEqual:@""] || [email isEqual:@""]){
        NSString* isEmpty = @"Password";
        if ([username isEqual:@""]){
            isEmpty = @"Username";
        }else if ([email isEqualToString:@""]){
            isEmpty = @"Email";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"Can't leave %@ blank.", isEmpty]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        WebService * webService = [[WebService alloc] initWithView:self.view];
        [webService loginAPIWithUsername:username andPassword:password callback:^(NSString *response) {
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
            } else{
                [webService findByUsername:username withAuthToken:response callback:^(NSDictionary* user) {
                    if (user) {
                        [self processLogin:user withAuthToken:response];
                    }else{
                        [webService findByEmail:username withAuthToken:response callback:^(NSDictionary* user) {
                            {
                                if (user) {
                                    [self processLogin:user withAuthToken:response];
                                }else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self showBadConnectionAlert];
                                    });
                                }
                            }
                            
                        }];
                    }
                }];
            }
        }];
    }

}
- (IBAction)whySignUp:(id)sender {
}


-(void) processLogin:(NSDictionary*)user withAuthToken:(NSString*)auth{
    NSMutableDictionary* mutableUser = [user mutableCopy];
    [mutableUser setObject:auth forKey:@"auth"];
    user = [mutableUser copy];
    [Credentials sharedCredentials].currentUser = user;
    //code executed in background
    [ApplicationViewController fetchCurrentUserSessions: self.view];
    ApplicationViewController.rightNav = nil;
    //code to be executed on main thread when block is finished
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate && [self.delegate respondsToSelector: @selector(goBack)]) {
            [self.delegate goBack];
        }else{
            [self goBack];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    self.passwordField.secureTextEntry = YES;
    self.topView.highlightedColor = [UIColor myLightGray];
    self.topView.unHighlightedColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(registerViewTapped:)];
    tap.delaysTouchesBegan = NO;
    tap.delaysTouchesEnded = NO;
    [self.topView addGestureRecognizer:tap];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text = @"Sign Up for Newco";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titleLabel;
    [self setBackButton];
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.usernameField.delegate = self;
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
}


- (void)adjustUI{
    
    
    [Helper setBorder:self.usernameField width:1.0 radius:5 color:[UIColor myLightGray]];
    [Helper setBorder:self.passwordField width:1.0 radius:5 color:[UIColor myLightGray]];
        [Helper setBorder:self.emailField width:1.0 radius:5 color:[UIColor myLightGray]];
    [Helper setBorder:self.bottomView width:1.0 radius:8 color:[UIColor myLightGray]];
    [Helper setBorder:self.topView width:1.0 radius:5 color:[UIColor myLightGray]];
    [Helper setBorder:self.signUp width:1.0 radius:5 color:[UIColor blackColor]];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[self.usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self.usernameField becomeFirstResponder];
    }else if ([[self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self.passwordField becomeFirstResponder];
    }else if ([[self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self.emailField becomeFirstResponder];
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
//an event handling method
- (void)registerViewTapped:(UITapGestureRecognizer *)recognizer {
        [self showWebViewWithUrl:[NSString stringWithFormat:@"%@/tickets", [[Credentials sharedCredentials].festival objectForKey:@"url"]]];
    
    //   [self showWebViewWithUrl:[NSString stringWithFormat:@"http://festivals.newco.co/%@/tickets", [[Credentials sharedCredentials].festival objectForKey:@"name"]]];
}

@end
