//
//  RecommendViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RecommendViewController.h"
#import "MobileAPI.h"

@interface RecommendViewController ()
@property (nonatomic,weak) IBOutlet UITextField *tf;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.tf resignFirstResponder];
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitButtonClick:(id)sender
{
    [self.tf resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    
    if ([self.tf.text length]<11) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    hud.detailsLabelText = @"提交中";
    NSDictionary *dicParameters = @{
                                    @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                                    @"mobile" : self.tf.text
                                    };
    [MobileAPI RecommendSoftwareWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![MobileAPI getErrorStringWithState:responseObject[@"state"]])
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"提交成功";
            [hud hide:YES afterDelay:1.0f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"提交失败";
            [hud hide:YES afterDelay:1.0f];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
