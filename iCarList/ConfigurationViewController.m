//
//  ConfigurationViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/22/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonEraseData.layer.masksToBounds = YES;
    self.buttonEraseData.layer.cornerRadius = 5.0f;
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

- (IBAction)eraseAllData:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[userDefaults dictionaryRepresentation] allKeys];
    
    for (NSString *key in keys) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

@end
