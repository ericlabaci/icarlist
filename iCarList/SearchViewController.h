//
//  SearchViewController.h
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

- (void)didApplyOrdering;

@end

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *filterArrayCopy;
}

@property (strong, nonatomic) id <SearchViewControllerDelegate> delegate;

@property (weak, nonatomic) NSMutableArray *filterArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)applyFilters:(id)sender;
- (IBAction)resetFilters:(id)sender;

@end
