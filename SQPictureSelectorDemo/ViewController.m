//
//  ViewController.m
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/4/14.
//  Copyright © 2017年 SNQU. All rights reserved.
//

#import "ViewController.h"
#import "SQActionSheetView.h"
#import "SQPictureSelector.h"

#import "SQPictureSelectorViewController.h"


@interface ViewController ()<SQActionSheetViewDelegate>

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) SQPictureSelector *pictureSelector;

@property (retain, nonatomic) NSArray* array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _pictureSelector = [[SQPictureSelector alloc] init];
   
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(100, 100, self.view.frame.size.width - 200,80);
    [self.button setBackgroundColor:[UIColor greenColor]];
    [self.button setTitle:@"点击" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(showActionSheetView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    
}

- (void)showActionSheetView:(id)sender
{
    SQActionSheetView *sheet = [[SQActionSheetView alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                destructiveButtonTitles:nil
                                                      otherButtonTitles:@"拍照",@"相册",@"图库",@"多选",nil];
    [sheet show];

}

#pragma mark - SQActionSheetViewDelegate meth
- (void)goActionSheet:(SQActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:  //相机
            [self takePhoto];
            break;
        case 1:  //相册
            [self getPictureFromPhotosAlbum];
            break;
        case 2://图库
           [self getPictureFromPhotoLibrary];
            break;
        case 3://多选
            [self getPicturesFromALAssetsLibrary];
//            [self getPictures];
            break;
        default:
            break;
    }
}

-(void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    //打开相机
    [_pictureSelector showTakePhotoWithController:self andWithBlock:^(NSArray *images) {
        
        NSObject *data = images.count ? images[0] : [[NSObject alloc] init];
        if ([data isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)data;
            [weakSelf.button setImage:image forState:UIControlStateNormal];
        }
        
    }];
}

-(void)getPictureFromPhotosAlbum
{
     __weak typeof(self) weakSelf = self;
    //打开相册
    [_pictureSelector showPhotosAlbumWithController:self andWithBlock:^(NSArray *images) {
        NSObject *data = images.count ? images[0] : [[NSObject alloc] init];
        if ([data isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)data;
            [weakSelf.button setImage:image forState:UIControlStateNormal];
        }
    }];
    

}
- (void)getPictureFromPhotoLibrary
{
    __weak typeof(self) weakSelf = self;
    //打开图库
    [_pictureSelector showPhotoLibraryWithController:self andWithBlock:^(NSArray *images) {
        NSObject *data = images.count ? images[0] : [[NSObject alloc] init];

        if ([data isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)data;
            [weakSelf.button setImage:image forState:UIControlStateNormal];
        }
    }];
}

- (void)getPictures
{
    
    __weak typeof(self) weakSelf = self;
    //打开图库
    [_pictureSelector showPhotosWithController:self maxImageCount:3 andWithBlock:^(NSArray *images) {
        NSObject *data = images.count ? images[0] : [[NSObject alloc] init];
        if ([data isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)data;
            [weakSelf.button setImage:image forState:UIControlStateNormal];
        }
        
    }];
}

- (void)getPicturesFromALAssetsLibrary
{
    SQPictureSelectorViewController *selectorVC = [[SQPictureSelectorViewController alloc] init];
    [self.navigationController pushViewController:selectorVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
