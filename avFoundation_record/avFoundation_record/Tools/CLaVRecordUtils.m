//
//  CLaVRecordUtils.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLaVRecordUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "CLMemoItem.h"
#import "CLLevelPair.h"
#import "CLMeterTable.h"
#import "NSDate+CLFormatter.h"
/// 录制需要提供一个文件保存地址, 因此最好的解决方案就是放到临时文件中

#define kVideoFloderName @"video"
#define kVideoFileName   @"record_video_"
#define kVideoDateFormmate @"_yyyyMMddhhmmss"
#define kVideoFileSuffix @".m4a"
@interface CLaVRecordUtils () <AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) CLMeterTable *meterTable;

@property (strong, nonatomic) CLRecordingStopCompletionHandler completionHandler;

@end

@implementation CLaVRecordUtils

- (instancetype)init
{
    if (self = [super init]) {
        
        NSError *error;
        /// 创建一个临时文件地址
        NSString *temp = NSTemporaryDirectory();
        NSString *memoPath = [temp stringByAppendingPathComponent:@"memo.caf"];\
        NSURL *url = [NSURL fileURLWithPath:memoPath];
        
        /// 所有配置都在 AVAudioSettings 里面
        NSDictionary *settings = @{
                                   /// 文件类型
                                   AVFormatIDKey: @(kAudioFormatAppleIMA4),
                                   /// 采样率
                                   AVSampleRateKey: @8000.0f,
                                   /// 位深
                                   AVEncoderBitDepthHintKey: @16,
                                   /// 质量
                                   AVVideoQualityKey: @(AVAudioQualityMedium),
                                   /// 通道
                                   AVNumberOfChannelsKey : @1,
                                   };
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        
        if (_recorder) {
            _recorder.delegate = self;
            [_recorder setMeteringEnabled:YES];
            [_recorder prepareToRecord];
        } else {
            NSLog(@"Create AudioRecorder Error : %@", error.localizedDescription);
        }
        
        _meterTable = [[CLMeterTable alloc] init];
    }
    return self;
}

- (BOOL)isRecording
{
    return _recorder.isRecording;
}

- (NSString *)formatCurrentTime
{
    NSUInteger times = (NSUInteger)_recorder.currentTime;
    NSInteger hours  = (times / 3600);
    NSInteger minutes= (times / 60) % 60;
    NSInteger seconds= (times % 60);
    NSString *format = @"%02i:%02i:%02i"; /// 输出格式, 两位整数
    return [NSString stringWithFormat:format, hours, minutes, seconds];
}

- (CLLevelPair *)levels
{
    [_recorder updateMeters];
    float averagePower = [_recorder averagePowerForChannel:0];
    float peakPower    = [_recorder peakPowerForChannel:0];
    float level        = [_meterTable valueForPower:averagePower];
    float peekLevel    = [_meterTable valueForPower:peakPower];
    
    return [CLLevelPair levelsWithLevel:level peekLevel:peekLevel];
}

- (void)record
{
    NSError *error;
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error]) {
        NSLog(@"Change Category Record Error : %@", error.localizedDescription);
    }
    [_recorder record];
}

- (void)pause
{
    [_recorder pause];
}

- (void)stopWithCompletionHandler:(CLRecordingStopCompletionHandler)handler
{
    [_recorder stop];
    _completionHandler = handler;
}

- (void)saveRecordingWithName:(NSString *)name
             completionHandle:(CLRecordingSaveCompletionHandler)handler
{
    /// 目标文件地址 destURL
    NSString *destName = [self videoFileName:name];
    NSString *destPath = [self videoFilePath:destName];
    NSURL *destURL = [NSURL fileURLWithPath:destPath];
    
    /// 源文件地址 srcURL
    NSURL *srcURL  = _recorder.url;
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager copyItemAtURL:srcURL toURL:destURL error:&error]) {
        NSLog(@"Move Item Error : %@", error.localizedDescription);
        handler(NO, error);
    } else {
        handler(YES, [CLMemoItem memoWithTitle:name name:destName]);
        [_recorder prepareToRecord]; /// 再次准备
    }
}

/// 音频文件保存到本地的名字
/// 格式为 kVideoFileName + 时间 + 后缀
/// 时间格式 kVideoDateFormmate
/// 后缀为 kVideoFileSuffix
- (NSString *)videoFileName:(NSString *)name
{
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [name stringByAppendingFormat:@"%.0f%@", timeInterval, kVideoFileSuffix];
    
    return fileName;
}

/// 音频保存到本地的地址
- (NSString *)videoFilePath:(NSString *)fileName
{
    return [[NSString videoDocument:kVideoFloderName] stringByAppendingPathComponent:fileName];
}


#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_completionHandler) {
        _completionHandler(flag);
    }
}
/// 来电中断, 停止录制, 并更新 UI 界面
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    if (_delegate && [_delegate respondsToSelector:@selector(interruptionBegin)]) {
        [_delegate interruptionBegin];
    }
}


@end
