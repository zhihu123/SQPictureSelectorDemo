//
//  SQPictureSelectorTableViewController.m
//  SQPictureSelectorDemo
//
//  Created by SNQU on 2017/5/5.
//  Copyright © 2017年 SNQU. All rights reserved.
//

#import "SQPictureSelectorTableViewController.h"
#import "SQPictureSelectorTableViewCell.h"

static NSString *identifier = @"SQPictureSelectorTableViewCell";

@interface SQPictureSelectorTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
}

@end

@implementation SQPictureSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
}

- (void)initTableView
{
    _mainTableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_mainTableView registerClass:[SQPictureSelectorTableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:_mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageGroups.count > 0 ? self.imageGroups.count : 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQPictureSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
