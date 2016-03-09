//
//  EditProfileViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 2/28/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomUILabel.h"
@interface EditProfileViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet CustomUILabel *showMoreOrLess;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet CustomUILabel *changePassword;
@property (strong, nonatomic) IBOutlet UIButton * changePasswordButton;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;
@property (strong, nonatomic) IBOutlet UISwitch *privacySwitch;
@property (strong, nonatomic) IBOutlet UILabel *privacyExplanation;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *companyNameField;
@property (strong, nonatomic) IBOutlet UILabel *websiteLabel;
@property (strong, nonatomic) IBOutlet UITextField *websiteField;
@property (strong, nonatomic) IBOutlet UILabel *companyPositionLabel;
@property (strong, nonatomic) IBOutlet UITextField *companyPositionField;
@property (strong, nonatomic) IBOutlet CustomUIView *profileView;
@property (strong, nonatomic) IBOutlet CustomUILabel *removePhotoLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *togglableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL showingMoreSettings;
@property (nonatomic) CGRect usernameLabelFrame;
@property (nonatomic) CGRect usernameFieldFrame;
@property (nonatomic) CGRect passwordLabelFrame;
@property (nonatomic) CGRect passwordFieldFrame;
@property (nonatomic) CGRect privacyLabelFrame;
@property (nonatomic) CGRect changePasswordFrame;
@property (nonatomic) CGRect privacySwitchFrame;
@property (nonatomic) CGRect privacyExplanationFrame;
@property (nonatomic) CGRect changePasswordButtonFrame;

@end

@implementation EditProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    self.showingMoreSettings = NO;
}
- (void)viewDidLayoutSubviews{
    UIGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    dismiss.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:dismiss];
    UIView *paddingView;
    int textFieldHeight = 30;
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    int X = 8;
    int Y = self.navigationController.navigationBar.frame.size.height;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y+textFieldHeight, self.scrollView.frame.size.width-16, 12)];
    self.nameLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.nameLabel.text = @"Full Name";
    [self.scrollView addSubview:self.nameLabel];
    
    Y += self.nameLabel.frame.size.height + 8 + textFieldHeight;
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.nameField.textColor = [UIColor darkTextColor];
    self.nameField.layer.borderColor = [UIColor grayColor].CGColor;
    self.nameField.layer.borderWidth = 1;
    self.nameField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.nameField.leftView = paddingView;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.delegate = self;
    [self.scrollView addSubview:self.nameField];
    
    Y += self.nameField.frame.size.height + 8 + 8;
    self.emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.emailLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.emailLabel.text = @"Email";
    [self.scrollView addSubview:self.emailLabel];
    
    Y += self.emailLabel.frame.size.height + 8;
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.emailField.layer.borderColor = [UIColor grayColor].CGColor;
    self.emailField.textColor = [UIColor darkTextColor];
    self.emailField.layer.borderWidth = 1;
    self.emailField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.emailField.leftView = paddingView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.delegate = self;
    [self.scrollView addSubview:self.emailField];
    
    Y+=self.emailField.frame.size.height + 8 + 8;
    self.showMoreOrLess = [[CustomUILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 20)];
    self.showMoreOrLess.userInteractionEnabled = YES;
    self.showMoreOrLess.textColor = [Helper getUIColorObjectFromHexString:LINK_COLOR alpha:1.0];
    self.showMoreOrLess.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 20];
    self.showMoreOrLess.text = @"Change your username, password and privacy setting?";
    self.showMoreOrLess.numberOfLines = 0;
    self.showMoreOrLess.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [Helper sizeForLabel:self.showMoreOrLess];
    CGRect labelFrame = self.showMoreOrLess.frame;
    labelFrame.size.height = size.height;
    self.showMoreOrLess.frame = labelFrame;
    UIColor* currentColor = self.showMoreOrLess.textColor;
    self.showMoreOrLess.highlightTextColor = [UIColor lightGrayColor];
    self.showMoreOrLess.unHighlightTextColor = currentColor;
    UIGestureRecognizer *showOrHide = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(showOrHide:)];
    showOrHide.enabled = YES;
    showOrHide.cancelsTouchesInView = YES;
    [self.showMoreOrLess addGestureRecognizer:showOrHide];
    [self.scrollView addSubview:self.showMoreOrLess];

    Y+=self.showMoreOrLess.frame.size.height + 8 + 8;
    self.usernameLabelFrame = CGRectMake(X, Y, (self.scrollView.frame.size.width/2)-16, 12);
    self.usernameLabel = [[UILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.usernameLabel.alpha = 0.0;
    self.usernameLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.usernameLabel.text = @"Username";
    [self.scrollView addSubview:self.usernameLabel];
    
    self.passwordLabelFrame = CGRectMake(X + (self.usernameLabelFrame.size.width) + X, Y, self.scrollView.frame.size.width-16, 12);
    self.passwordLabel = [[UILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.passwordLabel.alpha = 0.0;
    self.passwordLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.passwordLabel.text = @"Password";
    [self.scrollView addSubview:self.passwordLabel];
    
    Y += self.usernameLabelFrame.size.height + 8;
    self.usernameFieldFrame = CGRectMake(X, Y, (self.scrollView.frame.size.width/2)-16, textFieldHeight);
    self.usernameField = [[UITextField alloc]initWithFrame:self.showMoreOrLess.frame];
    self.usernameField.alpha = 0.0;
    self.usernameField.layer.borderColor = [UIColor grayColor].CGColor;
    self.usernameField.textColor = [UIColor darkTextColor];
    self.usernameField.layer.borderWidth = 1;
    self.usernameField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.usernameField.leftView = paddingView;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    [self.scrollView addSubview:self.usernameField];
    
    self.passwordFieldFrame = CGRectMake(X + self.usernameFieldFrame.size.width + X, Y, (self.scrollView.frame.size.width/2)-16, textFieldHeight);
    self.passwordField = [[UITextField alloc]initWithFrame:self.showMoreOrLess.frame];
    self.passwordField.alpha = 0.0;
    self.passwordField.layer.borderColor = [UIColor grayColor].CGColor;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textColor = [UIColor darkTextColor];
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.passwordField.leftView = paddingView;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.delegate = self;
    [self.scrollView addSubview:self.passwordField];
    
    Y+=self.passwordFieldFrame.size.height + 8 + 8;
    self.changePasswordFrame = CGRectMake(X, Y, 140, 16);
    self.changePassword =[[CustomUILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.changePassword.alpha = 0.0;
    self.changePassword.userInteractionEnabled = YES;
    self.changePassword.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 16.0];
    self.changePassword.text = @"Change password";
    self.changePassword.textColor = [Helper getUIColorObjectFromHexString:LINK_COLOR alpha:1.0];
    currentColor = self.changePassword.textColor;
    self.changePassword.highlightTextColor = [UIColor lightGrayColor];
    self.changePassword.unHighlightTextColor = currentColor;
    UIGestureRecognizer *changePasswordTap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(changePassword:)];
    changePasswordTap.enabled = YES;
    changePasswordTap.cancelsTouchesInView = YES;
    [self.changePassword addGestureRecognizer:changePasswordTap];
    [self.scrollView addSubview:self.changePassword];
    self.changePasswordButtonFrame = CGRectMake(self.changePasswordFrame.size.width, Y+2, 12, 12);
    self.changePasswordButton = [[UIButton alloc]initWithFrame:self.showMoreOrLess.frame];
    self.changePasswordButton.alpha = 0.0;
    UIImage *btnImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.changePasswordButton setImage:btnImage forState:UIControlStateNormal];
    self.changePasswordButton.tintColor =[Helper getUIColorObjectFromHexString:LINK_COLOR alpha:1.0];
    self.changePasswordButton.transform = CGAffineTransformMakeRotation(M_PI); //rotate it to point other direction
    [self.scrollView addSubview:self.changePasswordButton];
    
    Y+=self.changePasswordFrame.size.height + 8;
    self.privacyLabelFrame = CGRectMake(X, Y, self.scrollView.frame.size.width/2, 12);
    self.privacyLabel = [[UILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.privacyLabel.alpha = 0.0;
    self.privacyLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.privacyLabel.text = @"Privacy";
    [self.scrollView addSubview:self.privacyLabel];
    
    Y+=self.privacyLabelFrame.size.height + 8;
    self.privacySwitchFrame = CGRectMake(X, Y, 30, 40);
    self.privacySwitch = [[UISwitch alloc]initWithFrame:self.showMoreOrLess.frame];
    self.privacySwitch.alpha = 0.0;
    [self.scrollView addSubview:self.privacySwitch];
    
    self.privacyExplanationFrame = CGRectMake(self.privacySwitchFrame.size.width + X  + 24, Y + (self.privacySwitchFrame.size.height/6), self.scrollView.frame.size.width - self.privacySwitchFrame.size.width - 32, 16);
    self.privacyExplanation = [[UILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.privacyExplanation.alpha = 0.0;
    self.privacyExplanation.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 16.0];
    self.privacyExplanation.text = @"Hide my profile and schedule";
    self.privacyExplanation.numberOfLines = 0;
    self.privacyExplanation.lineBreakMode = NSLineBreakByWordWrapping;
    self.privacyExplanation.textColor = [UIColor grayColor];
    size = [Helper sizeForLabel:self.privacyExplanation];
    labelFrame = self.privacyLabelFrame;
    labelFrame.size.height = size.height;
    self.privacyLabelFrame = labelFrame;
    [self.scrollView addSubview:self.privacyExplanation];
    
    Y = self.showMoreOrLess.frame.origin.y + self.showMoreOrLess.frame.size.height + 16;
    self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width, 16)];
    self.companyNameLabel.text = @"ASSAD";
    [self.scrollView addSubview:self.companyNameLabel];
    [self.scrollView bringSubviewToFront:self.showMoreOrLess];
    [self.view addSubview:self.scrollView];

}

- (void)adjustUI{
    [self setBackButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
-(void)showOrHide:(UITapGestureRecognizer *) sender{
    int heightToAnimate = self.usernameFieldFrame.size.height + self.changePasswordFrame.size.height + self.privacySwitchFrame.size.height + 16 + 16 + 16 + 16;
    self.showingMoreSettings = !self.showingMoreSettings;
    if (self.showingMoreSettings){
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.usernameLabel.frame = self.usernameLabelFrame;
            self.usernameField.frame = self.usernameFieldFrame;
            self.changePassword.frame = self.changePasswordFrame;
            self.passwordLabel.frame = self.passwordLabelFrame;
            self.privacyLabel.frame = self.privacyLabelFrame;
            self.passwordField.frame = self.passwordFieldFrame;
            self.privacySwitch.frame = self.privacySwitchFrame;
            self.privacyExplanation.frame = self.privacyExplanationFrame;
            self.changePasswordButton.frame = self.changePasswordButtonFrame;
            
            self.usernameLabel.alpha = 1.0;
            self.usernameField.alpha = 1.0;
            self.changePassword.alpha = 1.0;
            self.passwordLabel.alpha = 1.0;
            self.privacyLabel.alpha = 1.0;
            self.passwordField.alpha = 1.0;
            self.privacySwitch.alpha = 1.0;
            self.privacyExplanation.alpha = 1.0;
            self.changePasswordButton.alpha = 1.0;
            CGRect newFrame = self.companyNameLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.companyNameLabel.frame = newFrame;
        } completion:nil];
    }else{
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.usernameLabel.frame = self.showMoreOrLess.frame;
            self.usernameField.frame = self.showMoreOrLess.frame;
            self.changePassword.frame = self.showMoreOrLess.frame;
            self.passwordLabel.frame = self.showMoreOrLess.frame;            self.privacyLabel.frame = self.showMoreOrLess.frame;
            self.passwordField.frame = self.showMoreOrLess.frame;
            self.privacySwitch.frame = self.showMoreOrLess.frame;
            self.privacyExplanation.frame = self.showMoreOrLess.frame;
            self.changePasswordButton.frame = self.showMoreOrLess.frame;
            
            self.usernameLabel.alpha = 0;
            self.usernameField.alpha = 0;
            self.changePassword.alpha = 0;
            self.passwordLabel.alpha = 0;
            self.privacyLabel.alpha = 0;
            self.passwordField.alpha = 0;
            self.privacySwitch.alpha = 0;
            self.privacyExplanation.alpha = 0;
            self.changePasswordButton.alpha = 0;
        } completion:nil];
    }
    
}
-(void)changePassword:(UITapGestureRecognizer *) sender{
    NSLog(@"HERER");
}
#pragma Mark textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveProfile:(id)sender {
}
@end
