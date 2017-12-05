//
//  SQPictureSelector.m
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/4/14.
//  Copyright © 2017年 SNQU. All rights reserved.
//

#import "SQPictureSelector.h"
#import "UIImage+FixOrientation.h"
#import "SQUIImagePickerController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define IOS8L [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

@interface SQPictureSelector()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, SQUIImagePickerControllerDelegate>
{
    ALAssetsLibrary  *_library;
    NSMutableArray   *_indexArray;
    NSMutableArray   *_albumsArray;
    NSMutableArray   *_imagesAssetArray;
}
/**
 *  相册选择器
 */
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SQPictureSelector

- (instancetype)init
{
    self = [super init];
    if (self) {
        _picker = [[UIImagePickerController alloc] init];
        _images = [NSMutableArray arrayWithCapacity:0];
        
        _library = [[ALAssetsLibrary alloc] init];
        _indexArray = [NSMutableArray array];

    }
    return self;
}
/**
 打开相机
 
 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showTakePhotoWithController: (UIViewController *)Controller
                       andWithBlock: (SelectBlock)block
{
    //回调
    _block = block;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    [_images removeAllObjects];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        _picker.delegate = self;
        _picker.sourceType = sourceType;
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = YES;
    
        [Controller presentViewController:_picker animated:YES completion:nil];
        
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    
}

/**
 选择相册
 
 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showPhotosAlbumWithController: (UIViewController *)Controller
                         andWithBlock: (SelectBlock)block
{
    _block = block;
    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [_images removeAllObjects];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        _picker.delegate = self;
        
        //设置选择后的图片可被编辑
        _picker.allowsEditing = YES;
        
        [Controller presentViewController:_picker animated:YES completion:nil];
    }else{
         NSLog(@"模拟其中无法打开相册,请在真机中使用");
    }
   
}

/**
 选择图库
 
 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showPhotoLibraryWithController: (UIViewController *)Controller
                          andWithBlock: (SelectBlock)block
{
    _block = block;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [_images removeAllObjects];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        _picker.delegate = self;
        
        //设置选择后的图片可被编辑
        
        _picker.allowsEditing = YES;
        
        [Controller presentViewController:_picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟其中无法打开相册,请在真机中使用");
    }

}
//当一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    [_images removeAllObjects];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //图片可编辑
        UIImage *newHeaderImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        newHeaderImage = [newHeaderImage fixOrientation];
        
        [_images addObject:newHeaderImage];
        
        if (self.block)
        {
            
            self.block(_images);
            
            [_picker dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

// 取消选择照片:
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 选择图库
 
 @param Controller 控制器对象
 @param count 照片数量
 @param block 照片回调
 */
- (void)showPhotosWithController: (UIViewController *)Controller
                   maxImageCount: (NSInteger)count
                    andWithBlock: (SelectBlock)block
{
    _block = block;
    [_images removeAllObjects];
    SQUIImagePickerController *picker = [[SQUIImagePickerController alloc] init];
    picker.msDelegate = self;
    picker.maxImageCount = count;
    picker.doneButtonTitle = @"选择";
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [Controller presentViewController:picker animated:true completion:nil];
}
#pragma mark - SQUIImagePickerControllerDelegate method
- (void)sqImagePickerControllerDidCancel:(SQUIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
    NSLog(@"do cancel");
}

- (void)sqImagePickerControllerDidFinish:(SQUIImagePickerController *)picker {
    
    [_images addObjectsFromArray:picker.images];
    
    if (_block) {
        _block(_images);
        [picker dismissViewControllerAnimated:true completion:^{
            
        }];
    }
    
}

- (void)sqImagePickerControllerOverMaxCount:(SQUIImagePickerController *)picker; // 选择的图片超过上限的时候调用
{
    NSString* message = [NSString stringWithFormat:@"你最多只能选择%ld张图片。", picker.maxImageCount];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}


- (NSArray *)handlePhotoGroups
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
        return nil;
    }
    if (IOS8L) {
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

    }else{
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
                        // result 为 nil，即遍历相片或视频完毕，可以展示资源列表
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    }
                }];
                
            }else{
                if ([_albumsArray count]) {
                    // 把所有的相册储存完毕，可以展示相册列表
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                    });
                } else {
                    NSLog(@"没有任何有资源的相册");
                }
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"访问失败：%@",error.description);
        }];

    }
    return _albumsArray;

}
- (NSArray *)handleAllPhotos
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
        return nil;
    }

    if (IOS8L) {
        // 获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        [_imagesAssetArray addObjectsFromArray:(NSArray *)assetsFetchResults];

    }else{
        //遍历资源库中所有的相册,有多少个相册,usingBlock会调用多少次
        [_library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
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
                        // result 为 nil，即遍历相片或视频完毕，可以展示资源列表
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    }
                }];
                
            }else{
                if ([_albumsArray count]) {
                    // 把所有的相册储存完毕，可以展示相册列表
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                } else {
                    NSLog(@"没有任何有资源的相册");
                }
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"访问失败：%@",error.description);
        }];

    }
    return _imagesAssetArray;
}
@end
