//
//  NXTBusinessTableViewCell+YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "NXTBusinessTableViewCell+YLPBusiness.h"
#import "YLPBusiness.h"

@implementation NXTBusinessTableViewCell (YLPBusiness) 

- (void)configureCell:(YLPBusiness *)business
{
    // Business Name
    self.nameLabel.text = business.name;
    self.categoriesLabel.text = business.categories;
    self.ratingLabel.text =[NSString stringWithFormat:@"%@ (%@ reviews)", business.rating.description, business.reviewCount.description];
    self.distanceLabel.text = business.distance.description;
    self.thumbnailImage.image = [UIImage imageNamed:business.thumbnail];
}

#pragma mark - NXTBindingDataForObjectDelegate
- (void)bindingDataForObject:(id)object
{
    [self configureCell:(YLPBusiness *)object];
}

@end
