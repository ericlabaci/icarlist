//
//  Utils.m
//  iCarList
//
//  Created by Eric Labaci on 6/29/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)delayCallback:(void(^)(void))callback forTotalSeconds:(double)delayInSeconds {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(callback) {
            callback();
        }
    });
}

@end
