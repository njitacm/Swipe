//
//  ACMAlertView.h
//  Swipe
//
//  Created by Grant Butler on 8/23/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACMAlertView : UIAlertView <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (NSInteger)addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(dispatch_block_t)block;

@end
