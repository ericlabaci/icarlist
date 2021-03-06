//
//  CarListTableViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarListTableViewController.h"
#import "CarListTableViewCell.h"
#import "CarInfo.h"
#import "Defines.h"
#import "Sort.h"

@interface CarListTableViewController ()

@property (strong, nonatomic) NSMutableArray *sortArray;

@end

@implementation CarListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create car data array
    self.carArray = [NSMutableArray new];
    
    //Load User Default's reference
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Enable paging in tableView
    self.tableView.pagingEnabled = YES;

    [self loadSortConfiguration];
    [self loadCarList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.carArray.count;
}

- (CarListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarInfoCell" forIndexPath:indexPath];
    CarInfo *carInfo = self.carArray[indexPath.row];
    
    cell.carInfo = carInfo;
    
    cell.labelModel.text = carInfo.model;
    cell.labelMake.text = carInfo.make;
    cell.labelYear.text = carInfo.year;
    if (carInfo.imageArray != nil && carInfo.imageArray.count > 0) {
        cell.imageCar.image = carInfo.imageArray[0];
    } else {
        cell.imageCar.image = [UIImage imageNamed:@"ImageNotAvailable"];
    }
    cell.imageCar.layer.masksToBounds = YES;
    cell.imageCar.layer.cornerRadius = 5.0f;
    
    if (overlayIsShown) {
        overlayIsShown = NO;
        [overlay removeFromSuperview];
        self.tableView.userInteractionEnabled = YES;
    }

    return cell;
}

- (void)loadCarList {
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    [self.carArray removeAllObjects];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        for (NSString *key in keys) {
            NSRange range = KEY_RANGE;
            if ([[key substringWithRange:range] isEqualToString:KEY_TYPE_CAR]) {
                NSData *carData = [userDefaults objectForKey:key];
                [self.carArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:carData]];
            }
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self sortCarArray];
        [self refreshCarList];
    });
}

- (void)refreshCarList {
    overlayIsShown = NO;
    //Check if there are no cars added
    if (self.carArray.count == 0) {
        int overlayWidth;
        int overlayHeight = 50;
        
        //Create label with text
        UILabel *label = [UILabel new];
        label.text = @"  No car found!  ";
        label.textColor = [UIColor whiteColor];
        
        //Get text width in pixels
        overlayWidth = label.attributedText.size.width;
        
        //Set label size to fit text
        [label setFrame:CGRectMake(0, 0, overlayWidth, overlayHeight)];
        
        //Create overlay so that the text fits and configure it's appearance
        overlay = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - overlayWidth / 2, 35, overlayWidth, overlayHeight)];
        overlay.layer.masksToBounds = YES;
        overlay.layer.cornerRadius = 5.0f;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.7;
        
        [overlay addSubview:label];
        
        [self.view addSubview:overlay];
        
        overlayIsShown = YES;
        self.tableView.userInteractionEnabled = NO;
    }
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Check if next screen is the Add Car Screen
    if ([[segue identifier] isEqualToString:@"AddCarSegue"]) {
        CarInfoViewController *carInfoVC = [segue destinationViewController];
        carInfoVC.mode = CarInfoViewControllerModeNew;
        carInfoVC.delegate = self; //Set delegate
    } else if ([[segue identifier] isEqualToString:@"ViewCarSegue"]) {
        CarInfoViewController *carInfoVC = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForCell:sender];  //Get cell path
        CarListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path]; //Get cell
        carInfoVC.carInfo = cell.carInfo;
        carInfoVC.mode = CarInfoViewControllerModeView;
        carInfoVC.delegate = self; //Set delegate
    } else if ([[segue identifier] isEqualToString:@"SearchCarSegue"]) {
        SearchViewController *searchVC = [segue destinationViewController];
        searchVC.delegate = self;
        searchVC.sortArray = self.sortArray;
    }
}

#pragma mark - CarInfoViewControllerDelegate methods
//Save a car
- (BOOL)saveNewCar:(CarInfo *)carInfo {
    NSString *key;
    [carInfo generateKey];
    key = [carInfo getKey];
    
    if ([userDefaults objectForKey:key] != nil) {
        NSLog(@"Car with key %@ already exists.", key);
        return NO;
    }
    
    if (self.carArray.count == 0) {
        [overlay removeFromSuperview];
        self.tableView.userInteractionEnabled = YES;
    }
    [self.carArray addObject:carInfo];
    [self sortCarArray];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:carInfo];
        
        [userDefaults setObject:carData forKey:[carInfo getKey]];
        [userDefaults synchronize];
    });
    return YES;
}

//Remove car from user defaults and table view
- (BOOL)deleteCar:(CarInfo *)carInfo withCarKey:(NSString *)key {
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
    [self.carArray removeObject:carInfo];
    //[self.tableView reloadData];
    [self refreshCarList];
    return YES;
}

//Edit a car
- (BOOL)saveEditCar:(CarInfo *)carInfo withCarKey:(NSString *)key {
    [self deleteCar:carInfo withCarKey:key];
    return [self saveNewCar:carInfo];
}

#pragma mark - Sort methods
- (void)sortCarArray {
    NSMutableArray *sortDescriptorArray = [NSMutableArray new];
    for (Sort *sort in self.sortArray) {
        NSSortDescriptor *sortDescriptor;
        BOOL ascending;
        
        if (sort.state == SortStateDisabled) {
            continue;
        } else if (sort.state == SortStateAscending) {
            ascending = YES;
        } else if (sort.state == SortStateDescending) {
            ascending = NO;
        } else {
            ascending = NO;
        }
        
        if ([sort.propertyName isEqualToString:@"price"] ||
            [sort.propertyName isEqualToString:@"horsepower"] ||
            [sort.propertyName isEqualToString:@"torque"]) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sort.propertyName ascending:ascending comparator:^(id obj1, id obj2) {
                if ([obj1 doubleValue] > [obj2 doubleValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if ([obj1 doubleValue] < [obj2 doubleValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
        } else {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sort.propertyName ascending:ascending selector:@selector(localizedCaseInsensitiveCompare:)];
        }
        [sortDescriptorArray addObject:sortDescriptor];
    }
    
    for (Sort *sort in self.sortArray) {
        NSString *key = [NSString stringWithFormat:@"%@%@", KEY_TYPE_SORT_CONFIG, sort.propertyName];
        
        if ([userDefaults objectForKey:key] != nil) {
            [userDefaults removeObjectForKey:key];
        }
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:sort] forKey:key];
    }
    
    [self.carArray sortUsingDescriptors:sortDescriptorArray];
    [self.tableView reloadData];
}

- (void)loadSortConfiguration {
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    NSRange range = KEY_RANGE;
    NSArray *sortNames = @[@"Make", @"Model", @"Year", @"Price", @"Configuration", @"Power (HP)", @"Torque (kgf*m)"];
    NSArray *propertyNames = @[@"make", @"model", @"year", @"price", @"configuration", @"horsepower", @"torque"];
    
    self.sortArray = [NSMutableArray new];
    for (int i = 0; i < sortNames.count; i++) {
        Sort *sort = [Sort new];
        sort.name = [sortNames objectAtIndex:i];
        sort.propertyName = [propertyNames objectAtIndex:i];
        sort.state = SortStateDisabled;
        [self.sortArray addObject:sort];
    }
    
    for (int i = 0; i < 3; i++) {
        ((Sort *)self.sortArray[i]).state = SortStateAscending;
    }
    
    for (NSString *key in keys) {
        if ([[key substringWithRange:range] isEqualToString:KEY_TYPE_SORT_CONFIG]) {
            NSData *sortData = [userDefaults objectForKey:key];
            Sort *sort = [NSKeyedUnarchiver unarchiveObjectWithData:sortData];
            for (Sort *sortAux in self.sortArray) {
                if ([sort.propertyName isEqualToString:sortAux.propertyName]) {
                    sortAux.state = sort.state;
                    break;
                }
            }
        }
    }
}

- (void)didApplyOrdering {
    [self sortCarArray];
}

@end
