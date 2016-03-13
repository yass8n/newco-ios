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
@property (strong, nonatomic) NSMutableArray* sessionFilterViews;
//@property (strong, nonatomic) IBOutlet CustomUIView *sessionView;
//@property (strong, nonatomic) IBOutlet CustomUIView *dateView;
@end

@implementation MapFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.sessionFilterViews = [[NSMutableArray alloc]init];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, 100, 18)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 16.0];
    label.text = @"General Filter";
    [self.scrollView addSubview:label];
    Y+=20;
    FilterView *view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
    view.title.text = @"All Sessions";
    view.filterSession = all;
    view.frame = frame;
    view.layer.borderColor = [UIColor myLightGray].CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 0;
    Y+=view.frame.size.height;
    view.check.hidden = YES;
    UIGestureRecognizer *changeFilter = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(changeSessionFilter:)];
    changeFilter.enabled = YES;
    changeFilter.cancelsTouchesInView = YES;
    [view addGestureRecognizer:changeFilter];
    [self.sessionFilterViews addObject:view];
    [self.scrollView addSubview:view];

    view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
    view.title.text = @"My Sessions";
    view.filterSession = my;
    frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
    view.frame = frame;
    view.layer.borderColor = [UIColor myLightGray].CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 0;
    Y+=view.frame.size.height;
    view.check.hidden = YES;
    changeFilter = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(changeSessionFilter:)];
    changeFilter.enabled = YES;
    changeFilter.cancelsTouchesInView = YES;
    [view addGestureRecognizer:changeFilter];
    [self.sessionFilterViews addObject:view];
    [self.scrollView addSubview:view];
    [self.view addSubview:self.scrollView];
    [self updateSessionViewsChecks];
}
-(void)changeSessionFilter:(UITapGestureRecognizer *) sender{
    FilterView * view = (FilterView*)[sender view];
    self.filterSessions = view.filterSession;
    [self updateSessionViewsChecks];
 
}
-(void)updateSessionViewsChecks{
    for (int i = 0; i < [self.sessionFilterViews count]; i++){
        FilterView * v = [self.sessionFilterViews objectAtIndex:i];
        if (v.filterSession == self.filterSessions){
            v.check.hidden = NO;
            [Helper buttonTappedAnimation:v];
            [Helper buttonTappedAnimation:v.check];
        }else{
            v.check.hidden = YES;
        }
    }
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
