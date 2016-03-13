//
//  MapViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "MapViewController.h"
#import "SessionDetailViewController.h"
#import "MapFilterViewController.h"
@import GoogleMaps;

@interface MapViewController () <GMSMapViewDelegate, MapFilterDelegate>
@end

@implementation MapViewController{
    GMSMapView *mapView_;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    
    [self setUpMap:self.sessionsArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.navigationBar.frame.size.height)];
    titleLabel.text =  [NSString stringWithFormat:@"Map for Newco %@", [[Credentials sharedCredentials].festival objectForKey:@"city"]];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titleLabel;
    
    
    UIButton *filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(goToFilter:) forControlEvents:UIControlEventTouchUpInside];
    [filter setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem * filterButton = [[UIBarButtonItem alloc]initWithCustomView:filter];
    [self navigationItem].rightBarButtonItem = filterButton;
    
    // Do any additional setup after loading the view.
}
-(void)setLocalFilters:(filterSessionEnum)filterSessions filterDate:(NSString*)filterDate sessionsArray:(NSMutableArray*)sessionsArray{
    self.filterSessions = filterSessions;
    self.filterDate = filterDate;
    self.sessionsArray = sessionsArray;
}
-(void)setUpMap:(NSArray*)sessionsArray {
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    Session * sessionInitial = [self.sessionsArray objectAtIndex:0];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[sessionInitial.lat floatValue]
                                                            longitude:[sessionInitial.lon floatValue]
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    for (int i = 0; i < [self.sessionsArray count]; i++){
        Session * session = [self.sessionsArray objectAtIndex:i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([session.lat floatValue], [session.lon floatValue]);
        marker.title = session.title;
        marker.snippet = session.address;
        marker.icon = [GMSMarker markerImageWithColor:session.color];
        marker.userData = session;
        marker.tappable = YES;
        marker.map = mapView_;
    }
}
-(IBAction)goToFilter:(id)sender  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapFilterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MapFilter"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    Session *session = marker.userData;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
    [vc setSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    SessionCell* view = [[SessionCell alloc]init];
//    view.title.text = @"asdasdasd";
//    return view;
//}
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
