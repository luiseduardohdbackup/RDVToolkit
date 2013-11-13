// UIColor+RDVToolkitAdditions.m
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

#import "UIColor+RDVToolkitAdditions.h"

@implementation UIColor (RDVToolkitAdditions)

- (CGFloat)rdv_redValue {
    CGFloat redValue = 0;
    
    [self getRed:&redValue green:NULL blue:NULL alpha:NULL];
    
    return redValue * 255.0;
}

- (CGFloat)rdv_greenValue {
    CGFloat greenValue = 0;
    
    [self getRed:NULL green:&greenValue blue:NULL alpha:NULL];
    
    return greenValue * 255.0;
}

- (CGFloat)rdv_blueValue {
    CGFloat blueValue = 0;
    
    [self getRed:NULL green:NULL blue:&blueValue alpha:NULL];
    
    return blueValue * 255.0;
}

- (CGFloat)rdv_alphaValue {
    CGFloat aplhaValue = 0;
    
    [self getRed:NULL green:NULL blue:NULL alpha:&aplhaValue];
    
    return aplhaValue * 255.0;
}

- (NSString *)rdv_hexString {
    CGFloat red = 0, green = 0, blue = 0;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    
    red *= 255;
    green *= 255;
    blue *= 255;
    
    return [NSString stringWithFormat:@"%0x%0x%0x", (unsigned int)red, (unsigned int)green, (unsigned int)blue];
}

+ (UIColor *)rdv_colorWithHex:(NSString *)hexString alpha:(CGFloat)alpha {
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    
    if ([hexString length] > 6) {
        [scanner setScanLocation:[hexString length] - 6];
    }
    
    unsigned int hexValue = 0, red = 0, green = 0, blue = 0;
    
    if (![scanner scanHexInt:&hexValue]) {
        return nil;
    }
    
    red = (hexValue >> 16) & 0xFF;
    green = (hexValue >> 8) & 0xFF;
    blue = (hexValue) & 0xFF;
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)rdv_colorWithHex:(NSString *)hexString {
    return [self rdv_colorWithHex:hexString alpha:1.0];
}

@end
