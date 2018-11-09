//
//  ViewController.m
//  UPDCA
//
//  Created by Allen_Du on 06/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    con = [[control alloc] init];
    con.delegate = (id<FPCallbackView>)self;
    Start = [[NSButton alloc] init];
    tableView = [[NSTableView alloc] init];
    arrayController = [[NSArrayController alloc] init];
    tableContainer = [[NSScrollView alloc] init];
    columnFilename = [[NSTableColumn alloc] init];
    columnStauts = [[NSTableColumn alloc] init];
    image = [[NSImageView alloc] init];
    textField = [[NSTextField alloc] init];
    
    FileName = [[NSMutableArray alloc] init];
    Status = [[NSMutableArray alloc] init];
    Row = 0;
    
    // Do any additional setup after loading the view.
}


- (void)awakeFromNib
{
    [self.view.window setOpaque:NO];
    [self.view.window setBackgroundColor:[NSColor whiteColor]];
    [self.view.window setTitle:@"UPDCA"];
    [self.view.window setContentSize:NSMakeSize(490,750)];
    
    [image setFrame:CGRectMake(0,0,480,73)];
    [image setImage:[NSImage imageNamed:@"logo"]];
    
    [tableView setFrame:NSMakeRect(0,0,490,630)];
    [tableView setBackgroundColor:[NSColor whiteColor]];
    [tableView setGridColor:[NSColor darkGrayColor]];
    [tableView setColumnAutoresizingStyle:NSTableViewNoColumnAutoresizing];
    [tableView setFocusRingType:NSFocusRingTypeDefault];
    [tableView setAllowsMultipleSelection:NO];
    [tableView setRowHeight:30];
    [tableView setEnabled:NO];
    
    [[columnFilename headerCell] setStringValue:@"FILENAME"];
    [columnFilename setIdentifier:@"fileName"];
    [[columnFilename headerCell] setAlignment:NSTextAlignmentCenter];
    [columnFilename setEditable:NO];
    [columnFilename setWidth:300];
    
    [[columnStauts headerCell] setStringValue:@"STATUS"];
    [columnStauts setIdentifier:@"status"];
    [[columnStauts headerCell] setAlignment:NSTextAlignmentCenter];
    [columnStauts setEditable:NO];
    [columnStauts setWidth:190];
    
    
    [tableView addTableColumn:columnFilename];
    [tableView addTableColumn:columnStauts];
    [tableView setGridStyleMask:NSTableViewDashedHorizontalGridLineMask];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [tableContainer setFrame:NSMakeRect(0,120,490,630)];
    [tableContainer setDocumentView:tableView];
    [tableContainer setDrawsBackground:NO];
    [tableContainer setHasVerticalScroller:YES];

    
    [self.view.window.contentView addSubview:tableContainer];
    [self.view.window.contentView addSubview:Start];
    [self.view.window.contentView addSubview:image];
    
    [con Run];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return Row;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}


- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    if([identifier isEqualToString:@"fileName"])
    {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:FileName[row]];
        [textCell setFont:[NSFont userFontOfSize:15]];
        [textCell setAlignment:NSTextAlignmentCenter];
    }
    else if([identifier isEqualToString:@"status"])
    {
        NSTextFieldCell *textCell = cell;
        
        [textCell setTitle:Status[row]];
        [textCell setFont:[NSFont userFontOfSize:15]];
        [textCell setAlignment:NSTextAlignmentCenter];
        [textCell setDrawsBackground:TRUE];
        if([Status[row] isEqualToString:@"PASS"])
        {
            [textCell setBackgroundColor:[NSColor greenColor]];
        }
        else
        {
            [textCell setBackgroundColor:[NSColor redColor]];
        }
    }
}

- (BOOL)showToTableView:(NSString *)fileName
                 status:(NSString *)status
                    row:(NSUInteger)row
{

    Row = row + 1;
    [FileName addObject:fileName];
    [Status addObject:status];
    dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    });
    return TRUE;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
