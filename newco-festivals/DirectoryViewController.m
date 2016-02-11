//
//  DirectoryViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "DirectoryViewController.h"
#import "ProfileTableViewController.h"
#import "CustomUIView.h"

@interface DirectoryViewController ()
    @property (weak, nonatomic) IBOutlet CustomUIView *presenters;
    @property (weak, nonatomic) IBOutlet CustomUIView *hostCompanies;
    @property (weak, nonatomic) IBOutlet CustomUIView *volunteers;
    @property (weak, nonatomic) IBOutlet CustomUIView *attendees;
@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setClickListeners];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ApplicationViewController.currentVC = enumDirectory;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setClickListeners{
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *presentersTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToPresenters:)];
    presentersTap.delaysTouchesBegan = NO;
    presentersTap.delaysTouchesEnded = NO;
    [self.presenters addGestureRecognizer:presentersTap];
    
    UITapGestureRecognizer *attendeesTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToAttendees:)];
    attendeesTap.delaysTouchesBegan = NO;
    attendeesTap.delaysTouchesEnded = NO;
    [self.attendees addGestureRecognizer:attendeesTap];
    
    UITapGestureRecognizer *companiesTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToCompanies:)];
    companiesTap.delaysTouchesBegan = NO;
    companiesTap.delaysTouchesEnded = NO;
    [self.hostCompanies addGestureRecognizer:companiesTap];
    
    UITapGestureRecognizer *volunteersTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToVolunteers:)];
    volunteersTap.delaysTouchesBegan = NO;
    volunteersTap.delaysTouchesEnded = NO;
    [self.volunteers addGestureRecognizer:volunteersTap];

}

//an event handling method
- (void)goToPresenters:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.presentersDict withTitle:@"Presenters" withSession:nil withType:@"speaker"];
}

//an event handling method
- (void)goToAttendees:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.attendeesDict withTitle:@"Attendees" withSession:nil withType:@"attendee"];

}

//an event handling method
- (void)goToCompanies:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.companiesDict withTitle:@"Companies" withSession:nil withType:@"company"];
}

//an event handling method
- (void)goToVolunteers:(UITapGestureRecognizer *)recognizer {
    [self goToProfileTable: ApplicationViewController.volunteersDict withTitle:@"Volunteers" withSession:nil withType:@"volunteer"];
}
@end