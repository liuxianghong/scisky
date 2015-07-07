//
//  PersonalProfileViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "PersonalProfileTableViewCell.h"
#import "MobileAPI.h"
#import "UIImageView+WebCache.h"
#import "UserManage.h"
#import "PersonalDetailTableViewController.h"

@interface PersonalProfileViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic,weak) IBOutlet UITableView *tabelView;
@property (nonatomic,strong) NSDictionary *dicUpdateApply;
@end

@implementation PersonalProfileViewController
{
    NSArray *tableViewTitleArray;
    NSArray *tableViewValueArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SSUIStyle RoundStyle:self.headImageView];
    [self loadData];
    [self updateUI];
    [self.tabelView reloadData];
}

-(void)loadData
{
    NSDictionary *dic = @{
                          @"id": [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]
                          };
    [MobileAPI UserGetUserByIdWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [MobileAPI saveUserImformatin:responseObject[@"data"]];
        [MobileAPI saveUserImformatin2:responseObject[@"data"]];
        self.dicUpdateApply = responseObject[@"data"][@"updateApply"];
        [self updateUI];
        [self.tabelView reloadData];
        //        if ([[responseObject[@"state"] safeString] integerValue] == 0) {
        //
        //        }
        //        else if([[responseObject[@"state"] safeString] integerValue] == 3)
        //        {
        //            ;
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

-(void)updateUI
{
    
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"] longLongValue];
    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *dataNow = [formatter stringFromDate:[NSDate date]];
    NSString *databirthday = [formatter stringFromDate:birthday];
    NSString *string = [NSString stringWithFormat:@"%ld",[dataNow integerValue] - [databirthday integerValue]];
    tableViewTitleArray = @[@"年龄",@"位置",@"服务区域",@"提供服务",@"施工经验"];
    
    NSString *locationDesc = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"locationDesc"]);
    NSString *serveDistriceDesc = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serveDistriceDesc"]);
    NSString *serviceDesc = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serviceDesc"]);
    NSString *workExpDesc = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"workExpDesc"]);
    
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.phoneLabel.text = [NSString stringWithFormat:@"账号：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"]];
    
    NSString *headImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"];
    
    
    if (self.dicUpdateApply&&self.dicUpdateApply[@"state"]&&([[self.dicUpdateApply[@"state"] safeString] integerValue]==0)) {
        self.title = @"个人资料（审核中）";
        if (self.dicUpdateApply[@"headimage"]) {
            headImage = [self.dicUpdateApply[@"headimage"] safeString];
        }
        
        if (self.dicUpdateApply[@"nickname"]) {
            self.nameLabel.text = [self.dicUpdateApply[@"nickname"] safeString];
        }
        
        if ([[self.dicUpdateApply[@"location_desc"] safeString] length]>0) {
            locationDesc = StringNoNull([self.dicUpdateApply[@"location_desc"] safeString]);
        }
        if ([[self.dicUpdateApply[@"serve_district_desc"] safeString] length]>0) {
            serveDistriceDesc = StringNoNull([self.dicUpdateApply[@"serve_district_desc"] safeString]);
        }
        if ([[self.dicUpdateApply[@"service_desc"] safeString] length]>0) {
            serviceDesc = StringNoNull([self.dicUpdateApply[@"service_desc"] safeString]);
        }
        if ([[self.dicUpdateApply[@"work_experience_desc"] safeString] length]>0) {
            workExpDesc = StringNoNull([self.dicUpdateApply[@"work_experience_desc"] safeString]);
        }
        
    }
    else
    {
        self.title = @"个人资料";
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.213.239/sciskyResource/%@",headImage]] placeholderImage:[UIImage imageNamed:@"Modify-data-Avatar"]];
    
    tableViewValueArray = @[string,locationDesc,serveDistriceDesc,serviceDesc,workExpDesc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SSUIStyle RoundStyle:self.headImageView];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"modif"]) {
        PersonalDetailTableViewController *vc = segue.destinationViewController;
        vc.dicUpdateApply = self.dicUpdateApply;
    }
    
}


@end
