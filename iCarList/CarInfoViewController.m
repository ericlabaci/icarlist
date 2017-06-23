//
//  CarInfoViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self.photoScroller setNeedsLayout];
    [self.photoScroller layoutIfNeeded];
    
    if (self.carInfo.image != nil) {
        self.photoScroller.imageArray = @[self.carInfo.image];
    } else {
        self.photoScroller.imageArray = @[];
    }
    
    [self.photoScroller loadGallery];
    
    self.labelTitle.text = [NSString stringWithFormat:@"%@ %@ %@", self.carInfo.make, self.carInfo.model, self.carInfo.year];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
