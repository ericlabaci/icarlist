//
//  SearchViewController.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

- (void)didApplyOrdering:(NSArray *)filterArray;

@end

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id <SearchViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)applyFilters:(id)sender;

@end
