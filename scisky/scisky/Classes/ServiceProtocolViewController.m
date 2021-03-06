//
//  ServiceProtocolViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ServiceProtocolViewController.h"
//#import "SeverChoiceTableViewController.h"

@interface ServiceProtocolViewController ()
@property (nonatomic,weak) IBOutlet UIWebView *webView;
@end

@implementation ServiceProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.webView) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"used2" ofType:@"jpg"];
        
        if(filePath)
        {
            NSURL *url = [NSURL fileURLWithPath:filePath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            self.webView.scalesPageToFit = YES;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
