//
//  FilterViewController.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"

@interface FilterViewController : ApplicationViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* sessionsArray;
@property (strong, nonatomic) NSMutableDictionary* sessionsDict;
@property (strong, nonatomic) NSMutableDictionary* datesDict;
@property (strong, nonatomic) NSMutableDictionary*sessionsAtDateAndTime;
@property (strong, nonatomic) NSMutableDictionary* orderOfInsertedDatesDict;
@property (strong, nonatomic) NSMutableDictionary* locationColorDict;

@end
