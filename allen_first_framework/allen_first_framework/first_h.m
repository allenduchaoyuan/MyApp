//
//  first_h.m
//  allen_first_framework
//
//  Created by Allen_Du on 2018/10/23.
//  Copyright © 2018 Allen. All rights reserved.
//

#import "first_h.h"

@implementation first_h

- (BOOL)first_faction:(NSString *)first_parm
{
    if([first_parm isEqualToString:@"Allen"])
    {
        return TRUE;
    }
    return FALSE;
}
@end
