//
//  TableViewController.m
//  FormDemo
//
//  Created by Yige on 2016/12/8.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import "TableViewController.h"
#import "FormTableViewCell.h"

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, nonnull) NSArray *dataArr;
@end

@implementation TableViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = @[];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormTableViewCell" forIndexPath:indexPath];
    cell.contentArr = @[@[@"早期死亡风险", @{@"风险分层指标及评分":@[@"休克或低血压", @"简化PESI>1", @"右心室功能不全/标志物"]}], @[@"高危>15%", @"+", @"(+)", @"+/(+)"], @[]];
    cell.heightArr = @[];
    cell.widthArr = @[];
    return cell;
}

@end
