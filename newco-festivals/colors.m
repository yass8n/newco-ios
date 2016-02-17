//
//  colors.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import "Helper.h"
#import "colors.h"

@implementation UIColor(myLightGray)

+(UIColor *)myLightGray{
    return [Helper getUIColorObjectFromHexString:@"#e9e9e9" alpha:1.0];

}
+(UIColor *) myRed{
    return [Helper getUIColorObjectFromHexString:@"#FFFC36" alpha:1.0];
}
+(UIColor *) myGreen{
    return [Helper getUIColorObjectFromHexString:@"#9EDF7D" alpha:1.0];

}
+(UIColor *) myBlue{
    return [Helper getUIColorObjectFromHexString:@"#B7CDFF" alpha:1.0];
 
}
+(UIColor *) myOrange{
    return [Helper getUIColorObjectFromHexString:@"#FFBC57" alpha:1.0];
 
}
+(UIColor *) myPurple{
    return [Helper getUIColorObjectFromHexString:@"#c488f6" alpha:1.0];
 
}
+(UIColor *) myTeal{
    return [Helper getUIColorObjectFromHexString:@"#88F4F6" alpha:1.0];
 
}
+(UIColor *) myYellow{
    return [Helper getUIColorObjectFromHexString:@"#FFFC36" alpha:1.0];

}
+(UIColor *) myPink{
    return [Helper getUIColorObjectFromHexString:@"#F688E0" alpha:1.0];
 
}
+(UIColor *) myDarkBlue{
    return [Helper getUIColorObjectFromHexString:@"#3b70e8" alpha:1.0];
 
}
+(UIColor *) myDarkRed{
    return [Helper getUIColorObjectFromHexString:@"#f23631" alpha:1.0];
  
}
+(UIColor *) myDarkPurple{
    return [Helper getUIColorObjectFromHexString:@"#86509b" alpha:1.0];
  
}
+(UIColor *) myDarkOrange{
    return [Helper getUIColorObjectFromHexString:@"#f47c15" alpha:1.0];
 
}
+(UIColor *) myMiddleBlue{
    return [Helper getUIColorObjectFromHexString:@"#3697FF" alpha:1.0];
  
}
+(UIColor *) myLimeGreen{
    return [Helper getUIColorObjectFromHexString:@"#62FF36" alpha:1.0];
  
}
+(UIColor *) myDarkTeal{
    return [Helper getUIColorObjectFromHexString:@"#1FB1D1" alpha:1.0];
  
}
+(UIColor *) myDarkYellow{
    return [Helper getUIColorObjectFromHexString:@"#B7BF1F" alpha:1.0];
  
}
+(UIColor *) myLightOrange{
    return [Helper getUIColorObjectFromHexString:@"#fbe0a9" alpha:1.0];
  
}
+(UIColor *) myLightPink{
    return [Helper getUIColorObjectFromHexString:@"#EFC8FE" alpha:1.0];
  
}
+(UIColor *) myFadedTurquoise{
    return [Helper getUIColorObjectFromHexString:@"#80c5ca" alpha:1.0];
  
}
+(UIColor *) myBrown{
    return [Helper getUIColorObjectFromHexString:@"#d79e80" alpha:1.0];
   
}
+(UIColor *) myTurquoise{
    return [Helper getUIColorObjectFromHexString:@"#44F4C4" alpha:1.0];
 
}
+(UIColor *) myPuke{
    return [Helper getUIColorObjectFromHexString:@"#7d7c27" alpha:1.0];
  
}
+(UIColor *)myPlaceHolderColor{
    return [Helper getUIColorObjectFromHexString:@"#EFEEF4" alpha:1.0];
}
+(UIColor*)myNavigationBarColor{
    return [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
}
NSString *const GRAY = @"#7f8c8d";
NSString *const PURPLE = @"#9b59b6";
NSString *const DARK_PURPLE = @"#8e44ad";
NSString *const DARK_BLUE = @"#2980b9";
NSString *const BLUE = @"#3498db";
NSString *const GREEN_BLUE = @"#1abc9c";
NSString *const GREEN = @"#27ae60";
NSString *const DARK_GREEN_BLUE = @"#16a085";
NSString *const ORANGE = @"#f39c12";
NSString *const DARK_ORANGE = @"#e67e22";
NSString *const DARKEST_ORANGE = @"#d35400";
NSString *const RED = @"#c0392b";
NSString *const DARK_GRAY = @"#484848";
NSString *const LIGHT_GRAY = @"#E8E8E8";
NSString *const MEDIUM_GRAY = @"#606060";
@end