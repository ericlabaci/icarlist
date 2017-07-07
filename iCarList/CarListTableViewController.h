//
//  CarListTableViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoViewController.h"
#import "SearchViewController.h"

@interface CarListTableViewController : UITableViewController <CarInfoViewControllerDelegate, SearchViewControllerDelegate> {
    UIView *overlay;
    NSUserDefaults *userDefaults;
    bool overlayIsShown;
}

@property (strong, nonatomic) NSMutableArray *carArray;

@end
