//
//  FilterViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/6.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "FilterViewController.h"
#import "GlobalDefs.h"

NSString * const CellIdentifier = @"CollectionViewCellIdentifier";

@interface FilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *filterList;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *filterArr;
@end

@implementation FilterViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.filterList];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"plsfilters" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    self.filterArr = [NSArray arrayWithArray:jsonDic[@"filters"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
#pragma mark  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *filterImgView = nil;
    if (!(filterImgView = [cell.contentView viewWithTag:3333])) {
        filterImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
        filterImgView.tag = 3333;
        [cell.contentView addSubview:filterImgView];
    }
    
    NSString *imgName = [self.filterArr[indexPath.row] objectForKey:@"name"];
    filterImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb", imgName]];
    
    return cell;
}

#pragma mark - getter&setter
- (UICollectionView *)filterList {
    if (!_filterList) {
        _filterList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREENH-100, SCREENW, 100) collectionViewLayout:self.flowLayout];
        [_filterList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        _filterList.delegate = self;
        _filterList.dataSource = self;
        _filterList.backgroundColor = [UIColor orangeColor];
    }
    return _filterList;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.itemSize = CGSizeMake(88, 88);
    }
    return _flowLayout;
}
@end
