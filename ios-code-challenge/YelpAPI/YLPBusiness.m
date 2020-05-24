//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init]) {
        _identifier = attributes[@"id"];
        _name = attributes[@"name"];
        _latitude = [self.class getLatitudeFromYelp:attributes];
        _longitude = [self.class getLongitudeFromYelp:attributes];
        _categories = [self.class getCategories:attributes];
        _rating = (attributes[@"rating"]);
        _reviewCount = attributes[@"review_count"];
        _price = (attributes[@"price"]);
        _distance = (attributes[@"distance"]);
        _thumbnail = (attributes[@"image_url"]);
    }
    
    return self;
}

+ (NSString *) getLatitudeFromYelp:(NSDictionary *)attributes {
    NSDictionary *coordinates = attributes[@"coordinates"];
    return [coordinates objectForKey:@"latitude"];
}

+ (NSString *) getLongitudeFromYelp:(NSDictionary *)attributes {
    NSDictionary *coordinates = attributes[@"coordinates"];
    return [coordinates objectForKey:@"longitude"];
}

+ (NSString *) getCategories:(NSDictionary *)attributes {
    NSArray *categoriesArray = attributes[@"categories"];
    
    NSMutableArray *categoriesStringArray = [[NSMutableArray alloc] init];
    for (NSDictionary *cat in categoriesArray) {
        [categoriesStringArray addObject:[cat objectForKey:@"title"]];
    }
    return [categoriesStringArray componentsJoinedByString:@","];
}

@end
