//
//  SeverChoiceTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/20.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "SeverChoiceTableViewController.h"
#import "MobileAPI.h"
#import "ServerChoiceTableViewCell.h"

@implementation SeverChoiceModel
@end

@interface SeverChoiceTableViewController ()

@end

@implementation SeverChoiceTableViewController
{
    NSMutableArray *tableViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    tableViewArray = [[NSMutableArray alloc]init];
    if (self.type==1) {
        self.title = @"服务区域";
        NSDictionary *dic = @{
                              @"id" : self.cityID
                              };
        [MobileAPI GetDistrictByParentIdWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                SeverChoiceModel *model = [[SeverChoiceModel alloc]init];
                model.name = [dic[@"cityname"] safeString];
                model.modelID = [dic[@"id"] safeString];
                model.checked = NO;
                for (NSDictionary *dic in self.array) {
                    if ([[dic[@"id"] safeString] isEqualToString:model.modelID]) {
                        model.checked = YES;
                        break;
                    }
                }
                
                [tableViewArray addObject:model];
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
    if (self.type==2) {
        self.title = @"提供服务";
        [MobileAPI GetUserServicesWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                SeverChoiceModel *model = [[SeverChoiceModel alloc]init];
                model.name = [dic[@"serviceName"] safeString];
                model.modelID = [dic[@"id"] safeString];
                model.checked = NO;
                for (NSDictionary *dic in self.array) {
                    if ([[dic[@"id"] safeString] isEqualToString:model.modelID]) {
                        model.checked = YES;
                        break;
                    }
                }
                
                [tableViewArray addObject:model];
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
    if (self.type==3) {
        self.title = @"工作经验";
        [MobileAPI GetWorkExperienceWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                SeverChoiceModel *model = [[SeverChoiceModel alloc]init];
                model.name = [dic[@"experience"] safeString];
                model.modelID = [dic[@"id"] safeString];
                model.checked = NO;
                for (NSDictionary *dic in self.array) {
                    if ([[dic[@"id"] safeString] isEqualToString:model.modelID]) {
                        model.checked = YES;
                        break;
                    }
                }
                
                [tableViewArray addObject:model];
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
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

-(IBAction)okClick:(id)sender
{
    [self.array removeAllObjects];
    for (SeverChoiceModel *model in tableViewArray) {
        
        if (model.checked) {
            NSDictionary *dic = @{
                                  @"name" : model.name,
                                  @"id" : model.modelID
                                  };
            [self.array addObject:dic];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableViewArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serverCell" forIndexPath:indexPath];
    SeverChoiceModel *model = tableViewArray[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.checkedImageView.hidden = !model.checked;
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeverChoiceModel *model = tableViewArray[indexPath.row];
    model.checked = !model.checked;
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
