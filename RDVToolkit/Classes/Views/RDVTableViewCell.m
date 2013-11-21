// RDVTableViewCell.m
// RDVToolkit
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTableViewCell.h"

@interface RDVTableViewCell () <UIScrollViewDelegate> {
    BOOL _touchesMoved;
}

@property (nonatomic, getter = isOpen) BOOL open;
@property (nonatomic) UIGestureRecognizer *tapGestureRecognizer;

@end

@implementation RDVTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat buttonsWidth = 200;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + buttonsWidth, CGRectGetHeight(self.bounds));
        [_scrollView setDelegate:self];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        
        _scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - buttonsWidth, 0,
                                                                         CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [_scrollViewButtonView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin];
        [_scrollViewButtonView setBackgroundColor:[UIColor yellowColor]];
        [_scrollView addSubview:_scrollViewButtonView];
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
        moreButton.frame = CGRectMake(0, 0, buttonsWidth / 2.0f, CGRectGetHeight(self.bounds));
        [moreButton setTitle:@"More" forState:UIControlStateNormal];
        [moreButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewButtonView addSubview:moreButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
        deleteButton.frame = CGRectMake(buttonsWidth / 2.0f, 0, buttonsWidth / 2.0f, CGRectGetHeight(self.bounds));
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewButtonView addSubview:deleteButton];
        
        UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds),
                                                                                 CGRectGetHeight(self.bounds))];
        scrollViewContentView.backgroundColor = [UIColor whiteColor];
        [scrollViewContentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.scrollView addSubview:scrollViewContentView];
        self.scrollViewContentView = scrollViewContentView;
        
        UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:RDVRectMake(15, 15,
                                                                              CGRectGetWidth(self.bounds) - 2 * 15,
                                                                              CGRectGetHeight(self.bounds) - 2 * 15)];
        [scrollViewLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        self.scrollViewLabel = scrollViewLabel;
        [self.scrollViewContentView addSubview:scrollViewLabel];
    }
    return self;
}

#pragma mark - Methods

- (void)userPressedMoreButton:(id)sender {
    DLog(@"More button was tapped");
}

- (void)userPressedDeleteButton:(id)sender {
    DLog(@"Delete button was tapped");
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setButtonsHidden:YES animated:NO];
}

- (void)setButtonsHidden:(BOOL)hidden animated:(BOOL)animated {
    CGPoint offsetPoint = CGPointZero;
    
    if (!hidden) {
        offsetPoint = CGPointMake(200, 0);
    }
    
    [self.scrollView setContentOffset:offsetPoint animated:animated];
}

- (void)setButtonsHidden:(BOOL)hidden {
    [self setButtonsHidden:hidden animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - 200),
                                                 0.0f, 200, CGRectGetHeight(self.bounds));
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    //TODO: make more intelligent
    
    CGFloat treshold = 200 * ([self isOpen] ? 5 / 6 : 1 / 4);
    if ([self isOpen]) {
        treshold = 200 * 5/6;
    } else {
        treshold = 200 * 1/4;
    }
    
    if (scrollView.contentOffset.x > treshold) {
        targetContentOffset->x = 200;
        
        [self setOpen:YES];
    } else {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
        
        [self setOpen:NO];
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
