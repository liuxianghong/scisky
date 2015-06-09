//
//  LoginViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LoginViewController.h"
#import "IHKeyboardAvoiding.h"

@interface LoginViewController ()
@property (nonatomic,weak) IBOutlet UITextField *textFiledPhone;
@property (nonatomic,weak) IBOutlet UITextField *textFiledPassWord;

@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IHKeyboardAvoiding setAvoidingView:self.view withTarget:self.loginButton];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textFiledPhone resignFirstResponder];
    [self.textFiledPassWord resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginClick:(id)sender
{
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
