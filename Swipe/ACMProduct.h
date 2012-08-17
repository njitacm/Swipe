//
//  ACMProduct.h
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACMProduct : NSObject

@property (nonatomic, strong) NSNumber *objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSURL *pictureURL;
@property (nonatomic, strong) UIImage *picture;

+ (ACMProduct *)productWithDictionary:(NSDictionary *)dict;

@end
