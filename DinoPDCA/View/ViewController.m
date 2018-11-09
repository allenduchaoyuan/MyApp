//
//  ViewController.m
//  DinoPDCA
//
//  Created by Allen_Du on 30/03/2018.
//  Copyright © 2018 Allen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Control = [[control alloc] init];
    Control.delegate = (id<FPCallbackView>)self;
    TestStatus = [[NSTextField alloc] init];
    ButtonOfPass = [[NSButton alloc] init];
    ButtonOfFail = [[NSButton alloc] init];
    SNLogo = [[NSTextField alloc] init];
    SNLable = [[NSTextField alloc] init];
    
    
    takePhoto = [[NSButton alloc] init];
    closePhoto = [[NSButton alloc] init];
    openPhoto = [[NSButton alloc] init];
    _image = [[NSImage alloc] init];
    imageView = [[NSImageView alloc] init];
    
    [self setupCaptureSession];

    
}

- (void)awakeFromNib
{
    [self.view.window setOpaque:NO];
    [self.view.window setBackgroundColor:[NSColor whiteColor]];
    [self.view.window setTitle:@"DinoPDCA"];
    [self.view.window setContentSize:NSMakeSize(1000,800)];
    
    [TestStatus setFrame:NSMakeRect(0,250,500,50)];
    TestStatus.stringValue = @"Please scan SN,than take a photograph...";
    [TestStatus setAlignment:NSTextAlignmentCenter];
    [TestStatus setFont:[NSFont fontWithName:@"kaiti SC" size:23]];
    [TestStatus setTextColor:[NSColor redColor]];
    [TestStatus setBordered:FALSE];
    [TestStatus setEditable:FALSE];
    
    [SNLogo setBordered:FALSE];
    [SNLogo setEditable:FALSE];
    [SNLogo setFrame:NSMakeRect(60,180,70,50)];
    [SNLogo setFont:[NSFont fontWithName:@"kaiti SC" size:23]];
    SNLogo.stringValue = @"SN :";
    [SNLogo setAlignment:NSTextAlignmentCenter];
    
    [SNLable setBordered:FALSE];
    [SNLable setFrame:NSMakeRect(120,190,300,40)];
    [SNLable setFont:[NSFont fontWithName:@"kaiti SC" size:23]];
    SNLable.stringValue = @"";
    [SNLable setAlignment:NSTextAlignmentLeft];
    
    [ButtonOfPass setFrame:NSMakeRect(0,0,250,50)];
    [ButtonOfPass setTitle:@"PASS"];
    ButtonOfPass.bezelStyle=NSButtonTypeSwitch;
    [ButtonOfPass setFont:[NSFont userFontOfSize:15]];
    [ButtonOfPass setEnabled:FALSE];
    
    
    [ButtonOfFail setFrame:NSMakeRect(250,0,250,50)];
    [ButtonOfFail setTitle:@"FAIL"];
    ButtonOfFail.bezelStyle=NSButtonTypeSwitch;
    [ButtonOfFail setFont:[NSFont userFontOfSize:15]];
    [ButtonOfFail setEnabled:FALSE];
    
    [self.view.window.contentView addSubview:TestStatus];
    [self.view.window.contentView addSubview:SNLogo];
    [self.view.window.contentView addSubview:SNLable];
    [self.view.window.contentView addSubview:ButtonOfPass];
    [self.view.window.contentView addSubview:ButtonOfFail];
    [self.view.window.contentView addSubview:takePhoto];
    [self.view.window.contentView addSubview:closePhoto];
    [self.view.window.contentView addSubview:openPhoto];
 //   [self.view.window.contentView addSubview:_image];
    [self.view.window.contentView addSubview:imageView];
    
//    [self InitThread];
//    [Control RunLoop];
}


- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    NSArray *arr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    AVCaptureDevice *device = [AVCaptureDevice
    //                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:arr[0]
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    // - (BOOL)canAddInput:(AVCaptureInput *)input;
    
    if ([session canAddInput:input]) {
        
        [session addInput:input];
        NSLog(@"打开摄像头");
    } else {
        NSLog(@"不能打开摄像头");
    }
    
    sleep(1);
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                            [NSNumber numberWithInt: 320], (id)kCVPixelBufferWidthKey,
                            [NSNumber numberWithInt: 240], (id)kCVPixelBufferHeightKey,
                            nil];
    
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = CGRectMake(500, 500, 320, 240);
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:preLayer];
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //    output.minFrameDuration = CMTimeMake(1, 15);
    
    // Start the session running to start the flow of data
    [session startRunning];
}

- (void)getImage
{
    NSImage *image = [self imageFromSampleBuffer:_buffer];
    _image = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = _image;
    });
    
    
    NSData *data = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:data];
    NSDictionary *imageProps = nil;
    NSNumber *quality = [NSNumber numberWithFloat:1];
    imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
    NSData *imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    
    NSString *imageType = @"jpg";
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:ss:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.%@",NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0],dateStr,imageType];
    
    BOOL ret = [imageData writeToFile:imagePath atomically:YES];
    
    if (ret) {
        _buffer = nil;
    }
}


#pragma mark -- 实现代理方法
//每当AVCaptureVideoDataOutput实例输出一个新视频帧时就会调用此函数
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_takePhoto) {
        _takePhoto = NO;
        _buffer = sampleBuffer;
        [self getImage];
    }
}



- (NSImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    NSImage *image = [[NSImage alloc] initWithCGImage:quartzImage size:CGSizeMake(320, 240)];
    
    //    UIImage *image = [NSImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void)MonitorSNLable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        while(1){
            
            if([[TestStatus stringValue] hasSuffix:@"\n"])
            {
                NSLog(@"1");
            }
        }
    });
}

- (void)InitThread
{
    ThreadSNLable = [[NSThread alloc] initWithTarget:self
                                                selector:@selector(MonitorSNLable)
                                                  object:nil];
    [ThreadSNLable start];
    
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}



@end
