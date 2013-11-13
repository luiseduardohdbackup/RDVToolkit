// RDVSelectionView.h
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

@protocol RDVSelectionViewDelegate;

@interface RDVSelectionView : UIView

@property (nonatomic) NSArray *items;

@property (nonatomic) UIImageView *indicatorImage;
@property id <RDVSelectionViewDelegate> delegate;
@property NSInteger selectedIndex;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

- (NSDictionary *)titleAttributes;
- (void)setTitleAttributes:(NSDictionary *)attributes;

@end

@protocol RDVSelectionViewDelegate <NSObject>
@optional
- (BOOL)selectionView:(RDVSelectionView *)header shouldSelectIndex:(NSInteger)index;
- (void)selectionView:(RDVSelectionView *)header willSelectIndex:(NSInteger)index;
- (void)selectionView:(RDVSelectionView *)header didSelectIndex:(NSInteger)index;
@end
