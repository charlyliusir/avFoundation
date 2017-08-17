//
//  CLMemoItem.h
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/17.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+CLDocument.h"

@interface CLMemoItem : NSObject <NSCoding>

/// 文件名称
@property (copy, readonly, nonatomic) NSString *title;
/// 日期
@property (copy, readonly, nonatomic) NSString *date;
/// 时间
@property (copy, readonly, nonatomic) NSString *time;
/// 播放地址
@property (strong, readonly, nonatomic) NSURL *url;

+ (instancetype)memoWithTitle:(NSString *)title name:(NSString *)name;
- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name;

- (void)deleteMemo;

@end
