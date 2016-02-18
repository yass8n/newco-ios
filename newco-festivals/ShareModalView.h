//
//  ShareModalView.h
//  newco-IOS
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"
#import "BaseModal.h"
#import "Session.h"

typedef enum shareEnum{
    facebook = 0, twitter = 1, copy = 2
}shareEnum;

typedef enum sharedByEnum{
    sharedByChoice = 0, sharedByFlow = 1
}sharedByEnum;

@protocol ShareModalDelegate <NSObject>

@optional
-(void)shareModalGone:(shareEnum)result session:(Session *)session ;
@end

@interface ShareModalView : BaseModal <TargetViewDelegate>
- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSString *)modalTitle oneLineTitle:(BOOL)oneLineTitle sharedBy:(sharedByEnum)note;
@property (nonatomic, weak) id<ShareModalDelegate> shareModalDelegate;
@property (nonatomic, strong) Session *session;
@end