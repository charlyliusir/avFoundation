//
//  NSString+CLDocument.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "NSString+CLDocument.h"

@implementation NSString (CLDocument)

/// document path
+ (NSString *)doucmentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

/// library path
+ (NSString *)libraryPath
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

/// video path
+ (NSString *)videoDocument:(NSString *)floderName
{
    NSString *videoPath = [[NSString doucmentPath] stringByAppendingPathComponent:floderName];
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /// 文件夹不存在, 直接创建文件
    if (![fileManager fileExistsAtPath:videoPath]) {
        BOOL success = [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(success, @"Create Video Floder Failed With Error : %@", error.localizedDescription);
    }
    
    return videoPath;
}

@end
