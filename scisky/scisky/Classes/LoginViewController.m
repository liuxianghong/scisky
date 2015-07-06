//
//  LoginViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LoginViewController.h"
#import "IHKeyboardAvoiding.h"
#import "MobileAPI.h"
#import "UserManage.h"

@interface LoginViewController ()
@property (nonatomic,weak) IBOutlet UITextField *textFiledPhone;
@property (nonatomic,weak) IBOutlet UITextField *textFiledPassWord;

@property (nonatomic,weak) IBOutlet UIButton *buttomButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    [self.textFiledPassWord setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    self.textFiledPassWord.tintColor = [UIColor whiteColor];
//    [self.textFiledPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    self.textFiledPhone.tintColor = [UIColor whiteColor];
    
//    self.textFiledPhone.text = @"18175152488";
//    self.textFiledPassWord.text = @"111111";
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textFiledPhone resignFirstResponder];
    [self.textFiledPassWord resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [IHKeyboardAvoiding setAvoidingView:self.view withTarget:self.buttomButton];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [IHKeyboardAvoiding removeTarget:self.buttomButton];
    [self.textFiledPhone resignFirstResponder];
    [self.textFiledPassWord resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginClick:(id)sender
{
    [self.textFiledPhone resignFirstResponder];
    [self.textFiledPassWord resignFirstResponder];
    NSString *loginName = self.textFiledPhone.text;
    NSString *password = self.textFiledPassWord.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    
    if (![loginName checkTel]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([password length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入密码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    hud.detailsLabelText = @"登陆中";
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSDictionary *dic = @{
                          @"loginname": loginName,
                          @"password": password,
                          @"deviceType" : @1,
                          @"deviceToken" : deviceToken?deviceToken:@" "
                          };
    [MobileAPI UserLoginWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(![MobileAPI getErrorStringWithState:responseObject[@"state"]])
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"登陆成功";
            [hud hide:YES];
            [MobileAPI saveUserImformatin:responseObject[@"data"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if([responseObject[@"state"] integerValue]==1)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"密码错误，请重新输入";
            [hud hide:YES afterDelay:1.5f];
        }
        else if([responseObject[@"state"] integerValue]==2)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"用户名错误，请重新输入";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"未知错误";
            [hud hide:YES afterDelay:1.5f];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
    //[[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:@"UID"];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
