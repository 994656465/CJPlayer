//
//  CJPlayerTool.m
//  播放器1
//
//  Created by dd luo on 2019/10/31.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import "CJPlayerTool.h"

@implementation CJPlayerTool
+(instancetype)sharePlayerTool{
    
    static CJPlayerTool * playerTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerTool = [[self alloc]init];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    });
    return playerTool;
}

-(AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}


-(void)playMusicWithURL:(NSString * )url{
    NSString * path = [[NSBundle mainBundle]pathForResource:url ofType:nil];
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    [self.player replaceCurrentItemWithPlayerItem:  self.playerItem];
    [self.player play];
    
}

-(CGFloat)progressFloat{
    
    NSInteger  totalTime = [self totalTime];
    NSInteger currentTime = [self currentTime];
    return currentTime * 1.0 / totalTime;
    
    
}

-(void)pause{
    [self.player pause];
}

-(void)play{
      [self.player play];
}
-(NSInteger)totalTime{
    return CMTimeGetSeconds(self.playerItem.asset.duration);
}
-(NSInteger)currentTime{
    return self.playerItem.currentTime.value / self.playerItem.currentTime.timescale;
}

-(void)jumpToTime:(NSTimeInterval)newTime{

    NSLog(@"--------%f",newTime);
    
    CGFloat progress =   newTime / [self totalTime];

    [self.player seekToTime:CMTimeMake([self totalTime] * progress, 1) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000)];
//    self.player.currentItem.currentTime
//  CGFloat progress =   newTime / [self totalTime];
//
//
//
//
//    [self.player seekToTime:CMTimeMake([self totalTime] * progress, 1)];
//
}

@end
