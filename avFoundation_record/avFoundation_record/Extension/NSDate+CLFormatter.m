//
//  NSDate+CLFormatter.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "NSDate+CLFormatter.h"

@implementation NSDate (CLFormatter)

+ (NSString *)dateWithFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *format = [NSDateFormatter dateFormatFromTemplate:formatter options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

@end
