//
//  ViewController.h
//  Test
//
//  Created by Allen_Du on 19/09/2017.
//  Copyright © 2017 William. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <poll.h>
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
//#import "PvApi.h"//#import "ImageLib.h"
//#import <allen_first_framework/first_h.h>
#define BUFFSIZE    8192


/*
 *使用confusion宏控制加密解密
 *当confusion宏被定义的时候，执行加密脚本，对字符串进行加密
 *当confusion宏被删除或未定义时，执行解密脚本，对字符串解密
 */
#define confusion
#ifdef confusion
#define confusion_NSSTRING(string) decryptConstString(string)
#define confusion_CSTRING(string) decryptConfusionCS(string)
#else
#define confusion_NSSTRING(string) @string
#define confusion_CSTRING(string) string
#endif


@interface ViewController : NSViewController
{
    
    NSString * response;
    NSTimer *countDownTimer[6];
    NSInteger count[6];
    NSInteger i_count[6];
}

@end

