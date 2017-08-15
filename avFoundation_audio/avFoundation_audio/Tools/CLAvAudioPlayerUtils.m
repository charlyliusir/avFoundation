//
//  CLAvAudioPlayerUtils.m
//  avFoundation_audio
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLAvAudioPlayerUtils.h"
#import <AVFoundation/AVFoundation.h>

@interface CLAvAudioPlayerUtils () <AVAudioPlayerDelegate>
@property (strong, nonatomic) NSMutableArray <AVAudioPlayer *>*players;

@end

@implementation CLAvAudioPlayerUtils

- (NSMutableArray<AVAudioPlayer *> *)players
{
    if (!_players) {
        _players = [NSMutableArray array];
    }
    return _players;
}

- (instancetype)init
{
    if (self = [super init]) {
        /// 添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRouteChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:[AVAudioSession sharedInstance]];
    }
    return self;
}

+ (instancetype)avAudioPlayerShareInstance
{
    static CLAvAudioPlayerUtils *audioPlayerUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerUtils = [[CLAvAudioPlayerUtils alloc] init];
    });
    return audioPlayerUtils;
}

- (BOOL)addPlayerWithPathName:(NSString *)name
{
    NSError *error;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"caf"];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    if (error) {
        NSLog(@"Create Player Error : %@", error.localizedDescription);
        return NO;
    }
    [player prepareToPlay];
    [player setNumberOfLoops:-1]; /// 无限循环
    [player setVolume:0.5f];
    [player setPan:0.0f];
    [player setRate:1.0];
    [player setDelegate:self];
    [self.players addObject:player];
    return YES;
}

- (void)paly
{
    if (!_playing) {
        NSTimeInterval postDelay = [_players[0] deviceCurrentTime] + 0.01;
        for (AVAudioPlayer *player in _players) {
            [player playAtTime:postDelay];
        }
        _playing = YES;
    }
}
- (void)stop
{
    if (_playing) {
        for (AVAudioPlayer *player in _players) {
            [player stop];
            [player setCurrentTime:0.0f];
        }
        _playing = NO;
    }
}
- (void)pause
{
    if (_playing) {
        for (AVAudioPlayer *player in _players) {
            [player pause];
        }
        _playing = NO;
    }
}

- (void)adjustRate:(float)rate
{
    for (AVAudioPlayer *player in _players) {
        player.rate = rate;
    }
}

- (void)adjustPan:(float)pan index:(NSUInteger)idx
{
    AVAudioPlayer *player = _players[idx];
    player.pan = pan;
}

- (void)adjustVolume:(float)volume index:(NSUInteger)idx
{
    AVAudioPlayer *player = _players[idx];
    player.volume = volume;
}

#pragma mark - notify method
- (void)handleRouteChange:(NSNotification *)notification
{
    NSLog(@"Session Route Change : %@", notification);
    NSDictionary *userinfo = notification.userInfo;
    AVAudioSessionRouteChangeReason routeReason = [userinfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (routeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *description = userinfo[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = description.outputs[0];
        if ([portDescription.portType isEqualToString:AVAudioSessionPortBluetoothLE]) {
            /// 停止播放，更新状态
            [self stop];
        }
    }
    
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying:successfully:%d",flag);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur:error:%@",error.localizedDescription);
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerBeginInterruption:");
    /// 开始中断, 更新界面, 让界面标记更新成暂停
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"audioPlayerEndInterruption:withOptions:%ld",flags);
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    NSLog(@"audioPlayerEndInterruption:withFlags:%ld",flags);
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerEndInterruption:");
}

@end
