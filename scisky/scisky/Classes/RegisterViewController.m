//
//  RegisterViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterViewController.h"
#import "PerfectDataTableViewController.h"
#import "MobileAPI.h"

@interface RegisterViewController ()
@property (nonatomic,weak) IBOutlet UITextField *phoneTf;
@property (nonatomic,weak) IBOutlet UITextField *codeTf;
@property (nonatomic,weak) IBOutlet UITextField *pwTf;
@property (nonatomic,weak) IBOutlet UITextField *rePwTf;
@property (nonatomic,weak) IBOutlet UIButton *codeButton;

@property (nonatomic,weak) IBOutlet UIButton *btnSeeFile;
@end

@implementation RegisterViewController
{
    NSTimer *countDownTimer;
    long timeCount;
    
    NSString *code;
}

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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneTf resignFirstResponder];
    [self.codeTf resignFirstResponder];
    [self.pwTf resignFirstResponder];
    [self.rePwTf resignFirstResponder];
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *recordTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastTimeGetCapthaTime"];
    if (recordTime) {
        long nowTime = [[NSDate date]timeIntervalSince1970];
        long interval = (nowTime - [recordTime longValue]);
        if (interval >= 60) {
            [self.codeButton setEnabled:YES];
        }
        else{
            [self.codeButton setEnabled:NO];
            [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
            timeCount = 60-interval;
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
        
    }
}

- (void)countDown
{
    timeCount --;
    if (timeCount > 0) {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
    }
    else{
        [self.codeButton setEnabled:YES];
        [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)sendClick:(id)sender
{
    if (![self.phoneTf.text checkTel]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    [self.codeButton setTitle:@"发送中" forState:UIControlStateNormal];
    NSDictionary *dicParameters = @{
                                    @"mobile" : self.phoneTf.text
                                    };
    [MobileAPI GetVerificationCodeWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        if(![MobileAPI getErrorStringWithState:dic[@"state"]])
        {
            code = dic[@"data"];
            long nowTime = [[NSDate date]timeIntervalSince1970];
            [[NSUserDefaults standardUserDefaults]setObject:@(nowTime) forKey:@"LastTimeGetCapthaTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.codeButton setEnabled:NO];
            [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
            timeCount = 60;
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = [MobileAPI getErrorStringWithState:responseObject[@"state"]];
            [hud hide:YES afterDelay:1.5f];
            [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }];
    
}

-(IBAction)nextClick:(id)sender
{
    [self.phoneTf resignFirstResponder];
    [self.codeTf resignFirstResponder];
    [self.pwTf resignFirstResponder];
    [self.rePwTf resignFirstResponder];
    
    if (![self.phoneTf.text checkTel]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.codeTf.text length]<1) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输验证码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.codeTf.text isEqualToString:code]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"验证码错误";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if([self.pwTf.text length]<6)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"密码长度至少6位";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.pwTf.text isEqualToString:self.rePwTf.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"两次密码不一致";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
     
    [self performSegueWithIdentifier:@"PerfectData" sender:nil];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"PerfectData"])
    {
        PerfectDataTableViewController *vc = segue.destinationViewController;
        vc.phoneNumber = self.phoneTf.text;
        vc.passWord = self.pwTf.text;
    }
}


@end
