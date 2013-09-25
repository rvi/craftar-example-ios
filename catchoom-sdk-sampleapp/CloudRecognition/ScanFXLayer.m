//
// © Catchoom Technologies S.L.
// Licensed under the MIT license.
// http://github.com/Catchoom/catchoom-example-ios/blob/master/LICENSE
//  All warranties and liabilities are disclaimed.
//


#import "ScanFXLayer.h"

@interface ScanFXLayer () {
    CGFloat _scanBarHeight;
    CGFloat _roundTripDuration;
    UIColor* _barColor;
}
@end

@implementation ScanFXLayer

- (id) initWithColor: (UIColor*) color andRoundTripDuration: (CGFloat) duration {
    self = [super init];
    if (self != nil) {
        _scanBarHeight = DEFAULT_SCAN_BAR_HEIGHT;
        _roundTripDuration = duration;
        _barColor = color;
    }
    return self;
}

- (id) initWithColor: (UIColor*) color {
    self = [super init];
    if (self != nil) {
        _scanBarHeight = DEFAULT_SCAN_BAR_HEIGHT;
        _roundTripDuration = DEFAULT_ROUND_TRIP_DURATION;
        _barColor = color;
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        _scanBarHeight = DEFAULT_SCAN_BAR_HEIGHT;
        _roundTripDuration = DEFAULT_ROUND_TRIP_DURATION;
        _barColor = [UIColor redColor];
    }
    return self;
}

- (void)startAnimation
{
    CAKeyframeAnimation *animationBottom2Top = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationBottom2Top setDuration:_roundTripDuration];
    [animationBottom2Top setRepeatCount:INT_MAX];
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSNumber numberWithInt:self.bounds.origin.y]];
    [values addObject:[NSNumber numberWithInt:self.bounds.origin.y + self.bounds.size.height - _scanBarHeight]];
    [values addObject:[NSNumber numberWithInt:self.bounds.origin.y]];
    [animationBottom2Top setValues:values];
    
    [self addAnimation:animationBottom2Top forKey:nil];
    [self setNeedsDisplay];
}

- (void) drawInContext:(CGContextRef)ctx {
    CGRect layerBounds = self.bounds;
    
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceRGB();    
    NSArray* colors = [NSArray arrayWithObjects: (id)[UIColor clearColor].CGColor, _barColor.CGColor, [UIColor clearColor].CGColor, nil];
    CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, (__bridge CFArrayRef)colors, nil);
    
    CGPoint myStartPoint, myEndPoint;
    myStartPoint.x = 0.0;
    myStartPoint.y = 0.0;
    myEndPoint.x = 0.0;
    myEndPoint.y = _scanBarHeight;
    CGContextDrawLinearGradient (ctx, myGradient, myStartPoint, myEndPoint, 0);
    
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, CGRectMake(layerBounds.origin.x, layerBounds.origin.y, layerBounds.size.width, 1));
    CGContextClip(ctx);
    CGContextRestoreGState(ctx);
    
}

@end
