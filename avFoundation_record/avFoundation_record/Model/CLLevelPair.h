//
//  CLLevelPair.h
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/17.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLevelPair : NSObject

@property (assign, readonly, nonatomic) float level;
@property (assign, readonly, nonatomic) float peekLevel;

+ (instancetype)levelsWithLevel:(float)level peekLevel:(float)peekLevel;
- (instancetype)initWithLevel:(float)level peekLevel:(float)peekLevel;

@end
