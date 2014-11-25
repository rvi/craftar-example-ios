//
//  CloudRecognitionSnapPhotoViewController.m
//
//  Created by Luis Martinell Andreu on 9/17/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#import "CloudRecognitionOneShotViewController.h"
#import <CraftARSDK/CraftARSDK.h>
#import <CraftARSDK/CraftARItem.h>

@interface CloudRecognitionOneShotViewController () <CraftARSDKProtocol, CraftARCloudRecognitionProtocol> {
    CraftARSDK *_sdk;
    CraftARCloudRecognition *_crs;
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
    
    // setup the CraftAR SDK
    _sdk = [CraftARSDK sharedCraftARSDK];
    _sdk.delegate = self;
    
    _crs = [_sdk getCloudRecognitionInterface];
    _crs.delegate = self;
    
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    // Start Video Preview for search and tracking
    [_sdk startCaptureWithView:self._preview];
}

#pragma mark -


#pragma mark Snap Photo mode implementation

- (void) didStartCapture {
    self._previewOverlay.hidden = NO;
}

- (IBAction)snapPhotoToSearch:(id)sender {
    self._previewOverlay.hidden = YES;
    self._scanningOverlay.hidden = NO;
    [self._scanningOverlay setNeedsDisplay];
    [_crs singleShotSearch];
    
}

- (void) didGetSearchResults:(NSArray *)resultItems {
    self._scanningOverlay.hidden = YES;
    
    if ([resultItems count] >= 1) {
        // Found one item, launch its content on a webView:
        CraftARItem *item = [resultItems objectAtIndex:0];
        
        // Open URL in Webview
        UIViewController *webViewController = [[UIViewController alloc] init];
        UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
        [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.url]]];
        uiWebView.scalesPageToFit = YES;
        [webViewController.view addSubview: uiWebView];
        [self.navigationController pushViewController:webViewController animated:YES];
        self._previewOverlay.hidden = NO;
        self._scanningOverlay.hidden = YES;
        [_sdk unfreezeCapture];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Nothing found"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
        self._scanningOverlay.hidden = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self._previewOverlay.hidden = NO;
    [_sdk unfreezeCapture];
}

- (void) didFailWithError:(CraftARSDKError *)error {
    // Check the error type
    NSLog(@"Error calling CRS: %@", [error localizedDescription]);
    self._previewOverlay.hidden = NO;
    self._scanningOverlay.hidden = YES;
    [_sdk unfreezeCapture];
}

- (void) didValidateToken {
    // Token valid, do nothing
}

#pragma mark -


#pragma mark view lifecycle

- (void) viewWillDisappear:(BOOL)animated {
    [_sdk stopCapture];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

@end
