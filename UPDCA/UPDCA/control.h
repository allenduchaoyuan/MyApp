//
//  control.h
//  UPDCA
//
//  Created by Allen_Du on 06/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCA.h"
#import "File.h"
#import "Connect.h"
#import "Log.h"


@protocol FPCallbackView <NSObject>
- (BOOL)showToTableView:(NSString *)fileName
                 status:(NSString *)status
                    row:(NSUInteger)row;
@end

@interface control : NSObject
{
    NSString * fileName;
    Connect *connect;
    File * file;
    PDCA * pdca;
    NSUInteger row;
    NSThread * thread;
}

- (void)Run;

@property (weak) id <FPCallbackView> delegate;
@end
