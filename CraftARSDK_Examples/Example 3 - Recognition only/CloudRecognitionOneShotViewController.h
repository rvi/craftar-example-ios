//
//  CloudRecognitionSnapPhotoViewController.h
//
//  Created by Luis Martinell Andreu on 9/17/13.
//  Copyright (c) 2013 Catchoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudRecognitionOneShotViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *_preview;
@property (weak, nonatomic) IBOutlet UIView *_previewOverlay;
@property (weak, nonatomic) IBOutlet UIView *_scanningOverlay;

- (IBAction)snapPhotoToSearch:(id)sender;

@end
