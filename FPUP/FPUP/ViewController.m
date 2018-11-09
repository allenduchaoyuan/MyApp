//
//  ViewController.m
//  FPUP
//
//  Created by Allen_Du on 17/4/18.
//  Copyright © 2017年 Allen_Du. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    log = [[Log alloc] init];
    log.delegate = (id<FPCallbackView>)self;
    
    nameArray = [[NSMutableArray alloc] init];
    PDCAStatusArray = [[NSMutableArray alloc] init];
    DataStatusArray = [[NSMutableArray alloc] init];
    _alert = [[NSAlert alloc] init];
    Row = 0;
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    [self.view.window setOpaque:NO];
    [self.view.window setBackgroundColor:[NSColor whiteColor]];
    [self.view.window setTitle:@"FPUP"];
    
    [_stationNameTitle setFrame:NSMakeRect(20, 53, 110, 35)];
    [_stationNameTitle setAlignment:NSTextAlignmentJustified];
    [_stationNameTitle setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_stationNameTitle setBordered:NO];
    [_stationNameTitle setEditable:NO];
    
    [_stationname setFrame:NSMakeRect(133, 53, 110, 35)];
    [_stationname setAlignment:NSTextAlignmentJustified];
    [_stationname setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_stationname setBordered:NO];
    [_stationname setEditable:NO];
    
    [_versionTitle setFrame:NSMakeRect(20, 16, 110, 35)];
    [_versionTitle setAlignment:NSTextAlignmentJustified];
    [_versionTitle setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_versionTitle setBordered:NO];
    [_versionTitle setEditable:NO];
    
    [_version setFrame:NSMakeRect(83, 16, 110, 35)];
    [_version setAlignment:NSTextAlignmentJustified];
    [_version setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_version setBordered:NO];
    [_version setEditable:NO];
    
    [_totalTitle setFrame:NSMakeRect(18, 99, 46, 35)];
    [_totalTitle setAlignment:NSTextAlignmentJustified];
    [_totalTitle setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_totalTitle setBordered:NO];
    [_totalTitle setEditable:NO];
    
    [_total setFrame:NSMakeRect(63, 99, 70, 35)];
    [_total setAlignment:NSTextAlignmentCenter];
    [_total setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_total setBordered:NO];
    [_total setEditable:NO];
    
    [_failTitle setFrame:NSMakeRect(133, 99, 60, 35)];
    [_failTitle setAlignment:NSTextAlignmentJustified];
    [_failTitle setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_failTitle setBordered:NO];
    [_failTitle setEditable:NO];
    
    [_fail setFrame:NSMakeRect(170, 99, 60, 35)];
    [_fail setAlignment:NSTextAlignmentCenter];
    [_fail setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_fail setTextColor:[NSColor redColor]];
    [_fail setBordered:NO];
    [_fail setEditable:NO];
    
    [_startTitle setFrame:NSMakeRect(230, 99, 160, 35)];
    [_startTitle setAlignment:NSTextAlignmentJustified];
    [_startTitle setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_startTitle setBordered:NO];
    [_startTitle setEditable:NO];
    
    [_startTime setFrame:NSMakeRect(310, 99, 160, 35)];
    [_startTime setAlignment:NSTextAlignmentJustified];
    [_startTime setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_startTime setBordered:NO];
    [_startTime setEditable:NO];
    
    [_connectStatus setAlignment:NSTextAlignmentLeft];
    [_connectStatus setFont:[NSFont fontWithName:@"kaiti SC" size:18]];
    [_connectStatus setBordered:NO];
    [_connectStatus setEditable:NO];
    
    [_greenFlage setHidden:YES];
    [_redFlags setHidden:YES];
    
    [_start setSelected:YES forSegment:0];
    [_start setSelected:NO forSegment:1];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

/*
 Describe : show Informations of plist'file.
 Input    : stationName & appVersion
 Output   : NA
 */
- (void)showInitInformations:(NSString *)stationName
                     version:(NSString *)appVersion
{
    [_stationname setStringValue:stationName];
    [_version setStringValue:appVersion];
}

- (void)showAppStartTime:(NSString *)startTime
{
    [_startTime setStringValue:startTime];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(tableView == _tableView)
    {
        return Row;
    }
    return 0;
}

//-(void)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    
//}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(nonnull id)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    NSTextFieldCell *textCell = cell;
    if([identifier isEqualToString:@"FileName"])
    {
        [textCell setTitle:nameArray[row]];
    }
    if([identifier isEqualToString:@"DataStatus"])
    {
        [textCell setTitle:DataStatusArray[row]];
        [textCell setBackgroundColor:[NSColor clearColor]];
        if([DataStatusArray[row] isEqualToString:@"PASS"])
        {
            [textCell setBackgroundColor:[NSColor greenColor]];
        }else{
            [textCell setBackgroundColor:[NSColor redColor]];
        }
    }
    if([identifier isEqualToString:@"PDCAStatus"])
    {
        [textCell setTitle:PDCAStatusArray[row]];
        [textCell setBackgroundColor:[NSColor clearColor]];
        if([PDCAStatusArray[row] isEqualToString:@"PASS"])
        {
            [textCell setBackgroundColor:[NSColor greenColor]];
        }else{
            [textCell setBackgroundColor:[NSColor redColor]];
        }
    }
}

- (void) showTableView:(NSString *)fileName
            dataStatus:(NSString *)dataStatus
                isPass:(NSString *)status
                   row:(NSUInteger)row
{
    Row = row + 1;
    [nameArray addObject:fileName];
    [DataStatusArray addObject:dataStatus];
    [PDCAStatusArray addObject:status];
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}


- (void)showStatusCount:(NSInteger)totalCount
              failCount:(NSInteger)failCount
{
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            _total.integerValue =  totalCount;
            _fail.integerValue =  failCount;
        });
    });
}


- (void)showNetworkStatus:(NSUInteger)status
                  timeout:(NSString *)timeout
{
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(status == 1){
                [_greenFlage setHidden:NO];
                [_redFlags setHidden:YES];
                [_connectStatus setStringValue:timeout];
            }else if(status == 2){
                [_greenFlage setHidden:YES];
                [_redFlags setHidden:NO];
                [_connectStatus setStringValue:timeout];
            }
        });
    });
}

- (void) showAlertWindow:(NSString *)msg
                 information:(NSString *)information
{
    [_alert addButtonWithTitle:@"OK"];
    [_alert setMessageText:msg];
    [_alert setInformativeText:information];
    [_alert setIcon:[NSImage imageNamed:@"waring_image"]];
    [_alert runModal];
    
}

- (IBAction)showReport:(id)sender {
    system("open /vault/FPUP/report/");
}


- (IBAction)Run:(id)sender
{
    if([_start isSelectedForSegment:1]){
        [log Run];
        [_start setEnabled:NO];
    }
}

@end
