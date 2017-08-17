//
//  CLaVAudioPlayerUtils.h
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/// 添加播放功能
@interface CLaVAudioPlayerUtils : NSObject

@property (assign, readonly, getter=isPlaying, nonatomic) BOOL playing;

- (void)playVoiceWithPath:(NSString *)path;
- (void)playVoiceWithUrl:(NSURL *)url;
- (void)stop;

@end
