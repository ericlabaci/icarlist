//
//  NextTextField.m
//  iCarList
//
//  Created by Eric Labaci on 6/22/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "NextTextField.h"

@implementation NextTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configureButton {
    if (self.nextField == nil) {
        [self setReturnKeyType:UIReturnKeyDone];
    } else {
        [self setReturnKeyType:UIReturnKeyNext];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureButton];
}

@end
