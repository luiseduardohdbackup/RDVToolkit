// RDVSelectionView.m
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

#import "RDVSelectionView.h"

@interface RDVSelectionView () {
    NSInteger _selectedIndex;
}
@end

@implementation RDVSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0f]];
        
        _indicatorImage = [[UIImageView alloc] init];
        [_indicatorImage setImage:[UIImage imageNamed:@"selectionview_selection_indicator"]];
        [self addSubview:_indicatorImage];
        
        _selectedIndex = -1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    NSInteger itemsCount = [[self items] count];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    
    NSInteger labelIndex = 0;
    for (NSString *item in [self items]) {
        CGSize labelSize = [item sizeWithFont:font
                             constrainedToSize:CGSizeMake(frameSize.width / [[self items] count], 20)];
        
        CGFloat positionOffset = (frameSize.width / itemsCount) * labelIndex;
        
        CGFloat startingX = frameSize.width / (itemsCount * 2) - labelSize.width / 2 + positionOffset;
        CGFloat startingY = (frameSize.height - labelSize.height) / 2;
        
        [item drawInRect:RDVRectMake(startingX, startingY, labelSize.width, labelSize.height)
                 withFont:font
            lineBreakMode:NSLineBreakByTruncatingTail];
        
        labelIndex++;
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Methods

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(selectionView:shouldSelectIndex:)]) {
        if (![[self delegate] selectionView:self shouldSelectIndex:selectedIndex]) {
            return;
        }
    }
    
    NSLog(@"from %d to %d", _selectedIndex, selectedIndex);
    
    _selectedIndex = selectedIndex;
    
    CGSize imageSize = [[[self indicatorImage] image] size];
    NSInteger itemsCount = [[self items] count];
    __weak RDVSelectionView *weakSelf = self;
    
    if ([[self delegate] respondsToSelector:@selector(selectionView:willSelectIndex:)]) {
        [[self delegate] selectionView:self willSelectIndex:selectedIndex];
    }
    
    simpleBlock animationBlock = ^{
        CGFloat positionOffset = positionOffset = (CGRectGetWidth(weakSelf.frame) / itemsCount) * _selectedIndex;
        
        [[weakSelf indicatorImage] setFrame:RDVRectMake(CGRectGetWidth(self.frame) / (itemsCount * 2) -
                                                        imageSize.width / itemsCount + positionOffset,
                                                        CGRectGetHeight(self.frame) - imageSize.height,
                                                        imageSize.width,
                                                        imageSize.height)];
    };
    
    boolBlock completionBlock = ^(BOOL status){
        if (status && [[weakSelf delegate] respondsToSelector:@selector(selectionView:didSelectIndex:)]) {
            [[weakSelf delegate] selectionView:weakSelf didSelectIndex:selectedIndex];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:animationBlock
                         completion:completionBlock];
    } else {
        animationBlock();
        completionBlock(YES);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (NSInteger)selectedIndex {
    return _selectedIndex;
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
    
    [self setSelectedIndex:0];
}

#pragma mark - Touch handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    NSInteger itemsCount = [[self items] count];
    CGSize frameSize = self.frame.size;
    CGFloat elementWidth = frameSize.width / itemsCount;
    
    for (NSInteger index = 0; index < itemsCount; index++) {
        if (CGRectContainsPoint(RDVRectMake(elementWidth * index, 0, frameSize.width / itemsCount, frameSize.height), touchPoint)) {
            [self setSelectedIndex:index animated:YES];
            return;
        }
    }
}

@end
