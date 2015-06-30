//
//  FeedBackTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "FeedBackTableViewController.h"
#import "MobileAPI.h"

@interface FeedBackTableViewController ()
@property (nonatomic,weak) IBOutlet UILabel *uilabel;

@property (nonatomic,weak) IBOutlet UITextField *nameTextFiled;
@property (nonatomic,weak) IBOutlet UITextField *phoneTextFiled;
@property (nonatomic,weak) IBOutlet UITextView *feedTextView;
@end

@implementation FeedBackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    CGRect tableViewFooterRect = self.tableView.tableFooterView.frame;
    tableViewFooterRect.size.height = 78.0f+10;
    [self.tableView.tableFooterView setFrame:tableViewFooterRect];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameTextFiled resignFirstResponder];
    [self.phoneTextFiled resignFirstResponder];
    [self.feedTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.uilabel.hidden = NO;
    }else{
        self.uilabel.hidden = YES;
    }
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)commitButtonClick:(id)sender
{
    [self.nameTextFiled resignFirstResponder];
    [self.phoneTextFiled resignFirstResponder];
    [self.feedTextView resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    
    if ([self.nameTextFiled.text length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入姓名";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.phoneTextFiled.text length]<11) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.feedTextView.text length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入反馈内容";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    hud.detailsLabelText = @"提交中";
    NSDictionary *dicParameters = @{
                                    @"supplierId" : [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                                    @"name" : self.nameTextFiled.text,
                                    @"phone" : self.phoneTextFiled.text,
                                    @"content" : self.feedTextView.text
                                    };
    [MobileAPI AddFeedBackWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![MobileAPI getErrorStringWithState:responseObject[@"state"]])
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"提交成功";
            [hud hide:YES afterDelay:1.5f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"提交失败";
            [hud hide:YES afterDelay:1.5f];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

#pragma mark - Table view data source



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
