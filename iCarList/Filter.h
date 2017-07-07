//
//  Filter.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(char, FilterState) {
    FilterStateDisabled,
    FilterStateAscending,
    FilterStateDescending
};

@interface Filter : NSObject <NSCoding>

@property (strong, nonatomic, nonnull) NSString *name;
@property (strong, nonatomic, nonnull) NSString *propertyName;
@property (nonatomic) FilterState state;

@end
