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
}

- (void)loadGallery;

@end
