//
//  LeftTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LeftTableViewController.h"
#import "IIViewDeckController.h"
#import "MobileAPI.h"
#import "UserManage.h"

@interface LeftTableViewController ()<UIAlertViewDelegate>

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:37/255.0 green:108/255.0 blue:150/255.0 alpha:1.0f];
    //把多余的表格行隐藏掉
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.scrollEnabled = NO;
    //让表格的分割线到表格的最左端显示
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        return tableView.height-tableView.tableHeaderView.height - 45*6 -20;
    }
    else
        return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"b2bapp"];
        [self.viewDeckController.theNavigationController pushViewController:loginVC animated:YES];
        
    }
    else if (indexPath.row==1) {
        ;
    }
    else if (indexPath.row==2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"ketianxieyi"];
        [self.viewDeckController.theNavigationController pushViewController:loginVC animated:YES];
        
    }
    else if(indexPath.row==3)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FeedBackVC"];
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row==4)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RecommendVC"];
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row==6)
    {
        UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aview show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"]) {
            NSDictionary *dic = @{
                                  @"loginname" : [[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"]
                                  };
            [MobileAPI UserLogoutPassWordWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                ;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ;
            }];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UID"];
        [UserManage sharedManager].decs = nil;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.viewDeckController.theNavigationController presentViewController:loginVC animated:YES completion:nil];
        [self.viewDeckController closeLeftViewAnimated:YES];
        NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
