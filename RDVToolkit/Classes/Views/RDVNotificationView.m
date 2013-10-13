// RDVNotificationView.m
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

#import "RDVNotificationView.h"

static const int kRDVToolkitNotificationViewTag = 1440;

@interface RDVNotificationView () {
    RDVNotificationViewType _type;
    UIGestureRecognizer *_tapGestureRecognizer;
    BOOL _isHiding;
}

@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UIImageView *iconView;

@end

@implementation RDVNotificationView

- (id)initWithMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        [self setTag:kRDVToolkitNotificationViewTag];
        
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:16]];
        [_textLabel setNumberOfLines:0];
        [_textLabel setText:message];
        [self addSubview:_textLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(hideNotification)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        _isHiding = NO;
    }
    return self;
}

- (id)init {
    return [self initWithMessage:nil];
}

- (void)layoutSubviews {
    CGSize viewSize = [self frame].size;
    CGSize iconSize = [[[self iconView] image] size];
    CGSize textSize = [[self textLabel] sizeThatFits:CGSizeMake(viewSize.width - 10 -
                                                                iconSize.width - 10 - 10, 200)];
    
    [[self iconView] setFrame:RDVRectMake(10, viewSize.height / 2 - iconSize.height / 2,
                                          iconSize.width, iconSize.height)];
    [[self textLabel] setFrame:RDVRectMake(CGRectGetMaxX([[self iconView] frame]),
                                           viewSize.height / 2 - textSize.height / 2,
                                           textSize.width, textSize.height)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize iconSize = [[[self iconView] image] size];
    CGSize textSize = [[self textLabel] sizeThatFits:CGSizeMake(size.width - 10 -
                                                                iconSize.width - 10 - 10, 200)];
    return CGSizeMake(size.width, textSize.height + 10 + 10);
}

#pragma mark - Methods

- (void)setType:(RDVNotificationViewType)type {
    _type = type;
    
    if (type == RDVNotificationViewTypeError) {
        [self setBackgroundColor:[UIColor redColor]];
        [[self textLabel] setTextColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
    } else if (type == RDVNotificationViewTypeSuccess) {
        [self setBackgroundColor:[UIColor greenColor]];
        [[self textLabel] setTextColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
    } else {
        [self setBackgroundColor:[UIColor blueColor]];
        [[self textLabel] setTextColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]];
    }
    [[self textLabel] setBackgroundColor:[self backgroundColor]];
}

- (RDVNotificationViewType)type {
    return _type;
}

- (void)showForView:(UIView *)view animated:(BOOL)animated {
    CGSize notificationSize = [self sizeThatFits:CGSizeMake(CGRectGetWidth([view frame]), 200)];
    [self setFrame:RDVRectMake(0, -notificationSize.height, notificationSize.width, notificationSize.height)];
    [view addSubview:self];
    
    __weak RDVNotificationView *weakSelf = self;
    
    simpleBlock animationBlock = ^{
        [weakSelf setFrame:RDVRectMake(0, 0, notificationSize.width, notificationSize.height)];
        
        if ([weakSelf siblingView]) {
            CGRect siblingFrame = [[weakSelf siblingView] frame];
            
            [[weakSelf siblingView] setFrame:RDVRectMake(siblingFrame.origin.x,
                                                         siblingFrame.origin.y + notificationSize.height,
                                                         siblingFrame.size.width,
                                                         siblingFrame.size.height - notificationSize.height)];
        }
    };
    
    boolBlock completionBlock = ^(BOOL status) {
        if (status && [weakSelf shouldDismiss]) {
            [weakSelf performSelector:@selector(hideNotification) withObject:nil afterDelay:4.0f];
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

- (void)showForView:(UIView *)view {
    [self showForView:view animated:YES];
}

- (void)hideNotificationAnimated:(BOOL)animated {
    if (_isHiding) {
        return;
    } else {
        _isHiding = YES;
    }
    
    __weak RDVNotificationView *weakSelf = self;
    
    simpleBlock animationBlock = ^{
        CGSize notificationSize = [self frame].size;
        [weakSelf setFrame:RDVRectMake(0, -notificationSize.height, notificationSize.width, notificationSize.height)];
        
        if ([weakSelf siblingView]) {
            CGRect siblingFrame = [[weakSelf siblingView] frame];
            
            [[weakSelf siblingView] setFrame:RDVRectMake(siblingFrame.origin.x,
                                                         siblingFrame.origin.y - notificationSize.height,
                                                         siblingFrame.size.width,
                                                         siblingFrame.size.height + notificationSize.height)];
        }
    };
    
    boolBlock completionBlock = ^(BOOL status) {
        if (status && [weakSelf shouldDismiss]) {
            [weakSelf removeFromSuperview];
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

- (void)hideNotification {
    [self hideNotificationAnimated:YES];
}

+ (void)addNotificationWithMessage:(NSString *)message withType:(RDVNotificationViewType)type forView:(UIView *)view
                       siblingView:(UIView *)siblingView animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                   completionBlock:(simpleBlock)completion {
    [RDVNotificationView removeNotificationForView:view];
    
    RDVNotificationView *notificationView = [[RDVNotificationView alloc] initWithMessage:message];
    [notificationView setType:type];
    [notificationView setSiblingView:siblingView];
    [notificationView setCompletion:completion];
    [notificationView showForView:view animated:animated];
    [notificationView setShouldDismiss:shouldDismiss];
}

+ (void)addInformationNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                                     animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                              completionBlock:(simpleBlock)completion {
    [self addNotificationWithMessage:message
                            withType:RDVNotificationViewTypeInformation
                             forView:view
                         siblingView:siblingView
                            animated:animated
                       shouldDismiss:shouldDismiss
                     completionBlock:completion];
}

+ (void)addErrorNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                               animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                        completionBlock:(simpleBlock)completion {
    [self addNotificationWithMessage:message
                            withType:RDVNotificationViewTypeError
                             forView:view
                         siblingView:siblingView
                            animated:animated
                       shouldDismiss:shouldDismiss
                     completionBlock:completion];
}

+ (void)addSuccessNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                                 animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                          completionBlock:(simpleBlock)completion {
    [self addNotificationWithMessage:message
                            withType:RDVNotificationViewTypeSuccess
                             forView:view
                         siblingView:siblingView
                            animated:animated
                       shouldDismiss:shouldDismiss
                     completionBlock:completion];
}

+ (void)removeNotificationForView:(UIView *)view {
    RDVNotificationView *notificationView = (RDVNotificationView *)[view viewWithTag:kRDVToolkitNotificationViewTag];
    if ([notificationView isKindOfClass:self]) {
        [notificationView hideNotification];
    }
}

@end
