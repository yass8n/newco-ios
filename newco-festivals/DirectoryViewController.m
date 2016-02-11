//
//  DirectoryViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "DirectoryViewController.h"
#import "ProfileTableViewController.h"

@interface DirectoryViewController ()
    @property (weak, nonatomic) IBOutlet UIView *presenters;
    @property (weak, nonatomic) IBOutlet UIView *host_companies;
    @property (weak, nonatomic) IBOutlet UIView *volunteers;
    @property (weak, nonatomic) IBOutlet UIView *attendees;
@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self setClickListeners];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)adjustUI{
    [ApplicationViewController setBorder:self.presenters width:1.0 radius:6 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.host_companies width:1.0 radius:6 color:[UIColor myLightGray]];
    [ApplicationViewController setBorder:self.volunteers width:1.0 radius:6 color:[UIColor myLightGray]];
     [ApplicationViewController setBorder:self.attendees width:1.0 radius:6 color:[UIColor myLightGray]];
}
-(void)setClickListeners{
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *presentersTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToPresenters:)];
    [self.presenters addGestureRecognizer:presentersTap];
    
    UITapGestureRecognizer *attendeesTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToAttendees:)];
    [self.attendees addGestureRecognizer:attendeesTap];
    
    UITapGestureRecognizer *companiesTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToCompanies:)];
    [self.host_companies addGestureRecognizer:companiesTap];
    
    UITapGestureRecognizer *volunteersTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToVolunteers:)];
    [self.volunteers addGestureRecognizer:volunteersTap];

}

//an event handling method
- (void)goToPresenters:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.presentersDict withTitle:@"Presenters"];
}

//an event handling method
- (void)goToAttendees:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.attendeesDict withTitle:@"Attendees"];
}

//an event handling method
- (void)goToCompanies:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.companiesDict withTitle:@"Companies"];
}

//an event handling method
- (void)goToVolunteers:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.volunteersDict withTitle:@"Volunteers"];
}

- (void)goToProfileTable: (NSMutableDictionary*) people withTitle: (NSString*) title{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:people];
    [vc setPageTitle:title];
    [self.navigationController pushViewController:vc animated:YES];
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
