//
//  CLAvSpeechConfigure.h
//  avFoundation_Speech
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAvSpeechConfigure : NSObject

/// 语言
@property (copy, nonatomic) NSString *language;
/// 语速
@property (assign, nonatomic) float rate;
/// 语调
@property (assign, nonatomic) float pitchMultiplier;
/// 音量
@property (assign, nonatomic) float volume;
/// 下一个条播放延时时间
@property (assign, nonatomic) float postUtteranceDelay;

@end
