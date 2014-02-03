//
//  CatchoomSDKUtils.h
//  catchoom-sdk-sampleapp
//
//  Created by Luis Martinell Andreu on 9/20/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#ifndef catchoom_sdk_sampleapp_CatchoomSDKUtils_h
#define catchoom_sdk_sampleapp_CatchoomSDKUtils_h

void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );

#endif
