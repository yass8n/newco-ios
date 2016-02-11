//
//  DirectoryViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "DirectoryViewController.h"
#import "ProfileTableViewController.h"
#import "HighlightableView.h"

@interface DirectoryViewController ()
    @property (weak, nonatomic) IBOutlet HighlightableView *presenters;
    @property (weak, nonatomic) IBOutlet HighlightableView *hostCompanies;
    @property (weak, nonatomic) IBOutlet HighlightableView *volunteers;
    @property (weak, nonatomic) IBOutlet HighlightableView *attendees;
@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setClickListeners];
    // Do any additional setup after loading the view.
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

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
//    if (currentSelectedIndexPath != nil)
//    {
//        [[tableView cellForRowAtIndexPath:currentSelectedIndexPath] setBackgroundColor:[UIColor myLightGray]];
//    }
//    
//    return indexPath;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor myLightGray]];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (cell.isSelected == YES)
//    {
//        [cell setBackgroundColor:[UIColor myLightGray]];
//    }
//    else
//    {
//        [cell setBackgroundColor:[UIColor whiteColor]];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
