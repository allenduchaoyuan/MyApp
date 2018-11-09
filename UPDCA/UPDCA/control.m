//
//  control.m
//  UPDCA
//
//  Created by Allen_Du on 06/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import "control.h"

@implementation control

- (id)init
{
    self = [super init];
    if (self)
    {
        fileName = [[NSString alloc] init];
        connect = [[Connect alloc] init];
        file = [[File alloc] init];
        pdca = [[PDCA alloc] init];
        row = 0;
        thread = [[NSThread alloc] init];
    }
    return self;
}

- (BOOL)operateFile
{
    if(![file backupsFile:fileName])
    {
        return FALSE;
    }
    if(![file praseFile:fileName])
    {
        return FALSE;
    }
    return TRUE;
}

- (BOOL)monitorFileFolder
{
    if (![file getInformationFromPlist])
    {
        
    }
    if(![file createFileFolder])
    {
        
    }
    if(![connect mountShareFolder:file->readPath])
    {
        
    }
    
    while(1)
    {
        usleep(1000000);
        NSFileManager * fm = [[NSFileManager alloc] init];
        fm = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [[NSDirectoryEnumerator alloc] init];
        dirEnum = [fm enumeratorAtPath:file->readPath];
        NSInteger snLength;
        for(fileName in dirEnum)
        {
            snLength = [[Common Regex:@"([[A-Z]\\d]*)" content:fileName] length];
            if([[[fileName componentsSeparatedByString:@"."] lastObject]
                isEqualToString:@"txt"]
               && snLength == 17)
            {
                usleep(10000000);
                if(![file readFile:fileName])
                {
                    continue;
                }
                if(![self operateFile])
                {
                    continue;
                }
                if(0!=[pdca updateToPDCA:[file->readPath stringByAppendingString:fileName]
                                      sn:file->sn result:file->result])
                {
                    continue;
                }
                else
                {
                    file->result = @"PASS";
                }
                if(![file deleteFileAtReadPath:fileName])
                {
                    continue;
                }
                [self.delegate showToTableView:fileName status:file->result row:row];
                row ++;
            }
        }
        
    }
    return TRUE;
}

- (void) Run
{
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(monitorFileFolder)
                                       object:nil];
    thread.name = @"threadOfMonitorFileFolder";
    [thread start];
}

@end
