// RDVNotificationView.h
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

typedef NS_ENUM(NSInteger, RDVNotificationViewType) {
    RDVNotificationViewTypeInformation = 0,
    RDVNotificationViewTypeError,
    RDVNotificationViewTypeSuccess,
};

@interface RDVNotificationView : UIView

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic) RDVNotificationViewType type;
@property (nonatomic, weak) UIView *siblingView;
@property (nonatomic, copy) simpleBlock completion;
@property (nonatomic) BOOL shouldDismiss;

- (id)initWithMessage:(NSString *)message;

- (void)showForView:(UIView *)view animated:(BOOL)animated;
- (void)showForView:(UIView *)view;

- (void)hideNotificationAnimated:(BOOL)animated;
- (void)hideNotification;

+ (void)addNotificationWithMessage:(NSString *)message withType:(RDVNotificationViewType)type forView:(UIView *)view
                       siblingView:(UIView *)siblingView animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                   completionBlock:(simpleBlock)completion;

+ (void)addInformationNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                                     animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                              completionBlock:(simpleBlock)completion;

+ (void)addErrorNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                                     animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                        completionBlock:(simpleBlock)completion;

+ (void)addSuccessNotificationWithMessage:(NSString *)message forView:(UIView *)view siblingView:(UIView *)siblingView
                                     animated:(BOOL)animated shouldDismiss:(BOOL)shouldDismiss
                          completionBlock:(simpleBlock)completion;

+ (void)removeNotificationForView:(UIView *)view;

@end
