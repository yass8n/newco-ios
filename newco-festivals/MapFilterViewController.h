//
//  MapFilterViewController.h
//  now-sessions
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"
typedef enum filterSessionEnum{
    all = 0, my = 1
}filterSessionEnum;

@protocol MapFilterDelegate <NSObject>

@required
-(void)setLocalFilters:(filterSessionEnum)filterSessions filterDate:(NSString*)filterDate sessionsArray:(NSMutableArray*)sessionsArray;

@end
@interface MapFilterViewController : ApplicationViewController
@property (nonatomic, weak) id<MapFilterDelegate> delegate;
@property (nonatomic) filterSessionEnum filterSessions;
@property (strong, nonatomic) NSString* filterDate;
@end