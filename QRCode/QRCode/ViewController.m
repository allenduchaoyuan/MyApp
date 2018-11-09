//
//  ViewController.m
//  QRCode
//
//  Created by Allen_Du on 19/12/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (void)awakeFromNib
{
    [self createQRcode];
//    [self.view.window setOpaque:NO];
//    [self.view.window setBackgroundColor:[NSColor whiteColor]];
//    [self.view.window setTitle:@"QRCode"];
//    [self.view.window setContentSize:NSMakeSize(100,100)];
//    [self.view addSubview:imageView];
//    [self.view addSubview:text];
}

- (void)createQRcode
{
    NSData *strData = [@"FH7XF0EEKDH3" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    NSCIImageRep * rep = [NSCIImageRep imageRepWithCIImage:qrImage];
    NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(rep.size.width, rep.size.height)];
    
    [image addRepresentation:rep];
    imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0,0,rep.size.width*10,rep.size.height*10)];
    imageView.image= image;
    [self.view addSubview:imageView];
}
@end
