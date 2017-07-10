//
//  SortTableViewCell.m
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "SortTableViewCell.h"

@implementation SortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadImageWithState:(SortState)state {
    [self.imageSortState setImage:[self imageFromSortState:state]];
    [self.imageSortState setTintColor:[self imageTintFromSortState:state]];
}

- (UIImage *)imageFromSortState:(SortState)state {
    UIImage *image;
    switch(state) {
        case SortStateDisabled:
            image = [UIImage imageNamed:@"SortDisabled"];
            break;
            
        case SortStateAscending:
            image = [UIImage imageNamed:@"SortAscending"];
            break;
            
        case SortStateDescending:
            image = [UIImage imageNamed:@"SortDescending"];
            break;
    }
    return image;
}

- (UIColor *) imageTintFromSortState:(SortState)state {
    UIColor *color;
    switch(state) {
        case SortStateDisabled:
            color = [UIColor colorWithRed:186 / 255.0f green:42 / 255.0f blue:42 / 255.0f alpha:1.0f];
            break;
            
        case SortStateAscending:
            color = [UIColor colorWithRed:42 / 255.0f green:168 / 255.0f blue:86 / 255.0f alpha:1.0f];
            break;
            
        case SortStateDescending:
            color = [UIColor colorWithRed:42 / 255.0f green:69 / 255.0f blue:186 / 255.0f alpha:1.0f];
            break;
    }
    return color;
}


@end
