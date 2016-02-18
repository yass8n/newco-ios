//
//  FestivalsViewController.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import "FestivalsViewController.h"
#import "AppDelegate.h"
#import "WebService.h"
#import "FestivalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "Helper.h"
#include "SVProgressHUD.h"
#import "FestivalCellHeader.h"


@interface FestivalsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *festivalsTableView;
@end


@implementation FestivalsViewController{
    NSArray* activeFestivalsArray;
    NSArray* inactiveFestivalsArray;
}

static CGFloat FESTIVAL_HEIGHT = 90;
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}
-(void) registerTableCells{
    [self.festivalsTableView registerNib:[UINib nibWithNibName:@"FestivalCell" bundle:nil]forCellReuseIdentifier:@"festival_cell"];
    [self.festivalsTableView registerNib:[UINib nibWithNibName:@"FestivalCellHeader" bundle:nil]forCellReuseIdentifier:@"festival_cell_header"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD show];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
    self.navigationController.navigationBarHidden = YES;
    activeFestivalsArray = [[NSMutableArray alloc] init];
    inactiveFestivalsArray = [[NSMutableArray alloc] init];
    WebService * webService = [[WebService alloc] init];
    [webService fetchFestivals:^(NSArray *activeFestivals, NSArray*inactiveFestivals) {
        activeFestivalsArray = activeFestivals;
        inactiveFestivalsArray = inactiveFestivals;
        [self.festivalsTableView reloadData];
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].
        networkActivityIndicatorVisible = NO;
    }];
    
    [self.festivalsTableView setShowsHorizontalScrollIndicator:NO];
    [self.festivalsTableView setShowsVerticalScrollIndicator:NO];
    [self registerTableCells];
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView functions

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FESTIVAL_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FESTIVAL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FestivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"festival_cell" forIndexPath:indexPath];
    NSDictionary * festival;
    if (indexPath.section == 0){
        festival = [activeFestivalsArray objectAtIndex:indexPath.row];
    }else{
        festival = [inactiveFestivalsArray objectAtIndex:indexPath.row];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[festival objectForKey:@"hero_image"]]
                  placeholderImage:[Helper imageFromColor:[UIColor myPlaceHolderColor]]];
    
    BOOL needs_image_info = [[festival objectForKey:@"needs_image_info"] boolValue];
   
    if (needs_image_info){
        cell.title.hidden = NO;
        cell.title.text = [[festival objectForKey:@"city"] uppercaseString];
        cell.title.textColor = [UIColor whiteColor];
        cell.logo.hidden = NO;
    }else{
        cell.title.hidden = YES;
        cell.logo.hidden = YES;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * festival;
    if (indexPath.section == 0){
       festival = [activeFestivalsArray objectAtIndex:indexPath.row];
    }else{
        festival = [inactiveFestivalsArray objectAtIndex:indexPath.row];
    }
     AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    [[Credentials sharedCredentials] setFestival:festival];

    [appDelegateTemp changeRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController] animSize:1.5];
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if ([activeFestivalsArray count] > 0 && [inactiveFestivalsArray count] > 0){
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return [activeFestivalsArray count];
    }else{
        return [inactiveFestivalsArray count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
       FestivalCellHeader* headerCell = [tableView dequeueReusableCellWithIdentifier:@"festival_cell_header"];
    if (section == 0){
        headerCell.title.text = @"CURRENT EVENTS";
    }else{
        headerCell.title.text = @"PAST EVENTS";
    }
    return headerCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

@end
