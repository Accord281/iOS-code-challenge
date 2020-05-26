//
//  YLPSearchQuery.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YLPSearchQuery : NSObject

//- (instancetype)initWithLocation:(NSString *)location;

/**
 *Initialize with Latitude, Longitude, number of records to return, number of records to offset, and sort by.
 */
- (instancetype)initWithLatitude:(NSString *)latitude longitude:(NSString *)longitude limit:(NSString *) limit offset:(NSString *) offset sortby:(NSString *) sortby;

- (NSDictionary *)parameters;

/**
 *  Optional. Search term (e.g. "food", "restaurants"). If term isn’t included we
 *  search everything. The term keyword also accepts business names such as "Starbucks".
 */
@property (nonatomic, copy, nullable) NSString *term;

/**
 *  Optional. Categories to filter the search results with.
 *  The category filter can be a list of comma delimited categories. For example,
 *  "bars,french" will filter by Bars OR French. The category identifier should be
 *  used (for example "discgolf", not "Disc Golf").
 */
@property (nonatomic, copy, null_resettable) NSArray<NSString *> *categoryFilter;

/**
 *  Optional. Search radius in meters. If the value is too large, a AREA_TOO_LARGE
 *  error may be returned. The max value is 40000 meters (25 miles).
 */
@property (nonatomic, assign) double radiusFilter;

/**
 *  Optional. Search via location
 */
@property (nonatomic, copy, nullable) NSString *latitude;

/**
 *  Optional. Search via location
 */
@property (nonatomic, copy, nullable) NSString *longitude;

/**
 *  Optional. Limit number of results
 */
@property (nonatomic, copy, nullable) NSString *limit;

/**
 *  Optional. Offset number of results
 */
@property (nonatomic, copy, nullable) NSString *offset;

/**
 *  Optional. Sort the results
 */
@property (nonatomic, copy, nullable) NSString *sortby;

@end

NS_ASSUME_NONNULL_END
