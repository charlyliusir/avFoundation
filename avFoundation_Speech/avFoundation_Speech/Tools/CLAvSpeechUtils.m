//
//  CLAvSpeechUtils.m
//  avFoundation_Speech
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLAvSpeechUtils.h"

@interface CLAvSpeechUtils () <AVSpeechSynthesizerDelegate>
@property (strong, readwrite, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@property (strong, readwrite, nonatomic) CLAvSpeechConfigure *avSpeechConfigure;

@end

@implementation CLAvSpeechUtils

- (instancetype)init
{
    if (self = [super init]) {
        [self initSpeechSynthesizerConfigure];
    }
    return self;
}

+ (instancetype)avSpeechUtilSharedInstance
{
    static CLAvSpeechUtils *avSpeechUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avSpeechUtils = [[CLAvSpeechUtils alloc] init];
    });
    return avSpeechUtils;
}

- (void)initSpeechSynthesizerConfigure
{
    _speechSynthsizer = [[AVSpeechSynthesizer alloc] init];
    _speechSynthsizer.delegate = self;
    
    CLAvSpeechConfigure *avSpeechConfigure = [[CLAvSpeechConfigure alloc] init];
    avSpeechConfigure.rate               = 0.5f;
    avSpeechConfigure.pitchMultiplier    = 1.3f;
    avSpeechConfigure.language           = @"zh-CN";
    avSpeechConfigure.postUtteranceDelay = 1.0f;
    avSpeechConfigure.volume             = 0.8;
    
    _avSpeechConfigure = avSpeechConfigure;
    
}

- (void)playSpeechString:(NSString *)string
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    utterance.rate   = _avSpeechConfigure.rate;
    utterance.volume = _avSpeechConfigure.volume;
    utterance.pitchMultiplier    = _avSpeechConfigure.pitchMultiplier;
    utterance.postUtteranceDelay = _avSpeechConfigure.postUtteranceDelay;
    utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:_avSpeechConfigure.language];
    [_speechSynthsizer speakUtterance:utterance];
}
- (void)stop
{
    [_speechSynthsizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
}
- (void)pause
{
    [_speechSynthsizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}
- (void)continue
{
    [_speechSynthsizer continueSpeaking];
}



@end
