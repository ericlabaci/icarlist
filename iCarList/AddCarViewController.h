//
//  AddCarViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/21/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfo.h"
#import "PhotoScroller.h"
#import "WebViewController.h"

//Declare delegate and methods
@protocol AddCarViewControllerDelegate <NSObject>

- (bool)saveCar:(CarInfo *)carInfo;

@end


@interface AddCarViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WebViewControllerDelegate> {
    NSMutableArray *imageArray;
}

//Delegate
@property (weak, nonatomic) id <AddCarViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonClearAll;

@property (weak, nonatomic) IBOutlet UIButton *buttonAddCar;

@property (weak, nonatomic) IBOutlet UITextField *textFieldModel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMake;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYear;

@property (weak, nonatomic) IBOutlet PhotoScroller *imageGallery;

- (IBAction)clearAll:(id)sender;
- (IBAction)addCar:(id)sender;
- (IBAction)attachImage:(id)sender;

@end
