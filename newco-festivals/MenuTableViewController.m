//
//  MenuTableViewController.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2015 Newco. All rights reserved.
//


#import "MenuTableViewController.h"
#import "MenuItem.h"
#import "HeaderMenuCell.h"
#import "RegularMenuCell.h"
#import "Helper.h"
#import "SWRevealViewController.h"
#import "FilterViewController.h"
#import "ProfileTableViewController.h"
#import "AppDelegate.h"
#import "colors.h"
#import "Credentials.h"
#import "MapViewController.h"
#import "MapFilterViewController.h"
@interface MenuTableViewController ()

@end

@implementation MenuTableViewController{
    NSMutableArray* menuItems;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    menuItems = [[NSMutableArray alloc] init];
    MenuItem * changeCity = [[MenuItem alloc]init];
    changeCity.title = @"Change NewCo City";
    changeCity.function = [NSValue valueWithPointer:@selector(changeCity)];
    changeCity.type = selectableType;
    changeCity.cellIdentifier = REGULAR;
    changeCity.icon = [[UIImage imageNamed:@"swap"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuItems addObject:changeCity];
    
    MenuItem * map = [[MenuItem alloc]init];
    map.title = @"Map";
    map.function = [NSValue valueWithPointer:@selector(map)];
    map.type = selectableType;
    map.cellIdentifier = REGULAR;
    map.icon = [[UIImage imageNamed:@"map"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuItems addObject:map];
    
    FestivalData *sharedFestivalData = [FestivalData sharedFestivalData];
    NSArray * keys = sharedFestivalData.datesDict.allKeys;
    NSMutableArray * fakeDatesToGetThemSorted = [[NSMutableArray alloc]init];
    NSDictionary * order = [Helper order];
    for (int i = 0; i < [keys count]; i ++){
        NSString * num = [order objectForKey:[[keys objectAtIndex:i]substringWithRange:NSMakeRange(0, 3)]];
        [fakeDatesToGetThemSorted addObject:[NSString stringWithFormat:@"%@%@", num, [keys objectAtIndex:i]]];
    }
    NSArray * datesDict = [fakeDatesToGetThemSorted sortedArrayUsingSelector:@selector(compare:)];
    if ([datesDict count] >0){
        MenuItem * header = [[MenuItem alloc]init];
        header.title = @"Dates";
        header.type = headerType;
        header.cellIdentifier = HEADER;
        [menuItems addObject:header];
        for (int i = 0; i < datesDict.count; i++){
            NSString * date = [datesDict objectAtIndex:i];
            MenuItem * dateItem = [[MenuItem alloc]init];
            dateItem.title = [date substringFromIndex:1];
            dateItem.type = selectableType;
            dateItem.cellIdentifier = REGULAR;
            dateItem.stringType = @"date";
            dateItem.icon = [UIImage imageNamed:@"calendar"];
            [menuItems addObject:dateItem];
        }
    }
    
    NSString *location_string = @"Audience";
    NSString *audience_string = @"Location";
    BOOL event_type_is_location = [[[Credentials sharedCredentials].festival objectForKey:@"event_type_is_location"]boolValue];
    if (event_type_is_location){
        location_string = @"Location";
        audience_string = @"Audience";
    }
    
    
    NSArray * colorDict = sharedFestivalData.locationColorDict.allKeys;
    if ([colorDict count] >0){
        MenuItem * header = [[MenuItem alloc]init];
        header.title = location_string;
        header.type = headerType;
        header.cellIdentifier = HEADER;
        [menuItems addObject:header];
        for (int i = 0; i < colorDict.count; i++){
            NSString * location = [colorDict objectAtIndex:i];
            MenuItem * locationItem = [[MenuItem alloc]init];
            locationItem.title = location;
            locationItem.type = selectableType;
            locationItem.cellIdentifier = REGULAR;
            locationItem.stringType = @"location";
            locationItem.color = [sharedFestivalData.locationColorDict objectForKey:location];
            //            if ([location_string isEqualToString:@"Location"]){
            //                locationItem.icon = [UIImage imageNamed:@"location"];
            //            }else{
            //                locationItem.icon = [UIImage imageNamed:@"industry"];
            //            }
            [menuItems addObject:locationItem];
        }
    }
    
    
    NSArray * audienceDict = sharedFestivalData.audienceMapToSessions.allKeys;
    if ([audienceDict count] > 0){
        MenuItem * header1 = [[MenuItem alloc]init];
        header1.title = audience_string;
        header1.type = headerType;
        header1.cellIdentifier = HEADER;
        [menuItems addObject:header1];
        for (int i = 0; i < audienceDict.count; i++){
            NSString * aud = [audienceDict objectAtIndex:i];
            MenuItem * audItem = [[MenuItem alloc]init];
            audItem.title = aud;
            audItem.type = selectableType;
            audItem.cellIdentifier = REGULAR;
            if ([audience_string isEqualToString:@"Location"]){
                audItem.icon = [UIImage imageNamed:@"location"];
            }else{
                audItem.icon = [UIImage imageNamed:@"industry"];
            }
            audItem.stringType = @"audience";
            [menuItems addObject:audItem];
        }
        
    }
    
    MenuItem * header2 = [[MenuItem alloc]init];
    header2.title = @"Directory";
    header2.type = headerType;
    header2.cellIdentifier = HEADER;
    [menuItems addObject:header2];
    
    MenuItem * presenters = [[MenuItem alloc]init];
    presenters.title = @"Presenters";
    presenters.function = [NSValue valueWithPointer:@selector(showPresenters)];
    presenters.type = selectableType;
    presenters.cellIdentifier = REGULAR;
    presenters.icon = [UIImage imageNamed:@"group"];
    [menuItems addObject:presenters];
    
    MenuItem * companies = [[MenuItem alloc]init];
    companies.title = @"Host Companies";
    companies.function = [NSValue valueWithPointer:@selector(showCompanies)];
    companies.type = selectableType;
    companies.cellIdentifier = REGULAR;
    companies.icon = [UIImage imageNamed:@"group"];
    [menuItems addObject:companies];
    
    MenuItem * volunteers = [[MenuItem alloc]init];
    volunteers.title = @"Volunteers";
    volunteers.function = [NSValue valueWithPointer:@selector(showVolunteers)];
    volunteers.type = selectableType;
    volunteers.cellIdentifier = REGULAR;
    volunteers.icon = [UIImage imageNamed:@"group"];
    [menuItems addObject:volunteers];
    
    MenuItem * attendees = [[MenuItem alloc]init];
    attendees.title = @"Attendees";
    attendees.function = [NSValue valueWithPointer:@selector(showAttendees)];
    attendees.type = selectableType;
    attendees.cellIdentifier = REGULAR;
    attendees.icon = [UIImage imageNamed:@"group"];
    [menuItems addObject:attendees];
    
    MenuItem * header3 = [[MenuItem alloc]init];
    header3.title = @"Account";
    header3.type = headerType;
    header3.cellIdentifier = HEADER;
    [menuItems addObject:header3];
    
    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count] > 0){
        MenuItem * logout = [[MenuItem alloc]init];
        logout.title = @"Log Out";
        logout.function = [NSValue valueWithPointer:@selector(logout)];
        logout.type = selectableType;
        logout.cellIdentifier = REGULAR;
        logout.icon = [UIImage imageNamed:@"logout"];
        [menuItems addObject:logout];
    }else{
        MenuItem * login = [[MenuItem alloc]init];
        login.title = @"Login";
        login.function = [NSValue valueWithPointer:@selector(login)];
        login.type = selectableType;
        login.cellIdentifier = REGULAR;
        login.icon = [UIImage imageNamed:@"user"];
        [menuItems addObject:login];
    }
    
    [self.tableView reloadData];
    [ApplicationViewController setMenuOpen:YES];
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.origin.y + 20;
};
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ApplicationViewController setMenuOpen:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem * item = [menuItems objectAtIndex:indexPath.row];
    BaseMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellIdentifier forIndexPath:indexPath];
    
    if (item.cellIdentifier == REGULAR){
        cell = (RegularMenuCell*) cell;
    }else{
        cell = (HeaderMenuCell*) cell;
    }
    
    if (item.type == headerType){
        cell.textLabel.text = item.title;
    }else{
        CGSize cellImageSize = CGSizeMake(22, 22);
        cell.textLabel.text = item.title;
        if (item.icon){
            cell.imageView.image = [item.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (item.color){
                [cell.imageView setTintColor:item.color];
            }else{
                [cell.imageView setTintColor:[UIColor whiteColor]];
            }
            cell.imageView.layer.cornerRadius = 0;
            
        }else{
            cell.imageView.image = [Helper imageFromColor:item.color];
            UIGraphicsBeginImageContextWithOptions(cellImageSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, cellImageSize.width, cellImageSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.imageView.layer.cornerRadius = cellImageSize.width/2;
        }
        cell.imageView.layer.masksToBounds = YES;
        
        
        //        if (indexPath.row+1 < [menuItems count]){
        //            MenuItem * itemNext = [menuItems objectAtIndex:indexPath.row+1];
        //            if (itemNext.type != headerType){
        //                UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(50, cell.bounds.size.height, self.view.bounds.size.width, 1)];
        //                bottomLineView.backgroundColor = [Helper getUIColorObjectFromHexString:@"#333333" alpha:1.0];
        //                [cell.contentView addSubview:bottomLineView];
        //            }
        //        }
    }
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // Draw top border only on first cell
    //    if (indexPath.row == 0) {
    //        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    //        topLineView.backgroundColor = [UIColor grayColor];
    //        [cell.contentView addSubview:topLineView];
    //    }
    //
    
    
    return cell;
}
//tableView functions
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItem * item = [menuItems objectAtIndex:indexPath.row];
    if (item.type == headerType){
        return 20.0;
    }else{
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem * item = [menuItems objectAtIndex:indexPath.row];
    if (item.type == headerType){
        return 20.0;
    }else{
        return 44.0;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItem * item = [menuItems objectAtIndex:indexPath.row];
    if (item.type == selectableType){
        [ApplicationViewController fakeMenuTap];
    }else{
        return;
    }
    if (item.function != nil){
        SEL mySelector = [item.function pointerValue];
        IMP imp = [self methodForSelector:mySelector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, mySelector);
        //executing function pointer
        return;
    }
    FestivalData *sharedFestivalData = [FestivalData sharedFestivalData];
    NSMutableArray* sessionsArray;
    if (item.stringType != nil){
        if ([item.stringType isEqualToString:@"location"]){
            sessionsArray = [NSMutableArray arrayWithArray:sharedFestivalData.locationMapToSessions[item.title]];
        }else if ([item.stringType isEqualToString:@"audience"]){
            
            sessionsArray = [NSMutableArray arrayWithArray:sharedFestivalData.audienceMapToSessions[item.title]];
        }else if([item.stringType isEqualToString:@"date"]){
            sessionsArray = [NSMutableArray arrayWithArray:sharedFestivalData.datesDict[item.title]];
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FilterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    vc.datesDict = [[NSMutableDictionary alloc] init];
    vc.orderOfInsertedDatesDict = [[NSMutableDictionary alloc] init];
    vc.sessionsArray = sessionsArray;
    [sharedFestivalData setDatesDict:vc.datesDict setOrderOfInsertedDatesDict:vc.orderOfInsertedDatesDict forSessions:vc.sessionsArray initializeEverything:NO modifyOrderOfInsertedDictKeysByAddingNumber:0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    [vc setTitle:item.title];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(IBAction)goBack:(id)sender  {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (!decelerate) {
//        [self scrollingFinish];
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self scrollingFinish];
}


#pragma mark - functions for menu
-(void)changeCity{
    [[Credentials sharedCredentials] clearFestivalData];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Festivals"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    [appDelegateTemp changeRootViewController:navigation animSize:1];
}
-(void)map{
    MapViewController * map = [[MapViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:map];
    [navController setViewControllers: @[map] animated: YES];
    map.sessionsArray = [FestivalData sharedFestivalData].sessionsArray;
    map.filterSessions = all;
    map.filterDate = @"All";
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [map navigationItem].leftBarButtonItem = backButton;
    
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];}
-(void)showPresenters{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:[FestivalData sharedFestivalData].presentersDict];
    [vc setPageTitle:@"Presenters"];
    [vc setSession:nil];
    [vc setType:@"speaker"];
    vc.setTheBackButton = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(void)showCompanies{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:[FestivalData sharedFestivalData].companiesDict];
    [vc setPageTitle:@"Companies"];
    [vc setSession:nil];
    [vc setType:@"company"];
    vc.setTheBackButton = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(void)showVolunteers{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:[FestivalData sharedFestivalData].volunteersDict];
    [vc setPageTitle:@"Volunteers"];
    [vc setSession:nil];
    [vc setType:@"volunteer"];
    vc.setTheBackButton = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(void)showAttendees{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:[FestivalData sharedFestivalData].attendeesDict];
    [vc setPageTitle:@"Attendees"];
    [vc setSession:nil];
    [vc setType:@"attendee"];
    vc.setTheBackButton = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(void) login{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    vc.setTheBackButton = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    back.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    [vc navigationItem].leftBarButtonItem = backButton;
    vc.delegate = self;
    [self.revealViewController presentViewController:navController animated:YES completion:^{
    }];
}
-(void)logout{
    [[Credentials sharedCredentials] logOut];
}

#pragma mark - Sign In Delegate
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end