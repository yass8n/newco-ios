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
    [self setBackButton];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text =  @"Map Filter";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
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
