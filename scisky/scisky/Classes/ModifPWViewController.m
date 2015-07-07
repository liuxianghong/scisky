//
//  ModifPWViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ModifPWViewController.h"
#import "MobileAPI.h"
#import "MBProgressHUD.h"
#import "IIViewDeckController.h"

@interface ModifPWViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UITextField *oldpwTf;
@property (nonatomic,weak) IBOutlet UITextField *newpwTf;
@property (nonatomic,weak) IBOutlet UITextField *reppwTf;
@end

@implementation ModifPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitClick:(id)sender
{
    [self.oldpwTf resignFirstResponder];
    [self.newpwTf resignFirstResponder];
    [self.reppwTf resignFirstResponder];
    if(self.oldpwTf.text.length<1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入旧密码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    
    if(self.newpwTf.text.length<1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入至少6位新密码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if([self.newpwTf.text length]<6)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"新密码长度至少6位";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.newpwTf.text isEqualToString:self.reppwTf.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        //hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"两次密码不一致";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    NSDictionary *dic = @{
                          @"loginname" : [[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"],
                          @"oldpwd" : self.oldpwTf.text,
                          @"newpwd" : self.newpwTf.text
                          };
    [MobileAPI UserUpdatePassWordWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([MobileAPI getErrorStringWithState:responseObject[@"state"]]) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"修改失败";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
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
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
            
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"修改成功";
            [hud hide:YES afterDelay:1.5f];
            [self.navigationController popViewControllerAnimated:NO];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UID"];
            NSNotification *notification =[NSNotification notificationWithName:@"logout" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
