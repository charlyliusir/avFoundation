//
//  AVMetadataItem+CLKeyString.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "AVMetadataItem+CLKeyString.h"

@implementation AVMetadataItem (CLKeyString)

- (NSString *)keyString
{
    if ([self.key isKindOfClass:[NSString class]]) {
        return (NSString *)self.key;
    }
    else if ([self.key isKindOfClass:[NSNumber class]]) {
        UInt32 keyValue = [(NSNumber *)self.key unsignedIntValue];
        
        size_t length = sizeof(keyValue);
        
        /// 整型有32位4个字节，每个字节有8位
        /// 右移 32 位, 为 0, 是低位第一个字节 xxxx xxxx xxxx xxxx xxxx xxxx 0000 0000
        /// 右移 16 位, 为 0, 是低位第一、二两个字节 xxxx xxxx xxxx xxxx 0000 0000 0000 0000
        /// 右移 8  位, 为 0, 是低位第一、二、三三个字节 xxxx xxxx 0000 0000 0000 0000 0000 0000
        /// 右移 0  位, 为 0, 是所有字节 0000 0000 0000 0000 0000 0000 0000 0000
        /// 由于读取资源为大端数据, 需要转化成小端数据, 因此以前的低位就变成了高位, 以前的高位就变成了低位
        
        /// 右移24位
        if (keyValue >> 24 == 0) length --;
        /// 右移16位
        if (keyValue >> 16 == 0) length --;
        /// 右移8位
        if (keyValue >> 8  == 0) length --;
        /// 右移0位
        if (keyValue >> 0  == 0) length --;
        /// 获取 keyValue 值的首地址
        long address = (unsigned long)&keyValue;
        /// 获取 keyValue 有效值首地址
        address += (sizeof(keyValue) - length);
        
        char cString[length];
        /// address 是一个指针, 可以作为一个数组, 将一个字符串的前 n 个字符复制到另一个字符串中
        strncpy(cString, (char *)address, length);
        cString[length] = '\0'; /// c 中字符串以'\0'结尾
        
        /// 将 '©' 字符串转换成 '@' 字符串, 跟 AVMetadataFormat.h 中的常量对应
        if (cString[0] == '\xA9') {
            cString[0] = '@';
        }
        
        return [NSString stringWithCString:(char *)cString encoding:NSUTF8StringEncoding];
        
    }
    else {
        return @"<<unknown>>";
    }
}

@end
