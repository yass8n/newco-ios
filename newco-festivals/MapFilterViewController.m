//
//  MapFilterViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "MapFilterViewController.h"
#import "FilterView.h"

@interface MapFilterViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray* sessionFilterViews;
@property (strong, nonatomic) NSMutableArray* datesFilterViews;
//@property (strong, nonatomic) IBOutlet CustomUIView *sessionView;
//@property (strong, nonatomic) IBOutlet CustomUIView *dateView;
@end

@implementation MapFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    //setting sessions
    self.sessionFilterViews = [[NSMutableArray alloc]init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text =  @"Map Filter";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    int X = 8;
    int Y = 8;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, 100, 18)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 16.0];
    label.text = @"General Filter";
    [self.scrollView addSubview:label];
    Y+=20;
    FilterView *view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
    view.title.text = @"All Sessions";
    view.filterSession = all;
    view.frame = frame;
    view.layer.borderColor = [UIColor myLightGray].CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 0;
    Y+=view.frame.size.height;
    view.check.hidden = YES;
    UIGestureRecognizer *changeFilter = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(changeSessionFilter:)];
    changeFilter.enabled = YES;
    changeFilter.cancelsTouchesInView = YES;
    [view addGestureRecognizer:changeFilter];
    [self.sessionFilterViews addObject:view];
    [self.scrollView addSubview:view];
    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count] > 0){
        view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
        view.title.text = @"My Sessions";
        view.filterSession = my;
        frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
        view.frame = frame;
        view.layer.borderColor = [UIColor myLightGray].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 0;
        Y+=view.frame.size.height;
        view.check.hidden = YES;
        changeFilter = [[UITapGestureRecognizer alloc]
                        initWithTarget:self action:@selector(changeSessionFilter:)];
        changeFilter.enabled = YES;
        changeFilter.cancelsTouchesInView = YES;
        [view addGestureRecognizer:changeFilter];
        [self.sessionFilterViews addObject:view];
        [self.scrollView addSubview:view];
    }
    
    //setting dates
    self.datesFilterViews = [[NSMutableArray alloc]init];
    Y+=40;
    label = [[UILabel alloc] initWithFrame:CGRectMake(8, Y, 100, 18)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName: @"ProximaNova-Regular" size: 16.0];
    label.text = @"Date Filter";
    [self.scrollView addSubview:label];
    
    Y+=20;
    view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
    view.title.text = @"All";
    frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
    view.frame = frame;
    view.layer.borderColor = [UIColor myLightGray].CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 0;
    Y+=view.frame.size.height;
    view.check.hidden = YES;
    changeFilter = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(changeDateFilter:)];
    changeFilter.enabled = YES;
    changeFilter.cancelsTouchesInView = YES;
    [view addGestureRecognizer:changeFilter];
    [self.datesFilterViews addObject:view];
    [self.scrollView addSubview:view];

    FestivalData *sharedFestivalData = [FestivalData sharedFestivalData];
    NSArray * keys = sharedFestivalData.datesDict.allKeys;
    NSMutableArray * fakeDatesToGetThemSorted = [[NSMutableArray alloc]init];
    NSDictionary * order = @{
                             @"Mon": @"1",
                             @"Tue": @"2",
                             @"Wed": @"3",
                             @"Thu": @"4",
                             @"Fri": @"5",
                             @"Sat": @"6",
                             @"Sun": @"7",};
    for (int i = 0; i < [keys count]; i ++){
        NSString * num = [order objectForKey:[[keys objectAtIndex:i]substringWithRange:NSMakeRange(0, 3)]];
        [fakeDatesToGetThemSorted addObject:[NSString stringWithFormat:@"%@%@", num, [keys objectAtIndex:i]]];
    }
    NSArray * datesDict = [fakeDatesToGetThemSorted sortedArrayUsingSelector:@selector(compare:)];
    if ([datesDict count] > 0){
        for (int i = 0; i < datesDict.count; i++){
            NSString * date = [datesDict objectAtIndex:i];
            view = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
            view.title.text = [date substringFromIndex:1];
            frame = CGRectMake(X, Y, self.scrollView.frame.size.width-(X*2), 40);
            view.frame = frame;
            view.layer.borderColor = [UIColor myLightGray].CGColor;
            view.layer.borderWidth = 1.0;
            view.layer.cornerRadius = 0;
            Y+=view.frame.size.height;
            view.check.hidden = YES;
            changeFilter = [[UITapGestureRecognizer alloc]
                            initWithTarget:self action:@selector(changeDateFilter:)];
            changeFilter.enabled = YES;
            changeFilter.cancelsTouchesInView = YES;
            [view addGestureRecognizer:changeFilter];
            [self.datesFilterViews addObject:view];
            [self.scrollView addSubview:view];
        }
        [self updateDateViewsChecks];
    }
    
    [self.view addSubview:self.scrollView];
    [self updateSessionViewsChecks];
}
-(void)changeDateFilter:(UITapGestureRecognizer *) sender{
    FilterView * view = (FilterView*)[sender view];
    self.filterDate = view.title.text;
    [self updateDateViewsChecks];
    
}
-(void)changeSessionFilter:(UITapGestureRecognizer *) sender{
    FilterView * view = (FilterView*)[sender view];
    self.filterSessions = view.filterSession;
    [self updateSessionViewsChecks];
 
}
-(void)updateDateViewsChecks{
    for (int i = 0; i < [self.datesFilterViews count]; i++){
        FilterView * v = [self.datesFilterViews objectAtIndex:i];
        if ([v.title.text isEqual:self.filterDate]){
            v.check.hidden = NO;
            [Helper buttonTappedAnimation:v];
            [Helper buttonTappedAnimation:v.check];
        }else{
            v.check.hidden = YES;
        }
    }
}
-(void)updateSessionViewsChecks{
    for (int i = 0; i < [self.sessionFilterViews count]; i++){
        FilterView * v = [self.sessionFilterViews objectAtIndex:i];
        if (v.filterSession == self.filterSessions){
            v.check.hidden = NO;
            [Helper buttonTappedAnimation:v];
            [Helper buttonTappedAnimation:v.check];
        }else{
            v.check.hidden = YES;
        }
    }
}
-(IBAction)done:(id)sender  {
    __block NSMutableArray * sessionsArray;
    __block NSMutableArray * finalSessionsArray = [[NSMutableArray alloc]init];
    if (self.filterSessions == all){
        sessionsArray = [FestivalData sharedFestivalData].sessionsArray;
        if (![self.filterDate isEqual:@"All"]){
            for(int i = 0; i <[sessionsArray count]; i++){
                Session* session = [sessionsArray objectAtIndex:i];
                if ([session.worded_date isEqualToString:self.filterDate]){
                    [finalSessionsArray addObject:session];
                }
            }
        }else{
            finalSessionsArray = sessionsArray;
        }
        if (self.delegate){
            [self.delegate setLocalFilters:self.filterSessions filterDate:self.filterDate sessionsArray:finalSessionsArray];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self goBack];
        });
    }else if(self.filterSessions == my){
        sessionsArray = [[NSMutableArray alloc]init];
        WebService * webService = [[WebService alloc] initWithView:self.view];
        [webService fetchSesionsForUser:^(NSArray *allSessionTransactions) {
            for (int i =0; i < [allSessionTransactions count]; i++){
                NSMutableDictionary* sessionTransaction = [allSessionTransactions objectAtIndex:i];
                NSString* username = [[Credentials sharedCredentials].currentUser objectForKey:@"username"];
                if ([[sessionTransaction objectForKey:@"username"] isEqual:username]){
                    [sessionsArray addObject:[[FestivalData sharedFestivalData].sessionsDict objectForKey:[sessionTransaction objectForKey:@"event_key"]]];
                }
            }
            if (![self.filterDate isEqual:@"All"]){
                for(int i = 0; i <[sessionsArray count]; i++){
                    Session* session = [sessionsArray objectAtIndex:i];
                    if ([session.worded_date isEqualToString:self.filterDate]){
                        [finalSessionsArray addObject:session];
                    }
                }
            }else{
                finalSessionsArray = sessionsArray;
            }
            if (self.delegate){
                [self.delegate setLocalFilters:self.filterSessions filterDate:self.filterDate sessionsArray:finalSessionsArray];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self goBack];
            });
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
