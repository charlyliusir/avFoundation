//
//  CLMetadataConverter.h
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol CLMetadataConverter<NSObject>
/// 根据 AVMetadataItem 解析要展示的数据
- (id)displayValueForItem:(AVMetadataItem *)item;
/// 设置对应 AVMetadataItem 对应的值
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item;

@end
