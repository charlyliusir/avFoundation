//
//  CLMetaItem.h
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLMetaData.h"

typedef void(^CompletionHandler)(BOOL completion);

@interface CLMetaItem : NSObject

@property (copy, readonly, nonatomic) NSString *filename;
@property (copy, readonly, nonatomic) NSString *filetype;
@property (strong, readonly, nonatomic) CLMetaData *metadata;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithUrl:(NSURL *)url;

- (void)prepareWithCompletionHandler:(CompletionHandler)handler;

@end
