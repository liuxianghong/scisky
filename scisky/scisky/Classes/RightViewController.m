//
//  RightViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RightViewController.h"
#import "RightTableViewCell.h"
#import "IIViewDeckController.h"
#import "MoneyViewController.h"
#import "UIImageView+WebCache.h"
#import "MobileAPI.h"

@interface RightViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic,weak) IBOutlet UIImageView *headImage;

@property (nonatomic,weak) IBOutlet UILabel *constructionSingleLabel;
@property (nonatomic,weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic,weak) IBOutlet UILabel *commissionLabel;

@property (nonatomic,weak) IBOutlet UIView *constructionSingleView;
@property (nonatomic,weak) IBOutlet UIView *balanceView;
@property (nonatomic,weak) IBOutlet UIView *commissionView;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end

@implementation RightViewController
{
    NSString *constructionSingle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [SSUIStyle ViewaddGestureRecognizer:self.constructionSingleView WithTarget:self action:@selector(ShowConstructionSingle:)];
    [SSUIStyle ViewaddGestureRecognizer:self.balanceView WithTarget:self action:@selector(ShowbalanceView:)];
    [SSUIStyle ViewaddGestureRecognizer:self.commissionView WithTarget:self action:@selector(ShowcommissionView:)];
    
    self.constructionSingleLabel.text = @"0";
    self.balanceLabel.text = @"¥0";
    self.commissionLabel.text = @"0";
    constructionSingle = @"0";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.213.239/sciskyResource/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"]]] placeholderImage:[UIImage imageNamed:@"Personal-Center-Avatar.png"]];
    
    [SSUIStyle RoundStyle:self.headImage];
    
    [self getUserStatistics];
}

-(void)getUserStatistics
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]) {
        NSDictionary *dic = @{
                              @"supplierId": [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]
                              }
        ;
        [MobileAPI GetUserStatisticsWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject[@"state"] safeString] integerValue]==0)
            {
                NSDictionary *dicData = responseObject[@"data"];
                constructionSingle = [dicData[@"orderCount"] safeString];
                self.constructionSingleLabel.text = [dicData[@"orderCount"] safeString];
                self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[dicData[@"balance"] safeString]];
                [[NSUserDefaults standardUserDefaults] setObject:[dicData[@"balance"] safeString] forKey:@"balance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.commissionLabel.text = [dicData[@"commissionCount"] safeString];
                [self.tableView reloadData];
            }
            else
            {
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}

-(void)ShowConstructionSingle:(UITapGestureRecognizer*)tap{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ConstructionSingle" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ConstructionSingleVC"];
    [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
}

-(void)ShowbalanceView:(UITapGestureRecognizer*)tap{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoneyViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MoneyVC"];
    vc.type = 1;
    [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
}

-(void)ShowcommissionView:(UITapGestureRecognizer*)tap{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoneyViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MoneyVC"];
    vc.type = 2;
    [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
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
    
    if (indexPath.row==0) {
        cell.labelTitle.text = @"个人资料";
    }
    else if (indexPath.row==1) {
        cell.labelNum.hidden = NO;
        cell.labelNum.text = StringNoNull(constructionSingle);
        cell.labelTitle.text = @"我的施工单";
    }
    else
    {
        cell.labelTitle.text = @"修改密码";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalProfile"];
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==1) {
        [self ShowConstructionSingle:nil];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ModifPWVC"];
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
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
