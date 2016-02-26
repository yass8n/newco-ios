//
//  ConfirmationModalView.m
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "ConfirmationModalView.h"
#import "TTTAttributedLabel.h"
@interface ConfirmationModalView()
@property (strong, nonatomic) TTTAttributedLabel* modalTitleLabel;
@property (strong, nonatomic) UIView* modalContent;
@property (strong, nonatomic) UIButton* noButton;
@property (strong, nonatomic) UIButton* yesButton;

@end
@implementation ConfirmationModalView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSMutableAttributedString *)modalTitle yesText:(NSString*)yesText noText:(NSString*)noText imageColor:(UIColor*)imageColor{
    self = [super initWithFrame:frame];
    UIView *modalContainer = [[UIView alloc] initWithFrame:self.bounds];
    
    self.modalContent = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 modalContainer.frame.size.width,
                                                                 modalContainer.frame.size.height - 22)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    self.YTapThreshhold = screenHeight; //if they tap anywhere out of the modal it will disappear
    
    self.modalContent.backgroundColor = [UIColor whiteColor];
    self.modalContent.layer.cornerRadius = 3.0f;
    self.modalContent.layer.masksToBounds = YES;
    [modalContainer addSubview:self.modalContent];
    
    
    //adding image at top center
    UIView *modalImageContainer = [[UIView alloc] initWithFrame:CGRectMake((modalContainer.frame.size.width - 44)/2, -22, 44, 44)];
    modalImageContainer.layer.cornerRadius = modalImageContainer.frame.size.width / 2;
    modalImageContainer.layer.masksToBounds = YES;
    modalImageContainer.backgroundColor = [UIColor whiteColor];
    [modalContainer addSubview:modalImageContainer];
    
    UIImageView *modalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
    modalImageView.image = [modalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [modalImageView setTintColor:imageColor];
    modalImageView.layer.cornerRadius = modalImageView.frame.size.width/2;
    modalImageView.layer.masksToBounds = YES;
    [modalImageContainer addSubview:modalImageView];

    //adding title
    self.modalTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 25, self.modalContent.frame.size.width, 0)];
    self.modalTitleLabel.numberOfLines = 0;
    self.modalTitleLabel.minimumFontSize = 0;
    self.modalTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.modalTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.modalTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.modalTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.modalTitleLabel.textAlignment = NSTextAlignmentCenter;

    self.modalTitleLabel.attributedText = modalTitle;
    
    int numlines = [Helper lineCountForLabel:self.modalTitleLabel];
    CGRect labelFrame = self.modalTitleLabel.frame;
    labelFrame.size.height = numlines * 25;
    self.modalTitleLabel.frame = labelFrame;
    CGRect modalFrame = self.modalContent.frame;
    modalFrame.size.height = modalFrame.size.height + (numlines - 2) * 20;
    self.modalContent.frame = modalFrame;
    [self.modalContent addSubview:self.modalTitleLabel];
    
    
    self.noButton = [[UIButton alloc] initWithFrame:CGRectMake(1, self.modalContent.frame.size.height - 41, (self.modalContent.frame.size.width/2) - 1, 40)];
    self.noButton.backgroundColor = [UIColor lightGrayColor];
    self.noButton.titleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 16.0f];
    [self.noButton setTitle:noText forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.layer.cornerRadius = 2.5f;
    self.noButton.layer.masksToBounds = YES;
    [self.noButton addTarget:self.baseModalDelegate action:@selector(noButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.modalContent addSubview:self.noButton];
    
    self.yesButton = [[UIButton alloc] initWithFrame:CGRectMake(2 + self.noButton.frame.size.width, self.modalContent.frame.size.height - 41, (self.modalContent.frame.size.width/2) - 2, 40)];
    self.yesButton.backgroundColor = [Helper getUIColorObjectFromHexString:@"#34495e" alpha:1.0];
    self.yesButton.titleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 16.0f];
    [self.yesButton setTitle:yesText forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yesButton.layer.cornerRadius = 2.5f;
    self.yesButton.layer.masksToBounds = YES;
    [self.yesButton addTarget:self.baseModalDelegate action:@selector(noButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.modalContent addSubview:self.yesButton];
    
    [self addSubview:modalContainer];
    
return self;

}
- (void)noButtonClicked:(UITapGestureRecognizer *)recognizer{
    [self hideModal];
    if (self.confirmationModalDelegate && [self.confirmationModalDelegate respondsToSelector: @selector(noButtonClicked)]) {
        [self.confirmationModalDelegate noButtonClicked];
    }
}
- (void)yesButtonClicked:(UITapGestureRecognizer *)recognizer{
    [self hideModal];
    if (self.confirmationModalDelegate && [self.confirmationModalDelegate respondsToSelector: @selector(yesButtonClicked)]) {
        [self.confirmationModalDelegate yesButtonClicked];
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
