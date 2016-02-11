//
//  UserInitial.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "UserInitial.h"

@implementation UserInitial

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [[NSBundle mainBundle] loadNibNamed:@"UserInitial" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [[NSBundle mainBundle] loadNibNamed:@"UserInitial" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    return self;
}

- (IBAction)initial:(id)sender {
    NSLog(@"%@", self.username);
}
@end
