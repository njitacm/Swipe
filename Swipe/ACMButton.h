//
//  ACMButton.h
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ACMButtonTypeNormal = 0,
	ACMButtonTypeRoundedRect = 1
} ACMButtonType;

@interface ACMButton : UIButton

@property (nonatomic, assign) ACMButtonType type;

@end
