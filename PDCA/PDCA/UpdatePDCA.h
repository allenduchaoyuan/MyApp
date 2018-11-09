//
//  UpdatePDCA.h
//  PDCA
//
//  Created by Allen_Du on 31/08/2017.
//  Copyright © 2017 Allen_Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstantPuddingWrapper.h"

#define IP_ATTRIBUTE_SERIALNUMBER "serialnumber"
#define IP_ATTRIBUTE_STATIONSOFTWAREVERSION	"softwareversion"
#define IP_ATTRIBUTE_STATIONSOFTWARENAME "softwarename"

enum RESULTSTATUS
{
    
    /// test failed
    STATUS_FAIL = 0,
    
    /// test passed
    STATUS_PASS,
    
    /// test was not run or was skipped
    STATUS_NA
    
};

@interface UpdatePDCA : NSObject
{
 @private
    IP_UUTHandle UID;
    NSString * Path;
    NSString * AbsolutePath;
    NSString * NameOfPDCA;
    bool ResultStatus;
    NSString * Result;
    NSString * SN;
}

- (NSUInteger) updateToPDCA:(NSString *)path;
@end
