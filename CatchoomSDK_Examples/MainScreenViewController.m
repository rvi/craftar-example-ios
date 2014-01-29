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

#import "MainScreenViewController.h"
#import <CatchoomSDK/CatchoomSDK.h>

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)buttonPressed:(id)sender {
    UIViewController *target;
    if (sender == self._helloWorldButton) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"CloudRecognitionAndTrackingLocalContents" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionAndTrackingLocalContentsViewController"];
        target.navigationItem.title = @"Hello world!";
        [[[CatchoomSDK sharedCatchoomSDK] getCloudRecognitionInterface] setToken:@"craftarexamples1"];
    } else if (sender == self._contentCreationButton) {
        UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"CloudRecognitionAndTracking" bundle:nil];
        target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionAndTrackingViewController"];
        target.navigationItem.title = @"Content creation!";
        [[[CatchoomSDK sharedCatchoomSDK] getCloudRecognitionInterface] setToken:@"craftarexamples2"];
    }
    [self.navigationController pushViewController:target animated:YES];
}


#pragma Websites with outside content
NSString* utm_medium = @"iOS";
NSString* utm_source = @"CraftARExamplesApp";


- (IBAction)signUpURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"https://crs.catchoom.com/try-free?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=SignUp"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)craftARProductURL:(id)sender {
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://catchoom.com/product/?utm_source="];
    [urlString appendString:utm_source];
    [urlString appendString:@"&utm_medium="];
    [urlString appendString:utm_medium];
    [urlString appendString:@"&utm_campaign=HelpWithAPI"];
    
    // Open URL in Webview
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: self.view.frame];
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    uiWebView.scalesPageToFit = YES;
    
    [webViewController.view addSubview: uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark -

@end
