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
@property (strong, nonatomic) IBOutlet NSObject *nameLabel;
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

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
