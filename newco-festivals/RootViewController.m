//
//  RootViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleViewController.h"

@interface RootViewController ()
    @property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
    - (IBAction)changedSegmentedControl:(id)sender;
@end

@implementation RootViewController

//waits until shceduleViewController has initialized the Directory variables before enabling the segmented control
-(void)enableSegmentedControl{
    while (true) {
        [NSThread sleepForTimeInterval:.3];
        if (ApplicationViewController.enableSegmentedControl == YES){
            self.navigationItem.titleView.userInteractionEnabled = YES;
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.loader startAnimating];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;

    UIButton *menu =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menu setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
    [user setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    [user addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [user setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
    
    self.navigationItem.titleView.userInteractionEnabled = NO;
    //disable segmented control until shceduleViewController has initialized the Directory variables

    [self setViewControllerWithSegmentedControl:self.segmentedControl];
    
    ApplicationViewController.sysVer = 0;
    
    dispatch_queue_t que = dispatch_queue_create("enableControl", NULL);
    dispatch_async(que, ^{[self enableSegmentedControl];});
}
- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
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

- (IBAction)changedSegmentedControl:(id)sender {
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    [self changeViewController:index];
}


@end
