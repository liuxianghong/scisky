//
//  ForgetPWViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "MobileAPI.h"
#import "ReactiveCocoa.h"

@interface ForgetPWViewController ()
@property (nonatomic,weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic,weak) IBOutlet UITextField *codeTextField;
@property (nonatomic,weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic,weak) IBOutlet UITextField *repasswordTextField;
@property (nonatomic,weak) IBOutlet UIButton *codeButton;
@end

@implementation ForgetPWViewController
{
    NSTimer *countDownTimer;
    long timeCount;
    
    NSString *code;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
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
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repasswordTextField resignFirstResponder];
    if (countDownTimer) {
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
    if ([self.phoneTextField.text length]<11) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    [self.codeButton setTitle:@"发送中" forState:UIControlStateNormal];
    NSDictionary *dicParameters = @{
                          @"mobile" : self.phoneTextField.text
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

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)loginClick:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repasswordTextField resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    
    if ([self.phoneTextField.text length]<11) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.codeTextField.text length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输验证码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.codeTextField.text isEqualToString:code]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"验证码错误";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if([self.passwordTextField.text length]<6)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"密码长度至少6位";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.repasswordTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"两次密码不一致";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    hud.detailsLabelText = @"登陆中";
    NSDictionary *dicParameters = @{
                                    @"loginname" : self.phoneTextField.text,
                                    @"password" : self.codeTextField.text
                                    };
    [MobileAPI CodeChangePasswordWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![MobileAPI getErrorStringWithState:responseObject[@"state"]])
        {
            [MobileAPI UserLoginWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                if(![MobileAPI getErrorStringWithState:responseObject[@"state"]])
                {
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = @"登陆成功";
                    [hud hide:YES afterDelay:0.2f];
                    [MobileAPI saveUserImformatin:responseObject[@"data"]];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = @"登陆失败";
                    [hud hide:YES afterDelay:1.5f];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = error.domain;
                [hud hide:YES afterDelay:1.5f];
            }];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"登陆失败";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
    
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
