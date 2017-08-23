//
//  CLMetaItem.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "AVMetadataItem+CLKeyString.h"
#import "CLMetaItem.h"

#define COMMON_META_DATA   @"commonMetadata"
#define AVAILABLE_META_KEY @"availableMetadataFormats"

@interface CLMetaItem ()

@property (copy, readwrite, nonatomic) NSString *filename;
@property (copy, readwrite, nonatomic) NSString *filetype;
@property (strong, readwrite, nonatomic) CLMetaData *metadata;
/// 文件链接
@property (strong, nonatomic) NSURL *url;
/// 资源文件
@property (strong, nonatomic) AVAsset *asset;
/// 是否准备成功
@property (assign, nonatomic) BOOL prepare;
/// 支持格式
@property (copy, nonatomic) NSArray *acceptedFormats;

@end

@implementation CLMetaItem

- (instancetype)initWithPath:(NSString *)path
{
    return [self initWithUrl:[NSURL fileURLWithPath:path]];
}

- (instancetype)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _url = url;
        _asset = [AVAsset assetWithURL:_url];
        _filename = [url lastPathComponent];
        _filetype = [self fileTypeForURL:_url];
        _acceptedFormats = @[
                             AVMetadataFormatID3Metadata,
                             AVMetadataFormatQuickTimeMetadata,
                             AVMetadataFormatiTunesMetadata
                             ];
    }
    return self;
}

- (NSString *)fileTypeForURL:(NSURL *)url
{
    /// 扩展名称
    NSString *ext = [[url lastPathComponent] pathExtension];
    NSString *type = nil;
    if ([ext isEqualToString:@"m4a"]) {
        type = AVFileTypeAppleM4A;
    } else if ([ext isEqualToString:@"m4v"]) {
        type = AVFileTypeAppleM4V;
    } else if ([ext isEqualToString:@"mov"]) {
        type = AVFileTypeQuickTimeMovie;
    } else if ([ext isEqualToString:@"mp4"]) {
        type = AVFileTypeMPEG4;
    } else {
        type = AVFileTypeMPEGLayer3; /// mp3
    }
    
    return type;
}

- (void)prepareWithCompletionHandler:(CompletionHandler)handler
{
    /// 如果准备成功, 不再准备
    if (_prepare) {
        handler(_prepare);
        return;
    }
    
    _metadata = [[CLMetaData alloc] init];
    
    NSArray *keys = @[COMMON_META_DATA, AVAILABLE_META_KEY];
    [_asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
        AVKeyValueStatus commonStatus = [_asset statusOfValueForKey:COMMON_META_DATA error:nil];
        
        AVKeyValueStatus formatStatus = [_asset statusOfValueForKey:AVAILABLE_META_KEY error:nil];
        
        _prepare = (commonStatus == AVKeyValueStatusLoaded) && (formatStatus == AVKeyValueStatusLoaded);
        
        if (_prepare) {
            for (AVMetadataItem *item in _asset.commonMetadata) {
                [_metadata addMetadataItem:item forKey:item.commonKey];
            }
            
            for (NSString *format in _asset.availableMetadataFormats) {
                if ([_acceptedFormats containsObject:format]) {
                    NSArray *items = [_asset metadataForFormat:format];
                    for (AVMetadataItem *item in items) {
                        [_metadata addMetadataItem:item forKey:item.keyString];
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(_prepare);
        });
        
    }];
}

@end
