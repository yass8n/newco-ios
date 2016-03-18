//
//  ShareModalView.h
//  now-sessions
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"
#import "BaseModal.h"
#import "Session.h"

typedef enum shareEnum{
    facebook = 0, twitter = 1, copy = 2, mail = 3, map = 4
}shareEnum;

typedef enum sharedByEnum{
    sharedByChoice = 0, sharedByFlow = 1
}sharedByEnum;

@protocol ShareModalDelegate <NSObject>

@optional
-(void)socialModalGone:(shareEnum)result session:(Session *)session ;
-(void)mapModalGone:(shareEnum)result session:(Session *)session ;

@end

@interface ShareModalView : BaseModal <TargetViewDelegate>
- (id)initWithFrame:(CGRect)frame title:(NSString *)modalTitle oneLineTitle:(BOOL)oneLineTitle sharedBy:(sharedByEnum)note;
-(id)initMapShareWithFrame:(CGRect)frame;
@property (nonatomic, weak) id<ShareModalDelegate> shareModalDelegate;
@property (nonatomic, strong) Session *session;
@end