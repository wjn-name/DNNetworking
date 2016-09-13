//
//  DNNetworkCache.h
//  DNNerworking
//
//  Created by mainone on 16/9/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNNetworkCache : NSObject

/**
 *  网络数据缓存
 *
 *  @param cache 要缓存的数据
 *  @param key   数据对应的key 一般以请求链接作为key
 */
+ (void)saveHttpCache:(id)cache forKey:(NSString *)key;

/**
 *  获取缓存数据
 *
 *  @param key 存入数据是的key 一般以请求链接作为key
 *
 *  @return 缓存的数据
 */
+ (id)getHttpCacheForKey:(NSString *)key;

/**
 *  获取缓存数据的大小
 *
 *  @return 字节数
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 *  清空所有网络缓存
 */
+ (void)removeAllHttpCache;

@end
