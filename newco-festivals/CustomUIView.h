//
//  CustomUIView.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
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
@property (nonatomic) BOOL passTouchesToSubViews;
@property (nonatomic, weak) id<TargetViewDelegate> delegate;
@end
