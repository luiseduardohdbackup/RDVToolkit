// RDVAlertView.m
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

#import "RDVAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface RDVAlertView ()

@property (nonatomic) UIWindow *alertWindow;
@property (nonatomic) UIView *buttonSeparator;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;

@end

@implementation RDVAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super init];
    if (self) {
        _title = [title copy];
        _message = [message copy];
        _delegate = delegate;
        
        // Setup alert view
        
        UIColor *backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        UIColor *separatorColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0];
        
        [self setBackgroundColor:backgroundColor];
        [[self layer] setCornerRadius:7.0];
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setBorderColor:separatorColor.CGColor];
        [[self layer] setMasksToBounds:YES];
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:backgroundColor];
        [self addSubview:_contentView];
        
        _buttonSeparator = [[UIView alloc] init];
        [_buttonSeparator setBackgroundColor:separatorColor];
        [self addSubview:_buttonSeparator];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setText:_title];
        [_contentView addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setTextColor:[UIColor blackColor]];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_messageLabel setNumberOfLines:0];
        [_messageLabel setText:_message];
        [_contentView addSubview:_messageLabel];
        
        // Setup notification observers
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(deviceDidChangeOrientation:)
                              name:UIDeviceOrientationDidChangeNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(keyboardDidShow:)
                              name:UIKeyboardDidShowNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(keyboardWillHide:)
                              name:UIKeyboardWillHideNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(keyboardWillChangeFrame:)
                              name:UIKeyboardWillChangeFrameNotification
                            object:nil];
        
        // Setup window
        
        CGRect applicationFrame = [[UIScreen mainScreen] bounds];
        _alertWindow = [[UIWindow alloc] initWithFrame:applicationFrame];
        [_alertWindow setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3f]];
        [_alertWindow setAlpha:0.0f];
        [_alertWindow setWindowLevel:UIWindowLevelAlert];
        [_alertWindow addSubview:self];
    }
    return self;
}

- (id)init {
    return [self initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
}

- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self forKeyPath:UIDeviceOrientationDidChangeNotification];
    [defaultCenter removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
    [defaultCenter removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [defaultCenter removeObserver:self forKeyPath:UIKeyboardWillChangeFrameNotification];
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    [[self contentView] setFrame:RDVRectMake(0, 0, viewSize.width, viewSize.height - 50)];
    
    [[self titleLabel] setFrame:RDVRectMake(20, 20, viewSize.width - 2 * 20,
                                            [[self titleLabel] sizeThatFits:
                                             CGSizeMake(viewSize.width - 2 * 20, 100)].height)];
    
    [[self messageLabel] setFrame:RDVRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 8, viewSize.width - 2 * 20,
                                            [[self messageLabel] sizeThatFits:
                                             CGSizeMake(viewSize.width - 2 * 20, 200)].height)];
    
    [[self buttonSeparator] setFrame:RDVRectMake(0, CGRectGetMaxY(self.contentView.frame),
                                                 viewSize.width, 1)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(270, 150);
}

#pragma mark - Configuring buttons

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return 0;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return nil;
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
    return nil;
}

#pragma mark - Displaying

- (void)show {
    CGSize windowSize = [[self alertWindow] frame].size;
    CGFloat alertWidth = 270.0f;
    CGFloat alertHeight = [self sizeThatFits:CGSizeMake(300, 600)].height;
    
    [[self alertWindow] makeKeyAndVisible];
    
    [self setFrame:RDVRectMake(roundf(windowSize.width / 2 - alertWidth / 2),
                               roundf(windowSize.height / 2 - alertHeight / 2),
                               alertWidth, alertHeight)];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.20f animations:^{
        [[self alertWindow] setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        _visible = YES;
    }];
}

#pragma mark - Dismissing

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
}

#pragma mark - Handle rotation

- (void)deviceDidChangeOrientation:(NSNotification *)notification {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.transform = rotation;
                     }
                     completion:nil
     ];
}

#pragma mark - Handle keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
//    [self setKeyboardShown:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.contentInset = contentInsets;
//    self.scrollIndicatorInsets = contentInsets;
//    self.contentOffset = CGPointZero;
//    
//    [self setKeyboardShown:NO];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    // convert keyboardFrame to view's coordinate system, because it is given in the window's which is always portrait
//    // http://stackoverflow.com/questions/9746417/keyboard-willshow-and-willhide-vs-rotation
//    CGRect convertedFrame = [self convertRect:keyboardFrame fromView:self.window];
//    [self moveContentFromBeneathTheKeyboard:convertedFrame];
}

@end
