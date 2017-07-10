//
//  FilterTableViewCell.m
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadImageWithState:(FilterState)state {
    [self.imageFilterState setImage:[self imageFromFilterState:state]];
    [self.imageFilterState setTintColor:[self imageTintFromFilterState:state]];
}

- (UIImage *)imageFromFilterState:(FilterState)state {
    UIImage *image;
    switch(state) {
        case FilterStateDisabled:
            image = [UIImage imageNamed:@"FilterDisabled"];
            break;
            
        case FilterStateAscending:
            image = [UIImage imageNamed:@"FilterAscending"];
            break;
            
        case FilterStateDescending:
            image = [UIImage imageNamed:@"FilterDescending"];
            break;
    }
    return image;
}

- (UIColor *) imageTintFromFilterState:(FilterState)state {
    UIColor *color;
    switch(state) {
        case FilterStateDisabled:
            color = [UIColor colorWithRed:186 / 255.0f green:42 / 255.0f blue:42 / 255.0f alpha:1.0f];
            break;
            
        case FilterStateAscending:
            color = [UIColor colorWithRed:42 / 255.0f green:168 / 255.0f blue:86 / 255.0f alpha:1.0f];
            break;
            
        case FilterStateDescending:
            color = [UIColor colorWithRed:42 / 255.0f green:69 / 255.0f blue:186 / 255.0f alpha:1.0f];
            break;
    }
    return color;
}


@end
