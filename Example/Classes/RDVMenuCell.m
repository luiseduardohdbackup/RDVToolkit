//
//  RDVMenuCell.m
//  RDVToolkit
//
//  Created by Robert Dimitrov on 11/13/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVMenuCell.h"

@implementation RDVMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _circularImageView = [[RDVCircularImageView alloc] init];
        [self.contentView addSubview:_circularImageView];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeMake(50, 50);
    CGSize textSize = [[self textLabel] sizeThatFits:CGSizeMake(frameSize.width - imageSize.width - 5 - 5 - 5, frameSize.height)];
    
    [[self circularImageView] setFrame:RDVRectMake(15, 5, 50, 50)];
    
    [[self textLabel] setFrame:RDVRectMake(CGRectGetMaxX(self.circularImageView.frame) + 5, frameSize.height / 2 - textSize.height / 2,
                                           textSize.width, textSize.height)];
}

@end
