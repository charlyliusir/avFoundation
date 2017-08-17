//
//  CLaVRecordUtils.h
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLMemoItem;
@class CLLevelPair;

@protocol CLaVRecordUtilsDelegate <NSObject>

- (void)interruptionBegin;

@end

typedef void(^CLRecordingStopCompletionHandler)(BOOL);
typedef void(^CLRecordingSaveCompletionHandler)(BOOL, id);

@interface CLaVRecordUtils : NSObject

@property (weak, nonatomic) id <CLaVRecordUtilsDelegate> delegate;

@property (assign, readonly, getter=isRecording, nonatomic) BOOL recording;
@property (copy, readonly, nonatomic) NSString *formatCurrentTime;

- (void)record;
- (void)pause;
- (void)stopWithCompletionHandler:(CLRecordingStopCompletionHandler)handler;
- (void)saveRecordingWithName:(NSString *)name
             completionHandle:(CLRecordingSaveCompletionHandler)handler;

- (CLLevelPair *)levels;

@end
