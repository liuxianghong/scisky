//
//  MobileAPI.m
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/12/4.
//
//

#import "MobileAPI.h"
#define kMethodUserRegister @"/user/register"
#define kMethodUserLogin @"/user/userLogin"

#define kMethodUserGetUserById @"/user/getUserById"
#define kMethodUserupdatePassWord @"/user/updatePassWord"
#define kMethoduserLogout @"/user/userLogout"
#define kMethodgetUserServices @"/userservice/getUserServices"
#define kMethodgetUserServicesByIds @"/userserivce/getUserServicesByIds"
#define kMethodgetWorkExperience @"/workexp/getWorkExperience"
#define kMethodgetWorkExperienceByIds @"/workexp/getWorkExperienceByIds"
#define kMethodgetProvinces @"/district/getProvinces"
#define kMethodgetDistrictByParentId @"/district/getDistrictByParentId"

@implementation MobileAPI
+(NSString *)getErrorStringWithState:(id)state
{
    NSInteger type = [[state safeString] integerValue];
    if (type==0) {
        return nil;
    }
    else if(type == 2)
    {
        return @"缺少必要参数";
    }
    else if (type == 3)
    {
        return @"服务器内部错误";
    }
    else return @"未知错误";
}

+(void)saveUserImformatin:(NSDictionary *)responseObject
{
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"id"] safeString] forKey:@"UID"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"birthday"] safeString] forKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"gender"] safeString] forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"headimage"] safeString] forKey:@"headimage"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"idCardImgBack"] safeString] forKey:@"idCardImgBack"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"idCardImgFront"] safeString] forKey:@"idCardImgFront"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"idCardNo"] safeString] forKey:@"idCardNo"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"location"] safeString] forKey:@"location"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"loginname"] safeString] forKey:@"loginname"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"mobile"] safeString] forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString decodeFromPercentEscapeString:[responseObject[@"nickname"] safeString]] forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"serveDistrict"] safeString] forKey:@"serveDistrict"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"serviceIds"] safeString] forKey:@"serviceIds"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"workExpIds"] safeString] forKey:@"workExpIds"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"workLife"] safeString] forKey:@"workLife"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"workLifeUnit"] safeString] forKey:@"workLifeUnit"];
    if (responseObject[@"serviceCode"]) {
        [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"serviceCode"] safeString] forKey:@"serviceCode"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveUserImformatin2:(NSDictionary *)responseObject
{
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"locationDesc"] safeString] forKey:@"locationDesc"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"serveDistriceDesc"] safeString] forKey:@"serveDistriceDesc"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"serviceDesc"] safeString] forKey:@"serviceDesc"];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject[@"workExpDesc"] safeString] forKey:@"workExpDesc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)UserRegisterWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserRegister WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UserLoginWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserLogin WithParameters:parameters post:YES success:success failure:failure];
}

//3、	根据用户ID获取信息
+ (void)UserGetUserByIdWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserGetUserById WithParameters:parameters post:YES success:success failure:failure];
}

//4、	修改密码
+ (void)UserUpdatePassWordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserupdatePassWord WithParameters:parameters post:YES success:success failure:failure];
}

//5、	用户登出
+ (void)UserLogoutPassWordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethoduserLogout WithParameters:parameters post:YES success:success failure:failure];
}

//6、	获取用户服务列表
+ (void)GetUserServicesWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetUserServices WithParameters:parameters post:YES success:success failure:failure];
}

//7、	根据服务ID集合获取服务
+ (void)GetUserServicesByIdsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetUserServicesByIds WithParameters:parameters post:YES success:success failure:failure];
}

//8、	获取施工经验项目列表
+ (void)GetWorkExperienceWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetWorkExperience WithParameters:parameters post:YES success:success failure:failure];
}

//9、	根据项目ID获取施工经验项目列表
+ (void)GetWorkExperienceByIdsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetWorkExperienceByIds WithParameters:parameters post:YES success:success failure:failure];
}

//10、	获取省份
+ (void)GetProvincesWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetProvinces WithParameters:parameters post:YES success:success failure:failure];
}

//11、	根据区域父ID获取子区域（根据省份获取城市）
+ (void)GetDistrictByParentIdWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodgetDistrictByParentId WithParameters:parameters post:YES success:success failure:failure];
}

//12、	提交意见反馈
+ (void)AddFeedBackWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/feedback/addFeedBack" WithParameters:parameters post:YES success:success failure:failure];
}

//13、	根据供应商ID获取意见反馈
+ (void)GetFeedBackBySupplierIdWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/feedback/getFeedBackBySupplierId" WithParameters:parameters post:YES success:success failure:failure];
}

//14、	获取短信验证码
+ (void)GetVerificationCodeWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/sms/getVerificationCode" WithParameters:parameters post:YES success:success failure:failure];
}

//15、	忘记密码
+ (void)CodeChangePasswordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/user/changePassword" WithParameters:parameters post:YES success:success failure:failure];
}

//16、	获取热门城市
+ (void)GetHotCityWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/district/getHotCity" WithParameters:parameters post:YES success:success failure:failure];
}

//17、	推荐软件
+ (void)RecommendSoftwareWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/sms/recommendSoftware" WithParameters:parameters post:YES success:success failure:failure];
}

//18、	查询施工单
+ (void)GetSupplierOrderListWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/order/getSupplierOrderList" WithParameters:parameters post:YES success:success failure:failure];
}

//19、	订单交易记录查询
+ (void)GetOrderPaymentsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/order/getOrderPayments" WithParameters:parameters post:YES success:success failure:failure];
}

//20、	提成订单查询
+ (void)GetCommissionListBySupplierIdWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/commission/getCommissionListBySupplierId" WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UpdateOrderWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/order/updateOrder" WithParameters:parameters post:YES success:success failure:failure];
}

//查询账户余额
+ (void)GetAccountBalanceWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/order/getAccountBalance" WithParameters:parameters post:YES success:success failure:failure];
}

//用户申请个人资料修改
+ (void)InsertUserUpdateApplyWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/user/insertUserUpdateApply" WithParameters:parameters post:YES success:success failure:failure];
}

//22、	获取订单数据
+ (void)GetOrderStatisticsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/order/getOrderStatistics" WithParameters:parameters post:YES success:success failure:failure];
}


//23、	获取提成单数据
+ (void)GetCommissionStatisticsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/commission/getCommissionStatistics" WithParameters:parameters post:YES success:success failure:failure];
}

//24、	获取用户数据
+ (void)GetUserStatisticsWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/user/getUserStatistics" WithParameters:parameters post:YES success:success failure:failure];
}


+(void)UploadImage:(UIImage *)image success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager] filePostWithUrl:@"http://123.57.213.239/sciskyResource/image" WithParameters:UIImageJPEGRepresentation(image, 0.8) success:success failure:failure];
}

+ (void)GetAgencyInfoByIdWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:@"/agency/getAgencyInfoById" WithParameters:parameters post:YES success:success failure:failure];
}

@end
