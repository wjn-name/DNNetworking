//
//  DNNetwoking.h
//  DNNerworking
//
//  Created by mainone on 16/9/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DNNetworkCache.h"

typedef NS_ENUM(NSUInteger, DNNetworkStatus) {
    DNNetworkStatusUnknown,         /**<未知网络*/
    DNNetworkStatusNotReachable,    /**<无网络*/
    DNNetworkStatusWWAN,            /**<手机网路*/
    DNNetworkStatusWiFi             /**<Wifi网路*/
};

typedef void (^DNSuccessBlock)(id responseObject);      /**<请求成功*/
typedef void (^DNFailureBlock)(NSError *error);         /**<请求失败*/
typedef void (^DNCacheBlock)(id responseObject);        /**<缓存数据*/
typedef void (^DNProgressBlock)(NSProgress *progress);  /**<请求进度*/
typedef void (^DNNetStatus)(DNNetworkStatus status);    /**<网络状态*/
typedef void (^DNFilePathBlock)(NSString *filePath);    /**<下载地址*/

@interface DNNetwoking : NSObject


/**
 *  开启网络监测,项目只开启一次
 */
+ (void)startMonitoringNetwork;

/**
 *  通Block回调网络状态
 */
+ (void)checkNetworkStatusWithBlock:(DNNetStatus)status;

/**
 *  检测当前是否有网
 */
+ (BOOL)currentNetworkStatus;


/**
 *  GET请求 (无缓存数据)
 *
 *  @param URL        请求链接
 *  @param parameters 参数
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)Get:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(DNSuccessBlock)success
                  failure:(DNFailureBlock)failure;

/**
 *  GET请求 (有缓存数据)
 *
 *  @param URL           请求链接
 *  @param parameters    参数
 *  @param responseCache 缓存数据
 *  @param success       成功后回调
 *  @param failure       失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)Get:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(DNCacheBlock)responseCache
                  success:(DNSuccessBlock)success
                  failure:(DNFailureBlock)failure;

/**
 *  POST请求 (无缓存数据)
 *
 *  @param URL        请求链接
 *  @param parameters 参数
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(DNSuccessBlock)success
                   failure:(DNFailureBlock)failure;

/**
 *  POST请求 (有缓存数据)
 *
 *  @param URL           请求链接
 *  @param parameters    参数
 *  @param responseCache 缓存数据
 *  @param success       成功后回调
 *  @param failure       失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(DNCacheBlock)responseCache
                   success:(DNSuccessBlock)success
                   failure:(DNFailureBlock)failure;

/**
 *  上传图片
 *
 *  @param URL        请求链接
 *  @param parameters 参数
 *  @param images     图片数组
 *  @param name       名字
 *  @param fileName   文件名
 *  @param progress   上传进度
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           progress:(DNProgressBlock)progress
                            success:(DNSuccessBlock)success
                            failure:(DNFailureBlock)failure;

/**
 *  下载文件
 *
 *  @param URL      请求链接
 *  @param fileDir  下载指定位置
 *  @param progress 请求进度
 *  @param success  成功后回调
 *  @param failure  失败后回调
 *
 *  @return 请求任务
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(DNProgressBlock)progress
                                       success:(DNFilePathBlock)success
                                       failure:(DNFailureBlock)failure;


#pragma MArk - 额外的请求配置

/**
 *  设置服务器主域名
 *
 *  @param baseUrl 域名地址
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;

/**
 *  设置请求头
 *
 *  @param value 字段对应的值
 *  @param field 头部字段
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  请求超时时长 默认30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

@end
