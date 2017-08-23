//
//  CLDefaultMetadataConverter.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLDefaultMetadataConverter.h"

@implementation CLDefaultMetadataConverter

- (id)displayValueForItem:(AVMetadataItem *)item
{
    return item.value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item copy];
    metadataItem.value = value;
    return metadataItem;
}

@end
