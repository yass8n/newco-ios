//
//  NSString+NSStringAdditions.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAdditions)
-(NSString *) stringByStrippingHTML;
-(BOOL) isValidEmail;
@end
