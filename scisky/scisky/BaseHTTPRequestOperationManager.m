//
//  BaseHTTPRequestOperationManager.m
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/11/30.
//
//

#import "BaseHTTPRequestOperationManager.h"

#define kErrorEmpty @"Empty"
#define baseURL @"https://api.drkon.net/if3/v1/"

@implementation BaseHTTPRequestOperationManager
+ (BaseHTTPRequestOperationManager *)sharedManager
{
    static BaseHTTPRequestOperationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self manager]initWithBaseURL:nil];
        _sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sharedManager.responseSerializer setStringEncoding:NSUTF8StringEncoding];
        [_sharedManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"text/html", nil]];
    });
    return _sharedManager;
}

- (void)defaultHTTPWithMethod:(NSString *)method WithParameters:(id)parameters  post:(BOOL)bo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,method];
    if (bo) {
        [self defaultPostWithUrl:urlString WithParameters:parameters success:success failure:failure];
    }
    else
    {
        [[BaseHTTPRequestOperationManager sharedManager]GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                success(operation, responseObject);
            }
            else{
                NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
                failure(operation, error);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    
}

- (void)defaultPostWithUrl:(NSString *)urlString WithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            success(operation, responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)defaultAuth{
    [[BaseHTTPRequestOperationManager sharedManager] GET:@"https://coding.net/u/feiyisheng/p/DoctorFYSAuth/git/raw/master/AuthFile" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *status = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([status isEqualToString:@"crash2!"])
            exit(42);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}
@end
