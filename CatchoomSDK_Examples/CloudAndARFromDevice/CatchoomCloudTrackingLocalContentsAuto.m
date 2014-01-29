// CatchoomSDK_Examples is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2014 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "CatchoomCloudTrackingLocalContentsAuto.h"
#import <CatchoomSDK/CatchoomCloudRecognitionItem.h>
#import <CatchoomSDK/CatchoomTrackingReference.h>
#import <CatchoomSDK/CatchoomTrackingContent.h>
#import <CatchoomSDK/CatchoomTrackingContentImage.h>

@interface CatchoomCloudTrackingLocalContentsAuto () <CatchoomCloudRecognitionProtocol> {
    CatchoomCloudRecognition *_cloudRecognition;
    CatchoomTracking *_tracking;
    
    Boolean _isTracking;
}

@end

@implementation CatchoomCloudTrackingLocalContentsAuto

- (id) init {
    self = [super init];
    if (self != nil) {
        // Get the SDK instance
        CatchoomSDK *sdk = [CatchoomSDK sharedCatchoomSDK];
        
        // Get the CloudRecognition and set self as delegate to receive search responses
        _cloudRecognition = [sdk getCloudRecognitionInterface];
        [_cloudRecognition setDelegate:self];
        
        // Get the Tracking instance
        _tracking = [sdk getTrackingInterface];
    }
    return self;
}

- (void) start {
    [_cloudRecognition startFinderMode];
}

- (void) stop {
    if (_isTracking) {
        [_tracking stopTracking];
        [_tracking removeAllARItems];
    } else {
        [_cloudRecognition stopFinderMode];
    }
}

- (void) didGetSearchResults:(NSArray *)results {
    Boolean haveContent = false;
    [_cloudRecognition stopFinderMode];
    
    // Look for trakcable results
    for (CatchoomCloudRecognitionItem* item in results) {
        
        if (item.getType == ITEM_TYPE_AR) {
            CatchoomARItem* arItem = (CatchoomARItem*)item;
            // Local content creation
            CatchoomTrackingContentImage *image = [[CatchoomTrackingContentImage alloc] initWithImageNamed:@"hello_world_image" ofType:@"png"];
            [arItem addContent:image];
            [_tracking addARItem:arItem];
            haveContent = true;
        }
    }
    
    if (haveContent) {
        [_tracking startTracking];
        if ([self.delegate respondsToSelector:@selector(didStartTracking)]) {
            [self.delegate didStartTracking];
        }
        _isTracking = true;
    } else {
        [_cloudRecognition startFinderMode];
    }
}

- (void) didFailWithError:(CatchoomSDKError *)error {
    
}

- (void) didValidateToken {
    // Called after setToken or startSearch if the token is valid.
}


@end