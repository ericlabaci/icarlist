//
//  ConfigurationViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/22/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "Defines.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonEraseData.layer.masksToBounds = YES;
    self.buttonEraseData.layer.cornerRadius = DEFAULT_BUTTON_CORNER_RADIUS;
    
    self.buttonClearCars.layer.masksToBounds = YES;
    self.buttonClearCars.layer.cornerRadius = DEFAULT_BUTTON_CORNER_RADIUS;
    
    self.buttonClearSort.layer.masksToBounds = YES;
    self.buttonClearSort.layer.cornerRadius = DEFAULT_BUTTON_CORNER_RADIUS;
    
    [self reloadNumberOfCars];
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

- (void)reloadNumberOfCars {
    NSInteger nCars = [self numberOfCars];
    self.labelNumberOfCars.text = [NSString stringWithFormat:@"Number of cars: %ld", (long)nCars];
    if (nCars == 0) {
        self.buttonClearCars.enabled = NO;
        self.buttonClearCars.alpha = 0.5f;
    } else {
        self.buttonClearCars.enabled = YES;
        self.buttonClearCars.alpha = 1.0f;
    }
}

- (NSInteger)numberOfCars {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    NSRange keyRange = KEY_RANGE;
    NSInteger nCars = 0;
    
    for (NSString *key in keys) {
        if ([[key substringWithRange:keyRange] isEqualToString:KEY_TYPE_CAR]) {
            nCars++;
        }
    }
    
    return nCars;
}

- (IBAction)eraseAllData:(id)sender {
    //Create alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete all data?" message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    //Create action for Delete button
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
        //Get user defaults and keys
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
        //Iterate trough all keys and remove them
        for (NSString *key in keys) {
            [userDefaults removeObjectForKey:key];
        }
        //Synchronize changes
        [userDefaults synchronize];
        [self reloadNumberOfCars];
    }];
    //Create action for Cancel button
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    //Add actions to alert
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    //Present alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clearCars:(id)sender {
    //Create alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete all cars?" message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    //Create action for Clear Cars button
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
        NSRange keyRange = KEY_RANGE;
        
        for (NSString *key in keys) {
            if ([[key substringWithRange:keyRange] isEqualToString:KEY_TYPE_CAR]) {
                [userDefaults removeObjectForKey:key];
            }
        }
        [userDefaults synchronize];
        [self reloadNumberOfCars];
    }];
    //Create action for Cancel button
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    //Add actions to alert
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    //Present alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clearSort:(id)sender {
    //Create alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset sorting?" message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    //Create action for Clear Cars button
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
        NSRange keyRange = KEY_RANGE;
        
        for (NSString *key in keys) {
            if ([[key substringWithRange:keyRange] isEqualToString:KEY_TYPE_SORT_CONFIG]) {
                [userDefaults removeObjectForKey:key];
            }
        }
        [userDefaults synchronize];
    }];
    //Create action for Cancel button
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    //Add actions to alert
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    //Present alert
    [self presentViewController:alert animated:YES completion:nil];
}

@end
