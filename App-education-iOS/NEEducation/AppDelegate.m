//
//  AppDelegate.m
//  NEEducation
//
//  Created by Netease on 2021/1/18.
//

#import "AppDelegate.h"
#import "EnterLessonViewController.h"
#import "ENavigationViewController.h"
#import <NEMeetingSDK/NEMeetingSDK.h>
#import "Config.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    EnterLessonViewController *enterLessonVC = [[EnterLessonViewController alloc] init];
    ENavigationViewController *navgationViewController = [[ENavigationViewController alloc] initWithRootViewController:enterLessonVC];
    self.window.rootViewController = navgationViewController;
    [self.window makeKeyAndVisible];
    [self setupSDK];
    return YES;
}

- (void)setupSDK {
    NEMeetingSDKConfig *config = [[NEMeetingSDKConfig alloc] init];
    config.appKey = kAppKey;
    config.enableDebugLog = YES;
    config.appName = @"智慧云课堂";
    [[NEMeetingSDK getInstance] initialize:config
                                  callback:^(NSInteger resultCode, NSString *resultMsg, id result) {
        NSLog(@"[demo init] code:%@ msg:%@ result:%@", @(resultCode), resultMsg, result);
    }];
}

@end
