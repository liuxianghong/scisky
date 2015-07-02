//
//  PersonalDetailTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/12.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "PersonalDetailTableViewController.h"
#import "LocationTableViewController.h"
#import "SeverChoiceTableViewController.h"
#import "MobileAPI.h"
#import "UIImageView+WebCache.h"

@interface PersonalDetailTableViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UITextField *nameTextField;
@property (nonatomic,weak) IBOutlet UITextField *ageTextField;
@property (nonatomic,weak) IBOutlet UILabel *locationLabel;
@property (nonatomic,weak) IBOutlet UILabel *serveDistrictLabel;
@property (nonatomic,weak) IBOutlet UILabel *serviceIdsLabel;
@property (nonatomic,weak) IBOutlet UILabel *workExpIdsLabel;

@property (nonatomic,strong) NSString *headImageName;
@property (nonatomic) BOOL isUploadImage;
@end

@implementation PersonalDetailTableViewController
{
    UIImageView *imageView;
    
    UIDatePicker *pickerView;
    
    NSMutableDictionary *locationDic;
    NSMutableArray *serveDistrictArray;
    NSMutableArray *serviceIdsArray;
    NSMutableArray *workExpIdsArray;
    
    BOOL first;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Modify-data-base"]];
    imageView.frame = CGRectInset(self.tableView.bounds, 0, 10);
    [self.tableView addSubview:imageView];
    [self.tableView sendSubviewToBack:imageView];
    
    [SSUIStyle RoundStyle:self.headImageView rect:70/2.0];
    
    self.headImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.213.239/sciskyResource/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"]]] placeholderImage:[UIImage imageNamed:@"Modify-data-Avatar"]];
    
    self.ageTextField.tintColor = [UIColor clearColor];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoice)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:cancelButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    pickerView = [[UIDatePicker alloc]init];
    [pickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [pickerView setDatePickerMode:UIDatePickerModeDate];
    self.ageTextField.inputView = pickerView;
    self.ageTextField.inputAccessoryView = topView;
    
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    long time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"] longLongValue];
    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *databirthday = [formatter stringFromDate:birthday];
    self.ageTextField.text = databirthday;
    
    self.locationLabel.text = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"locationDesc"]);
    self.serveDistrictLabel.text = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serveDistriceDesc"]);
    self.serviceIdsLabel.text = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serviceDesc"]);
    self.workExpIdsLabel.text = StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"workExpDesc"]);
    
    locationDic = [[NSMutableDictionary alloc]init];
    [locationDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"location" ] forKey:@"id"];
    [locationDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"locationDesc" ] forKey:@"cityname"];
    
    NSArray *arrayserveDistriceDesc = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serveDistriceDesc"]) componentsSeparatedByString:@","];
    NSArray *arrayserveDistrict = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serveDistrict"]) componentsSeparatedByString:@","];
    serveDistrictArray = [[NSMutableArray alloc]init];
    for(int i = 0;i<[arrayserveDistriceDesc count]&&i<[arrayserveDistrict count];i++)
    {
        NSDictionary *dic = @{
                              @"name" : arrayserveDistriceDesc[i],
                              @"id" : arrayserveDistrict[i]
                              };
        [serveDistrictArray addObject:dic];
    }
    
    NSArray *arrayserviceDesc = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serviceDesc"]) componentsSeparatedByString:@","];
    NSArray *arrayserviceIds = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"serviceIds"]) componentsSeparatedByString:@","];
    serviceIdsArray = [[NSMutableArray alloc]init];
    for(int i = 0;i<[arrayserviceDesc count]&&i<[arrayserviceIds count];i++)
    {
        NSDictionary *dic = @{
                              @"name" : arrayserviceDesc[i],
                              @"id" : arrayserviceIds[i]
                              };
        [serviceIdsArray addObject:dic];
    }
    
    NSArray *arrayserveworkExpDesc = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"workExpDesc"]) componentsSeparatedByString:@","];
    NSArray *arrayworkExpIds = [StringNoNull([[NSUserDefaults standardUserDefaults] objectForKey:@"workExpIds"]) componentsSeparatedByString:@","];
    workExpIdsArray = [[NSMutableArray alloc]init];
    for(int i = 0;i<[arrayserveworkExpDesc count]&&i<[arrayworkExpIds count];i++)
    {
        NSDictionary *dic = @{
                              @"name" : arrayserveworkExpDesc[i],
                              @"id" : arrayworkExpIds[i]
                              };
        [workExpIdsArray addObject:dic];
    }
    
    first = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!first) {
        self.locationLabel.text = locationDic[@"cityname"];
        self.serveDistrictLabel.text = [self getListString:serveDistrictArray byKey:@"name"];
        self.serviceIdsLabel.text = [self getListString:serviceIdsArray byKey:@"name"];
        self.workExpIdsLabel.text = [self getListString:workExpIdsArray byKey:@"name"];
    }
    
    
    //[self.tableView reloadData];
}

-(NSString *)getListString:(NSArray *)array byKey:(NSString *)key
{
    NSString *str = @"";
    for (int i =0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        str = [str stringByAppendingString:dic[key]];
        if (i!=([array count]-1)) {
            str = [str stringByAppendingString:@","];
        }
    }
    return str;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (first) {
        [self.nameTextField becomeFirstResponder];
        first = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelChoice
{
    [self.ageTextField resignFirstResponder];
}

-(void)doneChoice
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:pickerView.date];
    self.ageTextField.text = destDateString;
    [self.ageTextField resignFirstResponder];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)OKClick:(id)sender
{
    [self.ageTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    if ([self.nameTextField.text length]<1) {
        [self showHudToWarming:@"请输入姓名"];
        return;
    }
    if ([self.locationLabel.text length]<1) {
        [self showHudToWarming:@"请选择位置"];
        return;
    }
    if ([self.ageTextField.text length]<1) {
        [self showHudToWarming:@"请选择出生日期"];
        return;
    }
    if ([self.serveDistrictLabel.text length]<1) {
        [self showHudToWarming:@"请选择服务区域"];
        return;
    }
    if ([self.serviceIdsLabel.text length]<1) {
        [self showHudToWarming:@"请选择提供服务"];
        return;
    }
    if ([self.workExpIdsLabel.text length]<1) {
        [self showHudToWarming:@"请选择工作经验"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.detailsLabelText = @"上传中";
    NSDictionary *dic = @{
                          @"supplier_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                          @"nickname": self.nameTextField.text,
                          @"headimage": self.headImageName,
                          @"location": locationDic[@"id"],
                          @"serve_district": [self getListString:serveDistrictArray byKey:@"id"],
                          @"service_ids": [self getListString:serviceIdsArray byKey:@"id"],
                          @"work_experience_ids": [self getListString:workExpIdsArray byKey:@"id"]
                          };
    [MobileAPI InsertUserUpdateApplyWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject[@"state"] safeString] integerValue]==0) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"修改成功，请耐心等待审核";
            [hud hide:YES afterDelay:1.5f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"修改失败";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    
    
}

-(void)showHudToWarming:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = str;
    [hud hide:YES afterDelay:1.5f];
}



#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self chooseApproveImage];
    }
    else if (indexPath.row==3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LocationTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"locationVC"];
        vc.dic = locationDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        SeverChoiceTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"severVC"];
        vc.type = 1;
        vc.array = serveDistrictArray;
        vc.cityID = locationDic[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==5) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        SeverChoiceTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"severVC"];
        vc.type = 2;
        vc.array = serviceIdsArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==6) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        SeverChoiceTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"severVC"];
        vc.type = 3;
        vc.array = workExpIdsArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)chooseApproveImage{
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    //    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    //    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image2=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.headImageView.image = image2;
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.isUploadImage = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.headImageView animated:YES];
    hud.dimBackground = YES;
    __weak typeof(self) wself = self;
    [MobileAPI UploadImage:image2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        typeof(self) sself = wself;
        if([[responseObject[@"state"] safeString] integerValue]==0)
        {
            sself.headImageName = [responseObject[@"data"][@"name"] safeString];
            
        }
        self.isUploadImage = NO;
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        typeof(self) sself = wself;
        sself.headImageView.image = nil;
        [hud hide:YES];
        self.isUploadImage = NO;
    }];
}
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
