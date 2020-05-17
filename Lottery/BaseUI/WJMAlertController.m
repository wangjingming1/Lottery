//
//  WJMAlertController.m
//  Lottery
//
//  Created by wangjingming on 2020/5/16.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMAlertController.h"

@interface WJMAlertController ()

@end

@implementation WJMAlertController

+ (WJMAlertController *)showAlertController:(NSString *)title message:(NSString *)message confirmText:(NSString*)confirmText cancelText:(NSString*)cancelText confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel{
    WJMAlertController *alertController = [WJMAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (cancel) cancel();
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmText style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){
        if (confirm) confirm();
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction: confirmAction];
    
    return alertController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
