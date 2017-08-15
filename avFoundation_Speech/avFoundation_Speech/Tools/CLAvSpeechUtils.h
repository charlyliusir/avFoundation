//
//  CLAvSpeechUtils.h
//  avFoundation_Speech
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CLAvSpeechConfigure.h"

@interface CLAvSpeechUtils : NSObject
/// 解析器
@property (strong, readonly, nonatomic) AVSpeechSynthesizer *speechSynthsizer;

+ (instancetype)avSpeechUtilSharedInstance;

- (void)playSpeechString:(NSString *)string;
- (void)stop;
- (void)pause;
- (void)continue;

@end
