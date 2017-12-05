//
//  SQUIImagePickerController.h
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/4/19.
//  Copyright © 2017年 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SQUIImagePickerController;

@protocol SQUIImagePickerControllerDelegate <NSObject>

@optional

- (void)sqImagePickerControllerDidFinish:( SQUIImagePickerController * _Nonnull )picker;
- (void)sqImagePickerControllerDidCancel:(SQUIImagePickerController * _Nonnull)picker;
- (void)sqImagePickerControllerOverMaxCount:(SQUIImagePickerController * _Nonnull)picker;
- (BOOL)sqImagePickerController:(SQUIImagePickerController * _Nonnull)picker shouldSelectImage:(UIImage * _Nonnull)image;

@end


@interface SQUIImagePickerController : UIImagePickerController

@property (strong, readonly, nonatomic)  NSArray * _Nonnull images;
@property (assign, readwrite, nonatomic) NSInteger maxImageCount;
@property (assign, readwrite, nonatomic) NSString* _Nonnull doneButtonTitle;
@property (weak, nullable, nonatomic) id<SQUIImagePickerControllerDelegate> msDelegate;



@end


