//
//  ConfigurationViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/22/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfCars;
@property (weak, nonatomic) IBOutlet UIButton *buttonEraseData;
@property (weak, nonatomic) IBOutlet UIButton *buttonClearCars;
@property (weak, nonatomic) IBOutlet UIButton *buttonClearSort;

- (IBAction)eraseAllData:(id)sender;
- (IBAction)clearCars:(id)sender;
- (IBAction)clearSort:(id)sender;

@end
