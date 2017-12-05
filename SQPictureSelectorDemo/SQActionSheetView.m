//
//  SQActionSheetView.m
//  SQPictureSelectorDemo
//
//  Created by zhihu.huang on 2017/4/14.
//  Copyright © 2017年 SNQU. All rights reserved.
//

#import "SQActionSheetView.h"

#define RGBAColor(R, G, B, A)   [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]

@interface SQActionSheetView()
{
    NSMutableArray *_otherButtons;
    UIView *_superView;
}
@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation SQActionSheetView

- (id)initWithTitle:(NSString *)title
           delegate:(id < SQActionSheetViewDelegate >)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitles:(NSArray *)destructiveButtonTitles
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    va_list arg_prt;
    NSMutableArray *arg_arr = [NSMutableArray arrayWithObject:otherButtonTitles];
    id arg;
    
    va_start(arg_prt, otherButtonTitles);
    
    while ((arg = va_arg(arg_prt, id)))
    {
        [arg_arr addObject:arg];
    }
    
    va_end(arg_prt);
    
    return [self initWithTitle:title
                      delegate:delegate
             cancelButtonTitle:cancelButtonTitle
       destructiveButtonTitles:destructiveButtonTitles
        otherButtonTitlesArray:arg_arr];
}

- (id)initWithTitle:(NSString *)title
           delegate:(id < SQActionSheetViewDelegate >)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitles:(NSArray *)destructiveButtonTitles
otherButtonTitlesArray:(NSArray *)otherButtonTitles
{
    NSMutableArray *arg_arr = [NSMutableArray arrayWithArray:otherButtonTitles];
    _otherButtons = [NSMutableArray arrayWithCapacity:otherButtonTitles.count];
    CGFloat titleSpaceHeight = 0;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.delegate = delegate;
        
        CGRect f = CGRectZero;
        f.size.width = self.bounds.size.width;
        
        if (title) {
            f.size.height = 40;
            titleSpaceHeight = 40;
        }
        
        
        f.size.height = f.size.height + 16.0 * 2 + arg_arr.count * 44.0 + (arg_arr.count-1)*6.0;
        
        if (cancelButtonTitle)
        {
            f.size.height += 44.0;
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.actionSheetView = [[UIView alloc] initWithFrame:f];
        _actionSheetView.backgroundColor = [UIColor whiteColor];
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        
        [self addSubview:_maskView];
        [self addSubview:_actionSheetView];
        
        if (title)
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width -20, 45)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setNumberOfLines:0];
            [_actionSheetView addSubview:titleLabel];
        }
        
        NSString *des_titles = destructiveButtonTitles ? [destructiveButtonTitles componentsJoinedByString:@","] : @"";
        UIButton *btn = nil;
        NSInteger i = 0;
        
        for (id b in arg_arr)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 16+(i*44)+(i*5)+ titleSpaceHeight, self.bounds.size.width -20, 44);
            btn.tag = i;
            [btn setTitle:b forState:UIControlStateNormal];
            
            if (NSNotFound != [des_titles rangeOfString:b].location)
            {
                [btn setBackgroundColor:[UIColor colorWithRed:245.0/255 green:87.0/255 blue:15.0/255 alpha:1]];
            }
            else
            {
                [btn setBackgroundColor:RGBAColor(63, 137, 229, 1)];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:0.0];
            }
            
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:btn];
            [_otherButtons addObject:btn];
            
            i++;
        }
        
        if (cancelButtonTitle)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 16+(i*44)+(i*5)+ titleSpaceHeight, self.bounds.size.width -20, 44);
            btn.tag = i;
            [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [btn setBackgroundColor:RGBAColor(143, 142, 148, 1)];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:0.0];
            
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:btn];
        }
    }
    
    return self;
}

- (void)show
{
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self];
    
    CGRect f = _actionSheetView.bounds;
    f.origin.y = win.bounds.size.height + f.size.height;
    _actionSheetView.frame = f;
    
    f.origin.y = win.bounds.size.height - f.size.height;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _maskView.alpha = 0.5;
                         _actionSheetView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)showInView:(UIView *)view
{
    _superView = view;
    
    [view addSubview:self];
    
    CGRect f = _actionSheetView.bounds;
    f.origin.y = view.bounds.size.height + f.size.height;
    _actionSheetView.frame = f;
    
    f.origin.y = view.bounds.size.height - f.size.height;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _maskView.alpha = 0.5;
                         _actionSheetView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)dismissFromView
{
    
    CGRect f = _actionSheetView.bounds;
    f.origin.y = _superView.bounds.size.height + f.size.height;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _maskView.alpha = 0.0;
                         _actionSheetView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         _superView = nil;
                     }];
    
}

- (void)dismiss
{
    NSInteger count =[UIApplication sharedApplication].windows.count;
    UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:count-1];
    
    CGRect f = _actionSheetView.bounds;
    f.origin.y = win.bounds.size.height + f.size.height;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _maskView.alpha = 0.0;
                         _actionSheetView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark -

- (void)enableButton:(BOOL)enable withIndex:(NSUInteger)buttonIndex
{
    if (buttonIndex < _otherButtons.count) {
        [[_otherButtons objectAtIndex:buttonIndex] setEnabled:enable];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (_superView) {
        [self dismissFromView];
    } else {
        [self dismiss];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(goActionSheet:clickedButtonAtIndex:)])
    {
        [_delegate goActionSheet:self clickedButtonAtIndex:sender.tag];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
