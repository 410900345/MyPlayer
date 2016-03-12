//
//  AppDelegate.m
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    return YES;
}
//后台播放控制
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type==UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.play play];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.play nextMusic];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.play lastMusic];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.play stop];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.play playOrStop];
                break;
            default:
                break;
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
   //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goBack" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goForward" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
