//
//  SQPictureSelector.h
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/4/14.
//  Copyright © 2017年 SNQU. All rights reserved.
//
/*
 图片选择器，支持单选，多选
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSArray *images);

@interface SQPictureSelector : NSObject

@property (copy, nonatomic) SelectBlock block;

/**
 打开相机，系统方法

 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showTakePhotoWithController: (UIViewController *)Controller
                       andWithBlock: (SelectBlock)block;

/**
 选择相册，系统方法，只能选择一张图片

 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showPhotosAlbumWithController: (UIViewController *)Controller
                        andWithBlock: (SelectBlock)block;

/**
 选择图库，系统方法，只能选择一张图片
 
 @param Controller 控制器对象
 @param block 照片回调
 */
- (void)showPhotoLibraryWithController: (UIViewController *)Controller
                        andWithBlock: (SelectBlock)block;


/**
 选择图库,自定义方法，可以选择多张照片

 @param Controller 控制器对象
 @param count 照片数量
 @param block 照片回调
 */
- (void)showPhotosWithController: (UIViewController *)Controller
                   maxImageCount: (NSInteger)count
                    andWithBlock: (SelectBlock)block;




@end
