// CraftARSDK_Examples is free software. You may use it under the MIT license, which is copied
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


#import "AR_ProgrammaticallyViewController.h"
#import <CraftARSDK/CraftARSDK.h>

@interface AR_ProgrammaticallyViewController () <CraftARSDKProtocol, CraftARCloudRecognitionProtocol> {
    // CraftAR SDK reference
    CraftARSDK *_sdk;
    
    CraftARCloudRecognition *_cloudRecognition;
    CraftARTracking *_tracking;
    
    bool _isTrackingEnabled;
}
@end

@implementation AR_ProgrammaticallyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup the CraftAR SDK
    _sdk = [CraftARSDK sharedCraftARSDK];
    
    // Implement the CraftARSDKProtocol to know when the previewView is ready
    [_sdk setDelegate:self];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    // Start Video Preview for search and tracking
    [_sdk startCaptureWithView: self.videoPreviewView];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop the SDK when the view is being closed to cleanup sdk internals.
    [_sdk stopCapture];
    if (_isTrackingEnabled) {
        [_tracking stopTracking];
        [_tracking removeAllARItems];
    } else {
        [_cloudRecognition stopFinderMode];
    }
}

- (void) didStartCapture {
    // Get the CloudRecognition and set self as delegate to receive search responses
    _cloudRecognition = [_sdk getCloudRecognitionInterface];
    [_cloudRecognition setDelegate:self];
    
    // Get the Tracking instance
    _tracking = [_sdk getTrackingInterface];
    
    // Start scanning
    self._scanOverlay.hidden = false;
    [_cloudRecognition startFinderMode];
}

- (void) didGetSearchResults:(NSArray *)results {
    Boolean haveContent = false;
    [_cloudRecognition stopFinderMode];
    
    // Look for trakcable results
    for (CraftARItem* item in results) {
        
        if (item.getType == ITEM_TYPE_AR) {
            CraftARItemAR* arItem = (CraftARItemAR*)item;
            // Local content creation
            CraftARTrackingContentImage *image = [[CraftARTrackingContentImage alloc] initWithImageNamed:@"AR_programmatically_content" ofType:@"png"];
            image.wrapMode = CRAFTAR_TRACKING_WRAP_ASPECT_FIT;
            [arItem addContent:image];
            [_tracking addARItem:arItem];
            haveContent = true;
        }
    }
    
    if (haveContent) {
        [_tracking startTracking];
        _isTrackingEnabled = true;
        self._scanOverlay.hidden = true;
    } else {
        [_cloudRecognition startFinderMode];
    }
}

- (void) didFailWithError:(CraftARSDKError *)error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void) didValidateToken {
    // Called after setToken or startSearch if the token is valid.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
