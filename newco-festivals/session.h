//
//  session.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"

@interface Session : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *worded_date;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *note1;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *event_key;
@property (nonatomic, strong) NSString *event_type;
@property (nonatomic, strong) NSString *id_;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *audience;
@property (nonatomic, strong) NSArray *speakers;
@property (nonatomic, strong) NSArray *companies;
@property (nonatomic, strong) NSDate *event_start;
@property (nonatomic, strong) NSDate *event_end;

-(id)initWithTitle:(NSString *)title event_key:(NSString *)event_key event_type:(NSString *)event_type id_:(NSString*)id_ status:(NSString*)status note1:(NSString*)note1 color:(NSString*)color event_start:(NSDate*)event_start event_end:(NSDate*)event_end address: (NSString*)address audience: (NSString*)audience speakers: (NSArray*) speakers companies: (NSArray*) companies description: (NSString*) description;

@end
