//
//  Log.m
//  FPUP
//
//  Created by Allen_Du on 17/4/18.
//  Copyright © 2017年 Allen_Du. All rights reserved.
//

#import "Log.h"

@implementation Log

#pragma mark - ***Init Information***

- (id)init
{
    self = [super init];
    if (self)
    {
        stationName         = [[NSString alloc] init];
        appVersion          = [[NSString alloc] init];
        appName             = [[NSString alloc] init];
        AppStartTime        = [[NSString alloc] init];
        
        readPath            = [[NSString alloc] init];
        savePath            = [[NSString alloc] init];
        backupsPath         = [[NSString alloc] init];
        reportPath          = [[NSString alloc] init];
        documentPath        = [[NSString alloc] init];
        mountCommand        = [[NSString alloc] init];
        
        fileName            = [[NSString alloc] init];
        buffer              = [[NSString alloc] init];
        datePath            = [[NSString alloc] init];
        
        allItem             = [[NSArray alloc] init];
        allUpper            = [[NSMutableArray alloc] init];
        allLower            = [[NSMutableArray alloc] init];
        allMeasurement      = [[NSMutableArray alloc] init];
        allResultAndPass    = [[NSArray alloc] init];
        allResult           = [[NSMutableArray alloc] init];
        allValue            = [[NSMutableArray alloc] init];
        sn                  = [[NSString alloc] init];
        line                = [[NSString alloc] init];
        testTime            = [[NSString alloc] init];
        status              = [[NSString alloc] init];
        
        saveCSVFileNamePath = [[NSString alloc] init];
        saveCSVFileName     = [[NSString alloc] init];
        documentFileName    = [[NSString alloc] init];
        
        message             = [[NSString alloc] init];
        zipFileName         = [[NSString alloc] init];
        zipFilePath         = [[NSString alloc] init];
        
        row = 0;
        count = 0;
        commitedPdcaStatus  = [[NSString alloc] init];
        totalCount = 0;
        failCount = 0;
        
        IPAddress = [[NSString alloc] init];
        command = [[NSString alloc] init];
        timeout = [[NSString alloc] init];
        
        ConnectStatus = 0;
    }
    return self;
}

/*
 Describe : Init the Information of app.StationName,version,path and command.
 Input    : NA
 Output   : NA
 */
-(BOOL) initInformation
{
    stationName  = [self getInfoFromDicJson:@"ghinfo" andJsonInfoSecondLayer:JSON_KEY_STATIONTYPE inJsonPath:JSONPATH];
    appVersion   = [self readPlist:@"AppVersion"];
    appName      = [self readPlist:@"AppName"];
    readPath     = [self readPlist:@"PathOfReadFile"];
    savePath     = [self readPlist:@"PathOfSaveFile"];
    backupsPath  = [self readPlist:@"PathOfBackupsFile"];
    reportPath   = [self readPlist:@"PathOfReportFile"];
    mountCommand = [self readPlist:@"CommandOfMount"];
    IPAddress    = [self readPlist:@"IPAddress"];
    documentPath = [self readPlist:@"PathOfDocument"];
    
    
    [self getAppStartDate];
    [self.delegate showInitInformations:stationName version:appVersion];
    [self.delegate showAppStartTime:AppStartTime];
    [self.delegate showStatusCount:0 failCount:0];
    return YES;
}

/*
 Describe : Read Informations of plist'file.
 Input    : Key of plist.
 Output   : Information of plist accroding ur key.
 */
- (NSString *)readPlist:(NSString *)key
{
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
    NSString * information = [dataDic objectForKey:key];
    return information;
}

/*
 Describe : Create File Folder.According to the informations of plist's file.
 Input    : NA
 Output   : NA
 */
- (void)createFileFolder
{
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:readPath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    [fm createDirectoryAtPath:savePath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    [fm createDirectoryAtPath:backupsPath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    [fm createDirectoryAtPath:reportPath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    [fm createDirectoryAtPath:documentPath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];

}

#pragma mark - ***Main***
/*
 Describe : Monitor Folder.checkout csv file.
 Input    : NA
 Output   : NA
 */

- (void)monitorFileFolder
{
    while(1){
        usleep(100000);
        @autoreleasepool
        {
            NSFileManager * fm = [[NSFileManager alloc] init];
            fm = [NSFileManager defaultManager];
            NSDirectoryEnumerator *dirEnum = [[NSDirectoryEnumerator alloc] init];
            dirEnum = [fm enumeratorAtPath:readPath];

#if __ALI__
            for(fileName in dirEnum)
            {
                if(ConnectStatus == 1){
                    [self writeToDocument:@"Monitor network" decription:@"network disconnected!"];
                    [self threadCloed];
                }
                if([[[fileName componentsSeparatedByString:@"."] lastObject]
                    isEqualToString:@"zip"]
                   &&[self monitorFileInUpdateTable:fileName]
                   &&([[fileName componentsSeparatedByString:@"_"] count] == 2||[[fileName componentsSeparatedByString:@"_"] count] == 3))
                {
                    usleep(10000000);
                    saveCSVFileNamePath = fileName;
                    if([[fileName componentsSeparatedByString:@"_"] count] == 2)
                    {
                        status = [[fileName componentsSeparatedByString:@"_"] firstObject];
                        sn = [[[[fileName componentsSeparatedByString:@"_"] lastObject] componentsSeparatedByString:@"."] firstObject];
                    }
                    if([[fileName componentsSeparatedByString:@"_"] count] == 3)
                    {
                        status = [[fileName componentsSeparatedByString:@"_"] firstObject];
                        sn = [[[[fileName componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"_"] objectAtIndex:1];
                    }
                    if([status isEqualToString:@"OK"])
                    {
                        status = @"PASS";
                    }
                    else
                    {
                        status = @"FAIL";
                    }
                    [self backupsFile];
                    sleep(2);
                    [self backupsFileToParse];
                    sleep(2);
                    [self createReportFolder];
                    [self getPDCAHandle];
                    [self insertAttribute];
                    [self insertTestResult:status];
                    if([self addAndCommitPdca])
                    {
                        [self writeUpdateFileToUpdateTable:fileName];
                    }
                    [self deleteFileAtReadPath];
                    [self showToTableView];
                    
                }

            }
#else
            NSInteger snLength;
            for(fileName in dirEnum)
            {
                snLength = [[self Regex:@"([[A-Z]\\d]*)" content:fileName] length];
                if([[[fileName componentsSeparatedByString:@"."] lastObject]
                    isEqualToString:@"csv"]
                   && snLength == SNLENGTH
                   &&[self monitorFileInUpdateTable:fileName]) {
                    if([self readFile] == -1){
                    [self writeToDocument:@"Read buffer" decription:@"buffer is nil!"];
                        continue;
                    }
                    if(ConnectStatus == 1){
                    [self writeToDocument:@"Monitor network" decription:@"network disconnected!"];
                        [self threadCloed];
                    }
                    [self backupsFile];
                    [self praseFile];
                    [self saveFile];
                    [self createReportFolder];
                    [self getPDCAHandle];
                    [self insertAttribute];
                    [self insertTestItemAndResult];
                    if([self addAndCommitPdca])
                    {
                        [self writeUpdateFileToUpdateTable:fileName];
                    }
                    [self deleteFileAtReadPath];
                    [self showToTableView];
                }
            }
#endif
        }
    }
}

#pragma mark - ***Due to file***
/*
 Describe : Read Informations of csv file.Process stores datas to variables
 Input    : NA
 Output   : NA
 */
- (NSUInteger) readFile
{
    buffer = [NSString stringWithContentsOfFile:[readPath stringByAppendingString:fileName]
                                       encoding:NSASCIIStringEncoding
                                          error:nil];
    if([buffer isEqualToString:@""])
    {
        return -1;
    }else{
        return 1;
    }
}


- (BOOL)monitorFileInUpdateTable:(NSString *)file_name
{
    [self creatDatePath:backupsPath];
    //NSString * updateFilePath = [backupsPath stringByAppendingFormat:@"%@/%@",datePath,UPDATETABLE];
    NSString * updateFilePath = [backupsPath stringByAppendingFormat:@"%@",UPDATETABLE];
    NSFileManager * fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:updateFilePath])
    {
        [fm createFileAtPath:updateFilePath contents:nil attributes:nil];
    }
    NSString * contents = [NSString stringWithContentsOfFile:updateFilePath encoding:NSASCIIStringEncoding error:nil];
    if([contents rangeOfString:file_name].location != NSNotFound)
    {
        return FALSE;
    }

    return TRUE;
}

- (BOOL)writeUpdateFileToUpdateTable:(NSString *)file_name
{
    [self creatDatePath:backupsPath];
    NSFileManager * fm = [NSFileManager defaultManager];
  //  NSString * update_file = [backupsPath stringByAppendingFormat:@"%@/%@",datePath,UPDATETABLE];
    NSString * update_file = [backupsPath stringByAppendingFormat:@"%@",UPDATETABLE];
    if(![fm fileExistsAtPath:update_file])
    {
        [fm createFileAtPath:update_file contents:nil attributes:nil];
    }
    [self writeDataToFile:update_file content:[file_name stringByAppendingString:@"\n"]];
    return TRUE;
}
/*
 Describe : Backupsing file to path of backups
 Input    : NA
 Output   : NA
 */
- (void) backupsFile
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [self creatDatePath:backupsPath];
    [fm copyItemAtPath:[readPath
                        stringByAppendingPathComponent:fileName]
                toPath:[backupsPath
                        stringByAppendingFormat:@"%@/%@",datePath,fileName]
                 error:nil];
    [self writeToDocument:@"Backup file" decription:@"backups file is success!"];
}


- (void)backupsFileToParse
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [self creatDatePath:savePath];
    [fm copyItemAtPath:[readPath
                        stringByAppendingPathComponent:fileName]
                toPath:[savePath
                        stringByAppendingFormat:@"%@/%@",datePath,fileName]
                 error:nil];
}

/*
 Describe : Delete the original file of csv
 Input    : NA
 Output   : NA
 */
- (void)deleteFileAtReadPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[readPath
                          stringByAppendingString:fileName]
                   error:nil];
}

/*
 Describe : prase the datas of file.Item,Upper,Lower,Measurement,result,pass,sn,line,status,testTime
 Input    : NA
 Output   : NA
 */
- (void) praseFile
{
    NSArray * rowBuffer = [[NSArray alloc] init];
    rowBuffer         =   [buffer componentsSeparatedByString:@"\n"];
    allItem           =   [[self Regex:@"Line,Result,TestDateTime,(.*)"
                               content:rowBuffer[1]]
                           componentsSeparatedByString:@","];
    allUpper          =   [[[self Regex:@"[[UperlLimt]->\\s,]*(.*)"
                               content:rowBuffer[2]]
                           componentsSeparatedByString:@","] mutableCopy];
    allLower          =   [[[self Regex:@"[[Lowerimt]->\\s,]*(.*)"
                               content:rowBuffer[3]]
                           componentsSeparatedByString:@","] mutableCopy];
    allMeasurement    =   [[[self Regex:@"[[MeasurmntUit]->\\s,]*(.*)"
                                content:rowBuffer[4]]
                            componentsSeparatedByString:@","] mutableCopy];
    allResultAndPass  =   [[self Regex:@"\\w*,[\\w-\\s]*,\\w*,[\\w\\W]+?,(.*)"
                               content:rowBuffer[5]]
                           componentsSeparatedByString:@","];
    sn                =   [self Regex:@"(\\w*)" content:rowBuffer[5]];
    line              =   [self Regex:@"\\w*,([\\w-\\s]*)" content:rowBuffer[5]];
    status            =   [self Regex:@"\\w*,[\\w-\\s]*,(\\w*)" content:rowBuffer[5]];
    testTime          =   [self Regex:@"\\w*,[\\w-\\s]*,\\w*,([\\w-\\s:]*)" content:rowBuffer[5]];
    [self writeToDocument:@"Prase file" decription:[NSString stringWithFormat:@"sn:%@\nline:%@\ntestTime:%@\nstatus:%@\n\nallItem:%@\nallUpper:%@\nallLower:%@\nallMeasurement:%@\nallresultAndPass:%@",sn,line,testTime,status,allItem,allUpper,allLower,allMeasurement,allResultAndPass]];
}

/*
 Describe : Saveing the datas of parseing to new csv'file
 Input    : NA
 Output   : NA
 */
- (void) saveFile
{
    NSString * headCSV = [[NSString alloc] initWithFormat:@"SWVersion,%@,\nSN,%@,Line,%@\nResult,%@,TestDateTime,%@\nItemCount,TestItem,Status,TestResult,Upper,Lower,Unit\n",appVersion,sn,line,status,testTime];
    NSString * CSVFileName = [[NSString alloc] init];
    NSString * writeContents = [[NSString alloc] init];
    [self createSavePath];
    CSVFileName = [savePath
                   stringByAppendingFormat:@"%@/%@/%@",
                   datePath,
                   saveCSVFileNamePath,
                   saveCSVFileName];
    [self createFile:CSVFileName content:headCSV];
    count = [self countOfCycles];
    for(NSUInteger i = 0;i < count; i++)
    {
        [self separateResultAndValue:i];
        [self TransformerValueIsNilToNA:i];
        writeContents = [NSString stringWithFormat:@"%lu,%@,%@,%@,%@,%@,%@\n",i+1,allItem[i],allResult[i],allValue[i],allUpper[i],allLower[i],allMeasurement[i]];
        [self writeDataToFile:CSVFileName content:writeContents];
        [self writeToDocument:@"Save file" decription:writeContents];
    }
}

#pragma mark - ***Updata PDCA***
/*
 Describe : Getting PDCA handle for updataing data of PDCA
 Input    : NA
 Output   : NA
 */
- (void)getPDCAHandle
{
    if(-1 == IP_getPdcaHandle(&UID)){
        [self writeToReport:@"\n---GetPDCAHandle---\n" decriptions:@"getPDCAHandle faid!"];
        [self writeToDocument:@"PDCA" decription:@"get PDCA handle is failed!"];
    }else{
        [self writeToReport:@"\n---GetPDCAHandle---\n" decriptions:@"getPDCAHandle success!"];
        [self writeToDocument:@"PDCA" decription:@"get PDCA handle is success!"];
    }
}

/*
 Describe : InsertAttribute version,version name,sn
 Input    : NA
 Output   : NA
 */
- (void)insertAttribute
{
    if(IP_insertAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, appVersion) < 0){
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute appversion failed!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute appversion failed!"];
    }else{
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute appversion success!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute appversion success!"];
    }
    
    if(IP_insertAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME,@"charlieSW") < 0){
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute appName failed!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute appName failed!"];
    }else{
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute appName success!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute appName success!"];
    }
    
    if (IP_insertAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER, sn) < 0){
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute sn failed!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute sn failed!"];
    }else{
        [self writeToReport:@"\n---InsertAttribute---\n" decriptions:@"InsertAttribute sn success!\n"];
        [self writeToDocument:@"PDCA" decription:@"InsertAttribute sn success!"];
    }
}

/*
Faction : Insert TestItem for ALI's camera,only insert one result which
*/
- (BOOL)insertTestResult:(NSString*)result
{
    BOOL resultStatus;
    if([result isEqualToString:@"PASS"])
    {
        result = @"1";
        resultStatus = true;
    }
    else
    {
        result = @"0";
        resultStatus = false;
    }

    if(IP_insertTestItemAndResult(UID,
                                  @"RESULT",
                                  @"1",
                                  @"1",
                                  "NA",
                                  0,
                                  result,
                                  @"",
                                  resultStatus) == -1)
    {
        return FALSE;
    }
    return TRUE;
}

/*
 Describe : Insert TestItem and result
 Input    : NA
 Output   : NA
 */
- (void)insertTestItemAndResult
{
    [self writeToReport:@"\n---InsertTestItemAndResult---" decriptions:@"\n"];
    for(NSUInteger i = 0;i < count;i++)
    {
        if([self filterValue:i] == -1)
        {
            continue;
        }
        [self initDataForInsertTestItemAndResult:i];
        if(-1 == IP_insertTestItemAndResult(UID,
                                            allItem[i],
                                            allLower[i],
                                            allUpper[i],
                                            measurement,
                                            0,
                                            allValue[i],
                                            message,
                                            isPass))
        {
            [self writeToReport:@"\ninsert fail!\n"
                    decriptions:[NSString stringWithFormat:@"item = %@,lower = %@,upper = %@,measurement = %s,value = %@,\n",allItem[i],allLower[i],allUpper[i],measurement,allValue[i]]];
            [self writeToDocument:@"PDCA"
                       decription:[NSString stringWithFormat:@"insert fail!\nitem = %@,lower = %@,upper = %@,measurement = %s,value = %@,\n",allItem[i],allLower[i],allUpper[i],measurement,allValue[i]]];
        }else{
            [self writeToReport:@"\ninsert success!\n" decriptions:[NSString stringWithFormat:@"item = %@,lower = %@,upper = %@,measurement = %s,value = %@\n",allItem[i],allLower[i],allUpper[i],measurement,allValue[i]]];
            [self writeToDocument:@"PDCA"
                       decription:[NSString stringWithFormat:@"insert success!\nitem = %@,lower = %@,upper = %@,measurement = %s,value = %@,\n",allItem[i],allLower[i],allUpper[i],measurement,allValue[i]]];
        }
    }
}

/*
 Describe : Adding & Commiting to PDCA
 Input    : NA
 Output   : NA
 */
- (BOOL)addAndCommitPdca
{
    bool STATUS;
    if([status isEqualToString:@"PASS"])
    {
        STATUS = YES;
    }else{
        STATUS = NO;
        failCount ++;
    }
    [self writeToReport:@"\n---AddAndCommitPDCA--" decriptions:@"\n"];
#if __ALI__
    zipFileName = [backupsPath stringByAppendingFormat:@"%@/%@",datePath,fileName];
//    zipFileName = [readPath stringByAppendingFormat:@"%@",fileName];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    saveCSVFileNamePath = [NSString stringWithFormat:@"%@_%@_%@",status,sn,[dateFormatter stringFromDate:[NSDate date]]];
#else
    [self compressFile];
#endif
    if(IP_addFile(UID, zipFileName, saveCSVFileNamePath) == -1)
    {
        [self writeToReport:@"\nAddFile " decriptions:@"fail!\n"];
        [self writeToDocument:@"PDCA" decription:@"add file failed!"];
        return FALSE;
    }else{
        [self writeToReport:@"\nAddFile " decriptions:@"success!\n"];
        [self writeToDocument:@"PDCA" decription:@"add file sucess!"];
    }
    
    if(IP_commitData(UID, STATUS) == -1){
        [self writeToReport:@"\ncommitData " decriptions:@"fail!\n"];
        [self writeToDocument:@"PDCA" decription:@"commit data failed!"];
        commitedPdcaStatus = @"FAIL";
        return FALSE;
    }else{
        [self writeToReport:@"\ncommitData " decriptions:@"success!\n"];
        [self writeToDocument:@"PDCA" decription:@"commit data success!"];
        commitedPdcaStatus = @"PASS";
    }
    return TRUE;
}

/*
 Describe : Show informations to table
 Input    : NA
 Output   : NA
 */
- (void)showToTableView
{
    totalCount ++;
    [self.delegate showTableView:saveCSVFileNamePath
                      dataStatus:status
                          isPass:commitedPdcaStatus
                             row:row];
    [self.delegate showStatusCount:totalCount failCount:failCount];
    row++;
}

/*
 Describe : Initing datas for inserting test item and result
 Input    : NA
 Output   : NA
 */
- (void)initDataForInsertTestItemAndResult:(NSUInteger)Count
{
    if([allResult[Count] integerValue] == 1)
    {
        isPass = true;
    }else{
        isPass = false;
    }
    
    if([allValue[Count] isEqualToString:@"Fail"]||[allValue[Count] isEqualToString:@"FAIL"]||[allValue[Count] isEqualToString:@"Failed"]){
        message = @"Not define error message!";
    }else{
        message = @"";
    }
    measurement = (char *)malloc(sizeof(strlen([allMeasurement[Count] cStringUsingEncoding:NSUTF8StringEncoding])+1));
    strcpy(measurement, [allMeasurement[Count] cStringUsingEncoding:NSUTF8StringEncoding]);
}

/*
Describe : Initing datas for inserting test item and result
Input    : NA
Output   : NA
*/
- (void)TransformerValueIsNilToNA:(NSUInteger)Count
{
    if([allValue[Count] isEqualToString:@" "])
    {
        allValue[Count] = @"NA";
    }
    if([allValue[Count] rangeOfString:@"V"].location != NSNotFound)
    {
        allValue[Count] = [allValue[Count] substringToIndex:[allValue[Count] rangeOfString:@"V"].location];
    }
    if([allValue[Count] rangeOfString:@" "].location != NSNotFound)
    {
        allValue[Count] = [allValue[Count] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if([allUpper[Count] isEqualToString:@" "])
    {
        allUpper[Count] = @"NA";
    }
    if([allLower[Count] isEqualToString:@" "])
    {
        allLower[Count] = @"NA";
    }
    if([allMeasurement[Count] isEqualToString:@" "]||[allMeasurement[Count] isEqualToString:@"-"])
    {
        allMeasurement[Count] = @"NA";
    }
}

/*
 Describe : Filter value for insert item and result
 Input    : NA
 Output   : NA
 */
- (NSUInteger)filterValue:(NSUInteger)i
{
    NSUInteger flag = 0;
    NSString * validChar = @";";
    
    if([allValue[i] rangeOfString:@"x"].length != 0 || [allValue[i] rangeOfString:@"X"].length != 0)
    {
        flag = HEXADECIMAL;
    }
    for(int k = 0; k < [allValue[i] length]; k++)
    {
        for(int j = 0; j < [validChar length]; j++){
            if([allValue[i] characterAtIndex:k] == [validChar characterAtIndex:j] && [allValue[i] rangeOfString:@"x"].length == 0){
                flag = STRING;
                break;
            }
        }
    }
    if(flag == HEXADECIMAL)
    {
        NSString *value = [[NSString alloc] init];
        NSString *lower = [[NSString alloc] init];
        NSString *upper = [[NSString alloc] init];
        value = allValue[i];
        lower = allLower[i];
        upper = allUpper[i];
        allValue[i] = [self hexadecimalToDecimal:allValue[i]];
        allLower[i] = [self hexadecimalToDecimal:allLower[i]];
        allUpper[i] = [self hexadecimalToDecimal:allUpper[i]];
        [self writeToDocument:@"Transform value" decription:[NSString stringWithFormat:@"hexadecimal transform to decimal\nv%@->%@\n%@->%@\n%@->%@",value,allValue[i],lower,allLower[i],upper,allUpper[i]]];
    }
    if(flag == STRING)
    {
        NSString *value = [[NSString alloc] init];
        value = allValue[i];
        allValue[i] = allResult[i];
        [self writeToDocument:@"Transform value" decription:[NSString stringWithFormat:@"stirng transform to bool\n%@->%@",value,allValue[i]]];
    }
    return 0;
}

- (NSString *)hexadecimalToDecimal:(NSString *)value
{
    NSUInteger decimalData = 0;
    for(NSUInteger k = [value length] - 1; k > 1 ; k--)
    {
        NSString * str = [NSString stringWithFormat:@"%c",[value characterAtIndex:k]];
        if([str isEqualToString:@"A"] || [str isEqualToString:@"a"])
        {
            str = @"10";
        }
        if([str isEqualToString:@"B"] || [str isEqualToString:@"b"])
        {
            str = @"11";
        }
        if([str isEqualToString:@"C"] || [str isEqualToString:@"c"])
        {
            str = @"12";
        }
        if([str isEqualToString:@"D"] || [str isEqualToString:@"d"])
        {
            str = @"13";
        }
        if([str isEqualToString:@"E"] || [str isEqualToString:@"e"])
        {
            str = @"14";
        }
        if([str isEqualToString:@"F"] || [str isEqualToString:@"f"])
        {
            str = @"15";
        }
        decimalData += ([str intValue])*pow(16, [value length] - 1 - k);
    }
    value = [NSString stringWithFormat:@"%lu",(unsigned long)decimalData];
    return value;
}

#pragma mark - ***Common factions***
/*
 Describe : Compress files for adding & committing file to PDCA
 Input    : NA
 Output   : NA
 */
- (void)compressFile
{
    zipFilePath = [savePath stringByAppendingFormat:@"%@/%@",datePath,saveCSVFileNamePath];
    zipFileName = [zipFilePath stringByAppendingString:@".zip"];
    NSString *cmdZip = [NSString stringWithFormat:@"/usr/bin/zip -rj %@ %@",zipFileName,zipFilePath];
    system([cmdZip UTF8String]);
    [self writeToDocument:@"Compress file" decription:cmdZip];
}

/*
 Describe : Getting PDCA handle for updataing data of PDCA
 Input    : NA
 Output   : NA
 */
- (void)createSavePath
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [self creatDatePath:savePath];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    saveCSVFileNamePath = [NSString stringWithFormat:@"%@_%@_%@",status,sn,[dateFormatter stringFromDate:[NSDate date]]];
    [self createPath:[savePath stringByAppendingFormat:@"%@/%@",datePath,saveCSVFileNamePath]];
    saveCSVFileName = [saveCSVFileNamePath stringByAppendingFormat:@".csv"];
}

/*
 Describe : Create path'faction
 Input    : NA
 Output   : NA
 */
- (void)createPath:(NSString *)path
{
    NSFileManager *dir = [NSFileManager defaultManager];
    [dir createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)creatDatePath:(NSString *)basepath
{
    NSFileManager *dir = [NSFileManager defaultManager];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    datePath = [dateFormatter stringFromDate:[NSDate date]];
    [dir createDirectoryAtPath:[basepath stringByAppendingString:datePath] withIntermediateDirectories:YES attributes:nil error:nil];
}

-(NSString *)getInfoFromDicJson:(NSString *)jsonInfoFirstLayer andJsonInfoSecondLayer:(NSString *)jsonInfoSecondLayer inJsonPath:(NSString *)jsonPath
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if(![filemgr fileExistsAtPath:jsonPath])
    {
        return false;
    }
    
    //read json file, and change to string
    NSString* json_des = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    //change string to NSData
    NSData* aData = [json_des dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json_dic = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary * jsonInfoFirstLayerDic = [json_dic objectForKey:jsonInfoFirstLayer];
    
    NSString * jsonInfoSecLayerTemp = [jsonInfoFirstLayerDic objectForKey:jsonInfoSecondLayer];
    return jsonInfoSecLayerTemp;
}

- (void)getAppStartDate
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    AppStartTime = [dateFormatter stringFromDate:[NSDate date]];
}

/*
 Describe : Return the amount of items
 Input    : NA
 Output   : count of items
 */
- (NSUInteger)countOfCycles
{
    return [allItem count];
}

/*
 Describe : Separate result and value
 Example: 2.5#1 => value=2.5,result=PASS
 Input    : Results and values'alignment
 Output   : NA
 */
- (void)separateResultAndValue:(NSUInteger)alignment
{
    NSString * resultAndValue = allResultAndPass[alignment];
    allResult[alignment] = [[resultAndValue componentsSeparatedByString:@"#"] objectAtIndex:1];
    allValue[alignment]  = [[resultAndValue componentsSeparatedByString:@"#"] objectAtIndex:0];
}

/*
 Describe : Create file's faction
 Input    : File'name & contents of file
 Output   : NA
 */
- (void)createFile:(NSString *)filename
           content:(NSString *)content
{
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:[content dataUsingEncoding:NSASCIIStringEncoding] attributes:nil];
}

/*
 Describe : Writing datas to file
 Input    : File'name & contents of file
 Output   : NA
 */
- (void)writeDataToFile:(NSString *)filename
                content:(NSString *)content
{
    NSFileHandle *fh = [[NSFileHandle alloc] init];
    NSData *stringData = [[NSData alloc] init];
    fh = [NSFileHandle fileHandleForUpdatingAtPath:filename];
    [fh seekToEndOfFile];
    stringData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [fh writeData:stringData];
    [fh closeFile];
    
}

/*
 Describe : According to regular expression catch the values of content
 Input    : reular expression & content
 Output   : NA
 */
- (NSString *)Regex:(NSString *)regex
            content:(NSString *)content
{
    NSRegularExpression * regexTmp = [[NSRegularExpression alloc] initWithPattern:regex
                                                                          options:0
                                                                            error:0];
    NSTextCheckingResult * matchResTmp = [regexTmp firstMatchInString:content
                                                              options:0
                                                                range:NSMakeRange(0, [content length])];
    NSRange rangeOfValue = [matchResTmp rangeAtIndex:1];
    NSString * result = [content substringWithRange:rangeOfValue];
    return result;
}

/*
 Describe : Create report's folder
 Input    : NA
 Output   : NA
 */
- (void)createReportFolder
{
    [self creatDatePath:reportPath];
    [self createFile:[reportPath stringByAppendingFormat:@"%@/%@.log",datePath,saveCSVFileNamePath] content:@"---Report---"];
}

/*
 Describe : Writing datas to report
 Input    : faction'name & decriptions.
 Output   : NA
 */
- (void)writeToReport:(NSString *)act
          decriptions:(NSString *)decr
{
    [self writeDataToFile:[reportPath stringByAppendingFormat:@"%@/%@.log",datePath,saveCSVFileNamePath] content:[act stringByAppendingString:decr]];
}

- (void)createDocument
{
    NSString * date = [[NSString alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    date = [dateFormatter stringFromDate:[NSDate date]];
    documentFileName = [documentPath stringByAppendingFormat:@"%@_Transformers.log",date];
    [self createFile:documentFileName content:@""];
}

- (void)writeToDocument:(NSString *)act
             decription:(NSString *)decr
{
    NSString * date = [[NSString alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:ms"];
    date = [dateFormatter stringFromDate:[NSDate date]];
    [self writeDataToFile:documentFileName content:[NSString stringWithFormat:@"\n[%@]:---%@---\n%@\n",date,act,decr]];
}

#pragma mark - ***Monitor network***

/*
 Describe : Create report's folder
 Input    : NA
 Output   : NA
 */
- (void)monitorNetworkConnect
{
    while(1){
        usleep(5000000);
        if(![self judegeConnectStatus]){
            ConnectStatus = 1;
            [self threadCloed];
            break;
        }
    }
}

- (void)initIPAddressAndCommand
{
    command = [NSString stringWithFormat:@"ping -c 1 -W 1 %@ > %@ls.txt",IPAddress,reportPath];
}


- (BOOL) judegeConnectStatus
{
    system([command UTF8String]);
    NSString * IPInfor = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@ls.txt", reportPath]
                                                   encoding:NSASCIIStringEncoding
                                                      error:nil];
    NSRange infor = [IPInfor rangeOfString:@"="];
    if(infor.length > 0){
        timeout = [self Regex:@"=\\s*([\\d\\.]*)" content:IPInfor];
        timeout = [timeout stringByAppendingString:@" ms"];
        [self.delegate showNetworkStatus:1 timeout:timeout];
        return YES;
    }else{
        [self.delegate showNetworkStatus:2 timeout:@"disconnect"];
        [self writeToReport:@"---JudegeConnectStatus---" decriptions:@"\nNetwork disconnected!\n"];
        [self writeToDocument:@"Monitor network status" decription:@"network disconnected!"];
        
        return NO;
    }
}

#pragma mark ***Mount share folder***
- (BOOL) mountShareFolder
{
    [self initIPAddressAndCommand];
    if([self judegeConnectStatus]){
        NSString * Command = [[NSString alloc] init];
        Command = [mountCommand stringByAppendingFormat:@"%@/DropBox %@",IPAddress,readPath];
        system([Command UTF8String]);
        return YES;
    }else{
        [self.delegate showAlertWindow:@"Warning" information:@"Network is diconnected!\nPlease check out connection of internet!"];
        return NO;
    }
}

- (BOOL) clearFolderOfReadPath
{
    NSString * Command = [NSString stringWithFormat:@"mv -f %@* %@",readPath,backupsPath];
    system([Command UTF8String]);
    return YES;
}

#pragma mark ***Thread init***
- (BOOL)threadInit
{
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(monitorFileFolder)
                                       object:nil];
    thread.name = @"threadOfMonitorFileFolder";
    threadConnect = [[NSThread alloc] initWithTarget:self
                                            selector:@selector(monitorNetworkConnect)
                                            object:nil];
    threadConnect.name = @"threadOfMonitorFileFolder";
    return YES;
}

- (void)threadCloed
{
    [self writeToDocument:@"Thread" decription:[NSString stringWithFormat:@"thread:%@  exit!",[NSThread currentThread].name]];
    [NSThread exit];
}

#pragma mark ***Run***
- (void)Run
{
    [self initInformation];
    [self createFileFolder];
    [self createDocument];
    [self writeToDocument:@"init information"
               decription:[NSString stringWithFormat:@"stationName:%@\nversion:%@",stationName,appVersion]];
   if([self mountShareFolder]){
        [self writeToDocument:@"mount share folder" decription:@"mount share folder is success!"];
    }else{
        [self writeToDocument:@"mount share folder" decription:@"mount share folder is Fail!"];
    }
    if([self clearFolderOfReadPath]){
        [self writeToDocument:@"clear folder of read path" decription:@"clear folder of read path is successed!"];
    }else{
        [self writeToDocument:@"clear folder of read path" decription:@"clear folder of read path is failed!"];
    }
    if([self threadInit]){
        [self writeToDocument:@"Thread init" decription:@"thread init is success!"];
    }else{
        [self writeToDocument:@"Thread init" decription:@"thread init is failed!"];
    }
    [thread start];
    [self writeToDocument:@"Monitor Folder" decription:@"start monitor folder"];
//    [threadConnect start];
    [self writeToDocument:@"Monitor network status" decription:@"start monitor network status"];
}
@end
