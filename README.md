## Catchoom CraftAR - iOS SDK examples

### Introduction

Catchoom allows to create recognition only and Augmented Reality (AR)
experiences using the Catchoom CraftAR Service and its Mobile SDK (‘Mobile SDK’).

With Catchoom, you can create amazing apps that provide digital content
for real-life objects like printed media, packaging among others. You
can use our online web panel or APIs, to upload images to be recognized and set
AR content to display upon recognition in your Catchoom-powered
app.

This document describes mainly the Examples of different uses of the Service and the SDK.
General use of the SDK can be found in the [Documentation section of Catchoom website](http://catchoom.com/documentation/sdk/ios/). Complete SDK documentation of the
classes can be found within the SDK distribution.

### How to use the examples

This repository comes with an xCode project of an iOS app with several
examples that show how to use the SDK.

To run the examples follow these steps:
 1.  Open the CatchoomSDK_Examples.xcodeproj project.
 2.  Integrate the CatchoomSDK into the xCode project (see [below](#step-by-step-guide)).
 3.  Select an iOS 6 or 7 device (notice that the project will not
     compile for the simulator).
 4.  Hit the run button.


### Add CatchoomSDK to the Example project

#### Requirements

To build the project or use the library, you will need XCode 5 or newer,
and at least the iOS 6.0 library.

#### Step-by-step guide
1.  Download the [Catchoom SDK](http://catchoom.com/product/mobile-sdk/) for iOS.
2.  Unzip the package
3.  Drag the following files into the project:
 * CatchoomSDK.framework
 * CatchoomSDK.bundle
 * AFNetrowking.framework

