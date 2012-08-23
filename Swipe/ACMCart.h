//
//  ACMCart.h
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACMCartItem.h"

@interface ACMCart : NSObject

@property (nonatomic, strong, readonly) NSArray *items;

@property (nonatomic, strong, readonly) NSNumber *total;

+ (ACMCart *)cart;

- (void)addCartItem:(ACMCartItem *)item;
- (ACMCartItem *)cartItemWithProduct:(ACMProduct *)product;
- (void)removeCartItemWithProduct:(ACMProduct *)product;
- (void)removeCartItemAtIndex:(NSUInteger)index;

- (void)resetCart;

@end
