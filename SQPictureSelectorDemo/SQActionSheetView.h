//
//  SQActionSheetView.h
//  SQPictureSelectorDemo
//
//  Created by zhihu.huang on 2017/4/14.
//  Copyright © 2017年 SNQU. All rights reserved.
//
/****************************************************************************************/
/*
 本类选择图片的弹出框
 */
/****************************************************************************************/

#import <UIKit/UIKit.h>

@protocol SQActionSheetViewDelegate;

@interface SQActionSheetView : UIView

@property (weak, nonatomic) id delegate;
- (id)initWithTitle:(NSString *)title
           delegate:(id < SQActionSheetViewDelegate >)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitles:(NSArray *)destructiveButtonTitles
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (id)initWithTitle:(NSString *)title
           delegate:(id < SQActionSheetViewDelegate >)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitles:(NSArray *)destructiveButtonTitles
otherButtonTitlesArray:(NSArray *)otherButtonTitles;

- (void)show;
- (void)dismiss;

- (void)enableButton:(BOOL)enable withIndex:(NSUInteger)buttonIndex;

- (void)showInView:(UIView *)view;
@end

@protocol SQActionSheetViewDelegate <NSObject>

@optional

- (void)goActionSheet:(SQActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
