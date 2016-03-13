//
//  MapFilterViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "MapFilterViewController.h"

@interface MapFilterViewController ()

@end

@implementation MapFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [filter setTitle:@"Apply" forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * filterButton = [[UIBarButtonItem alloc]initWithCustomView:filter];
    [self navigationItem].rightBarButtonItem = filterButton;    // Do any additional setup after loading the view.
}
-(IBAction)done:(id)sender  {
    NSLog(@"asdasd");
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
