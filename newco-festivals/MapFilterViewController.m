//
//  MapFilterViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "MapFilterViewController.h"
#import "FilterView.h"

@interface MapFilterViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet CustomUIView *sessionView;
@property (strong, nonatomic) IBOutlet CustomUIView *dateView;
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
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    int X = 8;
    int Y = 8;
    self.sessionView = [[CustomUIView alloc]initWithFrame:CGRectMake(X, Y, self.scrollView.frame.size.width-16, 12)];
    self.sessionView.layer.borderWidth = 1.0;
    self.sessionView.layer.borderColor = [UIColor myLightGray].CGColor;
    self.sessionView.layer.cornerRadius = 5.0;
    
    UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];

    [self.sessionView addSubview:rootView];
    [self.sessionView sizeToFit];
    
    [self.scrollView addSubview:self.sessionView];
    [self.view addSubview:self.scrollView];
    
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
