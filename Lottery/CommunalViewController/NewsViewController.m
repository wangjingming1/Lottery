//
//  NewsViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCollectionViewCell.h"
#import "Masonry.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "LottoryNewsModel.h"
#import "NewsDownloadManager.h"
#import "GlobalDefines.h"
#import "WebViewController.h"

#define kNewsViewControllerCellIdentifier   @"NewsViewControllerCellIdentifier"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *newsTableView;
@property (nonatomic, strong) NSMutableArray *newsListArray;
@property (nonatomic) NSInteger newPage;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self refreshView];
}

- (void)initData{
    self.newsListArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.newPage = 0;
}

- (void)setUI{
    [self.view addSubview:self.newsTableView];
    
}

- (void)reloadView{
    [self.newsTableView reloadData];
}

- (void)refreshView{
    WS(weakSelf);
    [self reloadData:^{
        [weakSelf reloadView];
    }];
}

- (void)reloadData:(void (^)(void))finsh{
    NSInteger count = 10, begin = self.newPage*count;
    WS(weakSelf);
    [NewsDownloadManager newsDownloadBegin:begin count:count finsh:^(NSArray *news) {
        [weakSelf.newsListArray addObjectsFromArray:news];
        if (finsh) finsh();
    }];
    self.newPage++;
}

- (UITableView *)newsTableView{
    if (!_newsTableView){
        _newsTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _newsTableView.estimatedRowHeight = 44;
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线样式
        _newsTableView.rowHeight = UITableViewAutomaticDimension;
        [_newsTableView registerClass:[NewsCollectionViewCell class] forCellReuseIdentifier:kNewsViewControllerCellIdentifier];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
    }
    return _newsTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsViewControllerCellIdentifier];
    if (!cell) {
        cell = [[NewsCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kNewsViewControllerCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LottoryNewsModel *model = [[LottoryNewsModel alloc] init];
    if (indexPath.row < self.newsListArray.count) {
        model = [self.newsListArray objectAtIndex:indexPath.row];
    }
    cell.model = model;
    return cell;
}


- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LottoryNewsModel *model = [[LottoryNewsModel alloc] init];
    if (indexPath.row < self.newsListArray.count) {
        model = [self.newsListArray objectAtIndex:indexPath.row];
    }
    NSString *stateKey = @"unexpanded";
    return [NewsCollectionViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        NewsCollectionViewCell *cell = (NewsCollectionViewCell *)sourceCell;
        // 配置数据
        cell.model = model;
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey: indexPath,
                 kHYBCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 kHYBRecalculateForStateKey : @(NO) // 标识不用重新更新
        };
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[@"url"] = ((LottoryNewsModel *)self.newsListArray[indexPath.row]).newsUrl;
    params[@"leftTitle"] = @"资讯详情";
    [super pushViewController:[WebViewController class] params:params];
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
