//
//  SessionDetailViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "SessionDetailViewController.h"

@interface SessionDetailViewController ()

@end

@implementation SessionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.status.text = self.status.text;
    NSLog(@"->>>>>>>>> %@", _session.title);
    [self adjustUI];
    // Do any additional setup after loading the view.
}
- (void) adjustUI{
      [super setBackButton];
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

@end
