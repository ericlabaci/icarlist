//
//  CarInfo.h
//  iCarList
//
//  Created by Eric Labaci on 6/19/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CarInfo : NSCoder <NSCoding> {
    NSString *key;
}

@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) UIImage *image;

- (void)generateKey;
- (NSString *)getKey;

@end
