//
//  InstantPuddingWrapper.h
//  CCIAlphaLIB
//
//  Created by cci on 11/12/13.
//  Copyright (c) 2013 CCI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

#import "InstantPudding_API.h"
//#include "DebugLogInfoFile.h"
//#import "CommonUseFunc.h"
//#import "ConfigControl.h"


/*****************
 define the attribute names that are not in InstantPudding_API.h
 ****************/
// for stations: SA-Grape, Home Button & Grape Test
#define IP_ATTRIBUTE_DRAGONFLY_SN "DRAGONFLY_SN"

// for stations: QT0
#define IP_ATTRIBUTE_HOUSING_SN "HOUSING_SN"
#define IP_ATTRIBUTE_CLRC "CLRC"
#define IP_ATTRIBUTE_DCLR "DCLR"
#define IP_ATTRIBUTE_NANDID "NANDID"
#define IP_ATTRIBUTE_NANDCS "NANDCS"
#define IP_ATTRIBUTE_WO_SN "WO_SN"
#define IP_ATTRIBUTE_MLBSN "MLBSN"
#define IP_ATTRIBUTE_HWCONFIG "HWCONFIG"
#define IP_ATTRIBUTE_OPTS "OPTS"
// for stations: QT0, this is already defined.
// #define IP_ATTRIBUTE_UNIT_NUMBER "UNIT#"

// for stations: QT0b, QT0
#define IP_ATTRIBUTE_BATT_CHECKSUM "BATT_CHECKSUM"

// for stations: QT0b
#define IP_ATTRIBUTE_WIFI_SN "WIFI_SN"
#define IP_ATTRIBUTE_CHIP_ID "CHIP_ID"
#define IP_ATTRIBUTE_CHIPVER "CHIPVER"
#define IP_ATTRIBUTE_DIEID "DIEID"
#define IP_ATTRIBUTE_FUSEID "FUSEID"
#define IP_ATTRIBUTE_RAW_ECID "RAW_ECID"
#define IP_ATTRIBUTE_ECID_VER "ECID_VER"
#define IP_ATTRIBUTE_CORE_IDS "CORE_IDS"
#define IP_ATTRIBUTE_SOC_IDS "SOC_IDS"
#define IP_ATTRIBUTE_BB_FIRMWARE_VERSION "BB_FIRMWARE_VERSION"

// for stations: Connectivity1
#define IP_ATTRIBUTE_LCM_SN "LCM_SN"
#define IP_ATTRIBUTE_GRAPE_SN "GRAPE_SN"
#define IP_ATTRIBUTE_MT_MODULE_SN "MT_MODULE_SN"
#define IP_ATTRIBUTE_CLCD_ID "CLCD_ID"

//@interface _PDCA_TEST_ITEM : NSObject
//{
//@public
//    NSString *TestName;
//    NSString *LowLimit;
//    NSString *UpLimit;
//    NSString *Units;
//    NSString *Priority;
//}
//@end
//
//@interface _PDCA_TEST_RESULT : NSObject
//{
//@public
//    BOOL ResultPassed;   // PASS or not. PASS = 1.
//    NSString *Vaule;    // csv value
//    NSString *Message;    // error message
//}
//@end
//
//@interface _PDCA_DATA : NSObject
//{
//@public
//    _PDCA_TEST_ITEM *testItem;        // test item
//    _PDCA_TEST_RESULT *testResult;       // test result
//}
//@end


int IP_getPdcaHandle(IP_UUTHandle *UID);
int IP_insertAttribute(IP_UUTHandle a_UID, const char *ap_name, NSString *ap_attr);
int IP_insertTestItemAndResult(IP_UUTHandle a_UID, NSString *ap_TestName, NSString *ap_LowLimit, NSString *ap_UpLimit, char *ap_Units, int ap_Priority, NSString *ap_testValue, NSString *ap_testMessage, bool isPass);
int IP_commitData(IP_UUTHandle a_UID, bool a_bTotalPass);
int IP_commitData_audit(IP_UUTHandle a_UID, bool a_bTotalPass);
int IP_fail_releaseUUT(IP_UUTHandle a_UID);
int IP_addFile(IP_UUTHandle a_UID, NSString *input, NSString *description);

// make a general api to use
NSString *IP_getGroundHogStationInfo(enum IP_ENUM_GHSTATIONINFO StationInfo);

int CheckFatalError(IP_UUTHandle a_UID, NSString *sn, NSString **retValue);

bool isValidResult(NSString *aInput);

// test api
//int WriteToPdca(_PDCA_DATA *pdcaData);

