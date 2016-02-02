//
//  SignInViewController.m
//  newco-festivals
//
//  Created by yassen aniss
//  Copyright © 2016 newco. All rights reserved.
//

#import "SignInViewController.h"
#import "colors.h"


@interface SignInViewController ()
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *forgotPassword;
@property (strong, nonatomic) IBOutlet UILabel *wantToAttend;
- (IBAction)logIn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *logIn;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UILabel *registerEventbrite;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    
    int bottomViewHeight = [self.bottomView bounds].size.height;
    int bottomViewWidth = [self.bottomView bounds].size.width;
    
    int topViewHeight = [self.topView bounds].size.height;
    int topViewWidth = [self.topView bounds].size.width;
    //    self.username.translatesAutoresizingMaskIntoConstraints = YES; //disables autolayout so that we can adjust the frame size
    //    self.username.frame = CGRectMake(0, 0, self.username.bounds.size.width, bottomViewHeight/4);
    
}
- (void)adjustUI{
    
    
    [self setBorder:self.username width:1.0 radius:5 color:[UIColor myLightGray]];
    [self setBorder:self.password width:1.0 radius:5 color:[UIColor myLightGray]];
    [self setBorder:self.bottomView width:1.0 radius:8 color:[UIColor myLightGray]];
    [self setBorder:self.topView width:1.0 radius:5 color:[UIColor myLightGray]];
    [self setBorder:self.logIn width:1.0 radius:5 color:[UIColor blackColor]];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.jpg"] landscapeImagePhone:[UIImage imageNamed:@"back.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item;
}
-(IBAction)goBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}
- (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col{
    obj.layer.borderColor = col.CGColor;
    obj.layer.borderWidth = wid;
    obj.layer.cornerRadius = rad;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)logIn:(id)sender {
}
@end