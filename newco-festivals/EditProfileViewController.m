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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet CustomUILabel *showMoreOrLess;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet CustomUILabel *changePassword;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;
@property (weak, nonatomic) IBOutlet UILabel *privacyExplanation;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyNameField;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;
@property (weak, nonatomic) IBOutlet UILabel *companyPositionLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyPositionField;
@property (weak, nonatomic) IBOutlet CustomUIView *profileView;
@property (weak, nonatomic) IBOutlet CustomUILabel *removePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *togglableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews{
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UITextField* v = [[UITextField alloc]initWithFrame:CGRectMake(30, 30, 30, 30)];
    [v setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:v];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    int X = 8;
    int currentY = 78;
    self.usernameField.userInteractionEnabled = YES;
    [self.scrollView bringSubviewToFront:self.usernameField];
    self.nameLabel.frame = CGRectMake(X, currentY+=8, self.view.frame.size.width-16, 24);
    self.nameField.frame = CGRectMake(8, currentY+=16, self.view.frame.size.width-16, 24);
    self.emailLabel.frame = CGRectMake(8, currentY, self.view.frame.size.width-16, 24);

}

- (void)adjustUI{
    [self setBackButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
