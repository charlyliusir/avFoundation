//
//  CLMetadataConverterFactory.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLMetadataConverterFactory.h"
#import "CLDefaultMetadataConverter.h"
#import "CLArtworkMetadataConverter.h"
#import "CLCommentMetadataConverter.h"
#import "CLTrackMetadataConverter.h"
#import "CLDiscMetadataConverter.h"
#import "CLMetadataKeys.h"

@implementation CLMetadataConverterFactory

- (id <CLMetadataConverter>)convertForKey:(NSString *)key
{
    if ([key isEqualToString:CLMetadataKeyArtwork]) {
        return [[CLArtworkMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:CLMetadataKeyComments]) {
        return [[CLCommentMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:CLMetadataKeyTrackNumber]) {
        return [[CLTrackMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:CLMetadataKeyDiscNumber]) {
        return [[CLDiscMetadataConverter alloc] init];
    }
    else {
        return [[CLDefaultMetadataConverter alloc] init];
    }
}

@end
