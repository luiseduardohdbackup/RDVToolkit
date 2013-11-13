// RDVCircularImageView.h
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

#import <UIKit/UIKit.h>

@interface RDVCircularImageView : UIView

/**
 * The image displayed in the circular image view.
 */
@property (nonatomic, strong) UIImage *image;

/**
 * The highlighted image displayed in the image view.
 */
@property (nonatomic, strong) UIImage *highlightedImage;

/**
 * A Boolean value that determines whether user events are ignored and removed from the event queue.
 */
@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/**
 * A Boolean value that determines whether the image is highlighted.
 */
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

/**
 * Returns a circular image view initialized with the specified image.
 */
- (id)initWithImage:(UIImage *)image;

/**
 * Returns an image view initialized with the specified regular and highlighted images.
 */
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

#pragma mark - Configuration

/**
 * The width of the border surrounding the image. Default is 0.
 */
@property (nonatomic) CGFloat borderWidth;

/**
 * The color of the border surrounding the image. Default is nil.
 */
@property (nonatomic) UIColor *borderColor;

#pragma mark - Networking

/**
 * Asynchronously downloads an image from the specified URL, and sets it once the request is finished. 
 * Any previous image request for the receiver will be cancelled.
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 * Asynchronously downloads an image from the specified URL, and sets it once the request is finished. 
 * Any previous image request for the receiver will be cancelled.
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 * Cancels any executing image operation for the receiver, if one exists.
 */
- (void)cancelImageRequestOperation;

@end
