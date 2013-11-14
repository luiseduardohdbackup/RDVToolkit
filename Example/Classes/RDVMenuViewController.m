// RDVMenuViewController.m
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

#import "RDVMenuViewController.h"
#import "RDVMenuCell.h"

@interface RDVMenuViewController () <RDVAlertViewDelegate>

@property (nonatomic) NSArray *elements;
@property (nonatomic) RDVSelectionView *selectionView;

@end

@implementation RDVMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"RDVToolkit";
        
        _elements = @[@"Display error message", @"Display success message", @"Display information message",
                      @"Circular image", @"Show Alert View"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setRowHeight:60.0f];
    [self.tableView setSectionHeaderHeight:44.0f];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self elements] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 3) {
        NSString *CellIdentifier = @"ImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[RDVMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 3) {
            NSURL *url = [NSURL URLWithString:@"http://www.maxmotors.com/wp-content/uploads/2012/09/2014-Mustang-Under-Bridge.jpg"];
            [[(RDVMenuCell *)cell circularImageView] setImageWithURL:url];
        }
    } else {
        NSString *CellIdentifier = @"NormalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    [[cell textLabel] setText:[[self elements] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [RDVNotificationView addErrorNotificationWithMessage:@"Error message here"
                                                     forView:self.view
                                                 siblingView:self.tableView
                                                    animated:YES
                                               shouldDismiss:YES
                                             completionBlock:NULL];
    } else if (indexPath.row == 1) {
        [RDVNotificationView addSuccessNotificationWithMessage:@"Success message here"
                                                       forView:self.view
                                                   siblingView:self.tableView
                                                      animated:YES
                                                 shouldDismiss:YES
                                               completionBlock:NULL];
    } else if (indexPath.row == 2) {
        [RDVNotificationView addInformationNotificationWithMessage:@"Information message here"
                                                           forView:self.view
                                                       siblingView:self.tableView
                                                          animated:YES
                                                     shouldDismiss:YES
                                                   completionBlock:NULL];
    } else if (indexPath.row == 4) {
        RDVAlertView *alertView = [[RDVAlertView alloc] initWithTitle:@"Sample title"
                                                              message:@"Example not so long message string"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Done", nil];
        [alertView show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self selectionView]) {
        [self setSelectionView:[[RDVSelectionView alloc] initWithFrame:RDVRectMake(0, 0,
                                                                                   CGRectGetWidth([[self tableView] frame]),
                                                                                   44.0f)]];
        [[self selectionView] setItems:@[@"First", @"Second", @"Third"]];
    }
    
    return [self selectionView];
}

@end
