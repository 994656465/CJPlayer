//
//  CJSongLrcTool.m
//  播放器1
//
//  Created by dd luo on 2019/11/4.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import "CJSongLrcTool.h"

@implementation CJSongLrcTool


+(NSArray *)songLrcToolWithLrcName:(NSString *)lrcName{
    
    
    
 NSString *  path =   [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
//    NSMutableArray * arr = [NSMutableArray mutableArrayValueForKeyPath:path];
    
    NSString * lrcAllStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *  arr =   [lrcAllStr componentsSeparatedByString:@"\n"];
    
    NSLog(@"%@",arr);
    
    
    NSMutableArray * modelArr= [NSMutableArray array];
    for (NSInteger i = 0 ; i < arr.count; i++) {
        NSString * lrcString = arr[i];
//        [00:55.95]我要稳稳的幸福

        NSString * zhengze = @"\\[[0-9][0-9]:[0-9][0-9].[0-9][0-9]\\]";
        NSRegularExpression * reguler= [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray * allResultCheck = [reguler matchesInString:lrcString options:NSMatchingReportCompletion range:NSMakeRange(0, lrcString.length)];
        NSTextCheckingResult * result = allResultCheck.lastObject;
        
        //  匹配内容
        NSString *  textLrc  =     [lrcString substringFromIndex:(result.range.location + result.range.length)];
//        NSLog(@"textLrc:%@",textLrc);
        //  匹配时间 多个时间执行多次
        for (NSInteger   i = 0 ; i < allResultCheck.count; i++) {
            NSTextCheckingResult * textCheckResut = allResultCheck[i];
             //截取时间字符串[03:52.00];
            NSString* timeStr = [lrcString substringWithRange:textCheckResut.range ];
            
//            NSLog(@"timeStr----------:%@",timeStr);
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat =@"[mm:ss.SS]";
            NSDate * date = [dateFormatter dateFromString:timeStr];
            NSDate * zeroDate = [dateFormatter dateFromString:@"[00:00.00]"];
            NSTimeInterval lrcTime = [date timeIntervalSinceDate:zeroDate];
            lrcModel * model = [[lrcModel alloc]init];
            model.time =lrcTime;
            model.lrcStr = textLrc;
            [modelArr addObject:model];
            NSLog(@"timeStr------%@----:%f",timeStr,lrcTime);

        
        }
        
    }
    
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    
    [modelArr sortedArrayUsingDescriptors:@[descriptor]];
    
//    NSLog(@"lrc arr :   %@",results);
    
    return  [modelArr sortedArrayUsingDescriptors:@[descriptor]];;
}
@end
