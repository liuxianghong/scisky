//
//  RegisterViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic,weak) IBOutlet UIButton *btnSeeFile;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect tableViewHeaderRect = self.tableView.tableHeaderView.frame;
    tableViewHeaderRect.size.height = 40.0f;
    [self.tableView.tableHeaderView setFrame:tableViewHeaderRect];
    
    CGRect tableViewFooterRect = self.tableView.tableFooterView.frame;
    tableViewFooterRect.size.height = 78.0f+10;
    [self.tableView.tableFooterView setFrame:tableViewFooterRect];
    
    [SSUIStyle ButtonAttributedTitle:self.btnSeeFile title:@"水性科天用户服务协议"];
    
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextClick:(id)sender
{
    [self performSegueWithIdentifier:@"PerfectData" sender:nil];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
