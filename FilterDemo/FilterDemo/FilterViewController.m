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
#import "CIFilter+ColorLUT.h"

NSString * const CellIdentifier = @"CollectionViewCellIdentifier";

@interface FilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UICollectionView *filterList;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *filterArr;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *originalImg;

@end

@implementation FilterViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"相册" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:145.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(handleAlbumAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"plsfilters" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    self.filterArr = [NSArray arrayWithArray:jsonDic[@"filters"]];
    
    [self.view addSubview:self.filterList];
    [self.filterList reloadData];
    
    [self.view addSubview:self.imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
#pragma mark  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterArr.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UILabel *lab = [[UILabel alloc] initWithFrame:cell.bounds];
        lab.text = @"original";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor brownColor];
        lab.tag = 11111;
        [cell.contentView addSubview:lab];
        cell.imgView.hidden = YES;
    } else {
        [[cell viewWithTag:11111] removeFromSuperview];
        cell.imgView.hidden = NO;
        NSString *imgName = [self.filterArr[indexPath.row-1] objectForKey:@"name"];
        cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb.png", imgName]];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.imgView.image = self.originalImg;
    } else {
        //滤镜处理
        NSString *filterName = [self.filterArr[indexPath.row-1] objectForKey:@"name"];
        filterName = [filterName stringByAppendingString:@"_filter.png"];
        
        if (self.originalImg) {
            CIFilter *colorCube = [CIFilter colorCubeWithColrLUTImageNamed:filterName dimension:64];
            CIImage *inputImg = [[CIImage alloc] initWithImage:self.originalImg];
            [colorCube setValue:inputImg forKey:@"inputImage"];
            CIImage *outputImg = [colorCube outputImage];
            
            
            CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
//            CIContext *context = [CIContext contextWithOptions: nil];
            CGImageRef newImgRef = [context createCGImage:outputImg fromRect:outputImg.extent];
            UIImage *newImg = [UIImage imageWithCGImage:newImgRef scale:1.0 orientation:UIImageOrientationUp];
            self.imgView.image = newImg;
        }
    }
}


#pragma mark  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%s", __func__);
    UIImage *pickerImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.originalImg = pickerImg;
    
    CGFloat pickImgWidth = 0;
    CGFloat pickImgHeight = 0;
    if (pickerImg.size.width > SCREENW) {
        pickImgWidth = SCREENW;
        pickImgHeight = pickerImg.size.height*(SCREENW/pickerImg.size.width);
        if (pickImgHeight > SCREENH-90-64) {
            pickImgHeight = SCREENH-90-64;
            pickImgWidth = pickerImg.size.width*((SCREENH-90-64)/pickerImg.size.height);
        }
    } else {
        pickImgWidth = pickerImg.size.width;
        pickImgHeight = pickerImg.size.height;
        if (pickImgHeight > (SCREENH-90-64)) {
            pickImgHeight = SCREENH-90-64;
            pickImgWidth = pickerImg.size.width*((SCREENH-90-64)/pickerImg.size.height);
            if (pickImgWidth > SCREENW) {
                pickImgHeight = pickerImg.size.height*(SCREENW/pickImgWidth);
                pickImgWidth = SCREENW;
            }
        }
    }
    self.imgView.frame = CGRectMake(0, 0, pickImgWidth, pickImgHeight);
    self.imgView.center = CGPointMake(SCREENW/2, 64+(SCREENH-90-64)/2);
    self.imgView.image = pickerImg;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - event response
- (void)handleAlbumAction:(UIButton *)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
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
        _filterList.backgroundColor = [UIColor orangeColor];
    }
    return _filterList;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.itemSize = CGSizeMake(66, 66);
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.footerReferenceSize = CGSizeZero;
        _flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _flowLayout;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-90)];
    }
    return _imgView;
}
@end
