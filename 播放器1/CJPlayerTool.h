//
//  CJPlayerTool.h
//  播放器1
//
//  Created by dd luo on 2019/10/31.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJPlayerTool : NSObject

@property(nonatomic,strong) AVPlayer * player;
@property(nonatomic,strong) AVPlayerItem * playerItem;


+(instancetype)sharePlayerTool;

-(CGFloat)progressFloat;
-(void)playMusicWithURL:(NSString * )url;
-(void)pause;
-(void)play;
-(NSInteger)totalTime;
-(NSInteger)currentTime;


-(void)jumpToTime:(NSTimeInterval)newTime;
@end

NS_ASSUME_NONNULL_END
