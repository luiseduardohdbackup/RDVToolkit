// RDVTableViewController.m
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

#import "RDVTableViewController.h"

@interface RDVTableViewController () {
    UITableViewStyle _tableViewStyle;
}
@end

@implementation RDVTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _tableViewStyle = style;
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeBottom|UIRectEdgeLeft|UIRectEdgeRight];
        }
    }
    return self;
}

- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:contentView.bounds style:_tableViewStyle];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [tableView setRowHeight:44.0f];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [contentView addSubview:tableView];
    [self setTableView:tableView];
    
    [self setView:contentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self clearsSelectionOnViewWillAppear]) {
        [self.tableView deselectRowAtIndexPath:[[self tableView] indexPathForSelectedRow]
                                      animated:YES];
    }
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
