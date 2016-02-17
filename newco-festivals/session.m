//
//  session.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "Session.h"
#import "Helper.h"
@implementation Session
-(id)initWithTitle:(NSString *)title event_key:(NSString *)event_key event_type:(NSString *)event_type id_:(NSString*)id_ status:(NSString*)status note1:(NSString*)note1 color:(UIColor*)color event_start:(NSDate*)event_start event_end:(NSDate*)event_end address: (NSString*)address audience: (NSString*)audience speakers: (NSArray*) speakers companies: (NSArray*) companies description: (NSString*) description {
    self = [super init];
    if (self) {
        self.title = title;
        self.event_key = event_key;
        self.id_ = id_;
        self.status = status;
        self.note1 = note1;
        self.event_start = event_start;
        self.event_end = event_end;
        self.event_type = event_type;
        self.color = color;
        self.start_time = [Helper myDateToFormat:self.event_start withFormat:@"h:mm a"];
        self.worded_date = [Helper myDateToFormat:self.event_start withFormat:@"EEE, MMM d"];
        self.end_time = [Helper myDateToFormat:self.event_end withFormat:@"h:mm a"];
        self.desc = description;
        self.audience = audience;
        self.address = address;
        self.companies = companies;
        self.speakers = speakers;
        self.enabled = YES;
        self.picked = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;
    _title = [coder decodeObjectForKey:@"title"];
    _event_key = [coder decodeObjectForKey:@"event_key"];
    _id_ = [coder decodeObjectForKey:@"id_"];
    _status = [coder decodeObjectForKey:@"status"];
    _note1 = [coder decodeObjectForKey:@"note1"];
    _event_start = [coder decodeObjectOfClass:[NSDate class]forKey:@"event_start"];
    _event_end = [coder decodeObjectOfClass:[NSDate class]forKey:@"event_end"];
    _event_type =[coder decodeObjectForKey:@"event_type"];
    _color = [coder decodeObjectForKey:@"color"];
    _start_time = [coder decodeObjectForKey:@"start_time"];
    _worded_date = [coder decodeObjectForKey:@"worded_date"];
    _end_time = [coder decodeObjectForKey:@"end_time"];
    _desc = [coder decodeObjectForKey:@"desc"];
    _audience = [coder decodeObjectForKey:@"audience"];
    _address = [coder decodeObjectForKey:@"address"];
    _companies = [coder decodeObjectOfClass:[NSArray class]forKey:@"companies"];
    _speakers = [coder decodeObjectOfClass:[NSArray class]forKey:@"speakers"];
    _enabled = [coder decodeBoolForKey:@"enabled"];
    _picked = [coder decodeBoolForKey:@"picked"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.title != nil)  [coder encodeObject:self.title forKey:@"title"];
    if (self.event_key != nil)  [coder encodeObject:self.event_key forKey:@"event_key"];
    if (self.id_ != nil) [coder encodeObject:self.id_ forKey:@"id_"];
    if (self.status != nil)  [coder encodeObject:self.status forKey:@"status"];
    if (self.note1 != nil)  [coder encodeObject:self.note1 forKey:@"note1"];
    if (self.event_start != nil)  [coder encodeObject:self.event_start forKey:@"event_start"];
    if (self.event_end != nil)  [coder encodeObject:self.event_end forKey:@"event_end"];
    if (self.event_type != nil)  [coder encodeObject:self.event_type forKey:@"event_type"];
    if (self.color != nil)  [coder encodeObject:self.color forKey:@"color"];
    if (self.start_time != nil)  [coder encodeObject:self.start_time forKey:@"start_time"];
    if (self.worded_date != nil)  [coder encodeObject:self.worded_date forKey:@"worded_date"];
    if (self.end_time != nil)  [coder encodeObject:self.end_time forKey:@"end_time"];
    if (self.desc != nil)  [coder encodeObject:self.desc forKey:@"desc"];
    if (self.audience != nil)  [coder encodeObject:self.audience forKey:@"audience"];
    if (self.address != nil) [coder encodeObject:self.address forKey:@"address"];
    if (self.companies != nil)  [coder encodeObject:self.companies forKey:@"companies"];
    if (self.speakers != nil)  [coder encodeObject:self.speakers forKey:@"speakers"];
    [coder encodeBool:self.enabled forKey:@"enabled"];
    [coder encodeBool:self.picked forKey:@"picked"];
    
}
@end
