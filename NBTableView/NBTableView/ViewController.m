//
//  ViewController.m
//  NBTableView
//
//  Created by sunwell on 2016/10/17.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "NBTableView.h"
#import "NBTableViewDelegate.h"
#import "NBTableViewDataSource.h"
#import "NBGlobalDefines.h"

@interface ViewController ()

DEFINE_PROPERTY_STRONG(NBTableView *, tableView);
DEFINE_PROPERTY_STRONG(NSArray *, data);
DEFINE_PROPERTY_STRONG(NBTableViewDataSource *, dataSource);
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[NBTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:self.tableView];
    
    self.data = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g"];
    self.dataSource = [[NBTableViewDataSource alloc] initWithItems:self.data cellIdentifier:@"nbcell" configureBlock:^(id cell, id item) {
        NSLog(@"%@---------%@", cell, item);
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 24)];
        lab.text = item;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor greenColor];   
        [((NBTableViewCell *)cell).contentView addSubview:lab];
    }];
    self.dataSource.height = 44;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
