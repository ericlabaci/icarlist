//
//  CarListTableViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarListTableViewController.h"
#import "CarListTableViewCell.h"
#import "CarInfoViewController.h"
#import "CarInfo.h"
#import "Defines.h"

@interface CarListTableViewController ()

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
    
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    
    for (NSString *key in keys) {
        NSRange range = KEY_RANGE;
        if ([[key substringWithRange:range] isEqualToString:KEY_TYPE_CAR]) {
            NSData *carData = [userDefaults objectForKey:key];
            [self.carArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:carData]];
        }
    }
    
    //Enable paging in tableView
    self.tableView.pagingEnabled = YES;
    
    //Check if there are no cars added
    if (self.carArray.count == 0) {
        NSLog(@"No car found!");
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
        
        //Create overlay so that the text fits and configure it`s appearance
        overlay = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - overlayWidth / 2, 35, overlayWidth, overlayHeight)];
        overlay.layer.masksToBounds = YES;
        overlay.layer.cornerRadius = 5.0f;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.7;
        
        [overlay addSubview:label];
        
        [self.view addSubview:overlay];
        
        self.tableView.userInteractionEnabled = NO;
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarInfoCell" forIndexPath:indexPath];
    CarInfo *carInfo = self.carArray[indexPath.row];
    
    cell.carInfo = carInfo;
    
    cell.labelModel.text = carInfo.model;
    cell.labelMake.text = carInfo.make;
    cell.labelYear.text = carInfo.year;
    
    return cell;
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
    if ([[segue identifier] isEqualToString:@"ShowAddCarViewController"]) {
        AddCarViewController *addCarVC = [segue destinationViewController]; //Get view controller
        addCarVC.delegate = self;
    } else {
        CarInfoViewController *vc = [segue destinationViewController]; //Get view controller
        NSIndexPath *path = [self.tableView indexPathForCell:sender];  //Get cell path
        CarListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path]; //Get cell
        vc.carInfo = cell.carInfo;
    }
}

- (bool)saveCar:(CarInfo *)carInfo {
    NSString *key;
    [carInfo generateKey];
    key = [carInfo getKey];
    NSLog(@"Saving car with key:%@", key);
    
    if ([userDefaults objectForKey:key] != nil) {
        NSLog(@"Car with key %@ already exists.", key);
        return NO;
    }
    
    if (self.carArray.count == 0) {
        [overlay removeFromSuperview];
        self.tableView.userInteractionEnabled = YES;
    }
    [self.carArray addObject:carInfo];
    [self.tableView reloadData];
    
    NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:carInfo];
    
    [userDefaults setObject:carData forKey:[carInfo getKey]];
    return [userDefaults synchronize];
}

@end
