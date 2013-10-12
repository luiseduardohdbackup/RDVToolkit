// UITableViewCell+RDVToolkit.m
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

#import "UITableViewCell+RDVToolkit.h"
#import "RDVConstants.h"

@implementation UITableViewCell (RDVToolkit)

- (void)rdv_setBackgroundColor:(UIColor *)color {
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
    [backgroundView setBackgroundColor:color];
    [self setBackgroundView:backgroundView];
}

- (void)rdv_setHighlightedBackgroundColor:(UIColor *)color {
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
    [selectedBackgroundView setBackgroundColor:color];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

- (void)rdv_setupAccessoryImage:(UIImage *)image {
    UIView *accessoryView = [[UIImageView alloc] initWithImage:image];
    [accessoryView setFrame:RDVRectMake(0, 0, image.size.width, image.size.height)];
    [self setAccessoryView:accessoryView];
}

@end
