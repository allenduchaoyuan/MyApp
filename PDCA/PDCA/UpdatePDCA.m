//
//  UpdatePDCA.m
//  PDCA
//
//  Created by Allen_Du on 31/08/2017.
//  Copyright © 2017 Allen_Du. All rights reserved.
//

#import "UpdatePDCA.h"

@implementation UpdatePDCA

- (id)init
{
    self = [super init];
    if (self)
    {
        Path                = [[NSString alloc] init];
        AbsolutePath        = [[NSString alloc] init];
        NameOfPDCA          = [[NSString alloc] init];
        SN                  = [[NSString alloc] init];
        Result              = [[NSString alloc] init];
    }
    return self;
}


///commit the file to PDCA
///return 0 : success.
///return -1: path is nil.
///return -2: parse path fail.
///return -3: compress file fail.
///return -4: get handle fail.
///return -5: insert attrbute fail.
///return -6: add file fail.
///return -7: commit file fail.

- (NSUInteger)updateToPDCA:(NSString *)path
{
    @autoreleasepool {
        //parse path
        if([path isEqualToString:@""] || path == NULL || path == nil)
        {
            return -1;
        }
        
        if(![self parsePath:path])
        {
            return -2;
        }
        //compress file
        if(![self compressFile:path])
        {
            return -3;
        }
        
        //add
        if(IP_getPdcaHandle(&UID) == -1)
        {
            return -4;
        }
        //insert APPName, APPVersion, SN
        if(![self insertAttribute])
        {
            return -5;
        }
        
        //insert test item
        
        if(IP_insertTestItemAndResult(UID,
                                      @"RESULT",
                                      @"1",
                                      @"1",
                                      "NA",
                                      0,
                                      Result,
                                      @"",
                                      ResultStatus) == -1)
        {
            return FALSE;
        }
        
        
        if(IP_addFile(UID, AbsolutePath, NameOfPDCA) == -1)
        {
            return -6;
        }
        
        if(IP_commitData(UID, ResultStatus) == -1)
        {
            return -7;
        }
        //commit
        
        return 0;
    }
}


- (BOOL)parsePath:(NSString *)path
{
    AbsolutePath    = [path stringByAppendingString:@".zip"];
    NameOfPDCA      = [[path componentsSeparatedByString:@"/"] lastObject];
    Result          = [[[[path componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"_"] firstObject];
    SN              = [[[[path componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"_"] objectAtIndex:1];
    
    if([Result isEqualToString:@"PASS"])
    {
        Result = @"1";
        ResultStatus = true;
    }
    else if([Result isEqualToString:@"FAIL"])
    {
        ResultStatus = false;
        Result = @"0";
    }
    else
    {
        return FALSE;
    }
    if(AbsolutePath == NULL || NameOfPDCA == NULL || SN == NULL )
    {
        return FALSE;
    }
    return TRUE;
    
}

- (BOOL)compressFile:(NSString *)path
{
    pid_t system_sh_status;
    NSString * cmdZip = [NSString stringWithFormat:@"/usr/bin/zip -rj %@ %@",AbsolutePath,path];
    if(cmdZip == NULL)
    {
        return FALSE;
    }
    system_sh_status = system([cmdZip UTF8String]);
    if(-1 == system_sh_status)
    {
        return FALSE;
    }
    else
    {
        if(WIFEXITED(system_sh_status))
        {
            if(0 == WEXITSTATUS(system_sh_status))
            {
                return TRUE;
            }
            else
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
}

- (BOOL) insertAttribute
{
    if(IP_insertAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, SN) < 0)
    {
        return FALSE;
    }
    if(IP_insertAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME,@"charlieSW") < 0)
    {
        return FALSE;
    }
    if(IP_insertAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, @"100.10.001") < 0)
    {
        return FALSE;
    }
    return TRUE;
}

@end
