//
//  CLAvAudioPlayerUtils.h
//  avFoundation_audio
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAvAudioPlayerUtils : NSObject

@property (assign, getter=isPlaying, nonatomic) BOOL playing;


+ (instancetype)avAudioPlayerShareInstance;

- (BOOL)addPlayerWithPathName:(NSString *)name;

- (void)paly;
- (void)stop;
- (void)pause;

- (void)adjustRate:(float)rate;
- (void)adjustPan:(float)pan index:(NSUInteger)idx;
- (void)adjustVolume:(float)volume index:(NSUInteger)idx;

@end
