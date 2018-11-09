//
//  ViewController.h
//  DinoPDCA
//
//  Created by Allen_Du on 30/03/2018.
//  Copyright © 2018 Allen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "control.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController : NSViewController
<FPCallbackView,NSTableViewDelegate,NSTableViewDataSource,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    control *Control;
    NSButton *ButtonOfPass;
    NSButton *ButtonOfFail;
    NSTextField *TestStatus;
    NSTextField *SNLable;
    NSTextField *SNLogo;
    NSThread * ThreadSNLable;
    
    NSButton *takePhoto;
    NSButton *closePhoto;
    NSButton *openPhoto;
    CMSampleBufferRef _buffer;
    BOOL _takePhoto;
    NSImage *_image;
    AVCaptureSession *session;
    NSImageView *imageView;
}


@property (weak) id <FPCallbackView> delegate;
@end

