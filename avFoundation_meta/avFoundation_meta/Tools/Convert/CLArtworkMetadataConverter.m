//
//  CLArtworkMetadataConverter.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

/// 封面图, 要么是数据类型, 要么是字典

#import "CLArtworkMetadataConverter.h"
#import <UIKit/UIKit.h>

@implementation CLArtworkMetadataConverter

- (id)displayValueForItem:(AVMetadataItem *)item
{
    UIImage *image = nil;
    if ([item.value isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:(NSData *)item.value];
    }
    else if ([item.value isKindOfClass:[NSDictionary class]]) {
        NSData *data = [(NSDictionary *)item.value valueForKey:@"data"];
        image = [UIImage imageWithData:data];
    }
    return image;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item copy];
    UIImage *image = (UIImage *)value;
    if (UIImagePNGRepresentation(image)) {
        metadataItem.value = UIImagePNGRepresentation(image);
    }
    else if (UIImageJPEGRepresentation(image, 1.0)) {
        metadataItem.value = UIImageJPEGRepresentation(image, 1.0);
    }
    return metadataItem;
}

@end
