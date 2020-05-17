//
//  AppDelegate.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalDefines.h"
#import "LotteryTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)createFiles{
    [self homePageCreateFiles];
}

- (void)homePageCreateFiles{
    //轮播图片文件夹
    NSLog(@"%@", kDocumentsPath);
    NSString *documentsPath = kDocumentsPath;
    NSString *bannerPath = [NSString stringWithFormat:@"%@/homePage/banner/", documentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:bannerPath isDirectory:&isDir];
    if (!isDir && !existed) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:bannerPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self createFiles];
    if(@available(iOS 13, *)){
        
    } else {
//        self.window.backgroundColor = UIColor.commonBackgroundColor;// [UIColor whiteColor];
        self.window.rootViewController = [[LotteryTabBarViewController alloc] initWithNibName:@"LotteryTabBarViewController" bundle:nil];
    }
    return YES;
}
//说明：当应用程序将要进入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了。
- (void)applicationWillResignActive:(UIApplication*)application{
    NSLog(@"applicationWillResignActive:当应用程序将要进入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了。");
}
//说明：当应用程序进入活动状态执行，这个刚好和上面的那个方法相反
- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"applicationDidBecomeActive:当应用程序进入活动状态执行，这个刚好和上面的那个方法相反");
}
//说明：当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可。
- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"applicationDidEnterBackground:当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可。");
}
//说明：当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"applicationWillEnterForeground:当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。");
}
//说明：当程序将要退出时调用，通常是用来保存数据和一些推出前的清理工作。这个需要设置UIApplicationExitsOnSuspend的键值。
- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"applicationWillTerminate:当程序将要退出时调用，通常是用来保存数据和一些推出前的清理工作。这个需要设置UIApplicationExitsOnSuspend的键值。");
}

//说明：内存警告，通常可以在这里进行内存清理工作防止程序被终止
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"applicationDidReceiveMemoryWarning:内存警告，通常可以在这里进行内存清理工作防止程序被终止");
}
//说明：当系统时间发生改变时执行
- (void)applicationSignificantTimeChange:(UIApplication *)application{
    NSLog(@"当系统时间发生改变时执行:applicationSignificantTimeChange");
}
//说明：当程序载入后执行
- (void)applicationDidFinishLaunching:(UIApplication *)application{
    NSLog(@"当程序载入后执行:applicationDidFinishLaunching");
}
//说明：当前是通过URL启动
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
