//
//  ACMPorygonAPIRequest.h
//  Swipe
//
//  Created by Grant Butler on 8/6/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ACMPorygonAPIRequestType {
	ACMPorygonAPIRequestTypeUserCredits,
	ACMPorygonAPIRequestTypeUserCreate,
	ACMPorygonAPIRequestTypeUserPermissions,
	
	ACMPorygonAPIRequestTypeInventory,
	ACMPorygonAPIRequestTypeInventoryStock
} ACMPorygonAPIRequestType;

typedef void(^ACMPorygonAPIRequestSuccess)(NSHTTPURLResponse *response, id responseObject);
typedef void(^ACMPorygonAPIRequestFailure)(NSError *error);

@interface ACMPorygonAPIRequest : NSObject

@property (nonatomic, assign, readonly) ACMPorygonAPIRequestType type;

@property (nonatomic, strong) NSString *method;

@property (nonatomic, strong, readonly) NSMutableDictionary *requestData;

+ (void)setConsumerToken:(NSString *)consumerToken;
+ (NSString *)consumerToken;

+ (void)setSecretToken:(NSString *)secretToken;

+ (id)requestWithRequestType:(ACMPorygonAPIRequestType)type;

- (id)initWithRequestType:(ACMPorygonAPIRequestType)type;
- (void)sendWithSuccess:(ACMPorygonAPIRequestSuccess)success failure:(ACMPorygonAPIRequestFailure)failure;

@end
