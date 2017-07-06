//
//  CarInfoViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "NextTextField.h"
#import "PhotoScroller.h"
#import "CarInfo.h"

typedef NS_ENUM(char, CarInfoViewControllerModes) {
    CarInfoViewControllerModeView,
    CarInfoViewControllerModeEditing,
    CarInfoViewControllerModeNew
};

@protocol CarInfoViewControllerDelegate <NSObject>

- (BOOL)saveNewCar:(CarInfo *)carInfo;
- (BOOL)deleteCar:(CarInfo *)carInfo withCarKey:(NSString *)key;
- (BOOL)saveEditCar:(CarInfo *)carInfo withCarKey:(NSString *)key;

@end

@interface CarInfoViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WebViewControllerDelegate> {
    //Navigation Bar Buttons
    UIBarButtonItem *buttonEdit;
    UIBarButtonItem *buttonSave;
    UIBarButtonItem *buttonDelete;
    UIBarButtonItem *buttonCancel;
    
    //Images added array
    NSMutableArray *imageArray;
}

@property (strong, nonatomic) id <CarInfoViewControllerDelegate> delegate;

@property CarInfoViewControllerModes mode;

@property (strong, nonatomic) CarInfo *carInfo;

@property (weak, nonatomic) IBOutlet UIView *contentView;

//Both modes
@property (weak, nonatomic) IBOutlet PhotoScroller *photoScroller;

//Viewing mode
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelConfiguration;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberDoors;

//Editing mode
@property (weak, nonatomic) IBOutlet UIButton *buttonAddImage;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldMake;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldModel;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldYear;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldPrice;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldConfiguration;
@property (weak, nonatomic) IBOutlet NextTextField *textFieldNumberDoors;

//Labels
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;

//Text fields
@property (strong, nonatomic) IBOutletCollection(NextTextField) NSArray *textFieldCollection;

- (IBAction)actionGoBack:(id)sender;
- (IBAction)attachImage:(id)sender;

@end
