//
//  ACMInventory.h
//  Swipe
//
//  Created by Grant Butler on 8/16/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMProduct.h"

@interface ACMInventory : NSObject

@property (nonatomic, strong, readonly) NSArray *products;

+ (ACMInventory *)sharedInventory;

- (void)loadProducts;

@end
