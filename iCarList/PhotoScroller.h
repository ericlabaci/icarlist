//
//  PhotoScroller.h
//  PhotoScroller2
//
//  Created by Eric Labaci on 6/16/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScroller : UIView <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *imageArray;
    NSMutableArray *imageViewArray;
    int imagesAdded;
    CGRect ViewSize;
    int width;
    int height;
}

- (void)setImageArray:(NSMutableArray *)array;
- (void)loadGallery;
- (void)addImage:(UIImage *)image;
- (BOOL)deleteImageAtIndex:(NSInteger)index;

- (NSInteger)currentImageIndex;
- (NSInteger)imageCount;

@end
