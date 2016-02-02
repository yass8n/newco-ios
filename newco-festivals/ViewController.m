//
//  ViewController.m
//  newco-IOS
//
//  Created by yassen aniss .
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ViewController.h"
#import "SessionCell.h"

@interface ViewController ()
@property (strong) SessionCell *prototypeCell;
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
    session_cell.note1.text = [sessionsArray[indexPath.row] note1];
    session_cell.status.text = [sessionsArray[indexPath.row] status];
    session_cell.time.text = [sessionsArray[indexPath.row] time];
    CGRect newFrame = session_cell.note1.frame;
    
    [CustomViewController setBorder:session_cell.outerContainer width:1.0 radius:8 color:[UIColor whiteColor]];
     [CustomViewController setBorder:session_cell.statusContainer width:1.0 radius:4 color:[UIColor blackColor]];
    return session_cell;
}
- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
    return [text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat titleLabelHeight = [self sizeOfLabel:self.prototypeCell.title withText:[sessionsArray[indexPath.row] title]].height;
    CGFloat timeLabelHeight = [self sizeOfLabel:self.prototypeCell.time withText:[sessionsArray[indexPath.row] time]].height;
    CGFloat noteLabelHeight = [self sizeOfLabel:self.prototypeCell.title withText:[sessionsArray[indexPath.row] note1]].height;
    CGFloat padding = self.prototypeCell.outerContainer.frame.origin.y;
    
    CGFloat combinedHeight = padding + titleLabelHeight + padding + timeLabelHeight + padding + noteLabelHeight + padding;
    return combinedHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [sessionTableView setDataSource:self];
    [self adjustUI];
    [self addDataToTable];
    self.prototypeCell = [self->sessionTableView dequeueReusableCellWithIdentifier:@"session_cell"];
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
        [s setTime:@"9:00 AM"];
        [s setNote1:@"Just testingJust testingJust testingJust"];
        [s setStatus:@"Almost Full"];
        [sessionsArray addObject: s];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
