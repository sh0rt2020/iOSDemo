//
//  FilterViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/6.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#import "FilterViewController.h"

@interface FilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *filterList;
@end

@implementation FilterViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.filterList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
#pragma mark  UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - getter&setter
- (UICollectionView *)filterList {
    if (!_filterList) {
        _filterList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREENH-100, SCREENW, 100)];
        _filterList.delegate = self;
        _filterList.dataSource = self;
    }
    return _filterList;
}
@end
