//
//  ViewController.m
//  PDCA
//
//  Created by Allen_Du on 31/08/2017.
//  Copyright © 2017 Allen_Du. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    updatePDCA = [[UpdatePDCA alloc] init];
    btnStart = [[NSButton alloc] init];
    status = [[NSTextField alloc] init];
    Path = [[NSString alloc] init];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    [self.view.window setOpaque:NO];
    [self.view.window setBackgroundColor:[NSColor whiteColor]];
    [self.view.window setTitle:@"HAHAHA"];
    [self.view.window setContentSize:CGSizeMake(500, 500)];
    [self.view.window setFrameOrigin:CGPointMake(500, 200)];
    
    [btnStart setButtonType:NSMomentaryPushInButton];
    [btnStart setBezelStyle:NSBezelStyleRegularSquare];
    [btnStart setFrame:NSMakeRect(210,200, 60, 30)];
    [btnStart setTitle:@"Star"];
    [btnStart setFont:[NSFont fontWithName:@"kaiti SC" size:20]];
    [btnStart setAlignment:NSTextAlignmentJustified];
    [btnStart setBordered:YES];
    [btnStart setEnabled:YES];
    [btnStart setTarget:self];
    [btnStart setAction:@selector(Start)];
    
    [status setFrame:NSMakeRect(210,250, 60, 30)];
    [status setStringValue:@"123"];
    [status setFont:[NSFont fontWithName:@"kaiti SC" size:20]];
    [status setTextColor:[NSColor blackColor]];
    [status setBackgroundColor:[NSColor whiteColor]];
    [status setAlignment:NSTextAlignmentCenter];
    [status setBordered:NO];
    [status setEnabled:NO];
    
    [self.view.window.contentView addSubview:btnStart];
    [self.view.window.contentView addSubview:status];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)Start
{
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSUInteger result;
            Path = [self readPlist:@"path"];
            result = [updatePDCA updateToPDCA:Path];
            if(result == 0)
            {
                [status setStringValue:@"PASS"];
                [status setBackgroundColor:[NSColor greenColor]];
            }
            else
            {
                [status setStringValue:@"FAIL"];
                [status setBackgroundColor:[NSColor redColor]];
            }
        });
    });
    
}

- (NSString *)readPlist:(NSString *)key
{
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
    NSString * information = [dataDic objectForKey:key];
    return information;
}


@end
