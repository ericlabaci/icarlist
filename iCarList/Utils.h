//
//  Utils.h
//  iCarList
//
//  Created by Eric Labaci on 6/29/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)delayCallback:(void(^)(void))callback forTotalSeconds:(double)delayInSeconds;

@end
