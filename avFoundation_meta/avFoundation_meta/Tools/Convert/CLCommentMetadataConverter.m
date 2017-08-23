//
//  CLCommentMetadataConverter.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLCommentMetadataConverter.h"

/// 注释的样式如果是字符串类型则取其 stringValue 值
/// 注释的样式如果是字典类型则判断其 identifier 字段对应值是否为空字符串, 如果是则取 text 字段对应的值

@implementation CLCommentMetadataConverter

- (id)displayValueForItem:(AVMetadataItem *)item
{
    NSString *value = nil;
    if ([item.value isKindOfClass:[NSString class]]) {
        value = item.stringValue;
    }
    else if ([item.value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)item.value;
        if ([dict[@"identifier"] isEqualToString:@""]) {
            value = dict[@"text"];
        }
    }
    return value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item copy];
    metadataItem.value = value;
    return metadataItem;
}

@end
