//
//  FinderModeSearchViewController.m
//  catchoom-sdk-sampleapp
//
//  Created by Luis Martinell Andreu on 9/17/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#import <CatchoomSDK/CatchoomSDK.h>
#import <CatchoomSDK/CatchoomCloudRecognitionItem.h>
#import "FinderModeSearchViewController.h"
#import "CatchoomSDKUtils.h"

@interface FinderModeSearchViewController () <CatchoomSDKProtocol, CatchoomCloudRecognitionProtocol> {
    CatchoomSDK *_sdk;
    CatchoomCloudRecognition *_crs;
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
    
    [[_sdk getCloudRecognitionInterface] setToken: @"bd40bb6b8656d16f"];
    _crs = [_sdk getCloudRecognitionInterface];
    _crs.delegate = self;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    // Start Video Preview for search and tracking
    [_sdk startCaptureWithView:self._preview];
    self._initialOverlay.hidden = YES;
}

#pragma mark -


#pragma mark Finder mode search implementation

- (void) didStartCapture {
    self._initialOverlay.hidden = NO;
}

- (IBAction)startScanPressed:(id)sender {
    self._initialOverlay.hidden = YES;
    self._scanOverlay.hidden = NO;
    [_crs startFinderMode];
}

- (IBAction)stopScanPressed:(id)sender {
    [_crs stopFinderMode];
    self._initialOverlay.hidden = NO;
    self._scanOverlay.hidden = YES;
}

- (void) didGetSearchResults:(NSArray *)resultItems {
    // if NO match found, do nothing, scan continues
    if ([resultItems count] >= 1) {
        [_crs stopFinderMode];
        [_sdk freezeCapture];
        self._resultOverlay.hidden = NO;
        self._scanOverlay.hidden = YES;
        _foundItem = [resultItems objectAtIndex:0];
        [self._itemNameLabel setText:_foundItem.itemName];
        UIImageFromURL([NSURL URLWithString:_foundItem.thumbnail120], ^(UIImage *image) {
            [self._itemThumbnailView setImage:image];
        }, ^{
            NSLog(@"Error Loading image");
        });
    }
}

- (void) didFailWithError:(CatchoomSDKError *)error {
    // In this case we ignore the errors but the recommended is to check the error
    // type to know if the server is not responding
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void) didValidateToken {
    // Token valid, do nothing.
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
