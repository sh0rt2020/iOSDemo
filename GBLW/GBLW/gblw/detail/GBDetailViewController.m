//
//  GBDetailViewController.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBDetailViewController.h"
#import "GBDetailHeadCell.h"
#import "GBDetailCommentCell.h"
#import "GBListItemInfo.h"
#import "GBComment.h"
#import "GBShareView.h"

static NSString * const HeadCellId = @"DetailHeadCell";
static NSString * const CommentCellId = @"CommentCell";
static NSString * const NormalCellId = @"NormalCell";

static NSInteger const PageCount = 10;

static NSInteger CellTitleTag = 1111;

@interface GBDetailViewController () <UITableViewDelegate, UITableViewDataSource, GBDetailHeadCellDelegate, GBDetailCommentCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GBListItemInfo *item;
@property (nonatomic, strong) NSMutableArray *latestComments;
@property (nonatomic, strong) NSArray *hotComments;
@end

@implementation GBDetailViewController
#pragma mark - life 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 28)];
    [returnBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn setImage:ImageNamed(@"return") forState:UIControlStateNormal];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = returnItem;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:ImageNamed(@"share_detail") forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"详情";
    
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ((self.hotComments && self.hotComments.count > 0) && (self.latestComments.count == 0 || !self.latestComments)) {
            return self.hotComments.count + 1;
        } else if ((self.latestComments && self.latestComments.count > 0) && (!self.hotComments && self.hotComments.count == 0)) {
            return self.latestComments.count + 1;
        } else if (self.hotComments && self.hotComments.count > 0 && self.latestComments && self.latestComments.count > 0) {
            return self.latestComments.count+self.hotComments.count+2;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.item cacheCellHeight:self.item];
    } else {
        if (indexPath.row == self.hotComments.count+1 || indexPath.row == 0) {
            return 20;
        }
        
        GBComment *comment = nil;
        if (indexPath.row < self.hotComments.count+2) {
            comment = self.hotComments[indexPath.row-1];
        } else {
            comment = self.latestComments[indexPath.row-self.hotComments.count-2];
        }
        
        return [comment cacheCellHeight:comment];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:HeadCellId];
        headCell.delegate = self;
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.item) {
            [headCell configData:self.item];
        }
        return headCell;
    } else {
        if (indexPath.row == 0 || indexPath.row == self.hotComments.count+1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_W, 0, 0);
            
            UILabel *titleLab = nil;
            if (!(titleLab = [cell viewWithTag:CellTitleTag])) {
                titleLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, SCREEN_W-14, 20)];
                titleLab.font = [UIFont systemFontOfSize:12];
                titleLab.textColor = ColorHex(@"999999");
                titleLab.textAlignment = NSTextAlignmentLeft;
                titleLab.tag = CellTitleTag;
                [cell addSubview:titleLab];
            }
            if (indexPath.row == 0) {
                titleLab.text = @"热门评论";
            } else {
                titleLab.text = @"最新评论";
            }
            
            return cell;
        } else {
            
            GBDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:CommentCellId];
            commentCell.delegate = self;
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            GBComment *comment = nil;
            if (indexPath.row < self.hotComments.count+2) {
                comment = self.hotComments[indexPath.row-1];
            } else {
                comment = self.latestComments[indexPath.row-self.hotComments.count-2];
            }
        
            [commentCell configData:comment];
            return commentCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==  0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.01)];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
        view.backgroundColor = ColorHex(@"f4f4f4");
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.01)];
    return view;
}



#pragma mark  GBDetailHeadCellDelegate
- (void)detailHeadCellHandleAction:(UIButton *)sender {
    switch (sender.tag) {
        case FavorBtnTag:
        case UnfavorBtnTag: {
            if (!sender.selected) {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": self.feedId}];
                if (sender.tag == FavorBtnTag) {
                    [self favorRequest:params];
                } else {
                    [self unfavorRequest:params];
                }
            }
        }
            break;
        case CommentBtnTag: {
           
        }
            break;
        case AttentionTag: {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark  GBDetailCommentCellDelegate
- (void)detailCommentCellHandleFavor:(UIButton *)sender {
    
}

#pragma mark - network
//详情+热评+新评
- (void)request {
    WEAKSELF;
    NSDictionary *params = @{@"id":self.feedId};
    [[GBHttpManager sharedHttpManager] postReuqest:FeedDetail params:params success:^(id response) {
        NSError *err = nil;
        weakself.item = [MTLJSONAdapter modelOfClass:[GBListItemInfo class] fromJSONDictionary:[[response objectForKey:@"data"] objectForKey:@"feed"] error:&err];
        
        NSError *hotErr = nil;
        weakself.hotComments = [MTLJSONAdapter modelsOfClass:[GBComment class] fromJSONArray:[[response objectForKey:@"data"] objectForKey:@"hotestComments"] error:&hotErr];
        
        NSError *latestErr = nil;
        weakself.latestComments = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[GBComment class] fromJSONArray:[[response objectForKey:@"data"] objectForKey:@"latestComments"] error:&latestErr]];
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        NSLog(@"%@", response);
    } failure:^(id task, id error) {
        NSLog(@"%@", error);
        weakself.tableView.mj_header.hidden = YES;
        weakself.tableView.mj_footer.hidden = YES;
    }];
}

//最新评论
- (void)commentRequestWithParams:(NSDictionary *)params isRefresh:(BOOL)isRefresh {
    
    WEAKSELF;
    [[GBHttpManager sharedHttpManager] postReuqest:CommentList params:params success:^(id response) {
        NSError *err = nil;
        
        NSArray *results = [MTLJSONAdapter modelsOfClass:[GBComment class] fromJSONArray:[response objectForKey:@"data"] error:&err];
        if (weakself.latestComments) {
            [weakself.latestComments addObjectsFromArray:results];
        } else {
            weakself.latestComments = [NSMutableArray arrayWithArray:results];
        }
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        if (results && results.count < PageCount) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
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
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share {
    GBShareView *shareView = [[GBShareView alloc] initWithFrame:self.view.bounds];
    WEAKSELF;
    [shareView shareViewButtonSeleted:^(NSInteger sender) {
        //                [weakself shareHttp:sender detailsModel:self.headerModel];
    }];
    [self.view addSubview:shareView];
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
        [_tableView registerClass:[GBDetailHeadCell class] forCellReuseIdentifier:HeadCellId];
        [_tableView registerClass:[GBDetailCommentCell class] forCellReuseIdentifier:CommentCellId];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NormalCellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself request];
        }];
        
        _tableView.mj_footer = [GBRefreshAutoFooter footerWithRefreshingBlock:^{
            
            if (weakself.latestComments && weakself.latestComments.count > 0) {
                GBComment *lastComment = [weakself.latestComments lastObject];
                NSDictionary *params = @{@"feedId": weakself.feedId, @"criticalValue": lastComment.publishTime};
                [weakself commentRequestWithParams:params isRefresh:NO];
            }
        }];
    }
    return _tableView;
}
@end
