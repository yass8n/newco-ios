//
//  CustomUIView.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TargetViewDelegate <NSObject>

@optional
-(void)receivedTargetTapDone;
-(void)receivedTargetTapStart:(UIView*) view;
@end

@interface CustomUIView : UIView
    @property (strong, nonatomic) UIColor* highlightedColor;
    @property (strong, nonatomic) UIColor* unHighlightedColor;
    @property (nonatomic) BOOL animating;
    @property (nonatomic, weak) id<TargetViewDelegate> delegate;
@end
