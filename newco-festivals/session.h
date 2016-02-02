//
//  session.h
//  newco-IOS
//
//  Created by yassen aniss 
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface session : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *note1;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *event_key;
@property (nonatomic, strong) NSString *event_type;
@property (nonatomic, strong) NSString *id_;
@property (nonatomic, strong) NSString *event_start;

-(id)initWithTitle:(NSString *)title event_key:(NSString *)event_key event_type:(NSString *)event_type id_:(NSString*)id_ status:(NSString*)status note1:(NSString*)note1 color:(NSString*)color event_start:(NSString*)event_start;
//description,event_key,name,address,event_start,event_end,event_type,id,speakers,artists,seats,audience

@end
