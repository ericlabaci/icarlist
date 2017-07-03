//
//  HomeViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/21/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *button in self.buttonArray) {
        button.layer.backgroundColor = DEFAULT_BUTTON_BACKGROUND_COLOR;
        [button setTitleColor:DEFAULT_BUTTON_TEXT_COLOR forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = DEFAULT_BUTTON_CORNER_RADIUS;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
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

@end
