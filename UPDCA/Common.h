//
//  Common.h
//  UPDCA
//
//  Created by Allen_Du on 07/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
{
    
}

+ (NSString *)readPlist:(NSString *)key;

+ (BOOL)createPath:(NSString *)path;

+ (BOOL)createFile:(NSString *)filename
           content:(NSString *)content;

+ (NSString *)creatDatePath:(NSString *)basePath;

+ (NSString *)readFileDataToBuffer:(NSString *)path;

+ (BOOL)writeDataToFile:(NSString *)filename
                content:(NSString *)content;

+ (NSString *)Regex:(NSString *)regex
            content:(NSString *)content;
@end
