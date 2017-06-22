//
//  CarListTableViewCell.m
//  iCarList
//
//  Created by Eric Labaci on 6/14/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarListTableViewCell.h"

@implementation CarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void)updateInfo {
    UIImage *image;
    if (self.carInfo.imageURLArray.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.carrosnaweb.com.br/imagensbd007/%@", self.carInfo.imageURLArray[0]]]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:@"ImageNotAvailable.jpeg"];
    }
    self.imageCar.image = image;
    self.imageCar.layer.masksToBounds = YES;
    self.imageCar.layer.cornerRadius = 3.0f;
    
    self.layer.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 7.0f;
}
*/

@end
