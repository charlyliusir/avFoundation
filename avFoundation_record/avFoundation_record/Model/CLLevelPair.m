//
//  CLLevelPair.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/17.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLLevelPair.h"

@implementation CLLevelPair

+ (instancetype)levelsWithLevel:(float)level peekLevel:(float)peekLevel
{
    return [[self alloc] initWithLevel:level peekLevel:peekLevel];
}
- (instancetype)initWithLevel:(float)level peekLevel:(float)peekLevel
{
    if (self = [super init]) {
        _level = level;
        _peekLevel = peekLevel;
    }
    return self;
}

@end
