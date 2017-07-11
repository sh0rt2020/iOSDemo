//
//  FilterCollectionViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/11.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "FilterCollectionViewController.h"
#import "GlobalDefs.h"

static NSString * const CellIdentifier = @"TestCell";

@interface FilterCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionTable;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *filterArr;
@end

@implementation FilterCollectionViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionTable];
//    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *filterName = [[self.filterArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    UIImageView *filterImgView = nil;
    if (!(filterImgView = [cell viewWithTag:11111])) {
        filterImgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        [cell addSubview:filterImgView];
    }
    
    filterImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb.png", filterName]];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UIView *supplementaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 1)];
//    supplementaryView.backgroundColor = [UIColor whiteColor];
//    return supplementaryView;
//}

#pragma mark - event response

#pragma mark - getter&setter
- (UICollectionView *)collectionTable {
    if (!_collectionTable) {
        _collectionTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 500) collectionViewLayout:self.flowLayout];
        _collectionTable.delegate = self;
        _collectionTable.dataSource = self;
        [_collectionTable registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        _collectionTable.contentOffset = CGPointMake(0, 64);
    }
    return _collectionTable;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.itemSize = CGSizeMake(100, 44);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
@end
