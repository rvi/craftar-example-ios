//
// © Catchoom Technologies S.L.
// Licensed under the MIT license.
// http://github.com/Catchoom/catchoom-example-ios/blob/master/LICENSE
//  All warranties and liabilities are disclaimed.
//


#import <CatchoomSDK/CatchoomSDK.h>
#import <CatchoomSDK/CatchoomCloudRecognitionItem.h>
#import "FinderModeSearchViewController.h"
#import "ScanFXLayer.h"
#import "CatchoomSDKUtils.h"

@interface FinderModeSearchViewController () <CatchoomSDKProtocol, CatchoomCloudRecognitionProtocol> {
    CatchoomSDK *_sdk;
    CatchoomCloudRecognition *_crs;
    ScanFXLayer *_scanFXLayer;
    CatchoomCloudRecognitionItem *_foundItem;
}

@end

@implementation FinderModeSearchViewController

# pragma mark View initialization

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
    _sdk.delegate = self;
    
    [_sdk setDefaultCollectionToken:PLACE_YOUR_CRS_TOKEN_HERE];
    _crs = [_sdk getCloudRecognitionInterface];
    _crs.delegate = self;
    
    // Start Video Preview for search and tracking
    [_sdk startVideoForView:self._preview];
    self._initialOverlay.hidden = YES;
}

#pragma mark -


#pragma mark Finder mode search implementation

- (void) didStartVideoCaptureAndPreview {
    self._initialOverlay.hidden = NO;
}

- (IBAction)startScanPressed:(id)sender {
    self._initialOverlay.hidden = YES;
    self._scanOverlay.hidden = NO;
    [self addScanFX];
    [_crs startSearch];
}

- (IBAction)stopScanPressed:(id)sender {
    [self removeScanFX];
    [_crs stopSearch];
    self._initialOverlay.hidden = NO;
    self._scanOverlay.hidden = YES;
}

- (void) didGetSearchResults:(NSArray *)resultItems {
    // if NO match found, do nothing, scan continues
    if ([resultItems count] >= 1) {
        [_crs stopSearch];
        [_sdk pausePreview];
        self._resultOverlay.hidden = NO;
        self._scanOverlay.hidden = YES;
        [self removeScanFX];
        _foundItem = [resultItems objectAtIndex:0];
        [self._itemNameLabel setText:_foundItem.itemName];
        UIImageFromURL([NSURL URLWithString:_foundItem.thumbnail120], ^(UIImage *image) {
            [self._itemThumbnailView setImage:image];
        }, ^{
            NSLog(@"Error Loading image");
        });
    }
}

- (void) didFailWithError:(CatchoomCloudRecognitionError *)error {
    // In this case we ignore the errors but the recommended is to check the error
    // type to know if the server is not responding
}

- (void) donePressed:(id)sender {
    self._initialOverlay.hidden = NO;
    self._resultOverlay.hidden = YES;
    [_sdk continuePreview];
}

- (void) contentPressed:(id)sender {
    [self._contentBox setBackgroundColor:[UIColor grayColor]];
}

- (void) contentReleasedInside: (id)sender {
    [self._contentBox setBackgroundColor:[UIColor whiteColor]];
    if (_foundItem != nil) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *itemUrl = [NSURL URLWithString:_foundItem.url];
        [app openURL:itemUrl];
    }
}

- (void) contentReleasedOutside: (id)sender {
    [self._contentBox setBackgroundColor:[UIColor whiteColor]];
}


#pragma mark -


#pragma mark ScanFX management

- (void) addScanFX {
    _scanFXLayer = [[ScanFXLayer alloc] init];
    [_scanFXLayer setFrame:self._preview.layer.bounds];
    [self._preview.layer addSublayer:_scanFXLayer];
    [_scanFXLayer startAnimation];
}

- (void) removeScanFX {
    [_scanFXLayer removeFromSuperlayer];
}

#pragma mark -


#pragma mark view lifecycle

- (void) viewWillDisappear:(BOOL)animated {
    [_sdk stop];
}

- (void)viewDidUnload {
    [_sdk stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

@end
