//
//  CLMetaData.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLMetaData.h"
#import "CLMetadataKeys.h"
#import "CLMetadataConverterFactory.h"

@interface CLMetaData ()
/// 将 AVMetadataCommonKey 转换成 CLMetadataKey
@property (strong, nonatomic) NSDictionary *keyMapping;
///
@property (strong, nonatomic) NSMutableDictionary *metadata;
/// 转换工厂
@property (strong, nonatomic) CLMetadataConverterFactory *converterFactory;

@end

@implementation CLMetaData

- (instancetype)init
{
    if (self = [super init]) {
        [self buildMapping];
        _metadata = [NSMutableDictionary dictionary];
        _converterFactory = [[CLMetadataConverterFactory alloc] init];
    }
    return self;
}

- (void)buildMapping
{
    _keyMapping = @{
                    /// Name Mapping
                    AVMetadataCommonKeyTitle: CLMetadataKeyName,
                    
                    /// Artist Mapping
                    AVMetadataCommonKeyArtist: CLMetadataKeyArtist,
                    AVMetadataiTunesMetadataKeyArtist: CLMetadataKeyArtist,
                    AVMetadataQuickTimeMetadataKeyArtist: CLMetadataKeyArtist,
                    
                    /// Artist Album Mapping
                    AVMetadataID3MetadataKeyBand: CLMetadataKeyArtistAlbum,
                    AVMetadataiTunesMetadataKeyAlbumArtist: CLMetadataKeyArtistAlbum,
                    @"TP2": CLMetadataKeyArtistAlbum,
                    
                    /// Artwork Mapping
                    AVMetadataCommonKeyArtwork: CLMetadataKeyArtwork,
                    AVMetadataQuickTimeMetadataKeyArtwork: CLMetadataKeyArtwork,
                    
                    /// Album Mapping
                    AVMetadataCommonKeyAlbumName: CLMetadataKeyAlbum,
                    
                    /// Yera Mapping
                    AVMetadataCommonKeyCreationDate: CLMetadataKeyYear,
                    AVMetadataID3MetadataKeyYear: CLMetadataKeyYear,
                    AVMetadataID3MetadataKeyRecordingTime: CLMetadataKeyYear,
                    AVMetadataQuickTimeMetadataKeyYear: CLMetadataKeyYear,
                    @"TYE": CLMetadataKeyYear,
                    
                    /// BPM Mapping
                    AVMetadataiTunesMetadataKeyBeatsPerMin: CLMetadataKeyBPM,
                    AVMetadataID3MetadataKeyBeatsPerMinute: CLMetadataKeyBPM,
                    @"TBP": CLMetadataKeyBPM,
                    
                    /// Grouping Mapping
                    AVMetadataCommonKeySubject: CLMetadataKeyGrouping,
                    AVMetadataiTunesMetadataKeyGrouping: CLMetadataKeyGrouping,
                    @"@grp": CLMetadataKeyGrouping,
                    
                    /// Track Mapping
                    AVMetadataID3MetadataKeyTrackNumber: CLMetadataKeyTrackNumber,
                    AVMetadataiTunesMetadataKeyTrackNumber: CLMetadataKeyTrackNumber,
                    @"TRK": CLMetadataKeyTrackNumber,
                    
                    /// Composer Mapping
                    AVMetadataCommonKeyCreator: CLMetadataKeyComposer,
                    AVMetadataiTunesMetadataKeyComposer: CLMetadataKeyComposer,
                    AVMetadataID3MetadataKeyComposer: CLMetadataKeyComposer,
                    
                    /// Disc Mapping
                    AVMetadataiTunesMetadataKeyDiscNumber: CLMetadataKeyDiscNumber,
                    AVMetadataID3MetadataKeyPartOfASet: CLMetadataKeyDiscNumber,
                    @"TPA": CLMetadataKeyDiscNumber,
                    
                    /// Comments Mapping
                    AVMetadataCommonKeyDescription: CLMetadataKeyComments,
                    AVMetadataiTunesMetadataKeyUserComment: CLMetadataKeyComments,
                    AVMetadataID3MetadataKeyComments: CLMetadataKeyComments,
                    @"ldes": CLMetadataKeyComments,
                    @"COM": CLMetadataKeyComments,
                    
                    /// Genre Mapping
                    AVMetadataQuickTimeMetadataKeyGenre: CLMetadataKeyGenre,
                    AVMetadataiTunesMetadataKeyUserGenre: CLMetadataKeyGenre,
                    AVMetadataCommonKeyType: CLMetadataKeyGenre
                    };
}

- (void)addMetadataItem:(AVMetadataItem *)item forKey:(NSString *)key
{
    NSString *normalKey = _keyMapping[key];
    if (normalKey) {
        id <CLMetadataConverter> converter = [_converterFactory convertForKey:key];
        
        id value = [converter displayValueForItem:item];
        /// track / disc 的内容是字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)value;
            for (NSString *currentKey in dict) {
                if ([dict[currentKey] isKindOfClass:[NSNull class]]) {
                    [self setValue:dict[currentKey] forKey:key];
                }
            }
        } else {
            [self setValue:value forKey:key];
        }
        
        _metadata[key] = item;
    }
}

@end
