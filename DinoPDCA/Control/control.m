//
//  control.m
//  DinoPDCA
//
//  Created by Allen_Du on 30/03/2018.
//  Copyright © 2018 Allen. All rights reserved.
//

#import "control.h"

@implementation control

- (control *)init
{
    self = [super init];
    if(self){
        PATHOFFILE = @"/Users/allen_du/Desktop/DinoLiteImageLibrary.xml";
    }
    return self;
}

- (Boolean)size_of_file_is_pass_or_fail
{
    NSUInteger size_of_file;
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:PATHOFFILE]){
        size_of_file= [[manager attributesOfItemAtPath:PATHOFFILE error:nil] fileSize];
    }
    else
    {
        return false;
    }
    if (size_of_file > SIZEOFFILE)
    {
        SIZEOFFILE = size_of_file;
        return true;
    }
    return false;
}

- (void)monitorFile
{
    while (1) {
        usleep(1000000);
        if([self size_of_file_is_pass_or_fail])
        {
            NSLog(@"1");
            
        }
        else
        {
            NSLog(@"2");
        }
        
    }
}

- (Boolean)RunLoop
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:PATHOFFILE]){
        SIZEOFFILE = [[manager attributesOfItemAtPath:PATHOFFILE error:nil] fileSize];
    }
    ThreadMonitorFile = [[NSThread alloc] initWithTarget:self
                                                selector:@selector(monitorFile)
                                                  object:nil];
    [ThreadMonitorFile start];
    return true;
}

@end
