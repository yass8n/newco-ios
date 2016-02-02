//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ViewController.h"
#import "SessionCell.h"

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
    self->sessionTableView.frame = CGRectMake(0,0,100,30);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SessionCell * session_cell = [tableView dequeueReusableCellWithIdentifier:@"session_cell"];
    session_cell.title.text = [sessionsArray[indexPath.row] title];
    session_cell.note1.text = @"Note 2";
    session_cell.note2.text = @"Note 1";
    session_cell.status.text = @"FULL";
    session_cell.time.text = @"9:00 AM";
    return session_cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSString *cellText = [self.instructionDescription objectAtIndex:indexPath.row];
    //    UIFont *cellFont = [UIFont fontWithName:@"Arial" size:15];
    //    CGSize constraintSize = CGSizeMake(320.0f, MAXFLOAT);
    //    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    //
    return 200.0;
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
        [s setTitle:@"Title"];
        [sessionsArray addObject: s];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
