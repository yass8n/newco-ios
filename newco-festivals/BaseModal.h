//
//  BaseModal.h
//  newco-IOS
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colors.h"
#import "Helper.h"
static NSString *const modalGray = @"#C0C0C0";
@protocol BaseModalDelegate; //forward declaration
@interface BaseModal : UIView
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic) int YTapThreshhold;
//+ (BOOL)isShowingModalOfClass:(Class)modalClass;
- (void) showModalAtCenter;
- (void) showModalAtTop:(BOOL)animated;
- (void) hideTheModal:(double) duration;
+ (void)hideAllModals;
- (void) showSuccessModal:(NSString*)title onWindow:(UIWindow*) window;
- (void)hideModal:(UITapGestureRecognizer *)recognizer;
- (void)hideModal;
@property (nonatomic, weak) id<BaseModalDelegate> baseModalDelegate;
@end

@protocol BaseModalDelegate <NSObject>

@optional
-(void) modalGone:(BaseModal*)modal;
-(void) touchedBelowYTapThreshhold;
@end