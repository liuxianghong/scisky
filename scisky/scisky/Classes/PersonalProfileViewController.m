//
//  PersonalProfileViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "PersonalProfileTableViewCell.h"

@interface PersonalProfileViewController ()

@end

@implementation PersonalProfileViewController
{
    NSArray *tableViewTitleArray;
    NSArray *tableViewValueArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableViewTitleArray = @[@"年龄",@"位置",@"服务区域",@"提供服务",@"施工经验"];
    tableViewValueArray = @[@"年龄",@"位置",@"服务区域",@"提供服务",@"施工经验"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.labelTitle.text = tableViewTitleArray[indexPath.row];
    cell.labelValue.text = tableViewValueArray[indexPath.row];
    // Configure the cell...
    
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
