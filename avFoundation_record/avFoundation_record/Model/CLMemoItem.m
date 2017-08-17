//
//  CLMemoItem.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/17.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLMemoItem.h"

#define MemoItem_Title @"title"
#define MemoItem_Date @"date"
#define MemoItem_Time @"time"
#define MemoItem_Name @"name"

#define kVideoFloderName @"video"

@interface CLMemoItem ()

/// 文件名称
@property (copy, readwrite, nonatomic) NSString *title;
/// 日期
@property (copy, readwrite, nonatomic) NSString *date;
/// 时间
@property (copy, readwrite, nonatomic) NSString *time;
/// 文件地址名
@property (copy, readwrite, nonatomic) NSString *name;
/// 播放地址
@property (strong, readwrite, nonatomic) NSURL *url;

@end

@implementation CLMemoItem

+ (instancetype)memoWithTitle:(NSString *)title name:(NSString *)name
{
    return [[self alloc] initWithTitle:title name:name];
}

- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name
{
    if (self = [super init]) {
        self.title = [title copy];
        self.name  = [name copy];
        self.url   = [NSURL fileURLWithPath:[self videoFilePath:name]];
        NSDate *date = [NSDate date];
        self.date = [self dateStringWithDate:date];
        self.time = [self timeStringWithDate:date];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:MemoItem_Title];
    [aCoder encodeObject:_date forKey:MemoItem_Date];
    [aCoder encodeObject:_time forKey:MemoItem_Time];
    [aCoder encodeObject:_name forKey:MemoItem_Name];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:MemoItem_Title];
        _date  = [aDecoder decodeObjectForKey:MemoItem_Date];
        _time  = [aDecoder decodeObjectForKey:MemoItem_Time];
        _name  = [aDecoder decodeObjectForKey:MemoItem_Name];
        _url   = [NSURL fileURLWithPath:[self videoFilePath:_name]];
    }
    return self;
}

/// 音频保存到本地的地址
- (NSString *)videoFilePath:(NSString *)fileName
{
    return [[NSString videoDocument:kVideoFloderName] stringByAppendingPathComponent:fileName];
}

- (NSString *)dateStringWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter = [self formatterWithFormat:@"yyyy-MM-dd"];
    return [dateformatter stringFromDate:date];
}

- (NSString *)timeStringWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter = [self formatterWithFormat:@"HH:mm:ss"];
    return [dateformatter stringFromDate:date];
}

- (NSDateFormatter *)formatterWithFormat:(NSString *)template
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setLocale:[NSLocale currentLocale]];
    NSString *format = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:[NSLocale currentLocale]];
    [dateformatter setDateFormat:format];
    return dateformatter;
}

- (void)deleteMemo
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager removeItemAtURL:_url error:&error]) {
        NSLog(@"Remove Memo File Error : %@", error.localizedDescription);
    }
}

@end
