//
//  CarInfo.h
//  iCarList
//
//  Created by Eric Labaci on 6/19/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject

@property (weak, nonatomic) NSString *stringURL;
@property (strong, nonatomic) NSArray *imageURLArray;
@property (weak, nonatomic) NSNumber *carID;

- (void)fillImageURL;

@end
