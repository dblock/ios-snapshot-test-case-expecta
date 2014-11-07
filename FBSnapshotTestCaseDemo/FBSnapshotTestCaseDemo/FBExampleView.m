/*
 *  Copyright (c) 2013, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */
 
#import "FBExampleView.h"

@implementation FBExampleView

- (void)drawRect:(CGRect)rect
{
  [[self color] setFill];
  CGContextFillRect(UIGraphicsGetCurrentContext(), [self bounds]);
}

- (UIColor *)color
{
    return [UIColor clearColor];
}

@end

@implementation FBRedView
- (UIColor *)color
{
    return [UIColor redColor];
}
@end

@implementation FBBlueView
- (UIColor *)color
{
    return [UIColor blueColor];
}
@end
