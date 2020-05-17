//
//  WJMAlertController.h
//  Lottery
//
//  Created by wangjingming on 2020/5/16.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJMAlertController : UIAlertController

+ (WJMAlertController *)showAlertController:(NSString *)title message:(NSString *)message confirmText:(NSString*)confirmText cancelText:(NSString*)cancelText confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel;
@end

NS_ASSUME_NONNULL_END
