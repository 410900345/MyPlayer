//
//  ViewController.m
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LRCEngine.h"
#import "MyMusicPlayer.h"
#import "MusicContentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>

@interface ViewController ()<MyMusicPlayerDelegate>
{
    MyMusicPlayer * _player;
    //内容视图
    MusicContentView * _contentView;
    //标题标签
    UILabel * _titleLabel;
    //进度条
    UIProgressView * _progress;
    //播放按钮
    UIButton * _playBtn;
    //下一曲按钮
    UIButton * _nextBtn;
    //上一曲按钮
    UIButton * _lastBtn;
    //循环播放按钮
    UIButton * _circleBtn;
    //随机播放按钮
    UIButton * _randomBtn;
    //存放歌曲名
    NSArray * _dataArray;
    NSTimer * _timer;
    BOOL _isBack;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneToBack) name:@"goBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneToForward) name:@"goForward" object:nil];
    _isBack = NO;
    [self creatData];
    [self creatPlayer];
    [self creatView];
    [self updateUI];
    
}
-(void)phoneToBack{
    _isBack = YES;
}
-(void)phoneToForward{
    _isBack = NO;
}

-(void)creatData{
    _dataArray = @[@"匆匆那年",@"致青春",@"清风徐来",@"矜持",@"暗涌",@"天空",@"容易受伤的女人",@"清平调",@"但愿人长久",@"暧昧",@"执迷不悔",@"约定",@"我愿意",@"棋子",@"梦醒了",@"影子",@"人间",@"爱与痛的边缘",@"旋木",@"红豆",@"传奇",@"爱不可及"];
}
-(void)creatView{
    UIImageView * bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"BG.jpeg"];
    bg.userInteractionEnabled=YES;
    [self.view addSubview:bg];
    //创建歌曲标题Label
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, bg.frame.size.width, 40)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _dataArray[0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [bg addSubview:_titleLabel];
    _progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progress.progressTintColor=[UIColor redColor];
    _progress.trackTintColor = [UIColor whiteColor];
    _progress.frame=CGRectMake(20, self.view.frame.size.height-70, self.view.frame.size.width-40, 5);
    [bg addSubview:_progress];
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _playBtn.frame=CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height-45, 40, 30);
    [_playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_playBtn];
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame=CGRectMake(self.view.frame.size.width/2+40, self.view.frame.size.height-45, 40, 30);
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"nextMusic"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_nextBtn];
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame = CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height-45, 40, 30);
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"aboveMusic"] forState:UIControlStateNormal];
    [_lastBtn addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_lastBtn];
    _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _circleBtn.frame = CGRectMake(self.view.frame.size.width/2-140, self.view.frame.size.height-45, 40, 30);
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleClose"] forState:UIControlStateNormal];
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleOpen"] forState:UIControlStateSelected];
    [_circleBtn addTarget:self action:@selector(circle) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_circleBtn];
    _randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _randomBtn.frame=CGRectMake(self.view.frame.size.width/2+100, self.view.frame.size.height-45, 40, 30);
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"randomClose"] forState:UIControlStateNormal];
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"randomOpen"] forState:UIControlStateSelected];
    [_randomBtn addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_randomBtn];
    _contentView = [[MusicContentView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-150)];
    _contentView.titleDataAttay = _dataArray;
    _contentView.play=_player;
    [bg addSubview:_contentView];
    
}
-(void)creatPlayer{
    _player = [[MyMusicPlayer alloc]init];
    _player.songsArray=_dataArray;
    NSMutableArray * mulArr = [[NSMutableArray alloc]init];
    for (int i=0; i<_dataArray.count; i++) {
        LRCEngine * engine = [[LRCEngine alloc]initWithFile:_dataArray[i]];
        [mulArr addObject:engine];
    }
    _player.lrcsArray = mulArr;
    _player.delegate=self;
}
-(void)updateUI{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)update{
    
    uint64_t locked;
    __block int token = 0;
    
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&token,dispatch_get_main_queue(),^(int t){
    });
    notify_get_state(token, &locked);
    //如果屏幕变暗 直接不走更新方法
    if (locked) {
        return;
    }
    
    _titleLabel.text = _dataArray[[_player currentIndex]];
    //更新进度条
    if (_player.hadPlayTime!=0) {
        float progress = (float)_player.hadPlayTime/_player.currentSongTime;
        _progress.progress = progress;
    }
    //更新歌词
    LRCEngine * engine = _player.lrcsArray[_player.currentIndex];
    [engine getCurrentLRCInLRCArray:^(NSArray *lrcArray, int currentIndex) {
        [_contentView setCurretLRCArray:lrcArray index:currentIndex];
    } atTime:_player.hadPlayTime];
    //更新锁屏界面
    //如果在后台 在进行更新 否则不更新
    if (!_isBack) {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_dataArray[_player.currentIndex] forKey:MPMediaItemPropertyTitle];
    [dict setObject:@"王菲" forKey:MPMediaItemPropertyArtist];
    [dict setObject:@"致敬天后" forKey:MPMediaItemPropertyAlbumTitle];
    
    UIImage *newImage = _contentView.lrcImage;
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage]
             forKey:MPMediaItemPropertyArtwork];
    [dict setObject:[NSNumber numberWithDouble:_player.currentSongTime] forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithDouble:_player.hadPlayTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

}
-(void)playMusic{
    if (_player.isPlaying) {
        _playBtn.selected=NO;
        [_player stop];
    }else{
        _playBtn.selected=YES;
        [_player play];
    }
}
-(void)next{
    [_player nextMusic];
}
-(void)last{
    [_player lastMusic];
}
-(void)circle{
    if (_player.isRunLoop) {
        _player.isRunLoop=NO;
        _circleBtn.selected=NO;
    }else{
        _player.isRunLoop=YES;
        _circleBtn.selected=YES;
    }
}
-(void)random{
    if (_player.isRandom) {
        _player.isRandom=NO;
        _randomBtn.selected=NO;
    }else{
        _player.isRandom=YES;
        _randomBtn.selected=YES;
    }
}
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play{
    if (play) {
        _playBtn.selected=YES;
    }else{
        _playBtn.selected=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
