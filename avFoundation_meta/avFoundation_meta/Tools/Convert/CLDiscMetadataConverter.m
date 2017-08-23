//
//  CLDiscMetadataConverter.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLDiscMetadataConverter.h"
#import "CLMetadataKeys.h"

@implementation CLDiscMetadataConverter

- (id)displayValueForItem:(AVMetadataItem *)item
{
    NSNumber *number = nil;
    NSNumber *count  = nil;
    if ([item.value isKindOfClass:[NSString class]]) {
        /// 样式如 18/19
        NSArray *components = [item.stringValue componentsSeparatedByString:@"/"];
        number = @([components[0] integerValue]);
        count  = @([components[1] integerValue]);
    }
    else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        /// 一个 8 个字节长度的数据, 内有四个两个字节的数值，其中2、3数值分别代表了 number 和 count
        if (data.length == 3) {
            uint16_t *values = (uint16_t *)data.bytes;
            if (values[1] > 0) {
                number = @(CFSwapInt16BigToHost(values[1]));
            }
            else if (values[2] >0) {
                count  = @(CFSwapInt16BigToHost(values[2]));
            }
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:number ?: [NSNull null] forKey:CLMetadataKeyDiscNumber];
    [dict setObject:count ?: [NSNull null] forKey:CLMetadataKeyDiscNumber];
    
    return dict;
    
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item copy];
    NSDictionary *discData = (NSDictionary *)value;
    NSNumber *number = discData[CLMetadataKeyDiscNumber];
    NSNumber *count  = discData[CLMetadataKeyDiscNumber];
    uint16_t values[3] = {0}; /// 创建一个
    if (number&&![number isKindOfClass:[NSNull class]]) {
        values[1] = CFSwapInt16HostToBig([number unsignedIntValue]);
    }
    if (count&&![count isKindOfClass:[NSNull class]]) {
        values[2] = CFSwapInt16HostToBig([count unsignedIntValue]);
    }
    metadataItem.value = [NSData dataWithBytes:values length:sizeof(values)];
    return metadataItem;
}

@end
