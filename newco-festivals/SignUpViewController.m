//
//  SignUpViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/11/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "SignUpViewController.h"
#import "SWRevealViewController.h"
#import "EditProfileViewController.h"
#import "NSString+NSStringAdditions.h"
#import "RootViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *usernameSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *passwordSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *emailSpinner;

@property (weak, nonatomic) IBOutlet UIImageView *emailSuccessView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameSuccessView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordSuccessView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordErrorView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameErrorView;
@property (weak, nonatomic) IBOutlet UIImageView *emailErrorView;
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
    [self setBorders];
    NSString* username = [self.usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* password = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* email = [self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
        [webService signUpAPIWithUsername:username andPassword:password andEmail:email callback:^(NSString *response) {
            if ([response rangeOfString:@"ERR"].location != NSNotFound){
                
                response = [response stringByReplacingOccurrencesOfString:@"ERR: " withString:@""];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:response
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                if ([[response lowercaseString] rangeOfString:@"email"].location != NSNotFound){
                    [self setErrorView:self.emailField];
                }else if([[response lowercaseString] rangeOfString:@"username"].location != NSNotFound){
                    [self setErrorView:self.usernameField];
                    
                }else if([[response lowercaseString] rangeOfString:@"password"].location != NSNotFound){
                    [self setErrorView:self.passwordField];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EditProfile"];
        vc.dontSetBackButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
    UIImage *checkImage = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailSuccessView setImage:checkImage];
    self.emailSuccessView.tintColor = [UIColor greenColor];
    
    UIImage *exImage = [[UIImage imageNamed:@"delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailErrorView setImage:exImage];
    self.emailErrorView.tintColor = [UIColor redColor];
    
    [self.usernameSuccessView setImage:checkImage];
    self.usernameSuccessView.tintColor = [UIColor greenColor];
    
    [self.usernameErrorView setImage:exImage];
    self.usernameErrorView.tintColor = [UIColor redColor];
    
    [self.passwordSuccessView setImage:checkImage];
    self.passwordSuccessView.tintColor = [UIColor greenColor];
    
    [self.passwordErrorView setImage:exImage];
    self.passwordErrorView.tintColor = [UIColor redColor];
    
    [self.usernameSpinner startAnimating];
    [self.emailSpinner startAnimating];
    self.usernameSuccessView.hidden = YES;
    self.usernameErrorView.hidden = YES;
    self.usernameSpinner.hidden = YES;
    self.passwordSuccessView.hidden = YES;
    self.passwordErrorView.hidden = YES;
    self.passwordSpinner.hidden = YES;
    self.emailSuccessView.hidden = YES;
    self.emailErrorView.hidden = YES;
    self.emailSpinner.hidden = YES;
    
    [self.usernameField addTarget:self action:@selector(nameDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.emailField addTarget:self action:@selector(emailDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(passwordDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SWRevealViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SWReveal"];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"COMPLETED");
    }];
}

-(void)setBorders{
    [Helper setBorder:self.usernameField width:1.0 radius:5 color:[UIColor myLightGray]];
    [Helper setBorder:self.passwordField width:1.0 radius:5 color:[UIColor myLightGray]];
    [Helper setBorder:self.emailField width:1.0 radius:5 color:[UIColor myLightGray]];
}
- (void)adjustUI{
    
    [self setBorders];
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
        [self setErrorView:self.usernameField];
    }else if ([[self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self setErrorView:self.passwordField];
    }else if ([[self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqual: @""]){
        [self setErrorView:self.emailField];
    }
}

-(void)passwordDidChange :(UITextField *)theTextField{
    if (theTextField.text.length == 0){
        self.passwordSuccessView.hidden = YES;
        self.passwordErrorView.hidden = NO;
    }else{
        self.passwordSuccessView.hidden = NO;
        self.passwordErrorView.hidden = YES;
    }
}
-(void)nameDidChange :(UITextField *)theTextField{
    self.usernameSuccessView.hidden = YES;
    self.usernameErrorView.hidden = YES;
    if (theTextField.text.length == 0){
        self.usernameSpinner.hidden = YES;
        return;
    }
    self.usernameSpinner.hidden = NO;
    WebService * webservice = [[WebService alloc]init];
    [webservice findByUsername:self.usernameField.text withAuthToken:nil callback:^(NSDictionary *user) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.usernameSpinner.hidden = YES;
            if (user == nil){
                self.usernameSuccessView.hidden = NO;
                self.usernameErrorView.hidden = YES;
            }else{
                self.usernameSuccessView.hidden = YES;
                self.usernameErrorView.hidden = NO;
            }
        });
        
    }];
}
-(void)emailDidChange :(UITextField *)theTextField{
    self.emailSuccessView.hidden = YES;
    self.emailErrorView.hidden = YES;
    if (theTextField.text.length == 0){
        self.emailSpinner.hidden = YES;
        return;
    }else if (![theTextField.text isValidEmail]){
        self.emailSuccessView.hidden = YES;
        self.emailErrorView.hidden = NO;
        self.emailSpinner.hidden = YES;
        return;
    }
    self.emailSpinner.hidden = NO;
    WebService * webservice = [[WebService alloc]init];
    [webservice findByEmail:self.emailField.text withAuthToken:nil callback:^(NSDictionary *user) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.emailSpinner.hidden = YES;
            
            if (user == nil){
                self.emailSuccessView.hidden = NO;
                self.emailErrorView.hidden = YES;
            }else{
                self.emailSuccessView.hidden = YES;
                self.emailErrorView.hidden = NO;
            }
        });
        
    }];}
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
    //        [self showWebViewWithUrl:[NSString stringWithFormat:@"%@/tickets", [[Credentials sharedCredentials].festival objectForKey:@"url"]]];
    
    [self showWebViewWithUrl:[NSString stringWithFormat:@"http://festivals.newco.co/%@/tickets", [[Credentials sharedCredentials].festival objectForKey:@"name"]]];
}

@end
