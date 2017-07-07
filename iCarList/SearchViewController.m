//
//  SearchViewController.m
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "SearchViewController.h"
#import "FilterTableViewCell.h"
#import "Filter.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    filterArrayCopy = [self.filterArray mutableCopy];
    filterArrayCopy = [[NSMutableArray alloc] initWithArray:self.filterArray copyItems:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filterArrayCopy.count;
}

- (FilterTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    NSInteger row = indexPath.row;
    Filter *filter = [filterArrayCopy objectAtIndex:row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.labelFilterName setText:filter.name];
    [cell.imageFilterState setImage:[self imageFromFilterState:filter.state]];
    [cell.imageFilterState setTintColor:[self imageTintFromFilterState:filter.state]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Filter *filter = [filterArrayCopy objectAtIndex:row];
    filter.state = [self nextFilterStateFrom:filter.state];
    [filterArrayCopy setObject:filter atIndexedSubscript:row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIImage *)imageFromFilterState:(FilterState)state {
    UIImage *image;
    switch(state) {
        case FilterStateDisabled:
            image = [UIImage imageNamed:@"FilterDisabled"];
            break;
            
        case FilterStateAscending:
            image = [UIImage imageNamed:@"FilterAscending"];
            break;
            
        case FilterStateDescending:
            image = [UIImage imageNamed:@"FilterDescending"];
            break;
    }
    return image;
}

- (UIColor *) imageTintFromFilterState:(FilterState)state {
    UIColor *color;
    switch(state) {
        case FilterStateDisabled:
            color = [UIColor colorWithRed:186 / 255.0f green:42 / 255.0f blue:42 / 255.0f alpha:1.0f];
            break;
            
        case FilterStateAscending:
            color = [UIColor colorWithRed:42 / 255.0f green:168 / 255.0f blue:86 / 255.0f alpha:1.0f];
            break;
            
        case FilterStateDescending:
            color = [UIColor colorWithRed:42 / 255.0f green:69 / 255.0f blue:186 / 255.0f alpha:1.0f];
            break;
    }
    return color;
}
                    
- (FilterState)nextFilterStateFrom:(FilterState)state {
    switch(state) {
        case FilterStateDisabled:
            return FilterStateAscending;
            break;
            
        case FilterStateAscending:
            return FilterStateDescending;
            break;
            
        case FilterStateDescending:
            return FilterStateDisabled;
            break;
    }
    return FilterStateDisabled;
}

- (IBAction)applyFilters:(id)sender {
    BOOL enabled = NO;
    
    for (Filter *filter in filterArrayCopy) {
        if (filter.state != FilterStateDisabled) {
            enabled = YES;
            break;
        }
    }
    
    if (enabled) {
        for (int i = 0; i < filterArrayCopy.count; i++) {
            ((Filter *)self.filterArray[i]).state = ((Filter *)filterArrayCopy[i]).state;
        }
        [self.delegate didApplyOrdering];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No filter enabled" message:@"Please enable at least one filter." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
