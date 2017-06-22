//
//  CarListTableViewCell.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfo.h"

@interface CarListTableViewCell : UITableViewCell

@property (strong, atomic) CarInfo *carInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelMake;
@property (weak, nonatomic) IBOutlet UILabel *labelModel;
@property (weak, nonatomic) IBOutlet UILabel *labelYear;
@property (weak, nonatomic) IBOutlet UIImageView *imageCar;

//- (void)updateInfo;

@end
