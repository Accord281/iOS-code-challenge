//
//  YLPBusiness.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**
 *  Yelp id of this business.
 */
@property (nonatomic, readonly, copy) NSString *identifier;

/**
 *  Name of this business.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 *  Latitude of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *latitude;

/**
 *  Longitude of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *longitude;

/**
 *  Categories of this business.
 */
@property (nonatomic, readonly, copy) NSString *categories;

/**
 *  Rating of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *rating;

/**
 *  Review count of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *reviewCount;

/**
 *  Price Level for this business.
 */
@property (nonatomic, readonly, copy) NSString *price;

/**
 *  Distance of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *distance;

/**
 *  Thumbnail image of this business.
 */
@property (nonatomic, readonly, copy) NSString *thumbnail;

@end

NS_ASSUME_NONNULL_END
