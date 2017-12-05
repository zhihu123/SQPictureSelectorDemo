//
//  SQPictureSelectorViewController.m
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/4/27.
//  Copyright © 2017年 SNQU. All rights reserved.
//
/**
 ALAssetsLibrary.h 代表资源库(所有的视频,照片)
 ALAssetsGroup.h   代表资源库中的相册
 ALAsset.h         代表相册中一个视频或者一张照片
 ALAssetRepresentation.h 代表一个资源的描述,可以获取到原始图片
 */

#import "SQPictureSelectorViewController.h"
#import "SQPictureCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#define IOS8L [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

static NSString *cellIdentifier = @"SQPictureCollectionViewCell";

@interface SQPictureSelectorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSMutableArray   *_albumsArray;
    NSMutableArray   *_imagesAssetArray;
    ALAssetsLibrary  *_library;
    NSMutableArray   *_indexArray;
}


@end

@implementation SQPictureSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _albumsArray = [NSMutableArray array];
    _imagesAssetArray = [NSMutableArray array];
    _library = [[ALAssetsLibrary alloc] init];
    _indexArray = [NSMutableArray array];
    
    [self initBaseUI];
//    if (IOS8L) {
        [self handleImages];
//    }else{
//       [self handlePictures];
//    }
    
   
}
- (void)initBaseUI
{
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                         collectionViewLayout:layout];
    _collectionView.backgroundColor =  [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    UINib *cellNib = [UINib nibWithNibName:@"SQPictureCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];

    [self.view addSubview:_collectionView];
}
- (void)handlePictures
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        NSLog(@"%@", tipTextWhenNoPhotosAuthorization);
        return;
    }
    
    //遍历资源库中所有的相册,有多少个相册,usingBlock会调用多少次
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //如果存在相册,再遍历
        if (group) {
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            if (group.numberOfAssets) {
                // 把相册储存到数组中，方便后面展示相册时使用
                [_albumsArray addObject:group];
            }
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [_imagesAssetArray addObject:result];
                } else {
//                     result 为 nil，即遍历相片或视频完毕，可以展示资源列表
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_collectionView reloadData];
                    });
                }
            }];
            
        }else{
            if ([_albumsArray count]) {
//                 把所有的相册储存完毕，可以展示相册列表
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_collectionView reloadData];
//                });
            } else {
                NSLog(@"没有任何有资源的相册");
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"访问失败：%@",error.description);
    }];
    
    
}

- (void)handleImages
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        NSLog(@"%@", tipTextWhenNoPhotosAuthorization);
        return;
    }
#if 0
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    /*
     列出所有用户创建的相册
     PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
     */
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            NSLog(@"fetchResult:%@",fetchResult);
        }else{
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    
#endif
   // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    [_imagesAssetArray addObjectsFromArray:(NSArray *)assetsFetchResults];
    
}
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numbers = _imagesAssetArray.count;
    return numbers;
}

//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SQPictureCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (IOS8L) {
        // 在资源的集合中获取第一个集合，并获取其中的图片
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHAsset *asset = _imagesAssetArray[indexPath.row];
        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(80, 80)
                               contentMode:PHImageContentModeAspectFit
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 // 得到一张 UIImage，展示到界面上
                                 cell.pictureImageView.image = result;
                             }];

    }else{
        //取出对应的资源数据
        ALAsset *result = _imagesAssetArray[indexPath.row];
        //获取到缩略图
        CGImageRef cimg = [result thumbnail];
        //转换为UIImage
        UIImage *img = [UIImage imageWithCGImage:cimg];
        cell.pictureImageView.image = img;
        
        
        /**
         *  获取到原始图片
         ALAssetRepresentation *presentation = [result defaultRepresentation];
         
         CGImageRef resolutionImg = [presentation fullResolutionImage];
         */

    }
    
    return cell;
}
//设置单元格宽度
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:
(NSIndexPath *)indexPath{
    
    return CGSizeMake(80,80);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_indexArray.count > 2) {
        return NO;
    }
    return YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_indexArray addObject:[NSNumber numberWithInteger:indexPath.row]];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_indexArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
