//
//  LocationTableViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/28.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LocationTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"
#import "LocationTableViewCell.h"
#import "MobileAPI.h"
#import "BaiduMapAPI/BMKGeocodeSearch.h"
#import "NSString+PinYinUtil.h"

@interface LocationTableViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;
@property (nonatomic,weak) IBOutlet UIButton *loactionButton;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) BMKGeoCodeSearch *searcher;
@end

@implementation LocationTableViewController
{
    NSDictionary *locationCityDic;
    NSString *locationCityName;
    
    
    NSDictionary *citydic;
    BOOL first;
    NSArray *tableArray;
    NSMutableArray *tablehotArray;
    
    NSMutableDictionary *abcDic;
    NSMutableArray *abcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.cityLabel.text = @"";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    //改变索引选中的背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //self.tableView.sec
    
    __weak typeof(self) wself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        typeof(self) sself = wself;
        [sself refreshData];
    }];
    first = YES;
    tablehotArray = [[NSMutableArray alloc]init];
    self.cityLabel.text = StringNoNull(self.dic[@"cityname"]);
    
    abcArray = [[NSMutableArray alloc]init];
    abcDic = [[NSMutableDictionary alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (first) {
        [self.tableView.header beginRefreshing];
        first = NO;
        [self beginLocation];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (citydic) {
        [self.dic setObject:citydic[@"id"] forKey:@"id"];
        [self.dic setObject:citydic[@"cityname"] forKey:@"cityname"];
    }
    _searcher.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData
{
    [MobileAPI GetProvincesWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableView.header endRefreshing];
        [self.tableView removeHeader];
        tableArray = responseObject[@"data"];
        for (NSDictionary *dic in tableArray) {
            for (NSDictionary *dicCity in dic[@"children"]) {
                if ([[dicCity[@"hot"] safeString] integerValue]) {
                    [tablehotArray addObject:dicCity];
                }
                NSString *cityname = [dicCity[@"cityname"] safeString];
                NSString *str = [cityname getFirstCharPinYin];
                NSMutableArray *array2 = [abcDic objectForKey:str];
                if (!array2) {
                    array2 = [[NSMutableArray alloc]init];
                }
                [array2 addObject:dicCity];
                [abcDic setObject:array2 forKey:str];
            }
        }
        
        NSComparator cmptr = ^(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            switch(result)
            {
                case NSOrderedAscending:
                    return NSOrderedAscending;
                case NSOrderedDescending:
                    return NSOrderedDescending;
                case NSOrderedSame:
                    return NSOrderedSame;
                default:
                    return NSOrderedSame;
            }
        };
        NSArray *array3 = [[abcDic allKeys] sortedArrayUsingComparator:cmptr];
//        if ([tablehotArray count]>0) {
//            [abcDic setObject:tablehotArray forKey:@"热门"];
//            [abcArray addObject:@"热门"];
//        }
        [abcArray addObjectsFromArray:array3];
        
        [self updateLocationLabel];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
}

-(void)beginLocation
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([CLLocationManager locationServicesEnabled]) {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                [self.locationManager startUpdatingLocation];
            }
        }
        self.cityLabel.text = @"定位中";
    }
    else
    {
        if (locationCityDic) {
            self.cityLabel.text = locationCityDic[@"cityname"];
            //citydic = locationCityDic;
        }
    }
}

-(IBAction)locationClick:(id)sender
{
    if(locationCityDic)
    {
        citydic = locationCityDic;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized) {
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
        }
        [manager startUpdatingLocation];
        
    }else if(status == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有授权水性科天使用您的位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


-(void)updateLocationLabel
{
    if (locationCityName) {
        self.cityLabel.text = locationCityName;
        self.cityLabel.textColor = [UIColor redColor];
        for (NSDictionary *dic in tableArray) {
            for (NSDictionary *dicCity in dic[@"children"]) {
                if ([locationCityName rangeOfString:[dicCity[@"cityname"] safeString]].location!=NSNotFound) {
                    locationCityDic = dicCity;
                    self.cityLabel.textColor = [UIColor darkTextColor];
                    break;
                }
            }
        }
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    [self.locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    //发起反向地理编码检索
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    CLLocationCoordinate2D pt = newLocation.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        self.cityLabel.text = @"检索地理位置中";
        //self.cityLabel.text = locationCityName;
      NSLog(@"反geo检索发送成功");
    }
    else
    {
        //self.cityLabel.text = @"无法检索地理位置";
      NSLog(@"反geo检索发送失败");
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
            
            if (array.count > 0)
            {
                CLPlacemark *placemark = [array objectAtIndex:0];
                //获取城市
                NSString *city = placemark.locality;
                
                NSString *cityName = placemark.addressDictionary[@"State"];
                // 将最后一个字符【市】去掉,转成城市对应,用工具保存
                cityName = [cityName substringToIndex:cityName.length - 1];
                
                if ([city length]<1) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                locationCityName = city;
                [self updateLocationLabel];
                
            }
            else if (error == nil && [array count] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cityLabel.text = @"无法定位";
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"无法获得您当前的位置请手动选择城市", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
                    [alert show];
                });
            }
            else if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cityLabel.text = @"无法定位";
                });
            }
        }];
    }
    /*
    
    */
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      NSString *city = result.addressDetail.city;
      if ([city length]<1) {
          //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
          city = result.addressDetail.province;
      }
      locationCityName = city;
      [self updateLocationLabel];
  }
  else {
      self.cityLabel.text = @"无法定位";
      UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"无法获得您当前的位置请手动选择城市", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
      [alert show];
  }
}

//不使用时将delegate设置为 nil
#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //返回省份的数组
    return abcArray;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 45)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
//    if (section==0) {
//        label.text = @"热门城市";
//    }
    //else
    {
        label.text = abcArray[section];//[tableArray[section-1][@"cityname"] safeString];
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    [label sizeToFit];
    label.centerY = view.centerY;
    label.left = 10;
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [abcArray count];//[tableArray count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    if (section == 0) {
//        return [tablehotArray count];
//    }
    return [abcDic[abcArray[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dic = nil;
    dic = abcDic[abcArray[indexPath.section]][indexPath.row];
//    if (indexPath.section == 0) {
//        dic = tablehotArray[indexPath.row];
//    }
//    else
//    {
//        dic = abcDic[abcArray[indexPath.section]][indexPath.row];//tableArray[indexPath.section-1][@"children"][indexPath.row];
//    }
    cell.cityLabel.text = [dic[@"cityname"] safeString];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = nil;
     dic = abcDic[abcArray[indexPath.section]][indexPath.row];
//    if (indexPath.section == 0) {
//        dic = tablehotArray[indexPath.row];
//    }
//    else
//    {
//        dic = abcDic[abcArray[indexPath.section]][indexPath.row];//dic = tableArray[indexPath.section-1][@"children"][indexPath.row];
//    }
//    //self.cityLabel.text = [dic[@"cityname"] safeString];
    citydic = dic;
    [self.navigationController popViewControllerAnimated:YES];
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
