//
//  GBTopicViewController.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBTopicViewController.h"
#import "GBTopicCell.h"
#import "GBGroupInfo.h"
#import "GBTopicDetailViewController.h"

typedef enum : NSUInteger {
    TopicTypeFollowed,
    TopicTypeRecommended,
} TopicType;

static NSString * const TopicCellId = @"TopicCell";
static NSInteger const RecBtnTag = 3000;
static NSInteger const AttentionBtnTag = 3001;
static NSInteger const PageCount = 10;

@interface GBTopicViewController () <UITableViewDelegate, UITableViewDataSource, GBTopicCellDelegate>
@property (nonatomic, strong) UIView *switchContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *attentions;
@property (nonatomic, assign) TopicType topicType;
@end

@implementation GBTopicViewController
#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.switchContainer];
    [self.view addSubview:self.tableView];
    
    NSDictionary *params = @{@"beFollowed":[NSNumber numberWithBool:YES]};
    [self requestWithParams:params refresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attentions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.index = indexPath.row;
    
    GBGroupInfo *topic = self.attentions[indexPath.row];
    [cell configData:topic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GBGroupInfo *topic = self.attentions[indexPath.row];
    GBTopicDetailViewController *tdvc = [[GBTopicDetailViewController alloc] init];
    tdvc.hidesBottomBarWhenPushed = YES;
    tdvc.topic = topic;
    [self.navigationController pushViewController:tdvc animated:YES];
}

#pragma mark  GBTopicCellDelegate
- (void)topicCellHandleAttention:(UIButton *)sender index:(NSInteger)index {
    
    GBGroupInfo *topic = self.attentions[index];
    NSDictionary *params = @{@"id":topic.topicId};
    if (self.topicType == TopicTypeFollowed) {
        //取消关注
        [self unfollowRequestWithParams:params topic:topic];
    } else {
        //关注
        [self followRequestWithParams:params topic:topic];
    }
}

#pragma mark - network
- (void)requestWithParams:(NSDictionary *)params refresh:(BOOL)refresh {

    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:TopicList params:params success:^(id response) {
        NSError *err = nil;
        NSArray *results = [MTLJSONAdapter modelsOfClass:[GBGroupInfo class] fromJSONArray:response[@"data"] error:&err];
        if (refresh) {
            if (weakself.attentions) {
                [weakself.attentions removeAllObjects];
                [weakself.attentions addObjectsFromArray:results];
            } else {
                weakself.attentions = [NSMutableArray arrayWithArray:results];
            }
        } else {
            [weakself.attentions addObjectsFromArray:results];
        }
        [weakself.tableView reloadData];
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        if (!refresh && results.count < PageCount) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

//关注
- (void)followRequestWithParams:(NSDictionary *)params topic:(GBGroupInfo *)topic {
    
    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:TopicFollowApi params:params success:^(id response) {
        [weakself.attentions removeObject:topic];
        [self.tableView reloadData];
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

//取消关注
- (void)unfollowRequestWithParams:(NSDictionary *)params topic:(GBGroupInfo *)topic {
    
    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:TopicUnfollowApi params:params success:^(id response) {
        [weakself.attentions removeObject:topic];
        [self.tableView reloadData];
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - event
- (void)handleSwitchAction:(UIButton *)sender {
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, SCREEN_W, 1) animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (sender.tag) {
        case AttentionBtnTag: {
            self.topicType = TopicTypeFollowed;
            [params setObject:[NSNumber numberWithBool:true] forKey:@"beFollowed"];
        }
            break;
        case RecBtnTag: {
            self.topicType = TopicTypeRecommended;
            [params setObject:[NSNumber numberWithBool:true] forKey:@"beRecommended"];
        }
            break;
        default:
            break;
    }
    
    [self requestWithParams:params refresh:YES];
}

#pragma mark - private

#pragma mark - getter & setter
- (UIView *)switchContainer {
    if (!_switchContainer) {
        _switchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 44)];
        UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W/2-1, 44)];
        [attentionBtn setTitle:@"我的关注" forState:UIControlStateNormal];
        [attentionBtn setTitleColor:ColorHex(@"333333") forState:UIControlStateNormal];
        attentionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [attentionBtn addTarget:self action:@selector(handleSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        attentionBtn.tag = AttentionBtnTag;
        [_switchContainer addSubview:attentionBtn];
        
        UIButton *recBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2+1, 0, SCREEN_W/2-1, 44)];
        [recBtn setTitle:@"为我推荐" forState:UIControlStateNormal];
        [recBtn setTitleColor:ColorHex(@"333333") forState:UIControlStateNormal];
        recBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [recBtn addTarget:self action:@selector(handleSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        recBtn.tag = RecBtnTag;
        [_switchContainer addSubview:recBtn];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2-1, 8, 2, 44-16)];
        view.backgroundColor = ColorHex(@"ffc000");
        [_switchContainer addSubview:view];
    }
    return _switchContainer;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, SCREEN_W, SCREEN_H-64-44)];
        [_tableView registerClass:[GBTopicCell class] forCellReuseIdentifier:TopicCellId];
        _tableView.rowHeight = 76;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (weakself.topicType == TopicTypeFollowed) {
                [weakself requestWithParams:@{@"beFollowed": [NSNumber numberWithBool:true]} refresh:YES];
            } else {
                [weakself requestWithParams:@{@"beRecommended": [NSNumber numberWithBool:true]} refresh:YES];
            }
        }];
        
        _tableView.mj_footer = [GBRefreshAutoFooter footerWithRefreshingBlock:^{
            
            GBGroupInfo *topic = [self.attentions lastObject];
            if (weakself.topicType == TopicTypeFollowed) {
                [weakself requestWithParams:@{@"beFollowed": [NSNumber numberWithBool:true], @"criticalValue": topic.createdTime} refresh:NO];
            } else {
                [weakself requestWithParams:@{@"beRecommended": [NSNumber numberWithBool:true], @"criticalValue": topic.createdTime} refresh:NO];
            }
        }];
    }
    return _tableView;
}

@end
