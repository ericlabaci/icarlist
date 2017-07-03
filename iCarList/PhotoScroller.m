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
    
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    
    //Create scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
    /*
    scrollView = [UIScrollView new];
    [self addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0] setActive:YES];
    //[[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0] setActive:YES];
    //[[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0] setActive:YES];
    [scrollView setNeedsLayout];
    [scrollView layoutIfNeeded];
    NSLog(@"%f %f", self.frame.size.width, self.frame.size.height);
    NSLog(@"%f %f", scrollView.frame.size.width, scrollView.frame.size.height);
    */
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
        //Increment images added
        imagesAdded++;
        
        //Update ViewSize
        ViewSize = CGRectOffset(ViewSize, width, 0);
        
        //Update pageControl
        [pageControl setFrame:CGRectMake(width / 2 - imagesAdded * 6, height - 45, imagesAdded * 12, 37)];
        pageControl.numberOfPages = imagesAdded;
    }
    //Update scrollView contentSize
    scrollView.contentSize = CGSizeMake(imagesAdded * width, height);
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

@end
