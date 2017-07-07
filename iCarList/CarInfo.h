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

@property (strong, nonatomic) NSString *make;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *configuration;
@property (nonatomic) NSInteger numberOfDoors;
@property (nonatomic) NSInteger horsepower;
@property (nonatomic) NSInteger torque;


- (void)generateKey;
- (NSString *)getKey;

@end
