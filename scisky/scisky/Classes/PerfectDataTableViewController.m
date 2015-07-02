//
//  PerfectDataTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/10.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "PerfectDataTableViewController.h"
#import "MobileAPI.h"
#import "SeverChoiceTableViewController.h"
#import "LocationTableViewController.h"

@interface PerfectDataTableViewController ()
@property (nonatomic,weak) IBOutlet UITextField *nameTf;
@property (nonatomic,weak) IBOutlet UITextField *cardNoTf;
@property (nonatomic,weak) IBOutlet UITextField *dateTf;
@property (nonatomic,weak) IBOutlet UITextField *workeYearTf;

@property (nonatomic,weak) IBOutlet UILabel *location;
@property (nonatomic,weak) IBOutlet UILabel *serveDistrict;
@property (nonatomic,weak) IBOutlet UILabel *serviceIds;
@property (nonatomic,weak) IBOutlet UILabel *workExpIds;

@property (nonatomic,weak) IBOutlet UIButton *sexManBtn;
@property (nonatomic,weak) IBOutlet UIButton *sexWomanBtn;

@property (nonatomic,weak) IBOutlet UIImageView *imageViewFront;
@property (nonatomic,weak) IBOutlet UIImageView *imageViewBack;

@property (nonatomic,weak) IBOutlet UIButton *imageFrontBtn;
@property (nonatomic,weak) IBOutlet UIButton *imageBackBtn;

@property (nonatomic,strong) NSString *forntImageName;
@property (nonatomic,strong) NSString *backImageName;
@end

@implementation PerfectDataTableViewController
{
    UIImageView *imageViewCurrent;
    UIDatePicker *pickerView;
    
    NSMutableDictionary *locationDic;
    NSMutableArray *serveDistrictArray;
    NSMutableArray *serviceIdsArray;
    NSMutableArray *workExpIdsArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dateTf.tintColor = [UIColor clearColor];
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
    self.dateTf.inputView = pickerView;
    self.dateTf.inputAccessoryView = topView;
    
    locationDic = [[NSMutableDictionary alloc]init];
    serveDistrictArray = [[NSMutableArray alloc]init];
    serviceIdsArray = [[NSMutableArray alloc]init];
    workExpIdsArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.location.text = locationDic[@"cityname"];
    
    self.serveDistrict.text = [self getListString:serveDistrictArray byKey:@"name"];
    self.serviceIds.text = [self getListString:serviceIdsArray byKey:@"name"];
    self.workExpIds.text = [self getListString:workExpIdsArray byKey:@"name"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelChoice
{
    [self.dateTf resignFirstResponder];
}

-(void)doneChoice
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:pickerView.date];
    self.dateTf.text = destDateString;
    [self.dateTf resignFirstResponder];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showHudToWarming:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = str;
    [hud hide:YES afterDelay:1.5f];
}

-(IBAction)commitClick:(id)sender
{
    [self.nameTf resignFirstResponder];
    [self.cardNoTf resignFirstResponder];
    [self.dateTf resignFirstResponder];
    [self.workeYearTf resignFirstResponder];
    if ([self.nameTf.text length]<1) {
        [self showHudToWarming:@"请输入姓名"];
        return;
    }
    if ([self.cardNoTf.text length]<1) {
        [self showHudToWarming:@"请输入身份证号码"];
        return;
    }
    if (![NSString validateIDCardNumber:self.cardNoTf.text]) {
        [self showHudToWarming:@"请输入正确的身份证号码"];
        return;
    }
    if ([self.location.text length]<1) {
        [self showHudToWarming:@"请选择位置"];
        return;
    }
    if ([self.dateTf.text length]<1) {
        [self showHudToWarming:@"请选择出生日期"];
        return;
    }
    if ([self.serveDistrict.text length]<1) {
        [self showHudToWarming:@"请选择服务区域"];
        return;
    }
    if ([self.serviceIds.text length]<1) {
        [self showHudToWarming:@"请选择提供服务"];
        return;
    }
    if ([self.workExpIds.text length]<1) {
        [self showHudToWarming:@"请选择工作经验"];
        return;
    }
    if ([self.workeYearTf.text length]<1) {
        [self showHudToWarming:@"请输入工作年限"];
        return;
    }
    if ([self.forntImageName length]<1) {
        [self showHudToWarming:@"请上传身份证正面"];
        return;
    }
    if ([self.backImageName length]<1) {
        [self showHudToWarming:@"请上传身份证背面"];
        return;
    }
    NSDictionary *dic = @{
                          @"loginname" : self.phoneNumber,
                          @"password" : self.passWord,
                          @"nickname" : self.nameTf.text,
                          @"gender" : self.sexManBtn.selected?@"1":@"2",
                          @"idCardNo" : self.cardNoTf.text,
                          @"birthday" : self.dateTf.text,
                          @"location" : locationDic[@"id"],
                          @"serveDistrict" : [self getListString:serveDistrictArray byKey:@"id"],
                          @"serviceIds" : [self getListString:serviceIdsArray byKey:@"id"],
                          @"workExpIds" : [self getListString:workExpIdsArray byKey:@"id"],
                          @"workLife" : self.workeYearTf.text,
                          @"workLifeUnit" : @"3",
                          @"idCardImgFront" : self.forntImageName,
                          @"idCardImgBack" : self.backImageName
                          };

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"注册中";
    [MobileAPI UserRegisterWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject[@"state"] safeString] integerValue]==0) {
            hud.detailsLabelText = @"注册成功,请耐心等待审核通过";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            hud.detailsLabelText = @"注册失败";
        }
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        hud.detailsLabelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    }];
}

-(IBAction)sexClick:(UIButton *)sender
{
    sender.selected = YES;
    UIButton *btn = [sender isEqual:self.sexManBtn]?self.sexWomanBtn:self.sexManBtn;
    btn.selected = NO;
}

-(IBAction)uploadForntClick:(id)sender
{
    imageViewCurrent = self.imageViewFront;
    [self chooseApproveImage];
}

-(IBAction)uploadBackClick:(id)sender
{
    imageViewCurrent = self.imageViewBack;
    [self chooseApproveImage];
}
#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==9) {
        return (self.view.width - 60 - 20)/2/85.6*54+20+42;
    }
    else if (indexPath.row==10) {
        return 60;
    }
    else
        return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        [self performSegueWithIdentifier:@"location" sender:nil];
    }
    if (indexPath.row==5) {
        if (locationDic[@"id"]) {
            [self performSegueWithIdentifier:@"serveDistrict" sender:nil];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.detailsLabelText = @"请先选择位置";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.5f];
            
        }
    }
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
    imageViewCurrent.image = image2;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imageViewCurrent animated:YES];
    hud.dimBackground = YES;
    __block int type = 1;
    __weak typeof(self) wself = self;
    if ([imageViewCurrent isEqual:self.imageViewFront]) {
        self.forntImageName = nil;
        self.imageFrontBtn.enabled = NO;
        type = 0;
    }
    else
    {
        self.backImageName = nil;
        self.imageBackBtn.enabled = NO;
    }
    [MobileAPI UploadImage:image2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        typeof(self) sself = wself;
        if([[responseObject[@"state"] safeString] integerValue]==0)
        {
            if (type==1) {
                sself.imageBackBtn.enabled = YES;
                sself.backImageName = [responseObject[@"data"][@"name"] safeString];
            }
            else
            {
                sself.imageFrontBtn.enabled = YES;
                sself.forntImageName = [responseObject[@"data"][@"name"] safeString];
            }
            
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        typeof(self) sself = wself;
        if (type==1) {
            sself.imageBackBtn.enabled = YES;
            sself.imageViewBack.image = nil;
        }
        else
        {
            sself.imageFrontBtn.enabled = YES;
            sself.imageViewFront.image = nil;
        }
        [hud hide:YES];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"location"]) {
        LocationTableViewController *vc = segue.destinationViewController;
        vc.dic = locationDic;
    }
    if ([segue.identifier isEqualToString:@"serveDistrict"]) {
        SeverChoiceTableViewController *vc = segue.destinationViewController;
        vc.type = 1;
        vc.array = serveDistrictArray;
        vc.cityID = locationDic[@"id"];
    }
    if ([segue.identifier isEqualToString:@"userservice"]) {
        SeverChoiceTableViewController *vc = segue.destinationViewController;
        vc.type = 2;
        vc.array = serviceIdsArray;
    }
    if ([segue.identifier isEqualToString:@"WorkExperience"]) {
        SeverChoiceTableViewController *vc = segue.destinationViewController;
        vc.type = 3;
        vc.array = workExpIdsArray;
    }
}


@end
