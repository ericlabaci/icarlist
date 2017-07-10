//
//  SortTableViewCell.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sort.h"

@interface SortTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelSortName;
@property (weak, nonatomic) IBOutlet UIImageView *imageSortState;

- (void)reloadImageWithState:(SortState)state;

@end
