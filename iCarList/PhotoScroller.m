//
//  PhotoScroller.m
//  PhotoScroller2
//
//  Created by Eric Labaci on 6/16/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "PhotoScroller.h"

@implementation PhotoScroller

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)init {
    self = [super init];
    [self updateLayout];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self updateLayout];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self updateLayout];
    
    return self;
}

- (void)updateLayout {
    //[self setNeedsLayout];
    //[self layoutIfNeeded];
    
    imageViewArray = [NSMutableArray new];
    
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    
    //Create scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    [self addSubview:scrollView];
    
    //No images added yet
    imagesAdded = 0;
    
    //Create pageControl and configure it
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(width / 2, height - 45, 0, 37)];
    pageControl.numberOfPages = imagesAdded;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:pageControl];
    
    ViewSize = scrollView.bounds;
    
    [self addNotAvailableImage];
}

- (void)loadGallery {
    //Add all images in the array
    for (UIImage *image in imageArray) {
        [self addImage:image];
    }
    
    //If no image was added, add ImageNotAvailable image
    //If images were added, add UIPageControl
    if (imagesAdded == 0) {
        [self addNotAvailableImage];
    }
}

//Adds image to the gallery
- (void)addImage:(UIImage *)image {
    [self addImage:image incrementImagesAdded:YES];
}

- (void)addImage:(UIImage *)image incrementImagesAdded:(bool)inc {
    //Create UIImageView and set it
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:ViewSize];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    //Add to the scroll view
    [scrollView addSubview:imageView];
    
    if (inc) {
        //Add imageView to array so it can be removed later
        [imageViewArray addObject:imageView];
        
        //Increment images added
        imagesAdded++;
        
        //Update ViewSize
        ViewSize = CGRectOffset(ViewSize, width, 0);

        [self updatePageControl];
    }
    //Update scrollView contentSize
    scrollView.contentSize = CGSizeMake(imagesAdded * width, height);
}

- (BOOL)deleteImageAtIndex:(NSInteger)index {
    if (index >= imageViewArray.count)
        return NO;
    UIImageView *imageView = [imageViewArray objectAtIndex:index];
    [imageViewArray removeObjectAtIndex:index];
    [imageArray removeObjectAtIndex:index];
    
    imagesAdded--;
    ViewSize = CGRectOffset(ViewSize, -width, 0);
    
    CGRect frame = CGRectMake(index * width, 0, width, height);
    for (int i = (int)index; i < imagesAdded; i++) {
        [((UIImageView *)imageViewArray[i]) setFrame:frame];
        frame = CGRectOffset(frame, width, 0);
    }
    scrollView.contentSize = CGSizeMake(imagesAdded * width, height);
    
    [self updatePageControl];
    
    [imageView removeFromSuperview];
    
    return YES;
}

- (void)addNotAvailableImage {
    UIImage *image = [UIImage imageNamed:@"ImageNotAvailable.jpeg"];
    [self addImage:image incrementImagesAdded:NO];
}

- (void)setImageArray:(NSMutableArray *)array {
    imageArray = array;
}

//Get current page being displayed
- (int)currentPage {
    return (int) (scrollView.contentOffset.x / scrollView.frame.size.width);
}

//Update current page when the user ends dragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    pageControl.currentPage = [self currentPage];
}

//Update current page when the view stopped moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControl.currentPage = [self currentPage];
}

//Change image displayed when the user clicks on the page controller
- (void)changePage:(UIPageControl *)sender {
    [scrollView setContentOffset:CGPointMake(sender.currentPage * self.frame.size.width, 0) animated:YES];
}

- (NSInteger)currentImageIndex {
    return [self currentPage];
}

- (NSInteger)imageCount {
    return imagesAdded;
}

- (void)updatePageControl {
    [pageControl setFrame:CGRectMake(width / 2 - imagesAdded * 6, height - 45, imagesAdded * 12, 37)];
    pageControl.numberOfPages = imagesAdded;
}

@end
