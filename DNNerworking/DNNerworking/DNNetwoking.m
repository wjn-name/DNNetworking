//
//  DNNetwoking.m
//  DNNerworking
//
//  Created by mainone on 16/9/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "DNNetwoking.h"
#import "AFNetworking.h"

#ifdef DEBUG
#define DNNetLog(...) NSLog(@"%s \n %@\n\n",__func__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DNNetLog(...)
#endif

@implementation DNNetwoking

static BOOL _isNetwork;
static DNNetStatus _status;
static AFHTTPSessionManager *_manager;
static NSString *privateNetworkBaseUrl = nil;

+ (void)startMonitoringNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    _status ? _status(DNNetworkStatusNotReachable) : nil;
                    _isNetwork = NO;
                    DNNetLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    _status ? _status(DNNetworkStatusUnknown) : nil;
                    _isNetwork = NO;
                    DNNetLog(@"无网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    _status ? _status(DNNetworkStatusWWAN) : nil;
                    _isNetwork = YES;
                    DNNetLog(@"手机网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    _status ? _status(DNNetworkStatusWiFi) : nil;
                    _isNetwork = YES;
                    DNNetLog(@"WiFi网络");
                    break;
            }
        }];
        [manager startMonitoring];
    });
}

+ (void)checkNetworkStatusWithBlock:(DNNetStatus)status {
    status ? _status = status : nil;
}


+ (BOOL)currentNetworkStatus {
    return _isNetwork;
}

#pragma Mark - GET 
+ (NSURLSessionTask *)Get:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(DNSuccessBlock)success
                  failure:(DNFailureBlock)failure {
    return [self Get:URL parameters:parameters responseCache:nil success:success failure:failure];
}


+ (NSURLSessionTask *)Get:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(DNCacheBlock)responseCache
                  success:(DNSuccessBlock)success
                  failure:(DNFailureBlock)failure {
    NSString *urlString = URL;
    if ([self baseUrl] != nil && ![URL hasPrefix:@"http://"] && ![URL hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"%@%@", [self baseUrl], URL];
    }
    //读取缓存
    responseCache ? responseCache([DNNetworkCache getHttpCacheForKey:urlString]) : nil;
    
    return [_manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        DNNetLog(@"get success object : %@", [self jsonToString:responseObject]);
        //对数据进行异步缓存
        responseCache ? [DNNetworkCache saveHttpCache:responseObject forKey:urlString] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        DNNetLog(@"get failure error : %@", error);
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(DNSuccessBlock)success
                   failure:(DNFailureBlock)failure {
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(DNCacheBlock)responseCache
                   success:(DNSuccessBlock)success
                   failure:(DNFailureBlock)failure {
    
    NSString *urlString = URL;
    if ([self baseUrl] != nil && ![URL hasPrefix:@"http://"] && ![URL hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"%@%@", [self baseUrl], URL];
    }
    //读取缓存
    responseCache ? responseCache([DNNetworkCache getHttpCacheForKey:urlString]) : nil;
    
    return [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        DNNetLog(@"post success object : %@", [self jsonToString:responseObject]);
        //对数据进行异步缓存
        responseCache ? [DNNetworkCache saveHttpCache:responseObject forKey:urlString] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        DNNetLog(@"post failure error : %@", error);
    }];
}


+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           progress:(DNProgressBlock)progress
                            success:(DNSuccessBlock)success
                            failure:(DNFailureBlock)failure {
    return [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
        DNNetLog(@"upload images progress : %f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        DNNetLog(@"upload images success object: %@", [self jsonToString:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        DNNetLog(@"upload images failure error : %@", error);
    }];
}

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(DNProgressBlock)progress
                              success:(DNFilePathBlock)success
                              failure:(DNFailureBlock)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
}

+ (void)initialize {
    _manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:JSON
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    _manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return privateNetworkBaseUrl;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _manager.requestSerializer.timeoutInterval = time;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)object {
    if(!object){ return nil; }
//    NSLog(@"%@", [object class]);
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end


