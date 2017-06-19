//
//  CarInfo.m
//  iCarList
//
//  Created by Eric Labaci on 6/19/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "CarInfo.h"

@implementation CarInfo

- (void)fillImageURL {
    self.stringURL = [NSString stringWithFormat:@"http://www.carrosnaweb.com.br/fichadetalhe.asp?codigo=%ld", [self.carID integerValue]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.stringURL]];
    NSString *html = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSRange searchRange = NSMakeRange(0, html.length);
    NSRange resultRange;
    NSMutableArray *array = [NSMutableArray new];
    
    int i = 0;
    //Find all car images
    while(YES) {
        resultRange = [html rangeOfString:@"imagensbd007" options:0 range:searchRange];
        if (resultRange.location == NSNotFound) {
            break;
        }
        
        resultRange.location += resultRange.length + 1;
        resultRange.length = [html rangeOfString:@"\"" options:0 range:NSMakeRange(resultRange.location, 100)].location - resultRange.location;
        
        if ([html rangeOfString:@"thumb" options:0 range:resultRange].location == NSNotFound) {
            NSString *imageURL = [html substringWithRange:resultRange];
            NSLog(@"%@", imageURL);
            [array addObject:imageURL];
            i++;
        }
        
        searchRange = NSMakeRange(resultRange.location + 1, html.length - (resultRange.location + 1));
    }
    self.imageURLArray = [[NSOrderedSet orderedSetWithArray:array] array];
}

@end
