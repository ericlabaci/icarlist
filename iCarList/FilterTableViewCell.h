//
//  FilterTableViewCell.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

@interface FilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelFilterName;
@property (weak, nonatomic) IBOutlet UIImageView *imageFilterState;

- (void)reloadImageWithState:(FilterState)state;

@end
