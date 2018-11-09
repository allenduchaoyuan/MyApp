//
//  InstantPuddingWrapper.m
//  CCIAlphaLIB
//
//  Created by cci on 11/12/13.
//  Copyright (c) 2013 CCI. All rights reserved.
//

#import "InstantPuddingWrapper.h"

//@implementation _PDCA_TEST_ITEM @end
//@implementation _PDCA_TEST_RESULT @end
//@implementation _PDCA_DATA@end


// 1. AP get
// return IP_UUTHandle for using pdca api
int IP_getPdcaHandle(IP_UUTHandle *UID){
    
    if(UID == nil){
 //       inLog(2, @"Input nil");
        return -1;
    }
    
    //## required step #1:  IP_UUTStart()
    IP_API_Reply reply = IP_UUTStart(UID);
    if ( !IP_success(reply) )
    {
 //       inLog(2, @"[IPWrapper] Error from getPdcaHandle() for Unit : %s\n", IP_reply_getError(reply));
        IP_UUTCancel(UID);     //MUST CALL HERE TO CLEAN THE BRICKS
        IP_UID_destroy(UID);
        IP_reply_destroy(reply);
        return -1;       // do the appropriate thing here according to your needs
    }
    IP_reply_destroy(reply);
    return 0;
}

// 2. insert attributes
// return -1 if fail. 0 if OK.
// ap_name: please refer to "InstantPudding_API.h"
int IP_insertAttribute(IP_UUTHandle a_UID, const char *ap_name, NSString *ap_attr){
    const char *mATTR = [ap_attr UTF8String];
    const char *mName = ap_name;
    IP_API_Reply reply;
    
    
    if(a_UID == nil || ap_attr == nil || ap_name == nil){
//        inLog(3, @"[IPWrapper] Input nil");
        return -1;
    }
    
    
    if(strlen(ap_name) == 0 || [ap_attr length] == 0){
 //       inLog(3, @"[IPWrapper] Input nil");
        return -1;
    }
    
    reply = IP_addAttribute( a_UID, mName, mATTR);
    if ( !IP_success(reply) )
	{
//        inLog(2, @"[IPWrapper] Error from IP_insertAttribute() : %s\n", IP_reply_getError(reply));
        IP_UUTCancel(a_UID); //MUST CALL HERE TO CLEAN THE BRICKS
        IP_UID_destroy(a_UID);
        IP_reply_destroy(reply);
        return -1;
    }
    IP_reply_destroy(reply);
    return 0;
}

// 3. insert test item and result
// return -1 if fail. 0 if OK.
/************************
 ap_TestName:   test item name: MAX length: 48
 ap_LowLimit:   limit, accepted format: numberic value, NA, N/A
 ap_UpLimit:    limit, accepted format: numberic value, NA, N/A
 ap_testValue:  result, accepted format: numberic value only.
 //Modify ==> Benson modify NSString *ap_Priority --> int ap_Priority By 20140105 for Audit mode
 ************************/
int IP_insertTestItemAndResult(IP_UUTHandle a_UID, NSString *ap_TestName, NSString *ap_LowLimit, NSString *ap_UpLimit, char *ap_Units, int ap_Priority, NSString *ap_testValue, NSString *ap_testMessage, bool isPass){
    
    IP_TestSpecHandle testSpec;
    IP_TestResultHandle testResult;
    IP_API_Reply reply;
    
    if(a_UID == nil || ap_TestName == nil || ap_LowLimit == nil || ap_UpLimit == nil || ap_testValue == nil || ap_testMessage == nil
       || ap_Units == nil){
//        inLog(3, @"[IPWrapper] Input nil");
        return -1;
    }
    
    if(!isValidResult(ap_testValue)){
//        inLog(3, @"[IPWrapper] Result is not a value");
        return -1;
    }
    
    if([ap_TestName length] == 0){
 //       inLog(3, @"[IPWrapper] No test item name");
        return -1;
    }
    
    const char *TEST_NAME = [ap_TestName UTF8String];
    const char *TEST_LOW_LIMIT = [ap_LowLimit UTF8String];
    const char *TEST_UP_LIMIT = [ap_UpLimit UTF8String];
    // TODO: currently the priority are all 0
    // const char *TEST_PRIORITY = "0";
    
    // create a test specification for our first test, Rubberband stretching
    testSpec = IP_testSpec_create();
	if ( NULL != testSpec )
	{
        BOOL APIcheck = false;
		APIcheck = IP_testSpec_setTestName( testSpec, TEST_NAME, strlen(TEST_NAME));
        if(!APIcheck)
        {
//            inLog(2, @"[IPWrapper] IP_testSpec_setTestName error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            return -1;
        }
        
		//IP_testSpec_setSubTestName( testSpec, "Stretch\0", 8);
		//IP_testSpec_setSubSubTestName( testSpec, "Long Dimension\0", 15 );
		APIcheck = IP_testSpec_setLimits( testSpec, TEST_LOW_LIMIT, strlen(TEST_LOW_LIMIT), TEST_UP_LIMIT, strlen(TEST_UP_LIMIT));
        if(!APIcheck)
        {
//            inLog(2, @"[IPWrapper] IP_testSpec_setLimits error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            return -1;
        }
		
        // If units not set. skip it.
        if(strlen(ap_Units) != 0){
            APIcheck = IP_testSpec_setUnits( testSpec, ap_Units, strlen(ap_Units) );
            if(!APIcheck)
            {
 //               inLog(2, @"[IPWrapper] IP_testSpec_setUnits error");
                //IP_UUTCancel(a_UID);
                //IP_UID_destroy(a_UID);
                IP_testSpec_destroy(testSpec);
                return -1;
            }
        }
        if((ap_Priority == IP_PRIORITY_STATION_CALIBRATION_AUDIT) ||
           (ap_Priority>=IP_PRIORITY_REALTIME_WITH_ALARMS && ap_Priority<=IP_PRIORITY_ARCHIVE))
        {
            APIcheck = IP_testSpec_setPriority( testSpec, ap_Priority );
        }
		else
        {
//            inLog(2, @"[IPWrapper] ap_Priority is out of enum");
            return -1;
        }
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testSpec_setPriority error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            return -1;
        }
	}
	
	const char *TEST_VALUE = [ap_testValue UTF8String];
    const char *TEST_MESSAGE = [ap_testMessage UTF8String];
    
    testResult = IP_testResult_create();
    if(isPass){
        BOOL APIcheck = false;
        APIcheck = IP_testResult_setResult( testResult, IP_PASS );
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testResult_setResult error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
        APIcheck = IP_testResult_setValue( testResult, TEST_VALUE, strlen(TEST_VALUE));
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testResult_setValue error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
        APIcheck = IP_testResult_setMessage( testResult, TEST_MESSAGE, strlen(TEST_MESSAGE) );
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testResult_setMessage error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
    }else{
        BOOL APIcheck = false;
        APIcheck = IP_testResult_setResult( testResult, IP_FAIL );
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testResult_setResult error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
        APIcheck = IP_testResult_setValue( testResult, TEST_VALUE, strlen(TEST_VALUE));
        if(!APIcheck)
        {
 //           inLog(2, @"[IPWrapper] IP_testResult_setValue error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
        APIcheck = IP_testResult_setMessage( testResult, TEST_MESSAGE, strlen(TEST_MESSAGE));
        if(!APIcheck)
        {
//            inLog(2, @"[IPWrapper] IP_testResult_setMessage error");
            //IP_UUTCancel(a_UID);
            //IP_UID_destroy(a_UID);
            IP_testSpec_destroy(testSpec);
            IP_testResult_destroy(testResult);
            return -1;
        }
    }
    
    //## required step #2:  IP_addResult()
	reply = IP_addResult(a_UID, testSpec, testResult );
	if ( !IP_success( reply ) )
	{
		// handle the extremely unlikely even that the InstantPudding API just failed
//		inLog(2, @"[IPWrapper] Error from IP_addResult() : %s\n", IP_reply_getError(reply));
        IP_testResult_destroy(testResult);
        IP_testSpec_destroy(testSpec);
        IP_reply_destroy(reply);
        //IP_UUTCancel(a_UID);
        //IP_UID_destroy(a_UID);
		return -1;
	}
	IP_reply_destroy(reply);
	IP_testResult_destroy(testResult);
	IP_testSpec_destroy(testSpec);
    return 0;
}

// 4. AP commit PDCA
// return -1 if fail. 0 if OK.
//
int IP_commitData(IP_UUTHandle a_UID, bool a_bTotalPass){
    IP_API_Reply reply;
    IP_API_Reply commitReply;
    
    if(a_UID == nil){
 //       inLog(2, @"[IPWrapper] a_UID = nil");
        return -1;
    }
    
    //## required step #3:  IP_UUTDone()
	reply = IP_UUTDone(a_UID);
    /* //mark for check uop fail need to upload pdca
	if ( !IP_success( reply ) )
	{
        //Here please do check AMIOK error and your test results
        inLog(2, @"[IPWrapper] Error returned from UUTDone:  %s\n", IP_reply_getError(reply));
        //see if it test failure or process failure if later call sendStationFailureReport
        IP_UUTCancel(a_UID); //MUST CALL HERE TO CLEAN THE BRICKS
        IP_UID_destroy(a_UID);
        IP_reply_destroy(reply);
        
        return -1;
	}
     */
	IP_reply_destroy(reply);
    
	//## required step #4:  IP_UUTCommit()
    if(a_bTotalPass)
        commitReply = IP_UUTCommit( a_UID, IP_PASS );
    else
        commitReply = IP_UUTCommit( a_UID, IP_FAIL );
    
	if ( !IP_success( commitReply ) )
	{
//		inLog(2, @"[IPWrapper] ERROR with the commit: %s", IP_reply_getError(commitReply));
	}
	IP_reply_destroy( commitReply );
	IP_UID_destroy( a_UID );
    return 0;
}

// 4. AP commit PDCA
// return -1 if fail. 0 if OK.
//owen add 20150421 for uploading to PDCA when audit mode test.
int IP_commitData_audit(IP_UUTHandle a_UID, bool a_bTotalPass){
    IP_API_Reply reply;
    IP_API_Reply commitReply;
    
    if(a_UID == nil){
//        inLog(2, @"[IPWrapper] a_UID = nil");
        return -1;
    }
    
    //## required step #3:  IP_UUTDone()
    reply = IP_UUTDone(a_UID);
/*    if ( !IP_success( reply ) )
    {
        //Here please do check AMIOK error and your test results
        inLog(2, @"[IPWrapper] Error returned from UUTDone:  %s\n", IP_reply_getError(reply));
        //see if it test failure or process failure if later call sendStationFailureReport
        IP_UUTCancel(a_UID); //MUST CALL HERE TO CLEAN THE BRICKS
        IP_UID_destroy(a_UID);
        IP_reply_destroy(reply);
        
        return -1;
    }*/
    IP_reply_destroy(reply);
    
    //## required step #4:  IP_UUTCommit()
    if(a_bTotalPass)
        commitReply = IP_UUTCommit( a_UID, IP_PASS );
    else
        commitReply = IP_UUTCommit( a_UID, IP_FAIL );
    
    if ( !IP_success( commitReply ) )
    {
//        inLog(2, @"[IPWrapper] ERROR with the commit: %s", IP_reply_getError(commitReply));
    }
    IP_reply_destroy( commitReply );
    IP_UID_destroy( a_UID );
    return 0;
}

int IP_addFile(IP_UUTHandle a_UID, NSString *input, NSString *description){
    const char *fileInput = [input UTF8String];
    const char *fileDescription = [description UTF8String];
    IP_API_Reply reply;
    if(a_UID == nil){
//        inLog(2, @"[IPWrapper] a_UID = nil");
        return -1;
    }
	
	// now, submit the blob
	reply = IP_addBlob( a_UID, fileDescription, fileInput);
	if ( !IP_success( reply ) )
	{
 //       inLog(2, @"[IPWrapper] Error returned from IP_addBlob:  %s\n", IP_reply_getError(reply));
 //       inLog(2, @"[IPWrapper] fileDescription:%s\nfileInput:%s", fileDescription, fileInput);
        
//        ConfigControl * configFile = [[ConfigControl alloc]init];
//        if (!configFile.autoMationFlag &&
//            !configFile.autoMationOtherMethodFlag)
//        {
//            [CommonUseFunc AlertWindow:@"ERROR!" andMsgFormat:@"Error returned from IP_addBlob!!!!!!!!!" andDefaultButton:@"OK" andMainWindow:nil];
//        }
        
		IP_reply_destroy(reply);
		return -1;
	}
	
	// clean up
    IP_reply_destroy(reply);
    return 0;
}

/********
 when you do not commit data
 ********/
int IP_fail_releaseUUT(IP_UUTHandle a_UID){
    if(a_UID == nil){
 //       inLog(2, @"[IPWrapper] a_UID = nil");
        return -1;
    }
    
    IP_UUTCancel(a_UID); //MUST CALL HERE TO CLEAN THE BRICKS
    IP_UID_destroy(a_UID);
    return 0;
}


/****
 Make another handle. For general usage.
 ****/
NSString *IP_getGroundHogStationInfo(enum IP_ENUM_GHSTATIONINFO StationInfo){
    IP_UUTHandle UID;
    
    IP_API_Reply reply = IP_UUTStart(&UID);
    if ( !IP_success(reply) )
    {
        printf("[IPWrapper] Error from getPdcaHandle() for Unit : %s\n", IP_reply_getError(reply));
        IP_UUTCancel(UID);     //MUST CALL HERE TO CLEAN THE BRICKS
        IP_UID_destroy(UID);
        IP_reply_destroy(reply);
        return @"";       // do the appropriate thing here according to your needs
    }
    IP_reply_destroy(reply);
    
    size_t length;
    IP_API_Reply attribRep = IP_getGHStationInfo(UID,StationInfo,NULL,&length);//make sure first time you pass NULL for buffer
    if ( !IP_success( attribRep ) )
    {
        printf("[IPWrapper] Error from First call IP_getGHStationInfo(): %s\n", IP_reply_getError(attribRep));
        IP_UID_destroy(UID);
        IP_reply_destroy(attribRep);
        return @"";
    }
    IP_reply_destroy(attribRep);
    
    char *cpProduct = malloc(sizeof(char) * (length+1) );
    attribRep=IP_getGHStationInfo(UID,StationInfo,&cpProduct, &length);
    if ( !IP_success( attribRep ) )
    {
        printf("[IPWrapper] Error from second call IP_getGHStationInfo(): %s\n", IP_reply_getError(attribRep));
        IP_UID_destroy(UID);
        IP_reply_destroy(attribRep);
        return @"";
    }
    // Memory Leak
    IP_UID_destroy(UID);
    IP_reply_destroy(attribRep);
    
    NSString *retString = [[NSString alloc] initWithCString:cpProduct encoding:NSASCIIStringEncoding];
    
    if (NULL != cpProduct) {
        free(cpProduct);
        cpProduct = NULL;
    }
    
    return retString;
}


int CheckFatalError(IP_UUTHandle a_UID, NSString *sn, NSString **retValue){
    const char *SN_VALUE = [sn UTF8String];
    IP_API_Reply reply = IP_amIOkay(a_UID, SN_VALUE);

    if ( !IP_success( reply ) )
    {
 //       inLog(2, @"[IPWrapper] Error from CheckFatalError: %s\n", IP_reply_getError(reply));
        *retValue = [NSString stringWithFormat:@"%s", IP_reply_getError(reply)];
        IP_reply_destroy(reply);
        return -1;
    }
    IP_reply_destroy(reply);
    return 0;
}

/****
 For insert reslut usage. there will be an error check like this in InstantPudding lib.
 We have to block the invalid value to prevent any error.
 All results must be a value.
 ****/
bool isValidResult(NSString *aInput){
    NSString *mValidChar = @"0123456789.-+eE";
    int i=0, j=0;

    for(i=0; i<[aInput length]; i++){
        char c = [aInput characterAtIndex:i];
        bool match = false;
        for(j=0; j<[mValidChar length]; j++){
            char cValidchar = [mValidChar characterAtIndex:j];
            if(c == cValidchar){
                match = true;
                break;
            }
        }
        if(!match)
            return false;
    }
    return true;
}

/**********
 Do not use this. It's just for test.
 **********/
//int WriteToPdca(_PDCA_DATA *pdcaData)
//{
//    IP_UUTHandle UID;
//    IP_TestSpecHandle testSpec;
//    IP_TestResultHandle testResult;
//    IP_API_Reply doneReply;
//	IP_API_Reply commitReply;
//    FILE* blobFile;
//    //unsigned int doneMessageID = 0;
//    
//    if(pdcaData == nil){
//        return -1;
//    }
//    
//    //## required step #1:  IP_UUTStart()
//	IP_API_Reply reply = IP_UUTStart(&UID);
//    if ( !IP_success(reply) )
//	{
//        printf("Error from UUTStart() for Unit : %s\n", IP_reply_getError(reply));
//        IP_UUTCancel(UID);     //MUST CALL HERE TO CLEAN THE BRICKS
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//        return -1;       // do the appropriate thing here according to your needs
//    }
//    IP_reply_destroy(reply);
//    
//    // TODO: get SN, station name, software version
//    //record your station software version and name
//	reply = IP_addAttribute( UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, "Test_version" );
//    if ( !IP_success(reply) )
//	{
//        printf("Error from IP_addAttribute() : %s\n", IP_reply_getError(reply));
//        IP_UUTCancel(UID); //MUST CALL HERE TO CLEAN THE BRICKS
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//        return -1;
//    }
//    IP_reply_destroy(reply);
//    
//    //need station name
//	reply = IP_addAttribute( UID, IP_ATTRIBUTE_STATIONSOFTWARENAME, "Test_Sw_Name" );
//    if ( !IP_success(reply) )
//	{
//        printf("Error from IP_addAttribute() : %s\n", IP_reply_getError(reply));
//        IP_UUTCancel(UID); //MUST CALL HERE TO CLEAN THE BRICKS
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//        return -1;
//    }
//    IP_reply_destroy(reply);
//    
//	//add the unit's serial number
//	reply = IP_addAttribute( UID, IP_ATTRIBUTE_SERIALNUMBER, "1234567890123" );
//    if ( !IP_success(reply) )
//	{
//        printf("Error from IP_addAttribute() : %s\n", IP_reply_getError(reply));
//        IP_UUTCancel(UID); //MUST CALL HERE TO CLEAN THE BRICKS
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//        return -1;
//    }
//    IP_reply_destroy(reply);
//    
//    /*
//     IP_ATTRIBUTE_SERIALNUMBER
//     IP_ATTRIBUTE_STATIONLIMITSVERSION(gets from s/w version if not provided)
//     IP_ATTRIBUTE_STATIONSOFTWARENAME
//     IP_ATTRIBUTE_STATIONSOFTWAREVERSION
//     IP_ATTRIBUTE_STATIONIDENTIFIER(gets station identifier from GH server)
//     */
//    
//    
//    if(pdcaData->testItem == nil || pdcaData->testResult == nil ){
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//        return -1;
//    }
//    
//    if(pdcaData->testItem->TestName == nil || pdcaData->testItem->LowLimit == nil || pdcaData->testItem->UpLimit == nil){
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//        return -1;
//    }
//    
//    if(pdcaData->testResult->Vaule == nil || pdcaData->testResult->Message == nil){
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//        return -1;
//    }
//    
//    const char *TEST_NAME = [pdcaData->testItem->TestName UTF8String];
//    const char *TEST_LOW_LIMIT = [pdcaData->testItem->LowLimit UTF8String];
//    const char *TEST_UP_LIMIT = [pdcaData->testItem->UpLimit UTF8String];
//    //const char *TEST_PRIORITY = [pdcaData->testItem->Priority UTF8String];
//    // TODO: currently the priority are all 0
//    
//    // create a test specification for our first test, Rubberband stretching
//    testSpec = IP_testSpec_create();
//	if ( NULL != testSpec )
//	{
//        BOOL APIcheck = false;
//		APIcheck = IP_testSpec_setTestName( testSpec, TEST_NAME, strlen(TEST_NAME));
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            return -1;
//        }
//        
//		//IP_testSpec_setSubTestName( testSpec, "Stretch\0", 8);
//		//IP_testSpec_setSubSubTestName( testSpec, "Long Dimension\0", 15 );
//		APIcheck = IP_testSpec_setLimits( testSpec, TEST_LOW_LIMIT, strlen(TEST_LOW_LIMIT), TEST_UP_LIMIT, strlen(TEST_UP_LIMIT));
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            return -1;
//        }
//		//IP_testSpec_setUnits( testSpec, IP_UNITS_MILES, strlen(IP_UNITS_MILES) );
//		APIcheck = IP_testSpec_setPriority( testSpec, IP_PRIORITY_REALTIME_WITH_ALARMS );
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            return -1;
//        }
//	}
//	
//    BOOL IsPassed = pdcaData->testResult->ResultPassed;
//	const char *TEST_VALUE = [pdcaData->testResult->Vaule UTF8String];
//    const char *TEST_MESSAGE = [pdcaData->testResult->Message UTF8String];
//    
//    testResult = IP_testResult_create();
//    if(IsPassed){
//        BOOL APIcheck = false;
//        APIcheck = IP_testResult_setResult( testResult, IP_PASS );
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//        APIcheck = IP_testResult_setValue( testResult, TEST_VALUE, strlen(TEST_VALUE));
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//        APIcheck = IP_testResult_setMessage( testResult, "", 0 );
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//    }else{
//        BOOL APIcheck = false;
//        APIcheck = IP_testResult_setResult( testResult, IP_FAIL );
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//        APIcheck = IP_testResult_setValue( testResult, TEST_VALUE, strlen(TEST_VALUE));
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//        APIcheck = IP_testResult_setMessage( testResult, TEST_MESSAGE, strlen(TEST_MESSAGE));
//        if(!APIcheck)
//        {
//            IP_UUTCancel(UID);
//            IP_UID_destroy(UID);
//            IP_testSpec_destroy(testSpec);
//            IP_testResult_destroy(testResult);
//            return -1;
//        }
//    }
//    
//    //## required step #2:  IP_addResult()
//	reply = IP_addResult(UID, testSpec, testResult );
//	if ( !IP_success( reply ) )
//	{
//		// handle the extremely unlikely even that the InstantPudding API just failed
//		printf("Error from IP_addResult() : %s\n", IP_reply_getError(reply));
//        IP_testResult_destroy(testResult);
//        IP_testSpec_destroy(testSpec);
//        IP_reply_destroy(reply);
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//		return -1;
//	}
//	IP_reply_destroy(reply);
//	IP_testResult_destroy(testResult);
//	IP_testSpec_destroy(testSpec);
//    
//    
//    /*****************/
//	// add a blob to UUT results
//    // if needed
//	blobFile = fopen(".\\LWtestBlobFile.dat", "w");
//	fprintf(blobFile, "Hello from test!");
//	fclose(blobFile);
//	
//	// now, submit the blob
//	reply = IP_addBlob( UID, "LWtestBlobDescription", ".\\LWtestBlobFile.dat" );
//	if ( !IP_success( reply ) )
//	{
//		// handle an error writing your blob file
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//		return -1;
//	}
//	
//	// clean up
//	remove(".\\LWtestBlob.dat");
//    IP_reply_destroy(reply);
//	/******************/
//	
//	
//	//## required step #3:  IP_UUTDone()
//	doneReply = IP_UUTDone(UID);
//	if ( !IP_success( doneReply ) )
//	{
//        //Here please do check AMIOK error and your test results
//        printf("Error returned from UUTDone:  %s\n", IP_reply_getError(doneReply));
//        //see if it test failure or process failure if later call sendStationFailureReport
//        IP_UUTCancel(UID); //MUST CALL HERE TO CLEAN THE BRICKS
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//        
//        return -1;
//	}
//	IP_reply_destroy(doneReply);
//    
//    // TODO: get serial number
//    // Add checking:
//    /**
//    reply = IP_amIOkay( UID, "1234567890123" );
//    if ( !IP_success( reply ) )
//	{
//		printf("Error returned from IP_amIOkay:  %s\n", IP_reply_getError(reply));
//        IP_UUTCancel(UID);
//        IP_UID_destroy(UID);
//        IP_reply_destroy(reply);
//		return -1;
//	}
//    IP_reply_destroy(reply);
//    **/
//	
//	//## required step #4:  IP_UUTCommit()
// 	commitReply = IP_UUTCommit( UID, IP_PASS );
//	if ( !IP_success( commitReply ) )
//	{
//		printf("ERROR with the commit: %s", IP_reply_getError(commitReply));
//	}
//	IP_reply_destroy( commitReply );
//	IP_UID_destroy( UID );
//    
//    return 0;
//}




