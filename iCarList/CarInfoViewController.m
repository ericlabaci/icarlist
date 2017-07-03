//
//  CarInfoViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CarInfoViewController.h"
#import "Utils.h"

#define FADE_IN 1
#define FADE_OUT 0

#define CORNER_RADIUS 5.0f;
#define BORDER_WIDTH 0.5f;

#define EMPTY_FIELD_COLOR [[UIColor colorWithRed:255 / 255.0f green:0.0f blue:0.0f alpha:0.75f]CGColor]
#define FIELD_DEFAULT_COLOR [[UIColor clearColor]CGColor]

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIBarButtonItems
    buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    buttonSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    buttonDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    buttonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    //Create image array for photo scroller
    imageArray = [NSMutableArray new];
    
    //Switch to selected model
    [self switchModeTo:self.mode];
    
    [self.photoScroller setNeedsLayout];
    [self.photoScroller layoutIfNeeded];
    
    if (self.mode == CarInfoViewControllerModeView) {
        imageArray = [NSMutableArray arrayWithArray:self.carInfo.imageArray];
        [self.photoScroller setImageArray:self.carInfo.imageArray];
        [self.photoScroller loadGallery];
    }
    
    for (NextTextField *textField in self.textFieldCollection) {
        textField.layer.cornerRadius = CORNER_RADIUS;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = FIELD_DEFAULT_COLOR;
        textField.layer.borderWidth = BORDER_WIDTH;
    }
    
    self.buttonAddImage.layer.masksToBounds = YES;
    self.buttonAddImage.layer.cornerRadius = CORNER_RADIUS;
    
    [self reload];
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

#pragma mark - NextTextField delegate methods
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    for (UITextField *textFieldCol in self.textFieldCollection) {
        if (textField == textFieldCol) {
            textField.layer.borderColor = FIELD_DEFAULT_COLOR;
            break;
        }
    }
}

#pragma mark - Reload
- (void)reload {
    self.labelTitle.text = [NSString stringWithFormat:@"%@ %@ %@", self.carInfo.make, self.carInfo.model, self.carInfo.year];
}

#pragma mark - UIBarButtonItem actions
//Switch to editing mode
- (void)edit {
    [self switchModeTo:CarInfoViewControllerModeEditing];
    [self reload];
}

//Save changes
- (void)save {
    BOOL canSave = YES;
    
    [self dismissKeyboard];
    
    for (NextTextField *textField in self.textFieldCollection) {
        if (textField.text.length == 0) {
            textField.layer.borderColor = EMPTY_FIELD_COLOR;
            canSave = NO;
        }
    }
    
    if (canSave) {
        if (self.mode == CarInfoViewControllerModeNew) {
            self.carInfo = [CarInfo new];
        }
        [self.carInfo generateKey];
        self.carInfo.make = self.textFieldMake.text;
        self.carInfo.model = self.textFieldModel.text;
        self.carInfo.year = self.textFieldYear.text;
        self.carInfo.imageArray = imageArray;
        if (self.mode == CarInfoViewControllerModeNew) {
            [self.delegate saveNewCar:self.carInfo];
        } else if (self.mode == CarInfoViewControllerModeEditing) {
            [self.delegate saveEditCar:self.carInfo withCarKey:[self.carInfo getKey]];
        }
        [self dismissKeyboard];
        [self switchModeTo:CarInfoViewControllerModeView];
        [self reload];
    }
}

//Delete car
- (void)delete {
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Delete this car?" message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
        [self.carInfo generateKey];
        [self.delegate deleteCar:self.carInfo withCarKey:[self.carInfo getKey]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [deleteAlert addAction:deleteAction];
    [deleteAlert addAction:cancelAction];
    
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

//Cancel changes
- (void)cancel {
    [self cancelShouldClose:NO];
}

- (void)dismissKeyboard {
    for (NextTextField *textField in self.textFieldCollection) {
        [textField resignFirstResponder];
    }
}

#pragma mark - Navigation Bar Back Button Action
//Navigation Bar Back Button Action
- (IBAction)actionGoBack:(id)sender {
    [self cancelShouldClose:YES];
}

#pragma mark - What should the cancel and back button do
//Determines wheter the cancel and back button should show an alert or not, and what to do with the alert actions
- (void)cancelShouldClose:(BOOL)close {
    UIAlertController *cancelAlert = [UIAlertController alertControllerWithTitle:@"Do you really want to cancel?" message:@"All changes will be lost." preferredStyle:UIAlertControllerStyleAlert];
    if (self.mode == CarInfoViewControllerModeView ) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.mode == CarInfoViewControllerModeNew || close) {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [cancelAlert addAction:actionOK];
        [cancelAlert addAction:actionCancel];
        [self presentViewController:cancelAlert animated:YES completion:nil];
    } else {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act) {
            [self switchModeTo:CarInfoViewControllerModeView];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [cancelAlert addAction:actionOK];
        [cancelAlert addAction:actionCancel];
        [self presentViewController:cancelAlert animated:YES completion:nil];
    }
}

#pragma mark - Mode operations
//Switches and applies new UI mode
- (void)switchModeTo:(CarInfoViewControllerModes)mode {
    self.mode = mode;
    [self reloadMode];
}

//Applies current UI mode
- (void)reloadMode {
    BOOL viewFade = FADE_IN;
    BOOL editFade = !viewFade;
    NSTimeInterval interval = 0.25;
    if (self.mode == CarInfoViewControllerModeView) {
        [self.navigationItem setRightBarButtonItems:@[buttonEdit] animated:YES];
        viewFade = FADE_IN;
        editFade = !viewFade;
    } else if (self.mode == CarInfoViewControllerModeNew) {
        [self.navigationItem setRightBarButtonItems:@[buttonSave, buttonCancel] animated:YES];
        viewFade = FADE_OUT;
        editFade = !viewFade;
    } else if (self.mode == CarInfoViewControllerModeEditing) {
        [self.navigationItem setRightBarButtonItems:@[buttonSave, buttonDelete, buttonCancel] animated:YES];
        viewFade = FADE_OUT;
        editFade = !viewFade;
        self.textFieldMake.text = self.carInfo.make;
        self.textFieldModel.text = self.carInfo.model;
        self.textFieldYear.text = self.carInfo.year;
    }
    
    //Not hidden in view mode
    [self animateViewFade:self.labelTitle withFadeType:viewFade withTimeInterval:interval];
    
    //Not hidden in edit/new mode
    [self animateViewFade:self.buttonAddImage withFadeType:editFade withTimeInterval:interval];
    for (NextTextField *textField in self.textFieldCollection) {
        [self animateViewFade:textField withFadeType:editFade withTimeInterval:interval];
    }
}

//Animate fade animation and hides or unhides view
- (void)animateViewFade:(UIView *)view withFadeType:(BOOL)fade withTimeInterval:(NSTimeInterval)interval {
    [Utils delayCallback:^ {
        view.hidden = !fade;
    } forTotalSeconds:interval * (1 - fade)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:interval];
    view.alpha = fade;
    [UIView commitAnimations];
}

#pragma mark - Attach image methods
//Open a UIImagerPickerController to select a image from the photo gallery
- (IBAction)attachImage:(id)sender {
    //Dismiss keyboard
    [self dismissKeyboard];
    
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
                searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
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
    [self.photoScroller addImage:image];
}

//Get URL string from webViewController
- (BOOL)getStringURL:(NSString *)stringURL {
    NSLog(@"%@", stringURL);
    return [self attachImageFromURL:stringURL];
}

#pragma mark - Check if image is dark
- (BOOL) isDarkImage:(UIImage *)image {
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    BOOL isDark = FALSE;
    
    int darkPixels = 0;
    
    long length = CFDataGetLength(imageData);
    int const darkPixelThreshold = (image.size.width * image.size.height) * 0.45;
    
    for(int i = 0; i < length; i += 4) {
        int r = pixels[i];
        int g = pixels[i+1];
        int b = pixels[i+2];
        float luminance = (0.299 * r + 0.587 * g + 0.114 * b);
        if (luminance < 150)
            darkPixels++;
    }
    
    if (darkPixels >= darkPixelThreshold)
        isDark = YES;
    
    CFRelease(imageData);
    
    return isDark;
}

@end
