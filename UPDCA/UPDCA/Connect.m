//
//  Connect.m
//  UPDCA
//
//  Created by Allen_Du on 07/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import "Connect.h"

@implementation Connect

- (id)init
{
    self = [super init];
    if(self)
    {
        IPAddress = [[NSString alloc] init];
        sourceDirectory = [[NSString alloc] init];
        mountCommand = [[NSString alloc] init];
    }
    return self;
}

- (BOOL)getInformationFromPlist
{
    IPAddress = [Common readPlist:IPADDRESS];
    sourceDirectory = [Common readPlist:SOURCEDIRECTORY];
    mountCommand = [Common readPlist:MOUNTCOMMAND];
    if(IPAddress == nil || sourceDirectory == nil)
    {
        return FALSE;
    }
    return TRUE;
}
- (BOOL) mountShareFolder:(NSString *)designatedDirectory
{
    NSString * command = [[NSString alloc] init];
    if(![self getInformationFromPlist])
    {
        return FALSE;
    }
    command = [mountCommand stringByAppendingFormat:@"%@%@ %@",IPAddress,sourceDirectory,designatedDirectory];
    if(command == NULL)
    {
        return FALSE;
    }
    system([command UTF8String]);
    return TRUE;
}

@end
