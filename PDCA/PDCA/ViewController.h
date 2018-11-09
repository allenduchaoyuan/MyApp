//
//  ViewController.h
//  PDCA
//
//  Created by Allen_Du on 31/08/2017.
//  Copyright © 2017 Allen_Du. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UpdatePDCA.h"

@interface ViewController : NSViewController
{
@private
    NSButton * btnStart;
    NSTextField * status;
    UpdatePDCA * updatePDCA;
    NSString * Path;
}

- (void)Start;

@end

