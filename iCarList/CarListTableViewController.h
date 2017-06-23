//
//  CarListTableViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCarViewController.h"

@interface CarListTableViewController : UITableViewController <AddCarViewControllerDelegate> {
    UIView *overlay;
    NSUserDefaults *userDefaults;
    NSSortDescriptor *sort;
}

@property (strong, nonatomic) NSMutableArray *carArray;

@end
