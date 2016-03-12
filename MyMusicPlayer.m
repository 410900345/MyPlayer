//
//  MusicPlayer.m
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyMusicPlayer.h"
#import "AppDelegate.h"
@implementation MyMusicPlayer
{
    AVAudioPlayer * _player;
    NSTimer * _timer;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        AppDelegate * delegate =[UIApplication sharedApplication].delegate;
        delegate.play=self;
    }
    return self;
}
-(void)update{
    if (_player) {
        _hadPlayTime   = _player.currentTime;
    }
}
-(void)playOrStop{
    if (self.isPlaying) {
        [self stop];
    }else{
        [self play];
    }
}
-(void)play{
    if (_player!=nil) {
        [_player play];
        _isPlaying=YES;
        return;
    }else{
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:0] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        //添加时间的监听
        _player.delegate=self;
        [_player play];
        _isPlaying=YES;
        _currentIndex=0;
        _currentSongTime=_player.duration;
    }
}
-(void)stop{
    if (_player.isPlaying) {
        [_player stop];
        _isPlaying=NO;
    }
}
-(void)end{
    [_player stop];
    _isPlaying=NO;
    _player=nil;
}
-(void)playAtIndex:(int)index isPlay:(BOOL)play{
    [_player stop];
    _isPlaying=NO;
    _player = nil;
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:index] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.delegate=self;
    if (play) {
        [_player play];
        _isPlaying=YES;
    }
    _currentIndex=index;
    _currentSongTime = _player.duration;
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _player = nil;
    _isPlaying=NO;
    //是否循环播放
    if (_isRandom) {
        unsigned long max = self.songsArray.count;
        int songIndex = arc4random()%max;
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:songIndex] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate=self;
        [_player play];
        _isPlaying=YES;
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        _currentIndex=songIndex;
        _currentSongTime=_player.duration;
        return;
    }
    if (_currentIndex<self.songsArray.count-1) {
        //是否是最后一首
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:++_currentIndex] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _currentSongTime=_player.duration;
        _player.delegate=self;
        [_player play];
        _isPlaying=YES;
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
    }else if (_currentIndex==self.songsArray.count-1){
        //是否循环
        if (_isRunLoop) {
            _currentIndex=0;
            NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
            NSURL * url = [NSURL fileURLWithPath:path];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _player.delegate=self;
            _currentSongTime=_player.duration;
            [_player play];
            _isPlaying=YES;
            [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        }else{
            [self.delegate musicPlayEndAndWillContinuePlaying:NO];
        }
    }
}
-(void)nextMusic{
    BOOL play = _player.isPlaying;
    
    [_player stop];
    _isPlaying=NO;
    _player=nil;
    //是否是最后一曲
    if (_currentIndex<self.songsArray.count-1) {
        _currentIndex++;
    }else{
        _currentIndex=0;
    }
    //是否随机播放
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random()%max;
    }
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _currentSongTime=_player.duration;
    _player.delegate=self;
    if (play) {
       [_player play];
        _isPlaying=YES;
    }
    
}
-(void)lastMusic{
    BOOL play = _player.isPlaying;
    [_player stop];
    _isPlaying=NO;
    _player=nil;
    if (_currentIndex>0) {
        _currentIndex--;
    }else{
        _currentIndex=(int)_songsArray.count-1;
    }
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random()%max;
    }
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _currentSongTime=_player.duration;
    _player.delegate=self;
    if (play) {
        [_player play];
        _isPlaying=YES;
    }
}
    
   
@end
