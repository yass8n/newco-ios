//
//  FilterView.h
//  newco-festivals
//
//  Created by Yaseen Anss on 3/13/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapFilterViewController.h"

@interface FilterView : CustomUIView
@property (weak, nonatomic) IBOutlet UIImageView *check;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic) filterSessionEnum filterSession;
@end