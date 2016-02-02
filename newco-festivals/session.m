//
//  session.m
//  newco-IOS
//
//  Created by yassen aniss 
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "session.h"

@implementation session
-(id)initWithTitle:(NSString *)title event_key:(NSString *)event_key event_type:(NSString *)event_type id_:(NSString*)id_ status:(NSString*)status note1:(NSString*)note1 color:(UIColor*)color event_start:(NSString*)event_start{
    self = [super init];
    if (self) {
        self.title = title;
        self.event_key = event_key;
        self.id_ = id_;
        self.status = status;
        self.note1 = note1;
        self.event_start = event_start;
        self.color = color;
    }
    return self;
}
@end

