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


#import "CloudRecognitionAndTrackingLocalContentsViewController.h"
#import <CatchoomSDK/CatchoomSDK.h>
#import "CatchoomCloudTrackingLocalContentsAuto.h"

@interface CloudRecognitionAndTrackingLocalContentsViewController () <CatchoomSDKProtocol, CatchoomCloudTrackingAutoProtocol> {
    // Catchoom SDK reference
    CatchoomSDK *_sdk;
    
    // Manages communication with the SDK
    CatchoomCloudTrackingLocalContentsAuto *_catchoomAuto;
    
}
@end

@implementation CloudRecognitionAndTrackingLocalContentsViewController

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
    
    // setup the Catchoom SDK
    _sdk = [CatchoomSDK sharedCatchoomSDK];
    
    // Implement the CatchoomSDKProtocol to know when the previewView is ready
    _sdk.delegate = self;
    
    // Rotate the corner images for the scan overlay
    self._scanOverlayTR.transform = CGAffineTransformMakeRotation(M_PI_2);
    self._scanOverlayBR.transform = CGAffineTransformMakeRotation(M_PI);
    self._scanOverlayBL.transform = CGAffineTransformMakeRotation(M_PI+M_PI_2);
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
    [_catchoomAuto stop];
}

- (void) didStartCapture {
    // Setup Catchoom CloudTrackingAuto object for cloud search and automatic content setup
    _catchoomAuto = [[CatchoomCloudTrackingLocalContentsAuto alloc] init];
    
    // Implement the CatchoomCloudTrackingAuto Protocol to know when a reference was detected and the tracking started.
    [_catchoomAuto setDelegate:self];
}

// The user pressed the "Tap to scan" layer, start scanning for objects, display the scan overlay only.
- (IBAction)startScanning:(id)sender {
    self._tapToScanOverlay.hidden = true;
    self._trackingOverlay.hidden = true;
    
    self._scanOverlay.hidden = false;
    [_catchoomAuto start];
}

// A reference was found and tracking started displaying the reference's content. Display the tracking overlay only (with the "stop" button).
- (void) didStartTracking {
    self._scanOverlay.hidden = true;
    self._trackingOverlay.hidden = false;
    [self._trackingOverlay setNeedsDisplay];
}

// The user pressed the "stop" button.
- (IBAction)stopTracking:(id)sender {
    
    // Hide the scanning layer and tracking overlays
    self._scanOverlay.hidden = true;
    self._trackingOverlay.hidden = true;
    
    // Show the first layer ("Tap to scan")
    self._tapToScanOverlay.hidden = false;
    
    // Stop if tracking
    [_catchoomAuto stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
