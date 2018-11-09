//
//  control.h
//  DinoPDCA
//
//  Created by Allen_Du on 30/03/2018.
//  Copyright © 2018 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FPCallbackView <NSObject>

@end

@interface control : NSObject
{
    NSUInteger SIZEOFFILE;
    NSString *PATHOFFILE;
    NSThread *ThreadMonitorFile;
}

- (Boolean)RunLoop;
@property (weak) id <FPCallbackView> delegate;

@end
