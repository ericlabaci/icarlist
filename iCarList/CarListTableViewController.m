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
#import "Filter.h"

@interface CarListTableViewController ()

@property (strong, nonatomic) NSMutableArray *filterArray;

@end

@implementation CarListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Create data array
    self.carArray = [NSMutableArray new];
    
    //Load User Default's reference
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Enable paging in tableView
    self.tableView.pagingEnabled = YES;
    
//    self.filterArray = [NSMutableArray new];
//    NSArray *filterNames = @[@"Make", @"Model", @"Year", @"Price", @"Configuration"];
//    NSArray *propertyNames = @[@"make", @"model", @"year", @"price", @"configuration"];
//    for (int i = 0; i < filterNames.count; i++) {
//        Filter *filter = [Filter new];
//        filter.name = [filterNames objectAtIndex:i];
//        filter.propertyName = [propertyNames objectAtIndex:i];
//        filter.state = FilterStateDisabled;
//        [self.filterArray addObject:filter];
//    }
    [self loadFilterConfiguration];
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
        [self filterCaryArray];
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
        searchVC.filterArray = self.filterArray;
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
    [self filterCaryArray];
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

#pragma mark - Sort and filter methods
- (void)filterCaryArray {
    NSMutableArray *sortDescriptorArray = [NSMutableArray new];
    for (Filter *filter in self.filterArray) {
        NSSortDescriptor *sortDescriptor;
        BOOL ascending;
        
        if (filter.state == FilterStateDisabled) {
            continue;
        } else if (filter.state == FilterStateAscending) {
            ascending = YES;
        } else if (filter.state == FilterStateDescending) {
            ascending = NO;
        } else {
            ascending = NO;
        }
        
        if ([filter.propertyName isEqualToString:@"price"]) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:filter.propertyName ascending:ascending comparator:^(id obj1, id obj2) {
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
        } else {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:filter.propertyName ascending:ascending selector:@selector(localizedCaseInsensitiveCompare:)];
        }
        [sortDescriptorArray addObject:sortDescriptor];
    }
    
//    for (Filter *filter in self.filterArray) {
    for (int i = 0; i < self.filterArray.count; i++) {
        Filter *filter = [self.filterArray objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%@%@", KEY_TYPE_FILTER_CONFIG, filter.propertyName];
        
        if ([userDefaults objectForKey:key] != nil) {
            [userDefaults removeObjectForKey:key];
        }
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:filter] forKey:key];
    }
    
    [self.carArray sortUsingDescriptors:sortDescriptorArray];
    [self.tableView reloadData];
}

- (void)loadFilterConfiguration {
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    NSRange range = KEY_RANGE;
    NSArray *filterNames = @[@"Make", @"Model", @"Year", @"Price", @"Configuration"];
    NSArray *propertyNames = @[@"make", @"model", @"year", @"price", @"configuration"];
    
    self.filterArray = [NSMutableArray new];
    for (int i = 0; i < filterNames.count; i++) {
        Filter *filter = [Filter new];
        filter.name = [filterNames objectAtIndex:i];
        filter.propertyName = [propertyNames objectAtIndex:i];
        filter.state = FilterStateDisabled;
        [self.filterArray addObject:filter];
    }
    
    for (NSString *key in keys) {
        if ([[key substringWithRange:range] isEqualToString:KEY_TYPE_FILTER_CONFIG]) {
            NSData *filterData = [userDefaults objectForKey:key];
            Filter *filter = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
            for (int i = 0; i < self.filterArray.count; i++) {
                Filter *filter2 = [self.filterArray objectAtIndex:i];
                if ([filter.propertyName isEqualToString:filter2.propertyName]) {
                    filter2.state = filter.state;
                    self.filterArray[i] = filter2;
                    break;
                }
            }
        }
    }
}

- (void)didApplyOrdering {
    [self filterCaryArray];
}

@end
