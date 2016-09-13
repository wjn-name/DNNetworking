//
//  DNNetworkCache.m
//  DNNerworking
//
//  Created by mainone on 16/9/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "DNNetworkCache.h"
#import "YYCache.h"

@implementation DNNetworkCache
static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;


+ (void)initialize {
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveHttpCache:(id)cache forKey:(NSString *)key {
    [_dataCache setObject:cache forKey:key];
}

+ (id)getHttpCacheForKey:(NSString *)key {
    return [_dataCache objectForKey:key];
}

+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

@end
