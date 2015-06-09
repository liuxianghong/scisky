//
//  RightViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RightViewController.h"
#import "RightTableViewCell.h"

@interface RightViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightVCCell" forIndexPath:indexPath];
    cell.labelNum.hidden = YES;
    if (indexPath.row==1) {
        cell.labelTitle.text = @"个人资料";
    }
    else if (indexPath.row==1) {
        cell.labelNum.hidden = NO;
        cell.labelTitle.text = @"我的施工单";
    }
    else
    {
        cell.labelTitle.text = @"修改密码";
    }
    return cell;
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
