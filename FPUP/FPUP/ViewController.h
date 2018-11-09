//
//  ViewController.h
//  FPUP
//
//  Created by Allen_Du on 17/4/18.
//  Copyright © 2017年 Allen_Du. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Log.h"

@interface ViewController : NSViewController <FPCallbackView, NSTableViewDelegate, NSTableViewDataSource>
{
    Log *log;
    NSMutableArray *nameArray;
    NSMutableArray *PDCAStatusArray;
    NSMutableArray *DataStatusArray;
    NSInteger Row;
}


@property (weak) IBOutlet NSTextField *totalTitle;
@property (weak) IBOutlet NSTextField *failTitle;
@property (weak) IBOutlet NSTextField *startTitle;
@property (weak) IBOutlet NSTextField *stationNameTitle;
@property (weak) IBOutlet NSTextField *versionTitle;

@property (weak) IBOutlet NSSegmentedControl *start;
@property (weak) IBOutlet NSTextField *stationname;
@property (weak) IBOutlet NSTextField *version;
@property (weak) IBOutlet NSTextField *total;
@property (weak) IBOutlet NSTextField *fail;
@property (weak) IBOutlet NSTextField *startTime;
@property (weak) IBOutlet NSTableView *tableView;

@property (weak) IBOutlet NSTextField *connectStatus;
@property (weak) IBOutlet NSImageView *greenFlage;
@property (weak) IBOutlet NSImageView *redFlags;

@property NSAlert *alert;

@end

