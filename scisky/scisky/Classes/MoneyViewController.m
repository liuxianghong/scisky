//
//  MoneyViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/12.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyTableViewCell.h"
#import "MobileAPI.h"
#import "ConstructionSingleDetailTableViewController.h"

@interface MoneyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;

@property (nonatomic,weak) IBOutlet UILabel *labelNoPaid;
@property (nonatomic,weak) IBOutlet UILabel *labelPaid;
@property (nonatomic,weak) IBOutlet UILabel *labelTime;
@property (nonatomic,weak) IBOutlet UILabel *labelPaidMun;

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@end

@implementation MoneyViewController
{
    NSArray *tableViewArray;
    
    double sum;
    double balance;
    double paidMoney;
    double moeny;
    
    long nyear;
    long nmonth;
    long nowYear;
    long nowMonth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [UIView new];
    
    self.title = self.type==1?@"余额":@"提成单";
    if (self.type==1) {
        self.titleLabel.text = @"余额";
    }
    
    moeny = [[[NSUserDefaults standardUserDefaults]objectForKey:@"balance"] doubleValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    //long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    //nday=[comps day];//获取日期对应的长整形字符串
    nowYear = nyear = [comps year];//获取年对应的长整形字符串
    nowMonth = nmonth = [comps month];//获取月对应的长整形字符串
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.dimBackground = YES;
    //hud.detailsLabelText = @"加载中";
    if (self.type==2) {
//        __block long year = nyear;
//        __block long month = nmonth;
        NSDictionary *dic2 = @{
                               @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                               @"timeCondition": [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",nyear,nmonth]
                               };
        sum = 0;
        balance = 0;
        paidMoney = 0;
        tableViewArray = nil;
        [MobileAPI GetCommissionStatisticsWithParameters:dic2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            tableViewArray = responseObject[@"data"][@"commissionList"];
            
            for(NSDictionary *dic in tableViewArray)
            {
                paidMoney += [[dic[@"price"] safeString] doubleValue];
            }
            [self upDateUI];
            [hud hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hide:YES];
            [self upDateUI];
        }];
    }
    else
    {
        sum = 0;
        balance = 0;
        paidMoney = 0;
        tableViewArray = nil;
        NSDictionary *dic2 = @{
                               @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                               @"timeCondition": [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",nyear,nmonth]
                               };
        [MobileAPI GetOrderStatisticsWithParameters:dic2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dic = responseObject[@"data"];
            balance = [[dic[@"balance"] safeString] doubleValue];
            sum = [[dic[@"sum"] safeString] doubleValue];
            tableViewArray = dic[@"orderList"];
            for(NSDictionary *dic in tableViewArray)
            {
                paidMoney += [[dic[@"orderPrice"] safeString] doubleValue];
            }
            [self upDateUI];
            [hud hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self upDateUI];
            [hud hide:YES];
        }];
        
//        [MobileAPI GetOrderPaymentsWithParameters:dic2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            ;
//        }];
    }
}

-(void)upDateUI
{
    if (self.type==2) {
        self.labelTime.text = [NSString stringWithFormat:@"%ld年%02ld月账单",nyear,nmonth] ;
        self.labelNoPaid.text = [NSString stringWithFormat:@"¥%.2f",(paidMoney+balance-sum)];
        self.labelPaid.text = [NSString stringWithFormat:@"¥%.2f",paidMoney];
        self.labelPaidMun.text = [NSString stringWithFormat:@"%ld项",[tableViewArray count]];
        [self.tableView reloadData];
    }
    else
    {
        self.labelTime.text = [NSString stringWithFormat:@"%ld年%02ld月账单",nyear,nmonth] ;
        self.labelNoPaid.text = [NSString stringWithFormat:@"¥%.2f",moeny];
        self.labelPaid.text = [NSString stringWithFormat:@"¥%.2f",paidMoney];
        self.labelPaidMun.text = [NSString stringWithFormat:@"%ld项",[tableViewArray count]];
        [self.tableView reloadData];
    }
}

-(IBAction)leftClick:(id)sender
{
    if (nmonth==1) {
        nmonth = 12;
        nyear--;
    }
    else
    {
        nmonth--;
    }
    [self loadData];
}

-(IBAction)rightClick:(id)sender
{
    if (nyear==nowYear&&nmonth==nowMonth) {
        return;
    }
    if (nmonth==12) {
        nmonth = 1;
        nyear ++;
    }
    else
    {
        nmonth ++;
    }
    [self loadData];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 + [tableViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell1";
    if (indexPath.row>0&&indexPath.row<([tableViewArray count]+1)&&self.type==2) {
        cellIdentifier = @"cell2";
    }
    MoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    
    if (indexPath.row==0) {
        cell.nameLabel.text = @"承上结余";
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",balance] ;
        cell.timeLabel.text = [NSString stringWithFormat:@"%ld年%02ld月",nyear,nmonth] ;
    }
    else if(indexPath.row==([tableViewArray count]+1)) {
        cell.nameLabel.text = @"已结算";
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",sum] ;
        cell.timeLabel.text = [NSString stringWithFormat:@"%ld年%02ld月",nyear,nmonth];
    }
    else if(indexPath.row==([tableViewArray count]+2)) {
        cell.nameLabel.text = @"未结算";
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",(paidMoney+balance-sum)] ;
        cell.timeLabel.text = [NSString stringWithFormat:@"%ld年%02ld月",nyear,nmonth];
    }
    else if (self.type != 1) {
        NSDictionary *dic = tableViewArray[indexPath.row-1];
        cell.nameLabel.text = [dic[@"customerName"] safeString];
        long time = [[dic[@"createTime"] safeString] longLongValue];
        NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *databirthday = [formatter stringFromDate:birthday];
        cell.timeLabel.text = databirthday;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"] safeString]] ;
        cell.oredLabel.text = [NSString stringWithFormat:@"订单号:%@",[dic[@"orderId"] safeString]] ;
    }
    else
    {
        NSDictionary *dic = tableViewArray[indexPath.row-1];
        cell.nameLabel.text = [dic[@"customerName"] safeString];
        long time = [[dic[@"publishTime"] safeString] longLongValue];
        NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *databirthday = [formatter stringFromDate:birthday];
        cell.timeLabel.text = databirthday;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"orderPrice"] safeString]] ;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0&&indexPath.row<([tableViewArray count]+1)&&self.type==1) {
        NSDictionary *dic = tableViewArray[indexPath.row-1];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ConstructionSingle" bundle:nil];
        ConstructionSingleDetailTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ConstructionSingleDetail"];
        vc.dic = dic;
        [self.navigationController pushViewController:vc animated:YES];
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
