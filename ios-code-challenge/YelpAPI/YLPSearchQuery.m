//
//  YLPSearchQuery.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPSearchQuery.h"

@interface YLPSearchQuery()

@property (nonatomic, copy) NSString *location;

@end

@implementation YLPSearchQuery

- (instancetype)initWithLocation:(NSString *)location
{
    if(self = [super init]) {
        _location = location;
    }
    
    return self;
}

- (instancetype)initWithLatitude:(NSString *)latitude longitude:(NSString *)longitude limit:(NSString *) limit offset:(NSString *) offset sortby:(NSString *) sortby
{
    if(self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
        _limit = limit;
        _offset = offset;
        _sortby = _sortby;
    }
    
    return self;
}
- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(self.location) {
        params[@"location"] = self.location;
    }
    
    if(self.term) {
        params[@"term"] = self.term;
    }
    
    if (self.latitude) {
        params[@"latitude"] = self.latitude;
    }
    
    if (self.longitude) {
        params[@"longitude"] = self.longitude;
    }
    
    if (self.limit) {
        params[@"limit"] = self.limit;
    }
    
    if (self.offset) {
        params[@"offset"] = self.offset;
    }
    
    if (self.sortby) {
        params[@"sort_by"] = self.sortby;
    }
    
    if(self.radiusFilter > 0) {
        params[@"radius"] = @(self.radiusFilter);
    }
    
    if(self.categoryFilter != nil && self.categoryFilter.count > 0) {
        params[@"categories"] = [self.categoryFilter componentsJoinedByString:@","];
    }
    
    return params;
}

- (NSArray<NSString *> *)categoryFilter {
    return _categoryFilter ?: @[];
}

@end
