//
//  MapViewController.h
//  now-sessions
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"
#import "MapFilterViewController.h"

@interface MapViewController : ApplicationViewController
@property (strong, nonatomic) NSMutableArray* sessionsArray;
@property (nonatomic) filterSessionEnum filterSessions;
@property (strong, nonatomic) NSString* filterDate;
@end
