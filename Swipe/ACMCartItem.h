//
//  ACMCartItem.h
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACMProduct.h"

@interface ACMCartItem : NSObject

@property (nonatomic, strong) ACMProduct *product;
@property (nonatomic, assign) NSUInteger count;

@end
