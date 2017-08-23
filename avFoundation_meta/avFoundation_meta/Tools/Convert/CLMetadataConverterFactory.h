//
//  CLMetadataConverterFactory.h
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLMetadataConverter.h"

@interface CLMetadataConverterFactory : NSObject

- (id <CLMetadataConverter>)convertForKey:(NSString *)key;

@end
