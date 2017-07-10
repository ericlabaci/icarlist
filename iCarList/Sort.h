//
//  Sort.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(char, SortState) {
    SortStateDisabled,
    SortStateAscending,
    SortStateDescending
};

@interface Sort : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic, nonnull) NSString *name;
@property (strong, nonatomic, nonnull) NSString *propertyName;
@property (nonatomic) SortState state;

@end
