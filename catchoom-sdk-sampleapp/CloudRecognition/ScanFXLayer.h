//
// © Catchoom Technologies S.L.
// Licensed under the MIT license.
// http://github.com/Catchoom/catchoom-example-ios/blob/master/LICENSE
//  All warranties and liabilities are disclaimed.
//


#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#define DEFAULT_SCAN_BAR_HEIGHT 20.0
#define DEFAULT_ROUND_TRIP_DURATION 2.0

@interface ScanFXLayer : CALayer

- (id) init;
- (id) initWithColor: (UIColor*) color;
- (id) initWithColor: (UIColor*) color andRoundTripDuration: (CGFloat) duration;

- (void) startAnimation;

@end

