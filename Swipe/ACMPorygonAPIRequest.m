//
//  ACMPorygonAPIRequest.m
//  Swipe
//
//  Created by Grant Butler on 8/6/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMPorygonAPIRequest.h"

#include <CommonCrypto/CommonHMAC.h>

#import <SSToolkit/NSDictionary+SSToolkitAdditions.h>

#if defined(DEBUG)
#if TARGET_IPHONE_SIMULATOR
NSString *const ACMPorygonAPIRoot = @"http://porygon.dev/api/1/";
#else
NSString *const ACMPorygonAPIRoot = @"http://192.168.1.103/api/1/";
#endif
#else
NSString *const ACMPorygonAPIRoot = @""; // TODO: Fill this in with the production URL once Porygon goes live.
#endif

static NSString *ACMPorygonAPIRequestConsumerToken = nil;
static NSString *ACMPorygonAPIRequestSecretToken = nil;

@implementation ACMPorygonAPIRequest {
	NSMutableURLRequest *_request;
}

#pragma mark - Private

+ (NSString *)_pathForRequestType:(ACMPorygonAPIRequestType)type {
	switch (type) {
		case ACMPorygonAPIRequestTypeUserCredits:
			return @"user/credit.json";
			break;
		case ACMPorygonAPIRequestTypeUserCreate:
			return @"user/create.json";
			break;
		case ACMPorygonAPIRequestTypeUserPermissions:
			return @"user/permissions.json";
			break;
		case ACMPorygonAPIRequestTypeInventory:
			return @"inventory.json";
			break;
		case ACMPorygonAPIRequestTypeInventoryStock:
			return @"inventory/stock.json";
			break;
	}
	
	return @"";
}

- (void)_setupURLRequest {
	NSString *url = [ACMPorygonAPIRoot stringByAppendingString:[[self class] _pathForRequestType:self.type]];
	
	[_requestData setObject:ACMPorygonAPIRequestConsumerToken forKey:@"api_token"];
	[_requestData setObject:[NSNumber numberWithLong:time(NULL)] forKey:@"api_timestamp"];
	
	NSString *requestData = [_requestData stringWithFormEncodedComponents];
	
	NSData *formComponents = [requestData dataUsingEncoding:NSUTF8StringEncoding];
	NSData *secretData = [ACMPorygonAPIRequestSecretToken dataUsingEncoding:NSUTF8StringEncoding];
	
	uint8_t digest[CC_SHA512_DIGEST_LENGTH];
	
	CCHmac(kCCHmacAlgSHA512, [secretData bytes], [secretData length], [formComponents bytes], [formComponents length], digest);
	
	NSMutableString *signature = [NSMutableString string];
	
	for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
		[signature appendFormat:@"%02x", digest[i]];
	}
	
	requestData = [requestData stringByAppendingFormat:@"&api_signature=%@", signature];
	
	if([[_method lowercaseString] isEqualToString:@"get"]) {
		url = [url stringByAppendingFormat:@"?%@", requestData];
	}
	
	_request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	_request.HTTPMethod = self.method;
	
	if([[_method lowercaseString] isEqualToString:@"post"]) {
		_request.HTTPBody = [requestData dataUsingEncoding:NSUTF8StringEncoding];
	}
}

#pragma mark - Public

#pragma mark - Class Methods

+ (void)setConsumerToken:(NSString *)consumerToken {
	ACMPorygonAPIRequestConsumerToken = consumerToken;
}

+ (NSString *)consumerToken {
	return ACMPorygonAPIRequestConsumerToken;
}

+ (void)setSecretToken:(NSString *)secretToken {
	ACMPorygonAPIRequestSecretToken = secretToken;
}

#pragma mark - Instance Methods

+ (id)requestWithRequestType:(ACMPorygonAPIRequestType)type {
	return [[ACMPorygonAPIRequest alloc] initWithRequestType:type];
}

- (id)initWithRequestType:(ACMPorygonAPIRequestType)type {
	if((self = [super init])) {
		_type = type;
		
		_requestData = [[NSMutableDictionary alloc] init];
		_method = @"GET";
	}
	
	return self;
}

- (void)sendWithSuccess:(ACMPorygonAPIRequestSuccess)success failure:(ACMPorygonAPIRequestFailure)failure {
	if(!ACMPorygonAPIRequestConsumerToken || !ACMPorygonAPIRequestSecretToken) {
		[NSException raise:NSInternalInconsistencyException format:@"Missing required consumer token or secret token. You must set them on ACMPorygonAPIRequest."];
		
		return;
	}
	
	[self _setupURLRequest];
	
	[NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if(error) {
			failure(error);
		} else {
			NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
			
			NSError *err = nil;
			
			id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
			
			if(jsonObject) {
				success(httpResponse, jsonObject);
			} else {
				failure(err);
			}
		}
	}];
}

@end
