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

@property (nonatomic,weak) IBOutlet UIButton *buttomButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.textFiledPassWord setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textFiledPassWord.tintColor = [UIColor whiteColor];
    [self.textFiledPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textFiledPhone.tintColor = [UIColor whiteColor];
    
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
    [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:@"UID"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
