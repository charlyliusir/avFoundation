//
//  CLaVAudioPlayerUtils.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLaVAudioPlayerUtils.h"

@interface CLaVAudioPlayerUtils () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (assign, nonatomic) float volume;

@end

@implementation CLaVAudioPlayerUtils

- (instancetype)init
{
    if (self = [super init]) {
        /// 添加切换线路通知, 切换的时候停止播放
        [self initPlayerConfigure];
    }
    return self;
}

- (void)initPlayerConfigure
{
    ///音量
    _volume = 0.5f;
}

- (void)playVoiceWithPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    [self playVoiceWithUrl:url];
}

- (void)playVoiceWithUrl:(NSURL *)url
{
    if (_playing) {
        [self stop];
    }
    NSError *error;
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Change Category Record Error : %@", error.localizedDescription);
    }
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!_audioPlayer) {
        NSLog(@"Create Audio Player Error : %@", error.localizedDescription);
        return;
    }
    _audioPlayer.volume = _volume;
    _audioPlayer.numberOfLoops = 0;
    _audioPlayer.delegate = self;
    
    if (![_audioPlayer prepareToPlay]) {
        NSLog(@"Audio Player PrePareToPlay Failed!");
    }
    
    if (![_audioPlayer play]) {
        NSLog(@"Audio Failed Play!");
        return;
    }
    
    _playing = YES;
}

- (void)stop
{
    if (_playing) {
        [_audioPlayer stop];
        _playing = NO;
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _playing = NO;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    _playing = NO;
    NSLog(@"Audio Player Decode Error : %@", error.localizedDescription);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flag
{
    
}

@end
