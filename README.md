# DNNetworking
网络请求封装~基于AFNetworking 3.X

###实现的功能

####1.网络状态监测
1)全局检测

    + (void)startMonitoringNetwork;

2)通Block回调网络状态

    + (void)checkNetworkStatusWithBlock:(DNNetStatus)status;

3)检测当前是否有网

    + (BOOL)currentNetworkStatus;

####2.GET POST请求, 各提供两种模式,有缓存和无缓存模式

1)GET 

    + (NSURLSessionTask *)Get:(NSString *)URL
                   parameters:(NSDictionary *)parameters
                responseCache:(DNCacheBlock)responseCache
                      success:(DNSuccessBlock)success
                      failure:(DNFailureBlock)failure

2)POST 

    + (NSURLSessionTask *)POST:(NSString *)URL
                    parameters:(NSDictionary *)parameters
                 responseCache:(DNCacheBlock)responseCache
                       success:(DNSuccessBlock)success
                       failure:(DNFailureBlock)failure;

####3.上传图片

    + (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                             parameters:(NSDictionary *)parameters
                                 images:(NSArray<UIImage *> *)images
                                   name:(NSString *)name
                               fileName:(NSString *)fileName
                               progress:(DNProgressBlock)progress
                                success:(DNSuccessBlock)success
                                failure:(DNFailureBlock)failure;

####4.下载文件

    + (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                           fileDir:(NSString *)fileDir
                                          progress:(DNProgressBlock)progress
                                           success:(DNFilePathBlock)success
                                           failure:(DNFailureBlock)failure;

###另外封装类还提供了一些便捷的请求设置

####1.全局设置请服务器域名,可以将域名提取便于编译内外网域名那个测试,只需在AppDelegate中设置一次即可,会自动判断链接是否是完整链接

    + (void)updateBaseUrl:(NSString *)baseUrl

####2.设置超时时间

    + (void)setRequestTimeoutInterval:(NSTimeInterval)time

####3.设置请求头

    + (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field

目前只加入这些常用的配置.实际项目有其他需求可自行添加

