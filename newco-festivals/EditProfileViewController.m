//
//  EditProfileViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 2/28/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomUILabel.h"
#import "ModalView.h"
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
@property (strong, nonatomic) IBOutlet CustomUILabel *photoTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) BOOL showingMoreSettings;
@property (nonatomic) BOOL avatarSet;
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
    [self setBackButton];
//    [self hidePageLoader];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    self.showingMoreSettings = NO;
}
-(void)adjustUI{
    UIGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(dismissKeyboard:)];
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
    self.nameLabel.textColor = [UIColor grayColor];

    self.nameLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.nameLabel.text = @"Full Name";
    [self.scrollView addSubview:self.nameLabel];
    
    Y += self.nameLabel.frame.size.height + 8 + textFieldHeight;
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.nameField.textColor = [UIColor darkTextColor];
    self.nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameField.layer.borderWidth = 1;
    self.nameField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.nameField.leftView = paddingView;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"name"];
    self.nameField.delegate = self;
    [self.nameField addTarget:self action:@selector(nameDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.nameField];
    
    Y += self.nameField.frame.size.height + 8 + 8;
    self.emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 40, 12)];
    self.emailLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.emailLabel.text = @"Email";
    self.emailLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.emailLabel];
    
    Y += self.emailLabel.frame.size.height + 8;
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.emailField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailField.textColor = [UIColor darkTextColor];
    self.emailField.layer.borderWidth = 1;
    self.emailField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.emailField.leftView = paddingView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"email"];
    self.emailField.delegate = self;
    [self.emailField addTarget:self action:@selector(emailDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    self.usernameLabel.textColor = [UIColor grayColor];
    self.usernameLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.usernameLabel.text = @"Username";
    [self.scrollView addSubview:self.usernameLabel];
    
    self.passwordLabelFrame = CGRectMake(X + (self.usernameLabelFrame.size.width) + X, Y, self.scrollView.frame.size.width-16, 12);
    self.passwordLabel = [[UILabel alloc]initWithFrame:self.showMoreOrLess.frame];
    self.passwordLabel.alpha = 0.0;
    self.passwordLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.passwordLabel.textColor = [UIColor grayColor];
    self.passwordLabel.text = @"Confirm Password";
    [self.scrollView addSubview:self.passwordLabel];
    
    Y += self.usernameLabelFrame.size.height + 8;
    self.usernameFieldFrame = CGRectMake(X, Y, (self.scrollView.frame.size.width/2)-16, textFieldHeight);
    self.usernameField = [[UITextField alloc]initWithFrame:self.showMoreOrLess.frame];
    self.usernameField.alpha = 0.0;
    self.usernameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.usernameField.textColor = [UIColor darkTextColor];
    self.usernameField.layer.borderWidth = 1;
    self.usernameField.layer.cornerRadius = 3;
    self.usernameField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"username"];
    [self.usernameField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];

    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.usernameField.leftView = paddingView;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    [self.scrollView addSubview:self.usernameField];
    
    self.passwordFieldFrame = CGRectMake(X + self.usernameFieldFrame.size.width + X, Y, (self.scrollView.frame.size.width/2)-16, textFieldHeight);
    self.passwordField = [[UITextField alloc]initWithFrame:self.showMoreOrLess.frame];
    self.passwordField.alpha = 0.0;
    self.passwordField.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    self.privacyLabel.textColor = [UIColor grayColor];
    self.privacyLabel.text = @"Privacy";
    [self.scrollView addSubview:self.privacyLabel];
    
    Y+=self.privacyLabelFrame.size.height + 8;
    self.privacySwitchFrame = CGRectMake(X, Y, 30, 40);
    self.privacySwitch = [[UISwitch alloc]initWithFrame:self.showMoreOrLess.frame];
    self.privacySwitch.alpha = 0.0;
    if ([[[Credentials sharedCredentials].currentUser objectForKey:@"privacy_mode"] isEqualToString:@"N"]
        || [[[Credentials sharedCredentials].currentUser objectForKey:@"privacy_mode"] isEqualToString:@"0"]){
        self.privacySwitch.selected = NO;
    }else{
        self.privacySwitch.selected = YES;
    }
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
    self.profileView = [[CustomUIView alloc]initWithFrame:CGRectMake( (self.scrollView.frame.size.width/2)-(self.scrollView.frame.size.width/4), Y, (self.scrollView.frame.size.width/2), (self.scrollView.frame.size.width/2))];
    self.profileView.layer.cornerRadius =  self.profileView.frame.size.height/2;
    self.profileView.layer.masksToBounds = YES;
    [self setAvatar];
    [self.scrollView addSubview:self.profileView];
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotoTapped:)];
    profileTap.cancelsTouchesInView = YES;
    profileTap.numberOfTapsRequired = 1;
    [self.profileView addGestureRecognizer:profileTap];
//    for (int i = 0; i < [self.profileView.subviews count]; i++){
//        UIView* view = [self.profileView.subviews objectAtIndex:i];
//        [view addGestureRecognizer:profileTap];
//    }
    
    
    Y+= self.profileView.frame.size.height + 10;
    self.photoTextLabel = [[CustomUILabel alloc]initWithFrame:CGRectMake(0, Y, self.scrollView.frame.size.width, 18)];
    self.photoTextLabel.textAlignment = NSTextAlignmentCenter;
    self.photoTextLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    if (self.avatarSet){
        self.photoTextLabel.text = @"Remove Photo";
        self.photoTextLabel.textColor = [UIColor redColor];
    }else{
        self.photoTextLabel.text = @"Add Photo";
        self.photoTextLabel.textColor = [Helper getUIColorObjectFromHexString:LINK_COLOR alpha:1.0];
        
    }
    self.photoTextLabel.userInteractionEnabled = YES;
    currentColor = self.showMoreOrLess.textColor;
    self.photoTextLabel.highlightTextColor = [UIColor lightGrayColor];
    self.photoTextLabel.unHighlightTextColor = currentColor;
    UIGestureRecognizer *photoTextTapped = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(photoTextTapped:)];
    [self.photoTextLabel addGestureRecognizer:photoTextTapped];
    [self.scrollView addSubview:self.photoTextLabel];
    [self.scrollView bringSubviewToFront:self.showMoreOrLess];
    
    Y+=self.photoTextLabel.frame.size.height + 16;
    self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.companyNameLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.companyNameLabel.text = @"Company Name";
    self.companyNameLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.companyNameLabel];
    
    Y += self.companyNameLabel.frame.size.height + 8;
    self.companyNameField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.companyNameField.textColor = [UIColor darkTextColor];
    self.companyNameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.companyNameField.layer.borderWidth = 1;
    self.companyNameField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.companyNameField.leftView = paddingView;
    self.companyNameField.leftViewMode = UITextFieldViewModeAlways;
    self.companyNameField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"company"];
    self.companyNameField.delegate = self;
    [self.scrollView addSubview:self.companyNameField];
    
    Y += self.companyNameField.frame.size.height + 8 + 8;
    self.companyPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.companyPositionLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.companyPositionLabel.text = @"Position";
    self.companyPositionLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.companyPositionLabel];
    
    Y += self.companyPositionLabel.frame.size.height + 8;
    self.companyPositionField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.companyPositionField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.companyPositionField.textColor = [UIColor darkTextColor];
    self.companyPositionField.layer.borderWidth = 1;
    self.companyPositionField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.companyPositionField.leftView = paddingView;
    self.companyPositionField.leftViewMode = UITextFieldViewModeAlways;
    self.companyPositionField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"position"];
    self.companyPositionField.delegate = self;
    [self.scrollView addSubview:self.companyPositionField];
    
    Y += self.companyPositionField.frame.size.height + 8 + 8;
    self.websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.websiteLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.websiteLabel.text = @"Website";
    self.websiteLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.websiteLabel];
    
    Y += self.websiteLabel.frame.size.height + 8;
    self.websiteField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight)];
    self.websiteField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.websiteField.textColor = [UIColor darkTextColor];
    self.websiteField.layer.borderWidth = 1;
    self.websiteField.layer.cornerRadius = 3;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.websiteField.leftView = paddingView;
    self.websiteField.leftViewMode = UITextFieldViewModeAlways;
    self.websiteField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"website"];
    self.websiteField.delegate = self;
    [self.scrollView addSubview:self.websiteField];
    [self.view addSubview:self.scrollView];
    [self.scrollView setScrollEnabled:YES];
    
    Y += self.websiteField.frame.size.height + 8 + 8;
    self.aboutMeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.aboutMeLabel.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 12.0];
    self.aboutMeLabel.text = @"Tell us about yourself";
    self.aboutMeLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.aboutMeLabel];
    
    Y += self.aboutMeLabel.frame.size.height + 8;
    self.aboutMeField = [[UITextView alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, textFieldHeight * 5)];
    self.aboutMeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.aboutMeField.textColor = [UIColor darkTextColor];
    self.aboutMeField.layer.borderWidth = 1;
    self.aboutMeField.layer.cornerRadius = 3;
    self.aboutMeField.delegate = self;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.aboutMeField.text = [[Credentials sharedCredentials].currentUser objectForKey:@"about"];
    self.aboutMeField.delegate = self;
    [self.scrollView addSubview:self.aboutMeField];
    [self.view addSubview:self.scrollView];
    [self.scrollView setScrollEnabled:YES];
    
    
    Y += self.aboutMeField.frame.size.height + 8 + 8;
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 40)];
    [self.saveButton addTarget:self action:@selector(saveProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"Save Profile" forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [Helper getUIColorObjectFromHexString:@"#0AC92B" alpha:1.0];
    self.saveButton.layer.borderWidth = 1.0;
    self.saveButton.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.saveButton.layer.cornerRadius = 5.0;
    [self.scrollView addSubview:self.saveButton];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,Y + 100)];
}
-(void)setAvatar{
    [self.profileView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    NSString* avatar = [[Credentials sharedCredentials].currentUser objectForKey:@"avatar"] ;
    if ([ avatar isEqual:[NSNull null]] || [avatar  isEqual: @""] || avatar == nil){
        self.avatarSet = NO;
        self.selectedImage = nil;
        self.photoTextLabel.text = @"Upload Photo";
        self.photoTextLabel.textColor = [Helper getUIColorObjectFromHexString:LINK_COLOR alpha:1.0];
        [self setUserInitial:self.profileView.bounds withFont:self.profileView.frame.size.width/2 withUser:[Credentials sharedCredentials].currentUser intoView:self.profileView withType:nil];
    }else {
        self.avatarSet = YES;
        self.photoTextLabel.text = @"Remove Photo";
        self.photoTextLabel.textColor = [UIColor redColor];
        [self setUserImage:self.profileView.frame withAvatar:avatar withUser:[Credentials sharedCredentials].currentUser intoView:self.profileView withType:nil];
        self.profileView.layer.borderColor = [UIColor myLightGray].CGColor;
        self.profileView.layer.cornerRadius = self.profileView.frame.size.width/2;
        self.profileView.layer.borderWidth = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changePassword:(UITapGestureRecognizer *) sender{
    NSString* url = [NSString stringWithFormat:@"%@/mobile/#page:page-forgot", [[Credentials sharedCredentials].festival objectForKey:@"url"]];
    [self showWebViewWithUrl:url];
}
-(void)photoTextTapped:(UITapGestureRecognizer *) sender
{
    if (self.avatarSet){
        [self setAvatar];
        NSLog(@"REMOVING PHOTO");
    }else{
        [self presentPhotoLibrary];
        NSLog(@"UPLOADING PHOTO");
    }
}
- (void)dismissKeyboard:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
-(void)presentPhotoLibrary{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
-(void)addPhotoTapped:(UITapGestureRecognizer *) sender
{
    [self presentPhotoLibrary];
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
            
            CGRect newFrame = self.companyNameLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.companyNameLabel.frame = newFrame;
            
            newFrame = self.companyNameField.frame;
            newFrame.origin.y += heightToAnimate;
            self.companyNameField.frame = newFrame;
            
            newFrame = self.profileView.frame;
            newFrame.origin.y += heightToAnimate;
            self.profileView.frame = newFrame;
            
            newFrame = self.photoTextLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.photoTextLabel.frame = newFrame;
            
            newFrame = self.companyPositionLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.companyPositionLabel.frame = newFrame;
            
            newFrame = self.companyPositionField.frame;
            newFrame.origin.y += heightToAnimate;
            self.companyPositionField.frame = newFrame;
            
            newFrame = self.websiteLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.websiteLabel.frame = newFrame;
            
            newFrame = self.websiteField.frame;
            newFrame.origin.y += heightToAnimate;
            self.websiteField.frame = newFrame;
            
            newFrame = self.aboutMeLabel.frame;
            newFrame.origin.y += heightToAnimate;
            self.aboutMeLabel.frame = newFrame;
            
            newFrame = self.aboutMeField.frame;
            newFrame.origin.y += heightToAnimate;
            self.aboutMeField.frame = newFrame;
            
            newFrame = self.saveButton.frame;
            newFrame.origin.y += heightToAnimate;
            self.saveButton.frame = newFrame;
            
            CGSize size = self.scrollView.contentSize;
            size.height += heightToAnimate;
            [self.scrollView setContentSize:size];
            
            self.usernameLabel.alpha = 1.0;
            self.usernameField.alpha = 1.0;
            self.changePassword.alpha = 1.0;
            self.privacyLabel.alpha = 1.0;
            self.privacySwitch.alpha = 1.0;
            self.privacyExplanation.alpha = 1.0;
            self.changePasswordButton.alpha = 1.0;
            if (![self.usernameField.text isEqualToString:[[Credentials sharedCredentials].currentUser objectForKey:@"username"]]){
                self.passwordLabel.alpha = 1.0;
                self.passwordField.alpha = 1.0;
            }
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
            
            CGRect newFrame = self.companyNameLabel.frame;
            newFrame.origin.y -= heightToAnimate;
            self.companyNameLabel.frame = newFrame;
            
            newFrame = self.companyNameField.frame;
            newFrame.origin.y -= heightToAnimate;
            self.companyNameField.frame = newFrame;
            
            newFrame = self.profileView.frame;
            newFrame.origin.y -= heightToAnimate;
            self.profileView.frame = newFrame;
            
            newFrame = self.photoTextLabel.frame;
            newFrame.origin.y -= heightToAnimate;
            self.photoTextLabel.frame = newFrame;
            
            newFrame = self.companyPositionLabel.frame;
            newFrame.origin.y -= heightToAnimate;
            self.companyPositionLabel.frame = newFrame;
            
            newFrame = self.companyPositionField.frame;
            newFrame.origin.y -= heightToAnimate;
            self.companyPositionField.frame = newFrame;
            
            newFrame = self.websiteLabel.frame;
            newFrame.origin.y -= heightToAnimate;
            self.websiteLabel.frame = newFrame;
            
            newFrame = self.websiteField.frame;
            newFrame.origin.y -= heightToAnimate;
            self.websiteField.frame = newFrame;
            
            newFrame = self.aboutMeLabel.frame;
            newFrame.origin.y -= heightToAnimate;
            self.aboutMeLabel.frame = newFrame;
            
            newFrame = self.aboutMeField.frame;
            newFrame.origin.y -= heightToAnimate;
            self.aboutMeField.frame = newFrame;
            
            newFrame = self.saveButton.frame;
            newFrame.origin.y -= heightToAnimate;
            self.saveButton.frame = newFrame;
            
            CGSize size = self.scrollView.contentSize;
            size.height -= heightToAnimate;
            [self.scrollView setContentSize:size];
            
            self.usernameLabel.alpha = 0;
            self.usernameField.alpha = 0;
            self.changePassword.alpha = 0;
            self.privacyLabel.alpha = 0;
            self.passwordLabel.alpha = 0;
            self.passwordField.alpha = 0;
            self.privacySwitch.alpha = 0;
            self.privacyExplanation.alpha = 0;
            self.changePasswordButton.alpha = 0;
        } completion:nil];
    }
    
}
#pragma Mark textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//code for keyboard and views adjusting when focused on text view
-(void)usernameDidChange :(UITextField *)theTextField{
    if (![self.usernameField.text isEqualToString:[[Credentials sharedCredentials].currentUser objectForKey:@"username"]]){
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.passwordLabel.alpha = 1.0;
            self.passwordField.alpha = 1.0;
        }completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.passwordLabel.alpha = 0;
            self.passwordField.alpha = 0;
        }completion:^(BOOL finished) {
        }];
    }
    NSLog( @"text changed: %@", theTextField.text);
}
-(void)nameDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
}
-(void)emailDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
}
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
- (void)textViewDidBeginEditing:(UITextView *)textField{
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

- (void)textViewDidEndEditing:(UITextView *)textfield{
    
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
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.avatarSet = YES;
    self.photoTextLabel.text = @"Remove Photo";
    self.photoTextLabel.textColor = [UIColor redColor];
    self.selectedImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(self.profileView.frame.size.width, self.profileView.frame.size.height)];
    [self.profileView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.profileView.bounds];
    [imageView setImage:self.selectedImage];
    [self.profileView addSubview:imageView];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveProfile:(id)sender {
    [Helper buttonTappedAnimation:(UIView*)sender];
    NSLog(@"SAVED");
    WebService * webservice = [[WebService alloc]initWithView:self.view];
    NSDictionary* params;
    if (self.selectedImage != nil){
        params = @{@"sched_id" : [[Credentials sharedCredentials].currentUser objectForKey:@"id"],
                   @"avata" : self.selectedImage,
                   @"name" : self.nameField.text,
                   @"username" : self.usernameField.text,
                   @"email" : self.emailField.text,
                   @"url" : self.websiteField.text,
                   @"about" : self.aboutMeField.text,
                   @"position" : self.companyPositionField.text,
                   @"company" : self.companyNameField.text,
                   @"confirm_password" : self.passwordField.text,
                   @"privacy_mode" :self.privacySwitch.selected ? @"true" : @"false"};
    }else{
        params = @{@"sched_id" : [[Credentials sharedCredentials].currentUser objectForKey:@"id"],
                   @"name" : self.nameField.text,
                   @"username" : self.usernameField.text,
                   @"email" : self.emailField.text,
                   @"url" : self.websiteField.text,
                   @"about" : self.aboutMeField.text,
                   @"position" : self.companyPositionField.text,
                   @"company" : self.companyNameField.text,
                   @"confirm_password" : self.passwordField.text,
                   @"privacy_mode" :self.privacySwitch.selected ? @"true" : @"false"};
    }

    [webservice editProfile:params callback:^(NSDictionary *response) {
        NSString * status = [response objectForKey:@"status"];
        if ([status isEqualToString:@"success"]){
            NSDictionary* user = [response objectForKey:@"user"];
            NSLog(@"HI");
            NSMutableDictionary *mutable = [[Credentials sharedCredentials].currentUser mutableCopy];
            [mutable setValue:[user objectForKey:@"position"] forKey:@"position"];
            [mutable setValue:[user objectForKey:@"privacy_mode"] forKey:@"privacy_mode"];
            [mutable setValue:[user objectForKey:@"username"] forKey:@"username"];
            [mutable setValue:[user objectForKey:@"email"] forKey:@"email"];
            [mutable setValue:[user objectForKey:@"about"] forKey:@"about"];
            [mutable setValue:[user objectForKey:@"name"] forKey:@"name"];
            [mutable setValue:[user objectForKey:@"url"] forKey:@"website"];
            [mutable setValue:[user objectForKey:@"company"] forKey:@"company"];
            [[Credentials sharedCredentials] setCurrentUser:[NSDictionary dictionaryWithDictionary:mutable]];
            double window_width = self.view.frame.size.width;
            double window_height = self.view.frame.size.height;
            CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
             ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [modalView showSuccessModal:@"Profile Saved!" onWindow:self.view.window];
            });
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:status]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
    }];
}
@end
