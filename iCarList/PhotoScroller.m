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
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)loadGallery {
    //Get image number
    int pageCount = (int) self.imageArray.count;
    
    //Setup scroll view
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(pageCount * width, height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    //Setup Each View Size
    CGRect ViewSize = scrollView.bounds;
    
    if (pageCount == 0) {
        UIImage *image = [UIImage imageNamed:@"ImageNotAvailable.jpeg"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:ViewSize];
        imgView.image = image;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        scrollView.contentSize = CGSizeMake(width, height);
        [scrollView addSubview:imgView];
    } else {
        for (UIImage *image in self.imageArray) {
            //Create and set imageView
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:ViewSize];
            imgView.image = image;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [scrollView addSubview:imgView];
            
            //Update ViewSize offset
            ViewSize = CGRectOffset(ViewSize, width, 0);
        }
    }
    
    [self addSubview:scrollView];
    
    width = pageCount * 12;
    height = 37;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - width / 2, self.bounds.size.height - 45, width, height)];
    pageControl.numberOfPages = pageCount;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:pageControl];
}

- (int)currentPage {
    return (int) (scrollView.contentOffset.x / scrollView.bounds.size.width);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    pageControl.currentPage = [self currentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControl.currentPage = [self currentPage];
}

- (void)changePage:(UIPageControl *)sender {
    [scrollView setContentOffset:CGPointMake(sender.currentPage * self.bounds.size.width, 0) animated:YES];
}


/* DO NOT USE */
- (void)loadGalleryURL {
    //Get image number
    int pageCount = (int) self.imageArray.count;
    
    //Setup scroll view
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(pageCount * width, height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    //Setup Each View Size
    CGRect ViewSize = scrollView.bounds;
    
    if (pageCount == 0) {
        NSLog(@"pagecount == 0");
        UIImage *image = [UIImage imageNamed:@"ImageNotAvailable.jpeg"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:ViewSize];
        imgView.image = image;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        scrollView.contentSize = CGSizeMake(width, height);
        [scrollView addSubview:imgView];
    } else {
        for (NSString *stringURL in self.imageArray) {
            //Get image data from URL
            NSLog(@"Downloading... http://www.carrosnaweb.com.br/imagensbd007/%@", stringURL);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.carrosnaweb.com.br/imagensbd007/%@", stringURL]]];
            UIImage *image = [UIImage imageWithData:data];
        
            //Create and set imageView
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:ViewSize];
            imgView.image = image;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [scrollView addSubview:imgView];
        
            //Update ViewSize offset
            ViewSize = CGRectOffset(ViewSize, width, 0);
        }
    }
    
    [self addSubview:scrollView];
    
    width = pageCount * 12;
    height = 37;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - width / 2, self.bounds.size.height - 45, width, height)];
    pageControl.numberOfPages = pageCount;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:pageControl];
}

@end
