//
//  CLMetadataKeys.h
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMetadataKeys : NSObject

extern NSString *const CLMetadataKeyName;           /// 名称
extern NSString *const CLMetadataKeyArtist;         /// 艺人
extern NSString *const CLMetadataKeyArtistAlbum;    /// 主导艺人
extern NSString *const CLMetadataKeyArtwork;        /// 封面
extern NSString *const CLMetadataKeyAlbum;          /// 专辑
extern NSString *const CLMetadataKeyYear;           /// 年份
extern NSString *const CLMetadataKeyBPM;            /// 每一分钟的节拍数量[BESAT PER MINUTE]
extern NSString *const CLMetadataKeyGrouping;       /// 群组
extern NSString *const CLMetadataKeyTrackNumber;    /// 音轨总数量
extern NSString *const CLMetadataKeyTrackCount;     /// 在总音轨中的位置
extern NSString *const CLMetadataKeyComposer;       /// 作曲家
extern NSString *const CLMetadataKeyDiscNumber;     /// 专辑总数量
extern NSString *const CLMetadataKeyDiscCount;      /// 在专辑中的位置
extern NSString *const CLMetadataKeyComments;       /// 注释
extern NSString *const CLMetadataKeyGenre;          /// 风格

@end
