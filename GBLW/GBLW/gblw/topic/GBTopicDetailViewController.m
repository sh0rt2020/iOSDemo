//
//  GBTopicDetailViewController.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBTopicDetailViewController.h"
#import "GBHomeFeedCell.h"
#import "GBTopicHeadCell.h"
#import "GBListItemInfo.h"
#import "GBGroupInfo.h"
#import "GBShareView.h"
#import "GBDetailViewController.h"

static NSString * const  TopicGroupCellId = @"HomeFeedCell";
static NSString * const  TopicHeadCellId = @"TopicHeadCell";
static NSInteger const PageCount = 10;

@interface GBTopicDetailViewController () <UITableViewDelegate, UITableViewDataSource, GBHomeFeedCellDelegate, GBTopicHeadCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSMutableArray *feeds;
@end

@implementation GBTopicDetailViewController
#pragma mark - life
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBar];
    
    NSDictionary *params = @{@"topicId":self.topic.topicId};
    [self requestWithParams:params refresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 170;
    } else {
        
        GBListItemInfo *item = self.feeds[indexPath.row-1];
        return [item cacheCellHeight:item];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        GBTopicHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicHeadCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        [cell configData:self.topic];
        
        return cell;
    } else {
        GBHomeFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicGroupCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        GBListItemInfo *item = self.feeds[indexPath.row-1];
        [cell configData:item];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GBListItemInfo *feed = self.feeds[indexPath.row - 1];
    GBDetailViewController *dvc = [GBDetailViewController new];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.feedId = feed.feedId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset/64.0;
    [self.navBar setBackgroundColor:[ColorHex(@"ffe000") colorWithAlphaComponent:alpha]];
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
            if (!sender.selected) {
                GBListItemInfo *item = self.feeds[index];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": item.feedId}];
                if (sender.tag == FavorBtnTag) {
                    [self favorRequest:params];
                } else {
                    [self unfavorRequest:params];
                }
            }
        }
            break;
        case CommentBtnTag: {
            GBListItemInfo *item = self.feeds[index];
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

#pragma mark  GBTopicHeadCellDelegate
- (void)topicHeadCellFollowAction:(UIButton *)sender beFollowed:(BOOL)beFollowed {
    if (beFollowed) {
        //取消关注
        NSDictionary *params = @{@"id": self.topic.topicId};
        [self unfollowRequestWithParams:params];
    } else {
        //关注
        NSDictionary *params = @{@"id": self.topic.topicId};
        [self followRequestWithParams:params];
    }
}

#pragma mark - network
- (void)requestWithParams:(NSDictionary *)params refresh:(BOOL)refresh {
    
    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:FeedList params:params success:^(id response) {
        NSError *err = nil;
        NSArray *results = [MTLJSONAdapter modelsOfClass:[GBListItemInfo class] fromJSONArray:response[@"data"] error:&err];
        if (refresh) {
            if (weakself.feeds) {
                [weakself.feeds removeAllObjects];
                [weakself.feeds addObjectsFromArray:results];
            } else {
                weakself.feeds = [NSMutableArray arrayWithArray:results];
            }
        } else {
            [weakself.feeds addObjectsFromArray:results];
            
            if (results.count < PageCount) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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

//关注
- (void)followRequestWithParams:(NSDictionary *)params {
    
    [[GBHttpManager sharedHttpManager] postReuqest:TopicFollowApi params:params success:^(id response) {
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

//取消关注
- (void)unfollowRequestWithParams:(NSDictionary *)params {
    
    [[GBHttpManager sharedHttpManager] postReuqest:TopicUnfollowApi params:params success:^(id response) {
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - event
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        [_tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
        [_tableView registerClass:[GBHomeFeedCell class] forCellReuseIdentifier:TopicGroupCellId];
        [_tableView registerClass:[GBTopicHeadCell class] forCellReuseIdentifier:TopicHeadCellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself requestWithParams:@{@"topicId": weakself.topic.topicId} refresh:YES];
        }];
        
        _tableView.mj_footer = [GBRefreshAutoFooter footerWithRefreshingBlock:^{
            
            if (weakself.feeds.count > 0) {
                GBListItemInfo *feed = [weakself.feeds lastObject];
                [weakself requestWithParams:@{@"topicId": weakself.topic.topicId, @"criticalValue": feed.publishTime} refresh:NO];
            }
        }];
    }
    return _tableView;
}

- (UIView *)navBar {
    if (!_navBar) {
        UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 44, 44)];
        [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 28)];
        [returnBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [returnBtn setImage:ImageNamed(@"return_white") forState:UIControlStateNormal];
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        [_navBar addSubview:returnBtn];
        [_navBar setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0]];
    }
    return _navBar;
}

@end
