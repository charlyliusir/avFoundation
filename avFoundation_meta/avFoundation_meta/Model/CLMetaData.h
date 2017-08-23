//
//  CLMetaData.h
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CLMetaData : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *artist;   /// 艺术
@property (copy, nonatomic) NSString *albumArtist;  /// 主导艺人
@property (copy, nonatomic) NSString *album;
@property (copy, nonatomic) NSString *grouping; /// 分组
@property (copy, nonatomic) NSString *composer; /// 作曲家
@property (copy, nonatomic) NSString *comments; /// 注释
@property (strong, nonatomic) UIImage *artwork; /// 封面图

/// 风格
@property (strong, nonatomic) NSNumber *bpm;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) NSNumber *trackNumber;
@property (strong, nonatomic) NSNumber *trackCount;
@property (strong, nonatomic) NSNumber *discNumber;
@property (strong, nonatomic) NSNumber *discCount;

- (void)addMetadataItem:(AVMetadataItem *)item forKey:(NSString *)key;

@end
