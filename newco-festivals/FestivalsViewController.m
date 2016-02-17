//
//  FestivalsViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import "FestivalsViewController.h"
#import "AppDelegate.h"
#import "WebService.h"
#import "FestivalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "Helper.h"
#include "SVProgressHUD.h"


@interface FestivalsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *festivalsTableView;
@end


@implementation FestivalsViewController{
    NSArray* festivalsArray;
}

static CGFloat FESTIVAL_HEIGHT = 90;

-(void) registerTableCells{
    [self.festivalsTableView registerNib:[UINib nibWithNibName:@"FestivalCell" bundle:nil]forCellReuseIdentifier:@"festival_cell"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD show];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
    self.navigationController.navigationBarHidden = YES;
    festivalsArray = [[NSMutableArray alloc] init];
    WebService * webService = [[WebService alloc] init];
    [webService fetchFestivals:^(NSArray *festivals) {
        festivalsArray = festivals;
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
    NSDictionary * festival = [festivalsArray objectAtIndex:indexPath.row];
    FestivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"festival_cell" forIndexPath:indexPath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[festival objectForKey:@"hero_image"]]
                  placeholderImage:[Helper imageFromColor:[UIColor myPlaceHolderColor]]];
    
    BOOL needs_image_info = [[festival objectForKey:@"needs_image_info"] boolValue];
   
    if (needs_image_info){
        cell.title.hidden = NO;
        cell.title.text = [festival objectForKey:@"city"];
        cell.title.textColor = [UIColor whiteColor];
    }else{
        cell.title.hidden = YES;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * festival = [festivalsArray objectAtIndex:indexPath.row];
     AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    [[Credentials sharedCredentials] setFestival:festival];

    [appDelegateTemp changeRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController] animSize:1.5];
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [festivalsArray count];
}


@end
