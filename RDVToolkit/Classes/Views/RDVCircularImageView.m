// RDVCircularImageView.m
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

#import "RDVCircularImageView.h"

@interface RDVCircularImageView () <NSURLConnectionDataDelegate>

@property (nonatomic) NSURLConnection *urlConnection;
@property (nonatomic) NSMutableData *data;

@end

@implementation RDVCircularImageView

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super init];
    if (self) {
        _image = image;
        _highlightedImage = highlightedImage;
        
        [self setFrame:RDVRectMake(0, 0, image.size.width, image.size.height)];
        
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _borderColor = [UIColor blackColor];
        _borderWidth = 1.0f;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    return [self initWithImage:image highlightedImage:nil];
}

- (id)init {
    return [self initWithImage:nil highlightedImage:nil];
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = nil;
    if ([self isHighlighted] && [self highlightedImage]) {
        image = [self highlightedImage];
    } else if ([self image]) {
        image = [self image];
    }
    
    // Setup
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    // Draw image
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, rect, [image CGImage]);
    
    // Draw border
    
    CGContextSetLineWidth(context, [self borderWidth]);
    CGContextSetStrokeColorWithColor(context, [self borderColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

#pragma mark - Networking

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self cancelImageRequestOperation];
    
    [self setData:[[NSMutableData alloc] init]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url
                                                     cachePolicy:NSURLCacheStorageAllowed
                                                 timeoutInterval:30.0f];
    
    [self setUrlConnection:[[NSURLConnection alloc] initWithRequest:urlRequest
                                                           delegate:self]];
    [[self urlConnection] start];
}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)cancelImageRequestOperation {
    if ([self urlConnection]) {
        [[self urlConnection] cancel];
        [self setUrlConnection:nil];
        [self setData:nil];
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[self data] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"connection:%@ didFailWithError:%@ / %@", connection, [error localizedDescription],
         [error userInfo]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self data]) {
        self.image = [[UIImage alloc] initWithData:self.data];
        [self setNeedsDisplay];
    }
}

@end
