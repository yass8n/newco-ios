//
//  ProfileTableViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "UserInitial.h"
#import "UserImage.h"


@interface ProfileTableViewController ()
    @property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileTableViewController{
    NSArray * usersArray;
    NSMutableArray * cellsArray;

}
static const float MIN_SESSION_HEIGHT = 155.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    usersArray = [self.users allValues];
    cellsArray = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = NO;
    ApplicationViewController.currentVC = enumProfileTable;
    if (self.session){
        self.navigationController.navigationBar.barTintColor = self.session.color;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }else {
        self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
        self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    }
}
- (void)adjustUI{
    [self setBackButton];
    [self setMultiLineTitle: self.pageTitle fontColor: [UIColor blackColor]];
    self.profileTableView.estimatedRowHeight = 120.0;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell" forIndexPath:indexPath];
    NSMutableDictionary * user = [usersArray objectAtIndex:indexPath.row];
    if (ApplicationViewController.sysVer < 8.00){
        cell.clipsToBounds = YES;
    }
    cell.name.text = [user objectForKey:@"name"];
    cell.position.text = [user objectForKey:@"position"];
    cell.company.text = [user objectForKey:@"company"];
    NSString* avatar = [user objectForKey:@"avatar"];
    CGRect rect = CGRectMake(0, 0, cell.image.bounds.size.width, cell.image.bounds.size.height);

    if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""]){
        [self setUserInitial:rect withFont:20 withUser:user intoView:cell.image withType:self.type];
    }else {
        [self setUserImage:rect withAvatar:avatar withUser:user intoView:cell.image withType:self.type];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //opacity for speed of scroll
    [cell.contentView setOpaque:YES];
    [cell.backgroundView setOpaque:YES];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    //storyboard contains other border properties
    [cell layoutIfNeeded];

    return cell;
}

//tableView functions
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_SESSION_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_SESSION_HEIGHT;
    }
}

-(void)reloadTableView
{
    [self.profileTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
    [self goToProfile:[usersArray objectAtIndex:indexPath.row] withType:self.type];
}
@end
