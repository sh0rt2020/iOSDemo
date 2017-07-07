//
//  FilterViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/6.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "FilterViewController.h"
#import "GlobalDefs.h"
#import "FilterCell.h"

NSString * const CellIdentifier = @"CollectionViewCellIdentifier";

@interface FilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *filterList;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *filterArr;
@end

@implementation FilterViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"plsfilters" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    self.filterArr = [NSArray arrayWithArray:jsonDic[@"filters"]];
    
    [self.view addSubview:self.filterList];
    self.view.backgroundColor = [UIColor greenColor];
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
    
    NSString *imgName = [self.filterArr[indexPath.row] objectForKey:@"name"];
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb", imgName]];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:]) {
//        <#statements#>
//    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 2)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - getter&setter
- (UICollectionView *)filterList {
    if (!_filterList) {
        _filterList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREENH-90, SCREENW, 88) collectionViewLayout:self.flowLayout];
        [_filterList registerClass:[FilterCell class] forCellWithReuseIdentifier:CellIdentifier];
        _filterList.delegate = self;
        _filterList.dataSource = self;
        _filterList.showsVerticalScrollIndicator = NO;
        _filterList.showsHorizontalScrollIndicator = NO;
        _filterList.contentOffset = CGPointMake(0, 1);
        _filterList.contentSize = CGSizeMake(self.filterArr.count*68+67*10, 88);
        _filterList.backgroundColor = [UIColor orangeColor];
    }
    return _filterList;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 2;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.itemSize = CGSizeMake(68, 68);
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.footerReferenceSize = CGSizeZero;
        _flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
@end
