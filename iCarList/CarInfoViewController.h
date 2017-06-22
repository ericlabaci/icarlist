//
//  CarInfoViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScroller.h"
#import "CarInfo.h"

@interface CarInfoViewController : UIViewController

@property (weak, nonatomic) NSArray *imageURLArray;
@property (weak, nonatomic) CarInfo *carInfo;

@property (weak, nonatomic) IBOutlet PhotoScroller *photoScroller;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
