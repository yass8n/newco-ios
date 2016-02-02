//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *sessionsArray;
    IBOutlet UITableView *sessionTableView;
    IBOutlet UISegmentedControl *segmentedControl;
}


- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [sessionsArray count];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * session_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"session_cell"];
    session_cell.textLabel.text = [sessionsArray[indexPath.row] title];
    return session_cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [sessionTableView setDataSource:self];
    [self adjustUI];
    [self addDataToTable];
}
- (void) adjustUI{
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];

}
- (void) addDataToTable{
    sessionsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        session *s = [[session alloc] init];
        [s setTitle:@"you already know doh"];
        [sessionsArray addObject: s];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
