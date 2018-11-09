//
//  Connect.h
//  UPDCA
//
//  Created by Allen_Du on 07/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"


#define IPADDRESS @"IPAddress"
#define SOURCEDIRECTORY @"SourceDirectory"
#define MOUNTCOMMAND @"CommandOfMount"
@interface Connect : NSObject
{
    NSString * IPAddress;
    NSString * sourceDirectory;
    NSString * mountCommand;
}

- (BOOL) mountShareFolder:(NSString *)designatedDirectory;

@end
