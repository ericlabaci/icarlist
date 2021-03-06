//
//  CarInfo.m
//  iCarList
//
//  Created by Eric Labaci on 6/19/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarInfo.h"
#import "Defines.h"
#import "NSString+MD5.h"

#define KEY_MAKE @"make"
#define KEY_MODEL @"model"
#define KEY_YEAR @"year"
#define KEY_IMAGE @"image"
#define KEY_PRICE @"price"
#define KEY_CONFIGURATION @"configuration"
#define KEY_DOORS @"doors"
#define KEY_HORSEPOWER @"horsepower"
#define KEY_TORQUE @"torque"

#define NUMBER_TO_INTEGER(x) [NSNumber numberWithInteger:x]
#define INTEGER_TO_NUMBER(x) [x integerValue]

#define NUMBER_TO_DOUBLE(x) [NSNumber numberWithDouble:x]
#define DOUBLE_TO_NUMBER(x) [x doubleValue]

@implementation CarInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.make = [aDecoder decodeObjectForKey:KEY_MAKE];
    self.model = [aDecoder decodeObjectForKey:KEY_MODEL];
    self.year = [aDecoder decodeObjectForKey:KEY_YEAR];
    self.imageArray = [aDecoder decodeObjectForKey:KEY_IMAGE];
    self.price = INTEGER_TO_NUMBER([aDecoder decodeObjectForKey:KEY_PRICE]);
    self.configuration = [aDecoder decodeObjectForKey:KEY_CONFIGURATION];
    self.numberOfDoors = INTEGER_TO_NUMBER([aDecoder decodeObjectForKey:KEY_DOORS]);
    self.horsepower = INTEGER_TO_NUMBER([aDecoder decodeObjectForKey:KEY_HORSEPOWER]);
    self.torque = DOUBLE_TO_NUMBER([aDecoder decodeObjectForKey:KEY_TORQUE]);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.make forKey:KEY_MAKE];
    [aCoder encodeObject:self.model forKey:KEY_MODEL];
    [aCoder encodeObject:self.year forKey:KEY_YEAR];
    [aCoder encodeObject:self.imageArray forKey:KEY_IMAGE];
    [aCoder encodeObject:NUMBER_TO_INTEGER(self.price) forKey:KEY_PRICE];
    [aCoder encodeObject:self.configuration forKey:KEY_CONFIGURATION];
    [aCoder encodeObject:NUMBER_TO_INTEGER(self.numberOfDoors) forKey:KEY_DOORS];
    [aCoder encodeObject:NUMBER_TO_INTEGER(self.horsepower) forKey:KEY_HORSEPOWER];
    [aCoder encodeObject:NUMBER_TO_DOUBLE(self.torque) forKey:KEY_TORQUE];
}

- (void)generateKey {
    key = [NSString stringWithFormat:@"%@%@%@", [self.make lowercaseString], [self.model lowercaseString], [self.year lowercaseString]];
    key = [key MD5String];
    key = [[NSString stringWithFormat:@"%@", KEY_TYPE_CAR] stringByAppendingString:key];
}

- (NSString *)getKey {
    return key;
}

@end
