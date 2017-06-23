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

//Set text field description label to black when selected
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

//Clear all text fields
- (IBAction)clearAll:(id)sender {
    self.textFieldModel.text = @"";
    self.textFieldMake.text = @"";
    self.textFieldYear.text = @"";
}

//Add car
- (IBAction)addCar:(id)sender {
    CarInfo *carInfo = [CarInfo new]; //Create new CarInfo
    bool allFilled = YES; //Control variable to check if everything is filled
    
    //Get text field strings
    NSString *model = self.textFieldModel.text;
    NSString *make = self.textFieldMake.text;
    NSString *year = self.textFieldYear.text;
    
    //Check if there are empty text fields
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
    
    //If all text fields are filled, the CarInfo can be set and saved
    if (allFilled) {
        carInfo.model = model;
        carInfo.make = make;
        carInfo.year = year;
        carInfo.image = selectedImage;
    
        //Try to save CarInfo
        if ([self.delegate saveCar:carInfo]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error saving to userDefaults");
        }
    }
}

//Open a UIImagerPickerController to select a image from the photo gallery
- (IBAction)attachImage:(id)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//Get picked image from the photo gallery
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    id image = info[UIImagePickerControllerOriginalImage]; //Get image
    if ([image isKindOfClass:[UIImage class]]) { //Verify that it is an image
        selectedImage = (UIImage *)image;
        self.imageView.image = selectedImage;
    }
    
    //Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
