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
    
    imageArray = [NSMutableArray new];
    
    self.imageGallery.layer.masksToBounds = YES;
    self.imageGallery.layer.cornerRadius = 5.0f;
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
    } else {
        [self attachImageFromURLAction:textField.text];
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
    NextTextField *textField;
    textField = (NextTextField *) self.textFieldModel;
    textField.text = @"";
    textField.descriptionLabel.textColor = [UIColor blackColor];
    
    textField = (NextTextField *) self.textFieldMake;
    textField.text = @"";
    textField.descriptionLabel.textColor = [UIColor blackColor];
    
    textField = (NextTextField *) self.textFieldYear;
    textField.text = @"";
    textField.descriptionLabel.textColor = [UIColor blackColor];
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
        carInfo.imageArray = imageArray;
    
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
    //Dismiss keyboard
    [self.textFieldModel resignFirstResponder];
    [self.textFieldMake resignFirstResponder];
    [self.textFieldYear resignFirstResponder];
    
    //Action sheet to select image source
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Attach Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //Alert action to attach image from photo library
    UIAlertAction *actionAttachLibrary = [UIAlertAction actionWithTitle:@"Attach from Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    //Alert action to attach image form URL (image is downloaded)
    UIAlertAction *actionAttachURL = [UIAlertAction actionWithTitle:@"Attach from the Web" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
        //Alert to enter image URL
        UIAlertController *alertURL = [UIAlertController alertControllerWithTitle:@"Attach from the Web" message:@"Enter image URL or search the web" preferredStyle:UIAlertControllerStyleAlert];
        
        //Alert action to download image from specified URL
        UIAlertAction *actionAttach = [UIAlertAction actionWithTitle:@"Attach from URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            [self attachImageFromURLAction:alertURL.textFields[0].text];
        }];
        
        UIAlertAction *actionWebView = [UIAlertAction actionWithTitle:@"Search the Web" style:UIAlertActionStyleDefault handler:^(UIAlertAction *arc) {
            NSString *searchString = [NSString new];
            int makeLength = (int)self.textFieldMake.text.length;
            int modelLength = (int)self.textFieldModel.text.length;
            int yearLength = (int)self.textFieldYear.text.length;
            WebViewController *webViewController;
            
            if (makeLength > 0) {
                searchString = [NSString stringWithFormat:@"%@", self.textFieldMake.text];
            }
            if (modelLength > 0) {
                if (searchString.length > 0) {
                    searchString = [NSString stringWithFormat:@"%@+%@", searchString, self.textFieldModel.text];
                } else {
                    searchString = [NSString stringWithFormat:@"%@", self.textFieldModel.text];
                }
            }
            if (searchString.length > 0) {
                if (yearLength > 0) {
                    searchString = [NSString stringWithFormat:@"%@+%@", searchString, self.textFieldYear.text];
                }
                webViewController = [[WebViewController alloc] initWithSearchString:searchString];
            } else {
                webViewController = [[WebViewController alloc] initWithNibName:nil bundle:nil];
            }
            
            webViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            webViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            webViewController.modalPresentationCapturesStatusBarAppearance = YES;
            webViewController.delegate = self;
            [self presentViewController:webViewController animated:YES completion:nil];
        }];
        
        //Alert action to cancel
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        //Configure textField to enter URL
        [alertURL addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"URL";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleNone;
            textField.returnKeyType = UIReturnKeyGo;
            textField.delegate = self;
        }];
        
        [alertURL addAction:actionAttach];
        [alertURL addAction:actionWebView];
        [alertURL addAction:actionCancel];
        
        [self presentViewController:alertURL animated:YES completion:nil];
    }];
    
    //Alert action to cancel
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:actionAttachLibrary];
    [actionSheet addAction:actionAttachURL];
    [actionSheet addAction:actionCancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)attachImageFromURLAction:(NSString *)stringURL {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (![self attachImageFromURL:stringURL]) {
        //Invalid URL alert
        UIAlertController *alertInvalidURL = [UIAlertController alertControllerWithTitle:@"Invalid URL" message:@"Please enter valid URL." preferredStyle:UIAlertControllerStyleAlert];
        //Alert action OK
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        //Add action and present action controller
        [alertInvalidURL addAction:actionOK];
        [self presentViewController:alertInvalidURL animated:YES completion:nil];
    }
}

//Get image from URL
- (bool)attachImageFromURL:(NSString *)stringURL {
    NSURL *URL = [NSURL URLWithString:stringURL];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];

    if (image == nil) {
        return NO;
    }

    [self addImage:image];

    return YES;
}

//Get image picked from the photo gallery
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    id image = info[UIImagePickerControllerOriginalImage]; //Get image
    //Add image
    [self addImage:image];
    
    //Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//Add image to image gallery
- (void)addImage:(UIImage *)image {
    [imageArray addObject:(UIImage *)image];
    [self.imageGallery addImage:image];
}

//Get URL string from webViewController
- (BOOL)getStringURL:(NSString *)stringURL {
    NSLog(@"%@", stringURL);
    return [self attachImageFromURL:stringURL];
}

@end
