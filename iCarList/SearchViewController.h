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
    NSMutableArray *sortArrayCopy;
}

@property (strong, nonatomic) id <SearchViewControllerDelegate> delegate;

@property (weak, nonatomic) NSMutableArray *sortArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)applySort:(id)sender;
- (IBAction)resetSort:(id)sender;

@end
