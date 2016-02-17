//
//  BaseModal.m
//  newco-IOS
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 Newco. All rights reserved.
//

#import "BaseModal.h"

@interface BaseModal()
@property (nonatomic)NSUInteger numberOfOverlayTaps;
@end
@implementation BaseModal
static NSMutableArray * visibleModals;

-(BaseModal*)initWithFrame:(CGRect)frame{
    BaseModal * modal = [super initWithFrame:frame];
    modal.numberOfOverlayTaps = 0;
    if (!visibleModals){
        visibleModals = [[NSMutableArray alloc]init];
    }
    [visibleModals addObject:modal];
    return modal;
}
//+(BOOL)isShowingModalOfClass:(Class)modalClass{
//    NSMutableArray * visibleModalsCopy = [visibleModals copy];
//    for (int i = 0; i < [visibleModalsCopy count]; i++){
//        BaseModal * modal = [visibleModalsCopy objectAtIndex:i];
//        if ([modal isKindOfClass:modalClass]){
//            return YES;
//        }
//    }
//    return NO;
//}

+(void)hideAllModals{
    NSMutableArray * visibleModalsCopy = [visibleModals copy];
    for (int i = 0; i < [visibleModalsCopy count]; i++){
        BaseModal * modal = [visibleModalsCopy objectAtIndex:i];
        [modal removeWithoutCallBack:.2];
    }
}
-(void)removeWithoutCallBack:(double)duration{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 120;
        self.frame = frame;
        self.alpha = 0;
        [self.overlayView setAlpha:0];
    } completion:^(BOOL finished) {
        [visibleModals removeLastObject];
        [self removeFromSuperview];
    }];
}
- (void) showSuccessModal:(NSString*)title onWindow:(UIWindow*) window{
    double window_width = self.window.frame.size.width;
    double window_height = self.window.frame.size.height;
    UIView *modalContainer = [[UIView alloc] initWithFrame:self.bounds];
    modalContainer.userInteractionEnabled = NO;
    UIView *modalBorder = [[UIView alloc] initWithFrame:CGRectMake(0,22,modalContainer.frame.size.width,
                                                                   modalContainer.frame.size.height)];
    modalBorder.backgroundColor = [Helper getUIColorObjectFromHexString:LIGHT_GRAY alpha:1.0];
    modalBorder.layer.cornerRadius = 5.0f;
    modalBorder.layer.masksToBounds = YES;
    
    UIView *modalContent = [[UIView alloc] initWithFrame:CGRectMake(1,1,modalContainer.frame.size.width-2,
                                                                    modalContainer.frame.size.height-2)];
    modalContent.backgroundColor = [UIColor whiteColor];
    modalContent.layer.cornerRadius = 5.0f;
    modalContent.layer.masksToBounds = YES;
    
    [modalBorder addSubview:modalContent];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, modalContent.frame.size.width, 20)];
    titleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 14.0f];
    titleLabel.textColor = [Helper getUIColorObjectFromHexString:DARK_GRAY alpha:1.0];
    titleLabel.text = title;
    titleLabel.lineBreakMode = UILineBreakModeClip; //prevent "..."
    titleLabel.textAlignment = UITextAlignmentCenter;
    //            titleLabel.adjustsFontSizeToFitWidth = YES;
    [modalContent addSubview:titleLabel];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, modalContent.frame.size.width * .33, modalContent.frame.size.height * .33)];
    [imageView setCenter:CGPointMake(modalContent.frame.size.width/2, (modalContent.frame.size.height/3) + titleLabel.frame.size.height + 6)];
    UIImage* image = [UIImage imageNamed:@"check_plain"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; //allows us to change color of image
    imageView.image = image;
    imageView.tintColor = [Helper getUIColorObjectFromHexString:LIGHT_GRAY alpha:1.0];
    
    UIView * imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, modalContent.frame.size.width * .5, modalContent.frame.size.height * .5)];
    [imageContainer setCenter:CGPointMake(modalContent.frame.size.width/2, (modalContent.frame.size.height/3) + titleLabel.frame.size.height + 6)];
    imageContainer.layer.borderWidth = 1;
    imageContainer.layer.cornerRadius = imageContainer.frame.size.width/2;
    [imageContainer.layer setBorderColor:[[Helper getUIColorObjectFromHexString:LIGHT_GRAY alpha:1.0] CGColor]];
    
    [modalContent addSubview:imageContainer];
    [modalContent addSubview:imageView];
    [modalContainer addSubview:modalBorder];
    [self addSubview:modalContainer];
    [window addSubview:self];
    [self showModalAtTop:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hideTheModalFadeAway:.4];
    });
}
-(void)hideTheModalFadeAway:(double) duration{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.baseModalDelegate && [self.baseModalDelegate respondsToSelector: @selector(modalGone:)]) {
            [self.baseModalDelegate modalGone:self];
        }
        [visibleModals removeLastObject];
        [self removeFromSuperview];
    }];
}

-(void)hideTheModal:(double) duration{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 120;
        self.frame = frame;
        self.alpha = 0;
        [self.overlayView setAlpha:0];
    } completion:^(BOOL finished) {
        if(self.baseModalDelegate && [self.baseModalDelegate respondsToSelector: @selector(modalGone:)]) {
            [self.baseModalDelegate modalGone:self];
        }
        [visibleModals removeLastObject];
        [self removeFromSuperview];
    }];
}
- (void)showModalAtCenter
{
    [self setModalReadyForAnimation];
    [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.origin.y = (self.window.frame.size.height - self.frame.size.height) / 2;
        self.frame = frame;
        self.alpha = 1;
        [self.overlayView setAlpha:0.8];
    }completion:nil];
    
}
-(void)setModalReadyForAnimation{
    // Screen overlay
    self.overlayView = [[UIView alloc] initWithFrame:self.window.bounds];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideModalIfSatisfiesThreshhold:)];
    [self.overlayView addGestureRecognizer:singleFingerTap];
    self.overlayView.backgroundColor = [Helper getUIColorObjectFromHexString:@"#222" alpha:1.0];
    self.overlayView.alpha = 0;
    self.alpha = 0;
    [self.window insertSubview:self.overlayView belowSubview:self];
    
}
- (void)showModalAtTop:(BOOL) animated
{
    if (animated){
        [self setModalReadyForAnimation];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.frame;
            frame.origin.y = (self.window.frame.size.height - self.frame.size.height) / 3.5;
            self.frame = frame;
            self.alpha = 1;
            [self.overlayView setAlpha:0.8];
        }completion:nil];
    }else{
        CGRect frame = self.frame;
        frame.origin.y = (self.window.frame.size.height - self.frame.size.height) / 3.5;
        self.frame = frame;
        self.alpha = 1;
    }
}
- (void)hideModal{
    [self hideTheModal:.2];
}
-(void)hideModalIfSatisfiesThreshhold:(UITapGestureRecognizer *)recognizer{
    CGPoint tapPoint = [recognizer locationInView:self.overlayView];
    int tapY = (int) tapPoint.y;
    if (tapY < self.YTapThreshhold){
        [self hideTheModal:.2];
    }else if (self.baseModalDelegate && [self.baseModalDelegate respondsToSelector: @selector(touchedBelowYTapThreshhold)]) {
        [self.baseModalDelegate touchedBelowYTapThreshhold];
    }
}
-(void)hideModal:(UITapGestureRecognizer *)recognizer{
    [self hideTheModal:.2];
}

@end