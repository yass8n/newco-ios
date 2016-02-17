//
//  MenuItem.h
//  newco-IOS
//
//  Created by yassen aniss on 12/22/15.
//  Copyright © 2015 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    headerType,
    selectableType
} Type;
@interface MenuItem : NSObject
@property (strong, nonatomic)NSString * title;
@property (strong, nonatomic) NSString * cellIdentifier;
@property (strong, nonatomic) NSString * stringType;
@property (nonatomic, assign) Type type;
@property (strong, nonatomic)UIColor* color;
@property (strong, nonatomic)UIImage* icon;
@property (strong, nonatomic) NSValue* function;
@end