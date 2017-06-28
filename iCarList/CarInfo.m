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

@implementation CarInfo

- (void)generateKey {
    key = [NSString stringWithFormat:@"%@%@%@", [self.make lowercaseString], [self.model lowercaseString], [self.year lowercaseString]];
    key = [key MD5String];
    key = [[NSString stringWithFormat:@"%@", KEY_TYPE_CAR] stringByAppendingString:key];
}

- (NSString *)getKey {
    return key;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.make forKey:KEY_MAKE];
    [aCoder encodeObject:self.model forKey:KEY_MODEL];
    [aCoder encodeObject:self.year forKey:KEY_YEAR];
    [aCoder encodeObject:self.imageArray forKey:KEY_IMAGE];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.make = [aDecoder decodeObjectForKey:KEY_MAKE];
    self.model = [aDecoder decodeObjectForKey:KEY_MODEL];
    self.year = [aDecoder decodeObjectForKey:KEY_YEAR];
    self.imageArray = [aDecoder decodeObjectForKey:KEY_IMAGE];
    
    return self;
}

@end
