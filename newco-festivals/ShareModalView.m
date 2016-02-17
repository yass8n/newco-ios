//
//  ShareModalView.m
//  newco-IOS
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 Newco. All rights reserved.
//

#import "ShareModalView.h"
@interface ShareModalView ()
@property (nonatomic, assign) shareEnum share;
@property (nonatomic, assign) sharedByEnum sharedBy;
@end
@implementation ShareModalView


- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSString *)modalTitle oneLineTitle:(BOOL)oneLineTitle sharedBy:(sharedByEnum)note{
    self = [super initWithFrame:frame];
    if (self) {
        self.sharedBy = note;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        self.YTapThreshhold = screenHeight; //if they tap anywhere out of the modal it will disappear
        UIView *modalContainer = [[UIView alloc] initWithFrame:self.bounds];
        UIView *modalContent = [[UIView alloc] initWithFrame:CGRectMake(0,22,modalContainer.frame.size.width,
                                                                        modalContainer.frame.size.height)];
        modalContent.backgroundColor = [UIColor whiteColor];
        modalContent.layer.cornerRadius = 3.0f;
        modalContent.layer.masksToBounds = YES;
        [modalContainer addSubview:modalContent];
        
        UIImage *image = [UIImage imageNamed:@"ex"];
        UIImageView* cancel = [[UIImageView alloc] initWithFrame:CGRectMake(modalContent.frame.size.width-15, 0, 15, 15)];
        cancel.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cancel setTintColor:[Helper getUIColorObjectFromHexString:modalGray alpha:1.0]];
        cancel.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(hideModal:)];
        [cancel addGestureRecognizer:singleFingerTap];
        [modalContainer addSubview:cancel];
        
        UILabel *modalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, modalContent.frame.size.width-40, 30)];
        modalTitleLabel.textColor = [Helper getUIColorObjectFromHexString:DARK_GRAY alpha:1.0];
        modalTitleLabel.text = modalTitle;
        modalTitleLabel.textAlignment = NSTextAlignmentCenter;
        [modalTitleLabel.text uppercaseString];
        int numTitleLines = 0;
        if (oneLineTitle){
            modalTitleLabel.adjustsFontSizeToFitWidth = YES;
            modalTitleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 18.0f];
        }else{
            modalTitleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 16.0f];
            modalTitleLabel.minimumFontSize = 0;
            modalTitleLabel.numberOfLines = 0;
            modalTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            numTitleLines = [Helper lineCountForLabel:modalTitleLabel];
            CGRect labelFrame = modalTitleLabel.frame;
            labelFrame.size.height = numTitleLines * 25;
            modalTitleLabel.frame = labelFrame;
            
        }
        
        [modalContent addSubview:modalTitleLabel];
        
        double containerSize = modalContainer.frame.size.width / 5;
        double array_x_shift[3] = {
            (modalContent.frame.size.width/2) - (modalContent.frame.size.width/3)+12,
            (modalContent.frame.size.width/2),
            (modalContent.frame.size.width/2) + (modalContent.frame.size.width/3)-12
            
        };
        NSArray *imageNames = [NSArray arrayWithObjects:@"facebook", @"twitter", @"link", nil];
        NSArray *names = [NSArray arrayWithObjects:@"Facebook", @"Twitter", @"Copy Link", nil];
        
        //        int y_shift = 10;
        //        if (!oneLineTitle){
        //            y_shift = 20;
        //        }
        //
        for (int i = 0; i < 3; i ++){
            CustomUIView *container = [[CustomUIView alloc]initWithFrame:CGRectMake(0.f, 0.f, containerSize, containerSize)];
            container.animating = YES;
            container.highlightedColor = [Helper getUIColorObjectFromHexString:GREEN alpha:1.0];
            container.delegate = self;
            [container setCenter:CGPointMake(array_x_shift[i] , (modalContent.frame.size.height/2) + 10)];
            container.layer.cornerRadius = 5;
            container.layer.borderWidth = 1.0;
            container.frame = CGRectInset(container.frame, -12, -12);
            [container.layer setBorderColor:[[Helper getUIColorObjectFromHexString:LIGHT_GRAY alpha:1.0] CGColor]];
            [modalContent addSubview:container];
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitleColor:[Helper getUIColorObjectFromHexString:GRAY alpha:1.0] forState:UIControlStateNormal];
            [_button setFrame:CGRectMake(0, 0, containerSize/2, containerSize/2)];
            [_button setCenter:CGPointMake( (container.frame.size.width/2), (container.frame.size.height/2)-5)];
            [_button setClipsToBounds:false];
            
            
            UIImage *image = [[UIImage imageNamed:[imageNames objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_button setImage:image forState:UIControlStateNormal];
            _button.tintColor = [Helper getUIColorObjectFromHexString:modalGray alpha:1.0];
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_button.frame.size.height * 1.75), container.frame.size.width, _button.frame.size.height)];
            titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.f];
            titleLabel.textColor = [Helper getUIColorObjectFromHexString:MEDIUM_GRAY alpha:1.0];
            titleLabel.text = [names objectAtIndex:i];
            titleLabel.lineBreakMode = UILineBreakModeClip; //prevent "..."
            titleLabel.textAlignment = UITextAlignmentCenter;
            //            titleLabel.adjustsFontSizeToFitWidth = YES;
            [container addSubview:titleLabel];
            _button.userInteractionEnabled = NO;
            [container addSubview:_button];
            container.tag = i;
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(clickedShare:)];
            [container addGestureRecognizer:singleFingerTap];
            if (!oneLineTitle){
                CGRect newFrame = container.frame;
                newFrame.origin.y = newFrame.origin.y + (numTitleLines - 1) * 20;
                [UIView animateWithDuration:.4 animations:^{
                    container.frame = newFrame;
                }];
            }
            
        }
        if (!oneLineTitle){
            CGRect newFrame = modalContent.frame;
            newFrame.size.height = newFrame.size.height + (numTitleLines - 1) * 20;
            [UIView animateWithDuration:.4 animations:^{
                modalContent.frame = newFrame;
            }];
        }
        [self addSubview:modalContainer];
        
    }
    return self;
}

-(void)clickedShare:(UITapGestureRecognizer *)recognizer{
    UIView* clickedView = recognizer.view;
    int tag = (int)clickedView.tag;
    if (tag == 0){
        self.share = facebook;
    }else if(tag == 1){
        self.share = twitter;
    }else if(tag ==2){
        self.share = copy;
    }
}

-(void)receivedTargetTapDone{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hideTheModal:.1];
        if(self.shareModalDelegate && [self.baseModalDelegate respondsToSelector: @selector(shareModalGone:session:sharedBy:)]) {
            [self.shareModalDelegate shareModalGone:self.share session:self.session sharedBy:self.sharedBy];
        }
    });
}
-(void)receivedTargetTapStart:(UIView*) view{
    NSArray *subviews = view.subviews;
    UIButton * b;
    UILabel * l;
    for(UIView *v in subviews){
        if ([v isKindOfClass:[UIButton class]] ) {
            b = (UIButton*) v;
        }else if ([v isKindOfClass:[UILabel class]] ) {
            l = (UILabel*) v;
            
        }
        [UIView animateWithDuration:.6 animations:^{
            l.textColor = [UIColor whiteColor];
            b.tintColor = [UIColor whiteColor];
        }];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end