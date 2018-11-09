//
//  Log.h
//  FPUP
//
//  Created by Allen_Du on 17/4/18.
//  Copyright © 2017年 Allen_Du. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstantPudding_API.h"
#import "InstantPuddingWrapper.h"


@protocol FPCallbackView <NSObject>
-(void)showInitInformations:(NSString *)stationName
                    version:(NSString *)appVersion;

- (void) showTableView:(NSString *)fileName
            dataStatus:(NSString *)dataStatus
                isPass:(NSString *)status
                   row:(NSUInteger)row;

- (void)showAppStartTime:(NSString *)startTime;

- (void)showStatusCount:(NSInteger)totalCount
              failCount:(NSInteger)failCount;

- (void)showNetworkStatus:(NSUInteger)status
                  timeout:(NSString *)timeout;

- (void)showAlertWindow:(NSString *)msg
            information:(NSString *)information;

@end

@interface Log : NSObject
{
    NSString * stationName;
    NSString * appVersion;
    NSString * appName;
    NSString * readPath;
    NSString * savePath;
    NSString * backupsPath;
    NSString * reportPath;
    NSString * documentPath;
    NSString * mountCommand;
    NSString * fileName;
    NSString * saveCSVFileNamePath;
    NSString * saveCSVFileName;
    NSString * saveLOGFileName;
    NSString * documentFileName;
    NSString * buffer;
    NSString * datePath;
    
    NSThread * thread;
    NSThread * threadConnect;
    
    NSString * zipFileName;
    NSString * zipFilePath;
    
    NSString * AppStartTime;
    NSString * sn;
    NSString * testTime;
    NSString * line;
    NSString * status;
    NSArray * allItem;
    NSMutableArray * allUpper;
    NSMutableArray * allLower;
    NSArray * allMeasurement;
    NSArray * allResultAndPass;
    NSMutableArray * allResult;
    NSMutableArray * allValue;
    NSUInteger count;
    
    NSInteger totalCount;
    NSInteger failCount;
    
    NSString * message;
    
    char * measurement;
    
    IP_UUTHandle UID;
    bool isPass;
    
    NSUInteger row;
    NSString * commitedPdcaStatus;
    NSString * IPAddress;
    NSString * command;
    NSString * timeout;
    BOOL ConnectStatus;
    
}

#define IP_ATTRIBUTE_SERIALNUMBER "serialnumber"
#define IP_ATTRIBUTE_STATIONSOFTWAREVERSION	"softwareversion"
#define IP_ATTRIBUTE_STATIONSOFTWARENAME "softwarename"

#define SNLENGTH 17

#define HEXADECIMAL 1
#define STRING 2


@property (weak) id <FPCallbackView> delegate;
@property NSString * test;

- (void)Run;
- (BOOL)initInformation;


@end
