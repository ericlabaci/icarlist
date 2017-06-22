//
//  CarInfo.h
//  iCarList
//
//  Created by Eric Labaci on 6/19/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSCoder <NSCoding> {
    NSString *key;
}

@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *year;

- (void)generateKey;
- (NSString *)getKey;

@end
