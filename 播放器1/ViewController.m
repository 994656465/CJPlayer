//
//  ViewController.m
//  播放器1
//
//  Created by dd luo on 2019/10/30.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define kLrcLineHeight 44

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)     UIImageView  * bgImageView ;// 背景图片
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * sourceLabel;
@property(nonatomic,strong) UIProgressView * progressView;
@property(nonatomic,strong) UILabel * leftTimeLabel;
@property(nonatomic,strong) UILabel * rightTimeLabel;
@property(nonatomic,strong) UIButton * playButton;
@property(nonatomic,strong) UIButton * leftButton ;
@property(nonatomic,strong) UIButton * rightButton ;
@property(nonatomic,strong)  UIView * middleView ;

@property(nonatomic,strong)  UIImageView * middleImage;

@property (nonatomic, assign) NSInteger  currentSongIndex;// 当前歌曲

@property(nonatomic,strong)NSArray * songsArr ;

@property(nonatomic,strong)    NSTimer * timer ;
@property(nonatomic,strong) UIScrollView * scrollView;// 歌词
@property(nonatomic,strong) NSArray * songLrcLines; // 歌词 文字 时间 数组

@property(nonatomic,strong) UILabel * lrcLabel;
@property(nonatomic,strong) UIView * scrollviewContentView ;

@property(nonatomic,strong)  NSMutableArray * lrcLabelsArr ;  //歌词label  数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"123";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    [self creatUI];

    
    NSArray * songs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mlist.plist" ofType:nil] ];
    
    self.songsArr = [musicModel mj_objectArrayWithKeyValuesArray:songs];
    self.currentSongIndex = 0;
    [self playNewSong];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plauyerEndCurrentItem:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self becomeFirstResponder];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];

}

-(void)creatUI{
    UIImageView  * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.bgImageView = bgImageView;
//    bgImageView.backgroundColor = [UIColor redColor];
    bgImageView.image = [UIImage imageNamed:@"李克勤.jpg"];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.alpha = 1;
    effectView.frame =self.view.bounds;
    [bgImageView addSubview:effectView];
    [self.view addSubview:bgImageView];

    
    UIView * bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
        make.bottom.mas_equalTo(0);
        
    }];
    


    
    UIProgressView * progressView =[[UIProgressView alloc]init];
    self.progressView = progressView;
    
    progressView.progressTintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor grayColor];
    progressView.progress = 0.0;
    
    [bottomView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(3);
    }];

    
    UILabel * leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel = leftTimeLabel;
    leftTimeLabel.text = @"0:00";
    leftTimeLabel.textColor = RGB(238, 238, 238);
    leftTimeLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(progressView.mas_bottom).offset(10);
    }];
   UILabel * rightTimeLabel = [[UILabel alloc]init];
     self.rightTimeLabel = rightTimeLabel;
     rightTimeLabel.text = @"30:00";
     rightTimeLabel.textColor = RGB(238, 238, 238);
     rightTimeLabel.font = [UIFont systemFontOfSize:16];
     [bottomView addSubview:rightTimeLabel];
     [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-10);
         make.top.mas_equalTo(leftTimeLabel.mas_top);
     }];
    
    UIButton * playButton = [UIButton buttonWithType:0];
       self.playButton = playButton;
       [playButton setTitle:@"正在播放" forState:UIControlStateNormal];
       [playButton setTitle:@"已经暂停" forState:UIControlStateSelected];
       [playButton addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:playButton];
       [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.mas_equalTo(self.view.mas_centerX);
           make.top.mas_equalTo(progressView.mas_bottom).offset(30);
           make.size.mas_equalTo(CGSizeMake(80, 80));
       }];
    
    
    UIButton * leftButton = [UIButton buttonWithType:0];
//       leftButton.backgroundColor = [UIColor orangeColor];
    [leftButton setTitle:@"上一首" forState:UIControlStateNormal];

       self.leftButton = leftButton;
       leftButton.tag = 1;
       [leftButton addTarget:self action:@selector(changeSongButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:leftButton];
       [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(playButton.mas_centerY);
           make.left.mas_equalTo(20);
           make.size.mas_equalTo(CGSizeMake(60, 30));
       }];
       
       
       
       UIButton * rightButton = [UIButton buttonWithType:0];
       [rightButton setTitle:@"下一首" forState:UIControlStateNormal];
       self.rightButton = rightButton;
       rightButton.tag = 2;

       [rightButton addTarget:self action:@selector(changeSongButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:rightButton];
       [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(playButton.mas_centerY);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
    
    
    
    UIView * middleView = [[UIView alloc]init];
    self.middleView = middleView;
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomView.mas_top);
        make.top.mas_equalTo(64);
    }];
    
   


     UILabel * sourceLabel = [[UILabel alloc]init];
     self.sourceLabel = sourceLabel;
     sourceLabel.text = @"来源";
     sourceLabel.textColor = RGB(238, 238, 238);
     sourceLabel.font = [UIFont systemFontOfSize:16];
     [middleView addSubview:sourceLabel];
     [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(10);
         make.bottom.mas_equalTo(middleView.mas_bottom).offset(-10);
     }];
    
    
    UILabel * nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    nameLabel.text = @"张毅";
    nameLabel.textColor = RGB(238, 238, 238);
    nameLabel.font = [UIFont systemFontOfSize:16];
    [middleView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
     make.bottom.mas_equalTo(sourceLabel.mas_top).offset(-10);
        
    }];
    
    UIImageView * middleImage = [[UIImageView alloc]init];
    self.middleImage = middleImage;
    middleImage.image = [UIImage imageNamed:@"李克勤.jpg"];
    [middleView addSubview:middleImage];
    [middleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(nameLabel.mas_top).offset(-10);

    }];
    

    UISwipeGestureRecognizer * leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imageLeftSwiftWithRecognier:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [middleView addGestureRecognizer:leftRecognizer];
    
    
    

    UIScrollView * scrollView1 = [[UIScrollView alloc]init];
    scrollView1.alpha = 0;
    self.scrollView = scrollView1;
    scrollView1.delegate =self;
   UISwipeGestureRecognizer * rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imageLeftSwiftWithRecognier:)];
   [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
   [scrollView1 addGestureRecognizer:rightRecognizer];
    [self.view addSubview:scrollView1];
    
    [scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    
    UIView * scrollviewContentView = [[UIView alloc]init];
    self.scrollviewContentView = scrollviewContentView;
    [self.scrollView addSubview:scrollviewContentView];
    
    [scrollviewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
//
//    UIScrollView * scrollView = [[UIScrollView alloc]init];
////    self.scrollView = scrollView;
//    scrollView.backgroundColor = [UIColor purpleColor];
////    scrollView.alpha = 1;
//    scrollView.contentSize = CGSizeMake(100, 100);
//       [self.view addSubview:scrollView];
////       UISwipeGestureRecognizer * rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imageLeftSwiftWithRecognier:)];
////       [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
////       [scrollView addGestureRecognizer:rightRecognizer];
//
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(54);
//        make.bottom.mas_equalTo(0);
//
//        make.width.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
    
    
    
    
}


//  MARK: - timer
-(void)addTimer{
    NSTimer * timer = [NSTimer timerWithTimeInterval:1/60.0 target:self selector:@selector(timerUpdateEvent) userInfo:nil repeats:YES];
    self.timer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}
-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)timerUpdateEvent{
//    NSLog(@"progressFloat      %f",   [[CJPlayerTool sharePlayerTool] progressFloat] );
// 更新进度条
    [self.progressView setProgress:[[CJPlayerTool sharePlayerTool] progressFloat] animated:YES];
    NSInteger currentTime = [[CJPlayerTool sharePlayerTool] currentTime];
    
    NSInteger min = currentTime/60;
    NSInteger sec = currentTime %60;
    self.leftTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",min,sec];
  //  进度条 到头自动切换下一首
//    NSInteger totalTime = [[CJPlayerTool sharePlayerTool] totalTime];
//    if (currentTime == totalTime ) {
//        [self removeTimer];
//        [self changeSongButtonClick:self.rightButton];
//
//    }
    
    
//    self.progressView.progress = [[CJPlayerTool sharePlayerTool] progressFloat];
    
    
    //  更新歌词
    for (NSInteger  i = 0 ; i<self.songLrcLines.count; i++) {
        NSTimeInterval currentTime = [[CJPlayerTool sharePlayerTool] currentTime];
        
        lrcModel * currentlrcModel = self.songLrcLines[i];
        
        lrcModel * nextLrcModel = nil;
        if (i == self.songLrcLines.count - 1) {
            nextLrcModel = currentlrcModel;
        }else{
            nextLrcModel = self.songLrcLines[i+1];
        }
        
        
        
    

        if (currentTime >= currentlrcModel.time &&  currentTime <= nextLrcModel.time) {
           // 当前歌词
//            lrcModel * model = self.songLrcLines[i];
            
//            currentLrcLabel.text = model.lrcStr;
            CJLrcLabel * currentLrcLabel = self.lrcLabelsArr[i];

            
            CGFloat progress = 0.0;
            if (i == self.songLrcLines.count - 1) {
                
              progress = (currentTime - currentlrcModel.time)/([[CJPlayerTool sharePlayerTool] totalTime] - currentlrcModel.time);
            }else{

               progress =    ( currentTime - currentlrcModel.time) /(nextLrcModel.time - currentlrcModel.time);
//                NSLog(@"lrc   progress  nextLrcModel %f   %f",nextLrcModel.time ,currentlrcModel.time);
            }
            
            
            for (CJLrcLabel * subLabel in self.scrollviewContentView.subviews) {
                if ([subLabel isKindOfClass:[CJLrcLabel class]]) {
                    subLabel.progress = 0.0;
                }
            }
            
            currentLrcLabel.progress = progress;

        }
    }
    
    
    
}

//  MARK: - 更新歌词
-(void)creatLrcLabel{

     for (UIView *label in self.scrollviewContentView.subviews) {
        
        if ([label isKindOfClass:[CJLrcLabel class]]) {
             [label removeFromSuperview];
        }
    }
    
    [self.lrcLabelsArr removeAllObjects];

    
    
//    NSMutableArray * labelsArr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.songLrcLines.count; i++) {
        CJLrcLabel * lrcLabel =  [[CJLrcLabel alloc]init];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcModel * model = self.songLrcLines[i];
        lrcLabel.text =model.lrcStr;
        [self.lrcLabelsArr addObject:lrcLabel];
        [self.scrollviewContentView addSubview:lrcLabel];
        NSLog(@"model.time     %f    %@",model.time, model.lrcStr);
    }
    
    [self.lrcLabelsArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:(SCREEN_HEIGHT- 150-64 )*0.5 tailSpacing:160];
    
    [self.lrcLabelsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kLrcLineHeight);
    }];
    
}


//  MARK: - 点击v事件  远程播放

-(void)changeSongButtonClick:(UIButton *)button{



    if (button.tag == 1) {
        self.currentSongIndex--;
        if (self.currentSongIndex < 0) {
            self.currentSongIndex = self.songsArr.count - 1;
        }
    }else{
        self.currentSongIndex++;
        if (self.currentSongIndex >= self.songsArr.count) {
            self.currentSongIndex = 0;
        }
        
        
    }
    NSLog(@"currentSongIndex:%ld",self.currentSongIndex);
    [self playNewSong];

 
    
}


-(void)playNewSong{
    [self addTimer];

    self.playButton.selected = NO;
    musicModel * model = self.songsArr[self.currentSongIndex];
    
    self.bgImageView.image = [UIImage imageNamed:model.image];
    self.middleImage.image  =[UIImage imageNamed:model.image];
    self.title = model.name;
    self.nameLabel.text = model.singer;
    self.sourceLabel.text = model.zhuanji;
    
    self.songLrcLines =  [CJSongLrcTool songLrcToolWithLrcName:model.lrc];;
    
    [[CJPlayerTool sharePlayerTool] playMusicWithURL:model.mp3];
    
    NSInteger totalTime = [[CJPlayerTool sharePlayerTool] totalTime];
    
    if (totalTime > 0) {
        
    }
    NSInteger min = totalTime/60;
    NSInteger sec = totalTime %60;
    self.rightTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",min,sec];
    [self creatLrcLabel];
    [self updateScreenInfo];

}

-(void)pause{
    [self removeTimer];
    [[CJPlayerTool sharePlayerTool] pause];

    
}

-(void)plauCurrentSong{
        [self addTimer];
     [[CJPlayerTool sharePlayerTool] play];
}


-(void)button1Click{

    self.playButton.selected = !self.playButton.selected;
    
    if (self.playButton.selected == NO) {
        NSLog(@"正在播放");

        [self plauCurrentSong];
    }else{
        NSLog(@"已经暂停");

        [self pause];
    }
}

-(void)plauyerEndCurrentItem:(NSNotification *)notification{
    NSLog(@"-------end---------");
     [self removeTimer];
    [self changeSongButtonClick:self.rightButton];
    
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
//    UIEventSubtypeNone                              = 0,
//
//       // for UIEventTypeMotion, available in iPhone OS 3.0
//       UIEventSubtypeMotionShake                       = 1,
//
//       // for UIEventTypeRemoteControl, available in iOS 4.0
//       UIEventSubtypeRemoteControlPlay                 = 100,
//       UIEventSubtypeRemoteControlPause                = 101,
//       UIEventSubtypeRemoteControlStop                 = 102,
//       UIEventSubtypeRemoteControlTogglePlayPause      = 103,
//       UIEventSubtypeRemoteControlNextTrack            = 104,
//       UIEventSubtypeRemoteControlPreviousTrack        = 105,
//       UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
//       UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
//       UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
//       UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    NSLog(@"remoteControlReceivedWithEvent --   %ld",event.subtype);
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self plauCurrentSong];
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [self pause];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self changeSongButtonClick:self.rightButton];
            break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self changeSongButtonClick:self.leftButton];
                break;

        default:
            break;
    }
}

-(void)imageLeftSwiftWithRecognier:(UISwipeGestureRecognizer *)recognier{
    
    
    if (recognier.direction == UISwipeGestureRecognizerDirectionLeft) {

            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.alpha = 1;
                self.middleView.alpha = 0;
//                [ self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                      make.top.mas_equalTo(self.middleImage.mas_top);
//                      make.bottom.mas_equalTo(self.middleView.mas_bottom);
//
//                      make.width.mas_equalTo(self.middleImage.mas_width);
//                      make.left.mas_equalTo(0);
//                }];
            }];

        NSLog(@"左滑动");
    }else if(recognier.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"右滑动");
        [UIView animateWithDuration:0.5 animations:^{
                     self.scrollView.alpha = 0;
                     self.middleView.alpha = 1;
//                     [ self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                                   make.top.mas_equalTo(self.middleImage.mas_top);
//                                   make.bottom.mas_equalTo(self.middleView.mas_bottom);
//
//                                   make.width.mas_equalTo(self.middleImage.mas_width);
//                                   make.left.mas_equalTo(self.middleImage.mas_right);
//                     }];
                 }];

    }
}


//  MARK: - 懒加载
-(NSMutableArray *)lrcLabelsArr{
    if (!_lrcLabelsArr) {
        _lrcLabelsArr = [NSMutableArray array];
    }
    return _lrcLabelsArr;
}

//  MARK: - scrollview delegete
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //结束拖拽
   NSInteger index =  (scrollView.contentOffset.y + scrollView.contentInset.top) / kLrcLineHeight;
    NSLog(@"index    %zd",index);
    
    lrcModel * model = self.songLrcLines[index];
//    [CJPlayerTool sharePlayerTool].player.currentItem.currentTime = model.time;
    [[CJPlayerTool sharePlayerTool] jumpToTime:model.time];
    
    
    
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//  MARK: - 锁屏
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)becomeFirstResponder{
    return YES;
}


-(void)updateScreenInfo{
    musicModel * musicModel = self.songsArr[self.currentSongIndex];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[MPMediaItemPropertyArtist] = musicModel.singer;
    dict[MPMediaItemPropertyTitle] = musicModel.zhuanji;
    dict[MPMediaItemPropertyPlaybackDuration] = @([[CJPlayerTool sharePlayerTool] totalTime]);
    dict[MPNowPlayingInfoPropertyElapsedPlaybackTime]  = @([[CJPlayerTool sharePlayerTool] currentTime]);
    dict[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithBoundsSize:CGSizeMake(400, 400) requestHandler:^UIImage * _Nonnull(CGSize size) {
        NSString * path = [[NSBundle mainBundle] pathForResource:musicModel.image ofType:nil];
        
        return [UIImage imageWithContentsOfFile:path];
    }];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = dict;
}


@end
