- [Catchoom iOS SDK Example](#catchoom-ios-sdk-example)
	- [Description](#description)
	- [Requirements](#requirements)
	- [Quick Start](#quick-start)
	- [Example App](#example-app)
	- [Adding the SDK to your app](#adding-the-sdk-to-your-app)
	- [Reporting Issues](#reporting-issues)

Catchoom example for iOS
========================


Description
-----------

The project contains the source code of a simple example application that demonstrates the functionality of the Catchoom SDK for iOS.

Catchoom SDK for iOS allows you to integrate into your mobile application the advanced Image Recognition (IR) capabilities of the [Catchoom Recognition Service (CRS)](http://crs.catchoom.com).

The integration is as simple as importing the compiled SDK into your project and adding a few lines of code. The SDK takes care of capturing the best images, sending them to the CRS, and receiving the recognition results with the related content.

You can implement one of the two different modes of Image Recognition:

* **Single shot mode**, where users initiate every recognition request (e.g. by pressing a button).
* **Finder mode**, allowing continuous scan and automatic recognition of all objects appearing in front of the camera.

More specifically, the SDK implements the following features:

* Accessing the CRS image recognition service via [CRS recognition API](http://catchoom.com/documentation/api/recognition/). This includes sending recognition requests to your collections and getting the results and the associated contents/custom data. Moreover, you can even have the SDK communicating with your own backend service and working as a proxy to the CRS.
* Flexible image and video capturing abstraction layer allowing you to specify the video preview. The SDK manages the video capture and presentation of the augmented reality scene. Moreover, you can easily customise the preview and the rendering of the content associated to the recognised objects.


Requirements
------------
To build the project or use the library, you will need XCode 4.6 or newer, and at least the iOS 5.0 library.


Quick Start
-----------
The **easiest** way to get started with the Catchoom SDK is downloading this project, and trying the example application with your images from the [CRS](http://crs.catchoom.com). The example app includes a compiled version of the **RestKit** framework and all dependencies are already added to the project. 

To get the **CatchoomSDK framework**, please [contact us](http://catchoom.com/contact/?message=Hi%20Catchoom,%0D%0DI%20am%20interested%20in%20getting%20the%20Catchoom%20SDK%20for%20iOS%20version%201.0.) and we will send you the latest version.

In order to get the example running you just have to follow three simple steps:

1. Clone this repository
2. Get the [Catchoom SDK for iOS](http://catchoom.com/contact/?message=Hi%20Catchoom,%0D%0DI%20am%20interested%20in%20getting%20the%20Catchoom%20SDK%20for%20iOS%20version%201.0.) and unzip it into the ExternalFrameworks directory.
3. Get a collection token and add it as a string literal in the sdk call:

 
 ```objc
  [_sdk setDefaultCollectionToken: PLACE_YOUR_CRS_TOKEN_HERE];
  ```

This is enough to compile the project and start [recognising things](http://catchoom.com/documentation/what-kind-of-objects-do-we-recognize/).

Example App
-----------
This project shows two examples of how to use the Catchoom SDK to recognise images and objects from the device camera:

* **Single shot**: takes a picture from the camera and sends it to the CRS to obtain a response with the recognised object.
* **Finder mode** or continuous search: Takes video frames from the camera periodically and sends them to the CRS. When a match is found, the result is displayed and the scanning stopps.

Just by adding a few lines in your application, you can show a camera preview and search by taking a picture or capturing video frames from the camera.

In this case we show the example for the **Single shot** mode.

First you have to initialise the SDK and retrieve the **CloudRecognition** instance:

```objc
    // setup the Catchoom SDK
    _sdk = [CatchoomSDK sharedCatchoomSDK];
    _sdk.delegate = self;
    
    [_sdk setDefaultCollectionToken:PLACE_YOUR_CRS_TOKEN_HERE];
    _crs = [_sdk getCloudRecognitionInterface];
    _crs.delegate = self;
    
    // Start Video Preview for search and tracking
    [_sdk startVideoForView:self._preview];
``` 

Once the video capture has been initialised, you are ready to take a photo and send it to the CRS:

```objc
- (IBAction)snapPhotoToSearch:(id)sender {
    _foundItem = nil;
    self._initialOverlay.hidden = YES;
    [_sdk takePreviewSnapShot];
}

- (void) didGetSnapshotFromPreview:(UIImage *)snapShot {
    [self addScanFX];
    [_sdk pausePreview];
    [_crs searchWithUIImage:snapShot];
}
```

The SDK connects through the CRS API and parses the results encapsulating them in an easy to access class:

```objc
@property (nonatomic) NSString *itemId;
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *imageId;
@property (nonatomic) NSString *score;
@property (nonatomic) NSString *thumbnail120;
@property (nonatomic) NSString *url;

// String containing custom field from CRS
@property (nonatomic) NSString *custom;

```

The code for both examples can be found in this project under the `catchoom-sdk-sampleapp/CloudRecognition` directory. To switch from the **Single shot mode** example to the **Finder mode**, change the commented line in the ```SplashScreenViewController.m``` file:

```objc
    // FINDER MODE
    //target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionFinderMode"];
    
    // ONE SHOT MODE
    target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionSnapPhoto"];
```



Adding the SDK to your app
--------------------------

The iOS Catchoom SDK is distributed as a .framework that you can directly drag into your project. It has, though some dependencies on frameworks/libraries that have to be linked:

* QuartzCore
* AVFoundation
* CoreMedia
* CoreGraphics
* CoreVideo
* CoreFoundation
* GLKit
* OpenGLES
* MediaPlayer
* Security
* CFNetwork

It also depends on RestKit v0.20.3 and its dependencies.

Also, you will need to add some flags to your project in order to link the application properly due to [know issues](https://developer.apple.com/library/mac/qa/qa1490/_index.html) with xCode related to the use of categories in static libraries:

```
-Objc -all_load
```

Then you just have to create a view in your starboards and link it to a UIView IBOutlet for the camera preview. Pass the preview to the catchoom's SDK ```startVideoForView:``` message and use one of the methods in the examples to send images to the CRS shown in the examples.


Reporting Issues
----------------
If you have suggestions, bugs or other issues specific to this library, file them [here](https://github.com/Catchoom/catchoom-sdk-ios/issues) or contact us at [support@catchoom.com](mailto:support@catchoom.com).
