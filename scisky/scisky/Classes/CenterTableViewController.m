//
//  CenterTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "CenterTableViewController.h"
#import "IIViewDeckController.h"
#import "CenterTableViewCell.h"
#import "MJRefresh.h"
#import "MobileAPI.h"
#import "ConstructionSingleDetailTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface CenterTableViewController ()<centerTableViewCellDelegate,UIAlertViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation CenterTableViewController
{
    BOOL first;
    NSArray *tableArray;
    
    UILabel *labelNoOreder;
    NSDictionary *cancelDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:@"receiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCancel) name:@"orderCancel" object:nil];

    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refreshData];
    }];
    first = YES;

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    labelNoOreder = [[UILabel alloc]init];
    labelNoOreder.text = @"您暂时还沒有待服务的订单！";
    labelNoOreder.textColor = [UIColor darkGrayColor];
    labelNoOreder.font = [UIFont systemFontOfSize:18];
    [labelNoOreder sizeToFit];
    [self.view addSubview:labelNoOreder];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.viewDeckController closeLeftViewAnimated:YES];
    [self.viewDeckController closeRightViewAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    for (NSDictionary *dic in tableArray) {
        if ([dic[@"orderStatus"] integerValue]!=1) {
            first = YES;
            break;
        }
    }
    
    labelNoOreder.centerX = self.view.width/2;
    labelNoOreder.centerY = self.view.height/2-30;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (first) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]) {
            [self.tableView.header beginRefreshing];
            first = NO;
        }
    }
    else
    {
        
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData
{
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"] safeString];
    if (uid) {
        NSDictionary *dicParameters = @{
                                        @"supplierId" : uid,
                                        @"orderStatus" : @1
                                        };
        [MobileAPI GetSupplierOrderListWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSMutableArray *arry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [arry addObject:dic2];
            }
            tableArray = arry;//responseObject[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",[tableArray count]] forKey:@"ordeNewCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSNotification *notification =[NSNotification notificationWithName:@"orderCountUpdate" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }];
    }
}

-(IBAction)leftClick:(id)sender
{
    [self.viewDeckController toggleLeftView];
}

-(IBAction)rightClick:(id)sender
{
    [self.viewDeckController toggleRightView];
}


- (void)logout{
    [self.viewDeckController closeRightViewAnimated:YES];
    first = YES;
}

-(void)receiveRemoteNotification
{
    [self refreshData];
}

-(void)orderCancel
{
    [self refreshData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([tableArray count]>0) {
        labelNoOreder.hidden = YES;
    }
    else
        labelNoOreder.hidden = NO;
    return [tableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setData:tableArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UILabel *label = [[UILabel alloc]init];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    CGSize size = [StringNoNull([tableArray[indexPath.row][@"serviceContent"] safeString]) calculateSize:CGSizeMake(label.width-23-119, FLT_MAX) font:label.font];
//    CGFloat height = 51+11+size.height;
    
    CenterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.labelContent.translatesAutoresizingMaskIntoConstraints = NO;
    cell.labelContent.text = StringNoNull([tableArray[indexPath.row][@"serviceContent"] safeString]);
    NSString *str = cell.labelContent.text;
    CGSize size = [str calculateSize:CGSizeMake(self.view.width-66-23, FLT_MAX) font:cell.labelContent.font];
    return size.height+138+86;
}

-(void)centerTableViewCell:(CenterTableViewCell *)cell ButtonClicked:(NSInteger)index
{
    if (index==0) {
        UIAlertView *aview = [[UIAlertView alloc]initWithTitle:@"\n\n是否取消订单\n\n" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aview.tag = 111;
        cancelDic = cell.dic;
        [aview show];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ConstructionSingle" bundle:nil];
        ConstructionSingleDetailTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ConstructionSingleDetail"];
        vc.dic = cell.dic;
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==111) {
        if (buttonIndex==1) {
            if (cancelDic) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                hud.dimBackground = YES;
                NSDictionary *dic = @{
                                      @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                                      @"id" : [cancelDic[@"id"] safeString],
                                      @"orderStatus" : @3
                                      };
                [MobileAPI UpdateOrderWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if([[responseObject[@"state"] safeString] integerValue]==0)
                    {
                        hud.detailsLabelText = @"操作成功";
                        [self.tableView.header beginRefreshing];
                    }
                    else
                    {
                        hud.detailsLabelText = @"操作失败";
                    }
                    hud.mode = MBProgressHUDModeText;
                    [hud hide:YES afterDelay:1.5];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = error.domain;
                    [hud hide:YES afterDelay:1.5];
                }];
            }
        }
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSAttributedString *emptyTitle = [[NSAttributedString alloc]initWithString:@""];
    return emptyTitle;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
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
