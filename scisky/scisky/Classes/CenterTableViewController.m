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

@interface CenterTableViewController ()<centerTableViewCellDelegate,UIAlertViewDelegate>

@end

@implementation CenterTableViewController
{
    BOOL first;
    NSArray *tableArray;
    
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
    

    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refreshData];
    }];
    first = YES;
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
            tableArray = responseObject[@"data"];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.header endRefreshing];
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
    first = YES;
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
    };
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
