//
//  MapViewController.m
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "MapViewController.h"
#import "Helper.h"

@interface MapViewController ()
@property (strong, nonatomic) MGLMapView * mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.frame];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                            zoomLevel:12
                             animated:NO];
    [self.view addSubview:self.mapView];    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    // Declare the marker `hello` and set its coordinates, title, and subtitle
    MGLPointAnnotation *hello = [[MGLPointAnnotation alloc] init];
    hello.coordinate = CLLocationCoordinate2DMake(40.7326808, -73.9843407);
    hello.title = @"Hello world!";
    hello.subtitle = @"Welcome to my marker";
    // Add marker `hello` to the map
    [self.mapView addAnnotation:hello];
}
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    // Try to reuse the existing ‘pisa’ annotation image, if it exists
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"pisa"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here
    if ( ! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage * image = [UIImage imageNamed:@"map"];
        
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, image.CGImage);
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
      

        
        // The anchor point of an annotation is currently always the center. To
        // shift the anchor point to the bottom of the annotation, the image
        // asset includes transparent bottom padding equal to the original image
        // height.
        //
        // To make this padding non-interactive, we create another image object
        // with a custom alignment rect that excludes the padding.
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:img reuseIdentifier:@"pisa"];
    }
    
    return annotationImage;
}
- (CGFloat)mapView:(nonnull MGLMapView *)mapView
alphaForShapeAnnotation:(nonnull MGLShape *)annotation{
    return 1.0;
}
- (nonnull UIColor *)mapView:(nonnull MGLMapView *)mapView
strokeColorForShapeAnnotation:(nonnull MGLShape *)annotation{
    return [UIColor orangeColor];
}
- (nonnull UIColor *)mapView:(nonnull MGLMapView *)mapView
fillColorForPolygonAnnotation:(nonnull MGLPolygon *)annotation{
    return [UIColor blueColor];
}
- (void)mapView:(nonnull MGLMapView *)mapView
didSelectAnnotation:(nonnull id<MGLAnnotation>)annotation{
    NSLog(@"HERRRR 2");

}
- (void)mapView:(nonnull MGLMapView *)mapView
tapOnCalloutForAnnotation:(nonnull id<MGLAnnotation>)annotation{
    NSLog(@"HERRRR 2");
}

// Allow markers callouts to show when tapped
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
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
