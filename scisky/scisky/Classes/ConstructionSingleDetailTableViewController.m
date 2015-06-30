//
//  ConstructionSingleDetailTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ConstructionSingleDetailTableViewController.h"
#import "CompanyViewController.h"
#import "DoneViewController.h"
#import "MobileAPI.h"

@interface ConstructionSingleDetailTableViewController ()<UIAlertViewDelegate>
@property (nonatomic,weak) IBOutlet UILabel *seeComLabel;

@property (nonatomic,weak) IBOutlet UILabel *orderStatusLabel;
@property (nonatomic,weak) IBOutlet UILabel *orderCodeLabel;
@property (nonatomic,weak) IBOutlet UILabel *publishTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *serviceDistrictLabel;

@property (nonatomic,weak) IBOutlet UILabel *serviceItemsLabel;
@property (nonatomic,weak) IBOutlet UILabel *customerPhoneLabel;
@property (nonatomic,weak) IBOutlet UILabel *serviceContentLabel;

@property (nonatomic,weak) IBOutlet UILabel *orderPriceLabel;
@property (nonatomic,weak) IBOutlet UILabel *orderPaidLabel;
@property (nonatomic,weak) IBOutlet UILabel *agencyNameLabel;

@property (nonatomic,weak) IBOutlet UILabel *remarkLabel;

@property (nonatomic,weak) IBOutlet UIButton *changeButton;
@end

@implementation ConstructionSingleDetailTableViewController
{
    UIImageView *imageView;
    
    NSInteger rowCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    CGRect tableViewHeaderRect = self.tableView.tableFooterView.frame;
    tableViewHeaderRect.size.height = 1.0f;
    [self.tableView.tableFooterView setFrame:tableViewHeaderRect];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.orderCodeLabel.text = StringNoNull([self.dic[@"orderCode"] safeString]);
    
    //self.labelTitle.text = StringNoNull(dic[@"customerName"]);
    
    long time = [[self.dic[@"publishTime"] safeString] longLongValue];
    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *databirthday = [formatter stringFromDate:birthday];
    self.publishTimeLabel.text = StringNoNull(databirthday);
    NSInteger type = [[self.dic[@"orderStatus"] safeString] integerValue];
    NSString *status =  type==0?@"新创建":(type == 1?@"待服务":(type==2?@"已完成":@"已取消"));
    if (type==1) {
        self.orderStatusLabel.textColor = [UIColor redColor];
        rowCount = 5;
    }
    else
    {
        self.orderStatusLabel.textColor = self.orderCodeLabel.textColor;
        rowCount = 4;
    }
    self.orderStatusLabel.text = StringNoNull(status);
    self.serviceDistrictLabel.text = StringNoNull([self.dic[@"serviceDistrictString"] safeString]);
    
    self.serviceItemsLabel.text = StringNoNull([self.dic[@"serviceItemString "] safeString]);
    self.title = [self.dic[@"customerName"] safeString];
    [SSUIStyle LabelAttributedTitle:self.customerPhoneLabel title:StringNoNull([self.dic[@"customerPhone"] safeString])];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)];
    self.customerPhoneLabel.userInteractionEnabled = YES;
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.customerPhoneLabel addGestureRecognizer:tapGestureRecognizer];
    //self.customerPhoneLabel.text = StringNoNull([self.dic[@"customerPhone"] safeString]);
    self.serviceContentLabel.text = StringNoNull([self.dic[@"serviceContent"] safeString]);
    
    self.orderPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[[self.dic[@"orderPrice"] safeString] doubleValue]];
    time = [[self.dic[@"serviceStarttime"] safeString] longLongValue];
    birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    databirthday = [formatter stringFromDate:birthday];
    self.orderPaidLabel.text = StringNoNull(databirthday);
    [SSUIStyle LabelAttributedTitle:self.agencyNameLabel title:StringNoNull([self.dic[@"agencyName"] safeString])];
    self.remarkLabel.text = StringNoNull([self.dic[@"remark"] safeString]);
    if ([[self.dic[@"agencyId"] safeString]integerValue]==0&&type==1) {
        self.changeButton.hidden = NO;
    }
    else
    {
        self.changeButton.hidden = YES;
    }
    
    
    [self.tableView reloadData];
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Order-details-bottom-frame"]];
    [self.tableView addSubview:imageView];
    [self.tableView sendSubviewToBack:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    imageView.frame =  CGRectMake(10, 10, self.tableView.width-20, self.tableView.contentSize.height-10);//CGRectInset(self.tableView.bounds, 10, 10);
}


-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)phoneCall
{
    NSString *ssss = [NSString stringWithFormat:@"tel://%@",[self.dic[@"customerPhone"] safeString]];
    NSLog(@"%@",ssss);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ssss]];
}

-(IBAction)changePriceClick:(UISegmentedControl *)sender
{
    UIAlertView *aview = [[UIAlertView alloc]initWithTitle:@"请输入价格" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    aview.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [aview textFieldAtIndex:0];
    field.keyboardType = UIKeyboardTypeDecimalPad;
    [aview show];
}

-(IBAction)doneClick:(UISegmentedControl *)sender
{
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *field = [alertView textFieldAtIndex:0];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        if (field.text.length<1) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入金额";
            [hud hide:YES afterDelay:1.5f];
        }
        
        double price = [field.text doubleValue];
        hud.dimBackground = YES;
        NSDictionary *dic = @{
                              @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                              @"id" : [self.dic[@"id"] safeString],
                              @"orderPrice" : [NSString stringWithFormat:@"%.2f",price]
                              };
        [MobileAPI UpdateOrderWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject[@"state"] safeString] integerValue]==0)
            {
                hud.detailsLabelText = @"操作成功";
                self.orderPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
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
#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //compaly
    if ([segue.identifier isEqualToString:@"compaly"]) {
        CompanyViewController *vc = segue.destinationViewController;
        vc.compId = [self.dic[@"agencyId"] safeString];
        vc.compName = [self.dic[@"agencyName"] safeString];
    }
    else if([segue.identifier isEqualToString:@"donevc"])
    {
        DoneViewController *vc = segue.destinationViewController;
        vc.dic = self.dic;
    }
}


@end
