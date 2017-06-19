//
//  CarInfoViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScroller.h"

@interface CarInfoViewController : UIViewController

@property (strong, nonatomic) NSArray *galleryImagesArray;

@property (weak, nonatomic) IBOutlet PhotoScroller *photoScroller;

@end
