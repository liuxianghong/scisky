//
//  CompanyViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "CompanyViewController.h"
#import "MobileAPI.h"
#import "CompanyAdressViewController.h"

@interface CompanyViewController ()
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *linkmanLabel;
@property (nonatomic,weak) IBOutlet UILabel *mobileLabel;
@property (nonatomic,weak) IBOutlet UILabel *agencyidLabel;
@property (nonatomic,weak) IBOutlet UILabel *emailLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
//@property (nonatomic,weak) IBOutlet UILabel *emailLabel;
@end

@implementation CompanyViewController
{
    NSString *longitude;
    NSString *latitude;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.nameLabel.text = self.compName;
    self.agencyidLabel.text = self.compId;
    NSDictionary *dic = @{
                          @"id" : self.compId
                          };
    [MobileAPI GetAgencyInfoByIdWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [responseObject[@"data"] firstObject];
        self.title = self.nameLabel.text = [dic[@"name"] safeString];
        self.linkmanLabel.text = [dic[@"linkman"] safeString];
        self.mobileLabel.text = [dic[@"mobile"] safeString];
        self.agencyidLabel.text = [dic[@"agencyid"] safeString];
        self.emailLabel.text = [dic[@"email"] safeString];
        self.addressLabel.text = [dic[@"address"] safeString];
        
        latitude = [dic[@"latitude"] safeString];
        longitude = [dic[@"longitude"] safeString];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //map
    if ([segue.identifier isEqualToString:@"map"]) {
        CompanyAdressViewController *vc = segue.destinationViewController;
        vc.latitude = latitude;
        vc.longitude = longitude;
    }
}


@end
