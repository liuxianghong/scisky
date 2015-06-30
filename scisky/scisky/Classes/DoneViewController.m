//
//  DoneViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/29.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "DoneViewController.h"
#import "MobileAPI.h"

@interface DoneViewController ()
@property (nonatomic,weak) IBOutlet UITextField *codeTextField;
@end

@implementation DoneViewController
{
    NSString *code;
}

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
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"向客户发送验证码中";
    if ([[self.dic[@"customerPhone"] safeString] length]<11) {
        
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"客户没有正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    NSDictionary *dicParameters = @{
                                    @"mobile" : [self.dic[@"customerPhone"] safeString]
                                    };
    [MobileAPI GetVerificationCodeWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        if(![MobileAPI getErrorStringWithState:dic[@"state"]])
        {
            code = dic[@"data"];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"验证码发送成功";
            [hud hide:YES afterDelay:1.5f];
        }else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = [MobileAPI getErrorStringWithState:responseObject[@"state"]];
            [hud hide:YES afterDelay:1.5f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.codeTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)okClick:(id)sender
{
    [self.codeTextField resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    if (self.codeTextField.text.length<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入验证码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.codeTextField.text isEqualToString:code]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"验证码错误";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    
    hud.dimBackground = YES;
    NSDictionary *dic = @{
                          @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                          @"id" : [self.dic[@"id"] safeString],
                          @"orderStatus" : @2
                          };
    [MobileAPI UpdateOrderWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject[@"state"] safeString] integerValue]==0)
        {
            hud.detailsLabelText = @"操作成功";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
