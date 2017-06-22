//
//  AddCarViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/21/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "AddCarViewController.h"
#import "NextTextField.h"
#import "Defines.h"

#define START_YEAR 1900
#define END_YEAR 2018

@interface AddCarViewController ()

@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.barButtonClearAll setTintColor:[UIColor whiteColor]];
    
    self.buttonAddCar.layer.backgroundColor = DEFAULT_BUTTON_BACKGROUND_COLOR;
    [self.buttonAddCar setTitleColor:DEFAULT_BUTTON_TEXT_COLOR forState:UIControlStateNormal];
    self.buttonAddCar.layer.masksToBounds = YES;
    self.buttonAddCar.layer.cornerRadius = 5.0f;
    
    self.textFieldModel.delegate = self;
    self.textFieldMake.delegate = self;
    self.textFieldYear.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Go to next textField or close keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isKindOfClass:[NextTextField class]]) {
        UITextField *nextField = [(NextTextField *)textField nextField];
        
        if (nextField != nil) {
            [nextField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[NextTextField class]]) {
        NextTextField *nextTextField = (NextTextField *)textField;
        [nextTextField.descriptionLabel setTextColor:[UIColor blackColor]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearAll:(id)sender {
    self.textFieldModel.text = @"";
    self.textFieldMake.text = @"";
    self.textFieldYear.text = @"";
}

- (IBAction)addCar:(id)sender {
    CarInfo *carInfo = [CarInfo new];
    bool allFilled = YES;
    
    NSString *model = self.textFieldModel.text;
    NSString *make = self.textFieldMake.text;
    NSString *year = self.textFieldYear.text;
    
    if ([model length] == 0) {
        allFilled = NO;
        NextTextField *nextTextField = (NextTextField *)self.textFieldModel;
        [nextTextField.descriptionLabel setTextColor:[UIColor redColor]];
    }
    if ([make length] == 0) {
        allFilled = NO;
        NextTextField *nextTextField = (NextTextField *)self.textFieldMake;
        [nextTextField.descriptionLabel setTextColor:[UIColor redColor]];
    }
    if ([year length] == 0) {
        allFilled = NO;
        NextTextField *nextTextField = (NextTextField *)self.textFieldYear;
        [nextTextField.descriptionLabel setTextColor:[UIColor redColor]];
    }
    
    if (allFilled) {
        carInfo.model = self.textFieldModel.text;
        carInfo.make = self.textFieldMake.text;
        carInfo.year = self.textFieldYear.text;
    
        if ([self.delegate saveCar:carInfo]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error saving to userDefaults");
        }
    }
}

- (IBAction)attachImage:(id)sender {
    NSLog(@"Attatching image");
}

@end
