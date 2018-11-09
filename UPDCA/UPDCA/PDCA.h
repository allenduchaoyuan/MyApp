//
//  PDCA.h
//  UPDCA
//
//  Created by Allen_Du on 06/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstantPuddingWrapper.h"
#import "File.h"

enum RESULTSTATUS
{
    
    /// test failed
    STATUS_FAIL = 0,
    
    /// test passed
    STATUS_PASS,
    
    /// test was not run or was skipped
    STATUS_NA
    
};

@interface PDCA : NSObject
{
@private
    IP_UUTHandle UID;
    NSString * Path;
    NSString * AbsolutePath;
    NSString * NameOfPDCA;
    bool ResultStatus;
    NSString * Result;
    NSString * SN;
    
    File * file;
}

- (NSUInteger) updateToPDCA:(NSString *)path
                         sn:(NSString *)sn
                     result:(NSString *)result
;

@end
