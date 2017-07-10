//
//  SearchViewController.m
//  iCarList
//
//  Created by Eric Labaci on 7/7/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "SearchViewController.h"
#import "SortTableViewCell.h"
#import "Sort.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    sortArrayCopy = [[NSMutableArray alloc] initWithArray:self.sortArray copyItems:YES];
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
    return sortArrayCopy.count;
}

- (SortTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SortCell"];
    NSInteger row = indexPath.row;
    Sort *s = [sortArrayCopy objectAtIndex:row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.labelSortName setText:s.name];
    [cell reloadImageWithState:s.state];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Sort *s = [sortArrayCopy objectAtIndex:row];
    s.state = [self nextSortStateFrom:s.state];
    [sortArrayCopy setObject:s atIndexedSubscript:row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (SortState)nextSortStateFrom:(SortState)state {
    switch(state) {
        case SortStateDisabled:
            return SortStateAscending;
            break;
            
        case SortStateAscending:
            return SortStateDescending;
            break;
            
        case SortStateDescending:
            return SortStateDisabled;
            break;
    }
    return SortStateDisabled;
}

- (IBAction)applySort:(id)sender {
    BOOL enabled = NO;
    
    for (Sort *sort in sortArrayCopy) {
        if (sort.state != SortStateDisabled) {
            enabled = YES;
            break;
        }
    }
    
    if (enabled) {
        for (int i = 0; i < sortArrayCopy.count; i++) {
            ((Sort *)self.sortArray[i]).state = ((Sort *)sortArrayCopy[i]).state;
        }
        [self.delegate didApplyOrdering];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No sorting parameter enabled" message:@"Please enable at least one sort parameter." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)resetSort:(id)sender {
    NSIndexPath *indexPath;
    for (int i = 0; i < sortArrayCopy.count; i++) {
        if (i < 3) {
            ((Sort *)sortArrayCopy[i]).state = SortStateAscending;
        } else {
            ((Sort *)sortArrayCopy[i]).state = SortStateDisabled;
        }
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
