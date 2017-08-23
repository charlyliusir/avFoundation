//
//  CLViewController.m
//  avFoundation_meta
//
//  Created by tidemedia on 2017/8/23.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLViewController.h"
#import "CLMetaItem.h"

/// 媒体资源中包括: 普通字符或数字类型[Default]/注释[Comment]/封面图图片类型[Artwork]/风格类型[Genre]/音轨[Track]/唱片[Disc]

#define kMetaItemListCellIdentifier @"metaItemListCell"

@interface CLViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray <CLMetaItem *>*metaItems;

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 读取媒体数据
    [self loadMetaItems];
    /// 创建文件列表
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy method
- (NSMutableArray <CLMetaItem *>*)metaItems
{
    if (!_metaItems) {
        _metaItems = [NSMutableArray array];
    }
    return _metaItems;
}

#pragma mark - ui method
- (void)setupUI
{
    
}

#pragma mark - private method
- (void)loadMetaItems
{
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"Media"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.metaItems addObject:[[CLMetaItem alloc] initWithPath:obj]];
        if (stop) {
            [_tableView reloadData];
        }
    }];
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.metaItems[indexPath.row] prepareWithCompletionHandler:^(BOOL completion) {
        /// 进入下一个页面
        NSLog(@"prepare status : %d", completion);
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.metaItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMetaItemListCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMetaItemListCellIdentifier];
    }
    cell.textLabel.text = self.metaItems[indexPath.row].filename;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
