//
//  GBHomeViewController.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBHomeViewController.h"
#import "GBTitleBar.h"
#import "GBHomeFeedCell.h"
#import "GBListItemInfo.h"
#import "GBShareView.h"
#import "GBDetailViewController.h"


typedef enum : NSUInteger {
    ContentTypeRecommend,
    ContentTypeAttention,
    ContentTypeText,
    ContentTypeTextAndImgs,
} ContentType;

static NSString * const CellId = @"GBHomeFeedCell";
static NSInteger const PageCount = 10;

@interface GBHomeViewController ()<UITableViewDelegate, UITableViewDataSource, GBHomeFeedCellDelegate, GBTitleBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GBTitleBar *titleBar;
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) TableDataSource *dataSource;

@property (nonatomic, assign) ContentType contentType;  //切换数据流类型
@end

@implementation GBHomeViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.feedArray = [NSMutableArray array];
//    for (int i = 0; i < 25; i++) {
//        GBListItemInfo *item = [[GBListItemInfo alloc] init];
//        item.content = @"那天一起去唱歌，叫了几个陪酒的小妹妹，啤酒喝的太多，去上厕所出来后，小妹妹服务很好，在外面等我，然后给了我一张纸，我拿到手上很尴尬，小妹妹笑的肚子疼，大家知道我尴尬什么吗？";
//        NSArray *pictures = @[@"http://p1.pstatp.com/large/3c530004435e760a2bb0", @"http://p3.pstatp.com/large/3a2b0003f273edec59bc", @"http://p3.pstatp.com/large/3c550002a68ba9d0ee6e", @"http://p3.pstatp.com/large/3c52000447231bca8611", @"http://p1.pstatp.com/large/3c530004435bf34a3b62", @"http://p1.pstatp.com/large/3c500003ee058471e06a", @"http://p3.pstatp.com/large/3c530004435fce4716e5", @"http://p3.pstatp.com/large/3c54000442264047e3a8", @"http://p3.pstatp.com/large/3c5400044227ee2f9482"];
//        item.pictures = pictures;
//        [self.feedArray addObject:item];
//    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleArray = @[@"推荐", @"关注", @"娱乐", @"图片"];
    [self.view addSubview:self.titleBar];
    [self.view addSubview:self.tableView];
    
    
    NSDictionary *params = @{@"beRecommended": [NSNumber numberWithBool:true]};
    [self requestWithParams:params refresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBListItemInfo *item = [self.feedArray objectAtIndex:indexPath.row];
    CGFloat height = [item cacheCellHeight:item];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBHomeFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.index = indexPath.row;

    GBListItemInfo *item = self.feedArray[indexPath.row];
    [cell configData:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBListItemInfo *item = self.feedArray[indexPath.row];
    GBDetailViewController *dvc = [[GBDetailViewController alloc] init];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.feedId = item.feedId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark  GBHomeFeedCellDelegate
- (void)homeFeedCellHandleAction:(UIButton *)sender index:(NSInteger)index {
    switch (sender.tag) {
        case ShareBtnTag: {
            GBShareView *shareView = [[GBShareView alloc] initWithFrame:self.view.bounds];
            WEAKSELF;
            [shareView shareViewButtonSeleted:^(NSInteger sender) {
//                [weakself shareHttp:sender detailsModel:self.headerModel];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        }
            break;
        case FavorBtnTag:
        case UnfavorBtnTag: {
//            if (!sender.selected) {
                GBListItemInfo *item = self.feedArray[index];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": item.feedId}];
                if (sender.tag == FavorBtnTag) {
                    [self favorRequest:params];
                } else {
                    [self unfavorRequest:params];
                }
//            }
        }
            break;
        case CommentBtnTag: {
            GBListItemInfo *item = self.feedArray[index];
            GBDetailViewController *dvc = [GBDetailViewController new];
            dvc.hidesBottomBarWhenPushed = YES;
            dvc.feedId = item.feedId;
            dvc.isScrollToComment = YES;
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark  GBTitleBarDelegate
- (void)titleBarDidSelected:(NSInteger)index {
    
    self.tableView.mj_footer.hidden = NO;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, SCREEN_W, 1) animated:NO];
    NSDictionary *param = nil;
    switch (index) {
        case 0:
            self.contentType = ContentTypeRecommend;
            param = @{@"beRecommended": [NSNumber numberWithBool:true]};
            break;
        case 1:
            self.contentType = ContentTypeAttention;
            param = @{@"beFollowed": [NSNumber numberWithBool:true]};
            break;
        case 2:
            self.contentType = ContentTypeText;
            param = @{@"feedType": @1};
            break;
        case 3:
            self.contentType = ContentTypeTextAndImgs;
            param = @{@"feedType": @2};
            break;
        default:
            break;
    }
    
    [self requestWithParams:param refresh:YES];
}


#pragma mark - network
//列表
- (void)requestWithParams:(NSDictionary *)params refresh:(BOOL)refresh {

    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:FeedList params:params success:^(id response) {
        NSError *err = nil;
        if (refresh) {
            if (weakself.feedArray) {
                [weakself.feedArray removeAllObjects];
                [weakself.feedArray addObjectsFromArray:[MTLJSONAdapter modelsOfClass:GBListItemInfo.class fromJSONArray:response[@"data"] error:&err]];
            } else {
                weakself.feedArray = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:GBListItemInfo.class fromJSONArray:response[@"data"] error:&err]];
            }
        } else {
            NSArray *feeds = [MTLJSONAdapter modelsOfClass:[GBListItemInfo class] fromJSONArray:response[@"data"] error:&err];
            if (feeds.count < PageCount) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakself.feedArray addObjectsFromArray:feeds];
        }
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

//点赞
- (void)favorRequest:(NSMutableDictionary *)params {
    [[GBHttpManager sharedHttpManager] postReuqest:FavorApi params:params success:^(id response) {
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

//点踩
- (void)unfavorRequest:(NSMutableDictionary *)params {
    [[GBHttpManager sharedHttpManager] postReuqest:UnfavorApi params:params success:^(id response) {
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - event

#pragma mark - private
- (void)configTableDataSource {
    TableCellConfigBlock configBlock = ^(GBHomeFeedCell *cell, GBListItemInfo *item, NSIndexPath *indexPath) {
        cell.delegate = self;
        cell.index = indexPath.row;
        [cell configData:item];
    };
    
    NSArray *source = @[self.feedArray];
    self.dataSource = [[TableDataSource alloc] initWithItems:source
                                              cellIdentifier:CellId
                                                 configBlock:configBlock];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-49)];
        [_tableView registerClass:[GBHomeFeedCell class] forCellReuseIdentifier:CellId];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSDictionary *params = nil;
            switch (weakself.contentType) {
                case ContentTypeRecommend:
                    params = @{@"beRecommended": [NSNumber numberWithBool:true]};
                    break;
                case ContentTypeAttention:
                    params = @{@"beFollowed": [NSNumber numberWithBool:true]};
                    break;
                case ContentTypeText:
                    params = @{@"feedType": @"1"};
                    break;
                case ContentTypeTextAndImgs:
                    params = @{@"feedType": @"2"};
                    break;
                default:
                    break;
            }
            
            [weakself requestWithParams:params refresh:YES];
        }];
        
        _tableView.mj_footer = [GBRefreshAutoFooter footerWithRefreshingBlock:^{
            
            if (weakself.feedArray && weakself.feedArray.count > 0) {
                GBListItemInfo *lastItem = [weakself.feedArray lastObject];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastItem.publishTime, @"criticalValue", nil];
                switch (weakself.contentType) {
                    case ContentTypeRecommend:
                        [params setObject:[NSNumber numberWithBool:true] forKey:@"beRecommended"];
                        break;
                    case ContentTypeAttention:
                        [params setObject:[NSNumber numberWithBool:true] forKey:@"beFollowed"];
                        break;
                    case ContentTypeText:
                        [params setObject:@1 forKey:@"feedType"];
                        break;
                    case ContentTypeTextAndImgs:
                        [params setObject:@2 forKey:@"feedType"];
                        break;
                    default:
                        break;
                }
                
                [weakself requestWithParams:params refresh:NO];
            }
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (GBTitleBar *)titleBar {
    if (!_titleBar) {
        _titleBar = [[GBTitleBar alloc] initWithTitles:self.titleArray];
        _titleBar.frame = CGRectMake(0, 0, SCREEN_W, 64);
        _titleBar.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleBar.frame.size.height-1, SCREEN_W, 1)];
        line.backgroundColor = ColorHex(@"dddddd");
        _titleBar.delegate = self;
        [_titleBar addSubview:line];
    }
    return _titleBar;
}

@end
