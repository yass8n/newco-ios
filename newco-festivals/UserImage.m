//
//  UserImage.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import "UserImage.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
@implementation UserImage


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}
-(void)setup{
    [[NSBundle mainBundle] loadNibNamed:@"UserImage" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    [self stretchToSuperView:self.view];
    UITapGestureRecognizer *imageTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(goToProfile:)];
    imageTap.delaysTouchesBegan = NO;
    imageTap.delaysTouchesEnded = NO;
    [self addGestureRecognizer:imageTap];
}

- (void) stretchToSuperView:(UIView*) view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSString *formatTemplate = @"%@:|[view]|";
    for (NSString * axis in @[@"H",@"V"]) {
        NSString * format = [NSString stringWithFormat:formatTemplate,axis];
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:bindings];
        [view.superview addConstraints:constraints];
    }
    
}
//an event handling method
- (void)goToProfile:(UITapGestureRecognizer *)recognizer {
    if (self.type != nil){
        UIViewController * this = [self firstAvailableUIViewController];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        [vc setUser:self.user];
        [vc setType:self.type];
        [this.navigationController pushViewController:vc animated:YES];
    }
}


@end
