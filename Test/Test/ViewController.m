//
//  ViewController.m
//  Test
//
//  Created by Allen_Du on 19/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *time = [self dateTimeDifferenceWithStartTime:@"2018-06-16 21:15:" endTime:@"2018-07-16 21:19:50"];
//    NSLog(@"time = %@",time);
//     countDownTimer[0] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction1) userInfo:nil repeats:YES];
//    countDownTimer[1] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction2) userInfo:nil repeats:YES];
//    countDownTimer[2] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction3) userInfo:nil repeats:YES];
//    countDownTimer[3] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction4) userInfo:nil repeats:YES];
//    countDownTimer[4] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction5) userInfo:nil repeats:YES];
//    countDownTimer[5] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction6) userInfo:nil repeats:YES];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    for(int i = 0; i < 6; i++)
//    {
//       // [dict removeAllObjects];
////        [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:[@"count" stringByAppendingFormat:@"%d",i]];
////        countDownTimer[i] = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction:) userInfo:dict repeats:YES];
//        count[i] = 5;
//
//        [self start:i];
//    }
    
//    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    
//    [thread start];
//    count[0] = 5;
    
//    [self addnewline];
//    dispatch_queue_t main_queue = dispatch_get_main_queue();
//    dispatch_sync(main_queue,^{
//        NSLog(@"main queue");
//    });
//    NSLog(@"go on");
    
    
//    dispatch_queue_t global_queue = dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
//    dispatch_sync(global_queue, ^{
//        NSLog(@"global_queue out");
//        dispatch_sync(global_queue, ^{
//            NSLog(@"global_queue in");
//        });
//    });

    

//    int port = 5589;
//    const char * ip = [@"192.168.2.99" cStringUsingEncoding:NSUTF8StringEncoding];
//
//    struct sockaddr_in addrServer;
//    memset(&addrServer, 0, sizeof(addrServer));
//    addrServer.sin_family = AF_INET;
//    addrServer.sin_port = htons(port);
//    addrServer.sin_addr.s_addr = inet_addr(ip);
//
//    int socket_int;
//    NSInteger count = 1;
//    if((socket_int = socket(AF_INET, SOCK_STREAM, 0)) < 0)
//    {
//        NSLog(@"socket init failed");
//    }
//    else
//    {
//        dispatch_queue_t serialQueue = dispatch_queue_create("my serial queue", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(serialQueue, ^{
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSLog(@"socket init success");
//                while (1) {
//                    NSLog(@"count = %ld",(long)count);
//                    [self socket:socket_int addrServer:addrServer];
//                    usleep(2000000);
//                }
//            });
//        });
//    }
    
//    NSString *str = @"Hello World";
//    NSLog(@"%@",str);
//    char * cStr = "Super Man";
//    NSLog(@"%s",cStr);
//    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"productInfo" ofType:@"plist"];
//    NSArray * allProducts = [[NSArray alloc] initWithContentsOfFile:plistFile];
//    NSDictionary *proDic;
//    for (proDic in allProducts)
//    {
//        if ([proDic count] != 0)
//        {
//            if ([[proDic allKeys][0] isEqualToString:@"N131"])
//            {
//                break;
//            }
//        }
//    }
//    NSDictionary *dataDic = [[proDic objectForKey:@"N131"] objectForKey:@"BoardID"];
//    NSDictionary * LGDic = [dataDic objectForKey:@"LG"];
//    NSDictionary * SMDic = [dataDic objectForKey:@"SM"];
//    NSString * protypeName = [LGDic objectForKey:@"0x0E"];
//    NSLog(@"ASFDASD");

//    NSString * str = [NSString stringWithContentsOfFile:@"/Users/allen_du/Desktop/N131/log2.0/SA-BCM-Combo/N131B/vault-N131B/tmp/FGR832481VBK5LKEB_20180914153126/BCTestDCS.plist"
//                                               encoding:NSASCIIStringEncoding
//                                                  error:nil];
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//    NSString * str2  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str2);
//    NSString * scriptPath = @"/Users/allen_du/Desktop/N131/";
//    NSString * contents = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"contents = %@",contents);
   
//    NSString * StationName = [self getInfoFromDicJson:@"ghinfo" andJsonInfoSecondLayer:@"STATION_TYPE" inJsonPath:@"/vault/data_collection/test_station_config/gh_station_info.json"];
//    NSLog(@"StationName = %@",StationName);
    
  //  first_h * first_exp = [[first_h alloc] init];
  //  BOOL first_faction_result = [first_exp first_faction:@"Allen"];
  //  NSLog(@"first_faction_result = %hhd",first_faction_result);
    
}



void Sleep(unsigned int time)
{
    struct timespec t,r;
    
    t.tv_sec    = time / 1000;
    t.tv_nsec   = (time % 1000) * 1000000;
    
    while(nanosleep(&t,&r)==-1)
        t = r;
}

void SetConsoleCtrlHandler(void (*func)(int), int junk)
{
    signal(SIGINT, func);
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

/*字符串混淆解密函数，将char[] 形式字符数组和aa异或运算解密*/
extern char* decryptConfusionCS(char * string)
{
    char * orgin_string = string;
    while(*string){
        *string ^= 0xAA;
        string++;
    }
    return orgin_string;
}

/*解密函数，返回的是NSString类型*/
extern NSString *decryptConstString(char * string)
{
    /*先执行decryptConfusionCS函数解密字符串*/
    char * str = decryptConfusionCS(string);
    /*获取字符串的长度*/
    unsigned long len = strlen(str);
    NSUInteger length = [[NSString stringWithFormat:@"%lu",len] integerValue];
    NSString *resultString = [[NSString alloc] initWithBytes:str length:length encoding:NSUTF8StringEncoding];
    return resultString;
}


- (BOOL) socket:(int)socket_int
     addrServer:(struct sockaddr_in)addrServer
{
    NSInteger count2 = 1;
    if(connect(socket_int, (struct sockaddr *)&addrServer, sizeof(addrServer)) != 0)
    {
        NSLog(@"socket connect failed");
        return NO;
    }
    else
    {
      NSLog(@"socket connect success");
    }
    
    char sendBuf[1024],recvBuf[1024];
    while (recv(socket_int,recvBuf,sizeof(recvBuf),0)) {
        NSLog(@"count2 = %ld",(long)count2);
        NSLog(@"recvBuf = %s",recvBuf);
        strcpy(sendBuf, [@"here is client" UTF8String]);
        send(socket_int, sendBuf, strlen(sendBuf), 0);
        memset(&sendBuf, 0, sizeof(sendBuf));
        memset(&recvBuf, 0, sizeof(recvBuf));
        usleep(1000000);
        count2 ++;
    }
    shutdown(socket_int, SHUT_RDWR);
    usleep(1000000);
    return TRUE;
}

- (void)dispatchSemaphore
{
//    dispatch_semaphore_t sem = dispatch_semaphore_create(2);
}

- (void) addnewline
{
    NSString * chart = @"afdaa\r\n";
    NSLog(@"chart = %@",chart);
}


- (void)start
{
    [countDownTimer[0] fire];
}

- (void)start:(NSInteger)i
{
    [countDownTimer[i] fire];
}
//- (void)countDownAction:(NSTimer *)timer
//{
//
//    i_count[[[timer userInfo] count] - 1] = [[timer userInfo] count] - 1;
//
//    NSInteger j = [[timer userInfo] count] - 1;
//    NSString * key = [@"count" stringByAppendingFormat:@"%lu",j];
//    int i = [[[timer userInfo] objectForKey:key] intValue];
//    count[i_count[[[timer userInfo] count] - 1]] --;
//    NSLog(@"count%ld = %ld",i_count[[[timer userInfo] count] - 1],(long)count[i_count[[[timer userInfo] count] - 1]]);
//    if(count[i_count[[[timer userInfo] count] - 1]] == 0)
//    {
//        //[countDownTimer[i_count[[[timer userInfo] count] - 1]] invalidate];
//        NSLog(@"count%ld_t = %ld",i_count[[[timer userInfo] count] - 1],(long)count[i_count[[[timer userInfo] count] - 1]]);
//        count[i_count[[[timer userInfo] count] - 1]] = 5;
//    }
//}

- (void)countDownAction1
{
    count[0] --;
    NSLog(@"count1 = %ld",(long)count[0]);
    if(count[0]  == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count1_t = %ld",(long)count[0]);
        count[0]  = 5;
    }
}

- (void)countDownAction2
{
    count[1] --;
    NSLog(@"count2 = %ld",(long)count[1]);
    if(count[1]  == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count2_t = %ld",(long)count[1]);
        count[1]  = 5;
    }
}

- (void)countDownAction3
{
    count[2]  --;
    NSLog(@"count3 = %ld",(long)count[2]);
    if(count[2]  == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count3_t = %ld",(long)count[2]);
        count[2]  = 5;
    }
}

- (void)countDownAction4
{
    count[3]  --;
    NSLog(@"count4 = %ld",(long)count[3]);
    if(count[3]  == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count4_t = %ld",(long)count[3]);
        count[3]  = 5;
    }
}

- (void)countDownAction5
{
    count[4]  --;
    NSLog(@"count5 = %ld",(long)count[4]);
    if(count[4]  == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count5_t = %ld",(long)count[4]);
        count[4]  = 5;
    }
}

- (void)countDownAction6
{
    count[5] --;
    NSLog(@"count6 = %ld",(long)count[5]);
    if(count[5] == 0)
    {
        //[countDownTimer invalidate];
        NSLog(@"count6_t = %ld",(long)count[5]);
        count[5] = 5;
    }
}




- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 *3600)%3600;
    int day = (int)value / (24 *3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%dd%dh%dm%ds",day,house,minute,second];
    }else if (day==0 && house !=0) {
        str = [NSString stringWithFormat:@"%dh%dm%ds",house,minute,second];
    }else if (day==0 && house==0 && minute!=0) {
        str = [NSString stringWithFormat:@"%dm%ds",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%ds",second];
    }
    return [NSString stringWithFormat:@"%d",(int)value];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
