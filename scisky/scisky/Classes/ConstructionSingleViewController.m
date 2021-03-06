//
//  ConstructionSingleViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ConstructionSingleViewController.h"
#import "CenterTableViewCell.h"
#import "MJRefresh.h"
#import "MobileAPI.h"
#import "ConstructionSingleDetailTableViewController.h"

@interface ConstructionSingleViewController ()<UITableViewDataSource,UITableViewDelegate,centerTableViewCellDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ConstructionSingleViewController
{
    NSArray *type1Array;
    NSArray *type2Array;
    NSArray *type3Array;
    
    BOOL type1Need;
    BOOL type2Need;
    BOOL type3Need;
    
    NSInteger type;
    
    BOOL first;
    
    NSDictionary *cancelDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGRect tableViewHeaderRect = self.tableView.tableHeaderView.frame;
    tableViewHeaderRect.size.height = 10.0f;
    [self.tableView.tableHeaderView setFrame:tableViewHeaderRect];
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refreshData];
    }];
    first = YES;
    type = 1;
    
    type1Need = YES;
    type2Need = YES;
    type3Need = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:@"receiveRemoteNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (NSDictionary *dic in type1Array) {
        if ([dic[@"orderStatus"] integerValue]!=1) {
            first = YES;
            type1Need = YES;
            type2Need = YES;
            type3Need = YES;
            break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if (first)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]) {
            [self readData];
            //first = NO;
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveRemoteNotification
{
    [self loadData:1];
//    if (type==1) {
//        [self.tableView.header beginRefreshing];
//    }
//    else
//        [self loadData:1];
}

-(void)refreshData
{
    [self loadData:type];
}

-(void)loadData:(NSInteger)index
{
    __block NSInteger blockType = index;
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"] safeString];
    if (uid) {
        NSDictionary *dicParameters = @{
                                        @"supplierId" : uid,
                                        @"orderStatus" : @(index)
                                        };
        [MobileAPI GetSupplierOrderListWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [self.tableView.header endRefreshing];
            NSMutableArray *tableArray = [[NSMutableArray alloc]init];
            for(NSMutableDictionary *dic in responseObject[@"data"])
            {
                NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
                for (NSString *key in [dic allKeys]) {
                    [dic2 setObject:dic[key] forKey:key];
                }
                //[dic mutableCopy];//[[NSMutableDictionary alloc]initWithDictionary:[dic mutableCopy]];
                [tableArray addObject:dic2];
            }
            if (blockType==1) {
                type1Array = tableArray;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",[tableArray count]] forKey:@"ordeNewCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if(blockType==2) {
                type2Array = tableArray;
            }
            else {
                type3Array = tableArray;
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.header endRefreshing];
        }];
    }
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectClick:(UISegmentedControl *)sender
{
    type = sender.selectedSegmentIndex + 1;
    [self readData];
}

-(void)readData
{
    BOOL need = type==1?type1Need:(type==2?type2Need:type3Need);
    if (!need) {
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView.header beginRefreshing];
        if (type==1) {
            type1Need = NO;
        }
        else if(type==2)
        {
            type2Need = NO;
        }
        else
            type3Need = NO;
        
    }
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
    if (type==1) {
        return [type1Array count];
    }
    else if(type==2) {
        return [type2Array count];
    }
    else {
        return [type3Array count];
    }
    return 0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 241;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    NSDictionary *dic = nil;
    if (type==1) {
        dic = type1Array[indexPath.row];
    }
    else if(type==2) {
        dic = type2Array[indexPath.row];
    }
    else {
        dic = type3Array[indexPath.row];
    }
    [cell setData:dic];
    
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
    NSDictionary *dic = nil;
    if (type==1) {
        dic = type1Array[indexPath.row];
    }
    else if(type==2) {
        dic = type2Array[indexPath.row];
    }
    else {
        dic = type3Array[indexPath.row];
    }
    cell.labelContent.text = StringNoNull([dic[@"serviceContent"] safeString]);
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
    else if (index==1) {
        [self performSegueWithIdentifier:@"ConstructionSingleDetail" sender:cell.dic];
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
                        NSNotification *notification =[NSNotification notificationWithName:@"orderCancel" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ConstructionSingleDetail"]) {
        ConstructionSingleDetailTableViewController *vc = segue.destinationViewController;
        vc.dic = sender;
    }
}


@end
