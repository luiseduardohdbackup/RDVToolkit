// RDVAlertView.h
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

@protocol RDVAlertViewDelegate;

typedef NS_ENUM(NSInteger, RDVAlertViewStyle) {
    RDVAlertViewStyleDefault = 0,
    RDVAlertViewStyleSecureTextInput,
    RDVAlertViewStylePlainTextInput,
    RDVAlertViewStyleLoginAndPasswordInput,
};

@interface RDVAlertView : UIView

#pragma mark - Setting Properties

/**
 * A Boolean value that indicates whether the receiver is displayed. (read-only)
 */
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

/**
 * The string that appears in the receiver’s title bar.
 */
@property(nonatomic, copy) NSString *title;

/**
 * Descriptive text that provides more details than the title.
 */
@property(nonatomic, copy) NSString *message;

/**
 * The kind of alert displayed to the user.
 */
@property(nonatomic, assign) RDVAlertViewStyle alertViewStyle;

/**
 * Returns the content view of the alert view. (read-only)
 */
@property (nonatomic, readonly) UIView *contentView;

/**
 * The receiver’s delegate or nil if it doesn’t have a delegate.
 */
@property(nonatomic, assign) id <RDVAlertViewDelegate> delegate;

#pragma mark - Configuring Buttons

/**
 * Adds a button to the receiver with the given title.
 *
 * @param title The title of the new button.
 *
 * @return The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

/**
 * The number of buttons on the alert view. (read-only)
 */
@property(nonatomic, readonly) NSInteger numberOfButtons;

/**
 * Returns the title of the button at the given index.
 *
 * @param buttonIndex The index of the button. The button indices start at 0.
 *
 * @return The title of the button specified by index buttonIndex.
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

/**
 * Returns the text field at the given index
 *
 * @param textFieldIndex The index of the text field. The text field indices start at 0.
 *
 * @return The text field specified by index textFieldIndex.
 */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

/**
 * The index number of the cancel button.
 */
@property(nonatomic) NSInteger cancelButtonIndex;

/**
 * The index of the first other button. (read-only)
 */
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;

#pragma mark - Creating Alert Views

/**
 * Convenience method for initializing an alert view.
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id <RDVAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Displaying

/**
 * Displays the receiver using animation.
 */
- (void)show;

#pragma mark - Dismissing

/**
 * Dismisses the receiver, optionally with animation.
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

@protocol RDVAlertViewDelegate <NSObject>
@optional

#pragma mark Responding to Actions

/**
 * Sent to the delegate when the user clicks a button on an alert view.
 *
 * @param alertView The alert view containing the button.
 * @param buttonIndex The index of the button that was clicked. The button indices start at 0.
 */
- (void)alertView:(RDVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

#pragma mark Customizing Behavior

/**
 * Sent to the delegate to determine whether the first non-cancel button in the alert should be enabled.
 *
 * @param alertView The alert view that is being configured.
 */
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

/**
 * Sent to the delegate before an alert view is presented to the user.
 *
 * @param alertView The alert view that is about to be displayed.
 */
- (void)willPresentAlertView:(UIAlertView *)alertView;

/**
 * Sent to the delegate after an alert view is presented to the user.
 *
 * @param alertView The alert view that was displayed.
 */
- (void)didPresentAlertView:(UIAlertView *)alertView;

/**
 * Sent to the delegate before an alert view is dismissed.
 *
 * @param alertView The alert view that is about to be dismissed.
 * @param buttonIndex The index of the button that was clicked. The button indices start at 0. 
 * If this is the cancel button index, the alert view is canceling. If -1, the cancel button index is not set.
 */
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

/**
 * Sent to the delegate after an alert view is dismissed from the screen.
 *
 * @param alertView The alert view that was dismissed.
 * @param buttonIndex The index of the button that was clicked. The button indices start at 0. 
 * If this is the cancel button index, the alert view is canceling. If -1, the cancel button index is not set.
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

#pragma mark Canceling

/**
 * Sent to the delegate before an alert view is canceled.
 *
 * @param alertView The alert view that will be canceled.
 */
- (void)alertViewCancel:(UIAlertView *)alertView;

@end
