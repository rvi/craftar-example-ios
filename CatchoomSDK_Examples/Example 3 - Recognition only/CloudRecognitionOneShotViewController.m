//
//  CloudRecognitionSnapPhotoViewController.m
//  catchoom-sdk-sampleapp
//
//  Created by Luis Martinell Andreu on 9/17/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#import "CloudRecognitionOneShotViewController.h"
#import <CatchoomSDK/CatchoomSDK.h>
#import <CatchoomSDK/CatchoomCloudRecognitionItem.h>
#import "CatchoomSDKUtils.h"

#define TEST_CRS_SINGLE_SHOT_MODE 0

@interface CloudRecognitionOneShotViewController () <CatchoomSDKProtocol, CatchoomCloudRecognitionProtocol> {
    CatchoomSDK *_sdk;
    CatchoomCloudRecognition *_crs;
    CatchoomCloudRecognitionItem *_foundItem;
}

@end

@implementation CloudRecognitionOneShotViewController


#pragma mark view initialization

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
    
    [[_sdk getCloudRecognitionInterface] setToken: @"craftarexamples3"];
    _crs = [_sdk getCloudRecognitionInterface];
    _crs.delegate = self;
    
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    // Start Video Preview for search and tracking
    [_sdk startCaptureWithView:self._preview];
    self._takePhotoButton.enabled = false;
}

#pragma mark -


#pragma mark Snap Photo mode implementation

- (void) didStartCapture {
    self._takePhotoButton.enabled = true;
}

- (IBAction)snapPhotoToSearch:(id)sender {
    _foundItem = nil;
    self._initialOverlay.hidden = YES;
#if !TEST_CRS_SINGLE_SHOT_MODE
    [_sdk takeSnapshot];
#else
    [self addScanFX];
    [_crs singleShotSearch];
#endif
    
}

#if !TEST_CRS_SINGLE_SHOT_MODE
- (void) didGetSnapshot:(UIImage *)snapshot {
    [_sdk freezeCapture];
    [_crs searchWithUIImage:snapshot];
}
#endif

- (void) didGetSearchResults:(NSArray *)resultItems {
    self._resultOverlay.hidden = NO;
    if ([resultItems count] >= 1) {
        _foundItem = [resultItems objectAtIndex:0];
        [self._itemNameLabel setText:_foundItem.itemName];
        UIImageFromURL([NSURL URLWithString:_foundItem.thumbnail120], ^(UIImage *image) {
            [self._itemThumbnailView setImage:image];
        }, ^{
            NSLog(@"Error Loading image");
        });
    } else {
        [self._itemNameLabel setText:@"No match found"];
        UIImage *catchyHead = [UIImage imageNamed:@"Icon.png"];
        [self._itemThumbnailView setImage:catchyHead];
    }
}

- (void) didFailWithError:(CatchoomSDKError *)error {
    // Check the error type
    NSLog(@"Error calling CRS: %@", [error localizedDescription]);
    self._resultOverlay.hidden = NO;
}

- (void) didValidateToken {
    // Token valid, do nothing
}

- (void) donePressed:(id)sender {
    self._initialOverlay.hidden = NO;
    self._resultOverlay.hidden = YES;
    [_sdk unfreezeCapture];
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


#pragma mark view lifecycle

- (void) viewWillDisappear:(BOOL)animated {
    [_sdk stopCapture];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [_sdk stopCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

@end
