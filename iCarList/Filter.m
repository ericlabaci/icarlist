//
//  Filter.m
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "Filter.h"

#define KEY_NAME @"name"
#define KEY_PROPERTY @"property"
#define KEY_STATE @"state"

#define NUMBER_TO_CHAR(x) [NSNumber numberWithChar:x]
#define CHAR_TO_NUMBER(x) [x charValue]

@implementation Filter

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.name = [aDecoder decodeObjectForKey:KEY_NAME];
    self.propertyName = [aDecoder decodeObjectForKey:KEY_PROPERTY];
    self.state = CHAR_TO_NUMBER([aDecoder decodeObjectForKey:KEY_STATE]);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:KEY_NAME];
    [aCoder encodeObject:self.propertyName forKey:KEY_PROPERTY];
    [aCoder encodeObject:NUMBER_TO_CHAR(self.state) forKey:KEY_STATE];
}

@end
