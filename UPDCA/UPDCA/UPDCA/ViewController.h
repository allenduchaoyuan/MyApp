//
//  ViewController.h
//  UPDCA
//
//  Created by Allen_Du on 06/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "control.h"

@interface ViewController : NSViewController<FPCallbackView,NSTableViewDelegate,NSTableViewDataSource>
{
    control *con;
    NSButton *Start;
    NSTableView *tableView;
    NSScrollView *tableContainer;
    NSArrayController *arrayController;
    NSTableColumn * columnFilename;
    NSTableColumn * columnStauts;
    NSImageView * image;
    NSTextField *textField;
    
    NSMutableArray * FileName;
    NSMutableArray * Status;
    NSUInteger Row;
}

- (BOOL)showToTableView:(NSString *)fileName
                 status:(NSString *)status
                    row:(NSUInteger)row;

@end

