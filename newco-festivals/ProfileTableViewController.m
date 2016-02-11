//
//  ProfileTableViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileCell.h"
#import "UserInitial.h"
#import "UserImage.h"


@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileTableViewController{
    NSArray * users_array;
}
static const float MIN_CELL_HEIGHT = 120.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    self.profileTableView.estimatedRowHeight = 120.0;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.title = self.pageTitle;
    users_array = [self.users allValues];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSMutableDictionary * user = [users_array objectAtIndex:indexPath.row];
    if (ApplicationViewController.sysVer < 8.00){
        cell.clipsToBounds = YES;
    }
    cell.name.text = [user objectForKey:@"name"];
    cell.position.text = [user objectForKey:@"position"];
    cell.company.text = [user objectForKey:@"company"];
    NSString* avatar = [user objectForKey:@"avatar"];
    if ([avatar  isEqual: @""]){
        UserInitial *userInitial = [[UserInitial alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [userInitial.text.titleLabel setFont:[UIFont systemFontOfSize:20]];
        userInitial.username = [user objectForKey:@"username"];
        [userInitial.text setTitle: [[cell.name.text substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
        [cell.image addSubview:userInitial];
    }else {
        UserImage *userImage = [[UserImage alloc] initWithFrame:CGRectMake(0, 0, cell.image.bounds.size.width, cell.image.bounds.size.height)];
        userImage.bounds = cell.image.bounds; //resizes userImage to be exact size of cell image
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]];
        UIImage *profilePic = [UIImage imageWithData:imageData];
        //        [userImage.image setImageWithURL:[NSURL URLWithString:avatar]
        //                                            placeholderImage:[UIImage imageNamed:@"user.png"]];
        [cell.image addSubview:userImage];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.container.layer.masksToBounds = YES; //for speed of scroll
    [cell.contentView setOpaque:YES]; //for speed of scroll
    [cell.backgroundView setOpaque:YES]; //for speed of scroll
    
    [cell layoutIfNeeded];
    
    return cell;
}

//tableView functions
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_CELL_HEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ApplicationViewController.sysVer > 8.00) {
        return UITableViewAutomaticDimension;
    } else {
        return MIN_CELL_HEIGHT;
    }
}

-(void)reloadTableView
{
    [self.profileTableView reloadData];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end