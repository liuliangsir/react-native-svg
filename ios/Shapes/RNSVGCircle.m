/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNSVGCircle.h"
#import <React/RCTLog.h>

@implementation RNSVGCircle

- (void)setCx:(NSString *)cx
{
    if (cx == _cx) {
        return;
    }
    [self invalidate];
    _cx = cx;
}

- (void)setCy:(NSString *)cy
{
    if (cy == _cy) {
        return;
    }
    [self invalidate];
    _cy = cy;
}

- (void)setR:(NSString *)r
{
    if (r == _r) {
        return;
    }
    [self invalidate];
    _r = r;
}

- (CGPathRef)getPath:(CGContextRef)context
{
    [self setContextBoundingBox:CGContextGetClipBoundingBox(context)];
    CGMutablePathRef path = CGPathCreateMutable();
    RNSVGPercentageConverter* convert = [[RNSVGPercentageConverter alloc] init];
    CGFloat cx = [self getWidthRelatedValue:self.cx];
    CGFloat cy = [self getHeightRelatedValue:self.cy];
    CGFloat r;
    // radius percentage calculate formula:
    // radius = sqrt(pow((width*percent), 2) + pow((height*percent), 2)) / sqrt(2)
    
    if ([convert isPercentage:self.r]) {
        CGFloat radiusPercent = [convert percentageToFloat:self.r relative:1 offset:0];
        
        r = sqrt(
                 pow((CGRectGetWidth([self getContextBoundingBox]) * radiusPercent), 2) +
                 pow((CGRectGetHeight([self getContextBoundingBox]) * radiusPercent), 2)
                 ) / sqrt(2);
    } else {
        r = [self.r floatValue];
    }
    
    CGPathAddArc(path, nil, cx, cy, r, 0, 2*M_PI, NO);
    return (CGPathRef)CFAutorelease(path);
}

@end
