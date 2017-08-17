//
//  NSString+CLDocument.h
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CLDocument)

/// document path
+ (NSString *)doucmentPath;

/// library path
+ (NSString *)libraryPath;

/// video path
+ (NSString *)videoDocument:(NSString *)floderName;

@end
