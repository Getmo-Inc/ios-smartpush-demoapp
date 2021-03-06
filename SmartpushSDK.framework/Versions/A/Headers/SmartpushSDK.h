//
//  SmartpushSDK.h
//  AnunciosPush
//
//  Created by William Hass on 7/27/14.
//  Copyright (c) 2014 William Hass. All rights reserved.
//  Version 1.3



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SmartpushDevice.h"
#import "SmartpushUser.h"
#import "SmartpushHit.h"

@protocol SmartpushSDKDelegate <NSObject>

@optional

- (void)onPushAccepted:(NSDictionary *)push andOpenFromPush:(BOOL) openFromPush;

@end

@class UIUserNotificationSettings, SmartpushUser;

@interface SmartpushSDK : NSObject

extern NSString * const SmartpushSDKDeviceAddedNotification;
extern NSString * const SmartpushSDKUserInfoObtainedNotification;
extern NSString * const SmartpushSDKBlockUserNotification;

@property (strong, nonatomic) UIWindow *window;

- (NSString *)getDeviceToken;

- (void)registerForPushNotifications;

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

+ (SmartpushSDK*)sharedInstance;

- (SmartpushDevice *)getDevice;
- (SmartpushUser *)getUserInfo;
- (void)setValue:(NSString *)value forTag:(NSString *)key __deprecated_msg("use setString:foTag: instead.");

- (void)setString:(NSString *)value forTag:(NSString *)key;
- (void)setArray:(NSArray *)array forTag:(NSString *)key;
- (void)setNumber:(NSNumber *)number forTag:(NSString *)key;
- (void)setBool:(BOOL)boolean forTag:(NSString *)key;
- (void)setDate:(NSDate*)date forTag:(NSString *)key;

- (void)delString:(NSString *)value forTag:(NSString *)key;
- (void)delArray:(NSArray *)array forTag:(NSString *)key;
- (void)delNumber:(NSNumber *)number forTag:(NSString *)key;
- (void)delBool:(BOOL)boolean forTag:(NSString *)key;
- (void)delDate:(NSDate*)date forTag:(NSString *)key;

- (void)delStringTag:(NSString *)key;
- (void)delArrayTag:(NSString *)key;
- (void)delNumberTag:(NSString *)key;
- (void)delBoolTag:(NSString *)key;
- (void)delDateTag:(NSString *)key;

- (void)nearestZoneWithLatitude:(double)latitude andLongitude:(double)longitude;
- (void)blockUser:(BOOL)block;
- (void)requestCurretUserInformation;
- (void)sendHit:(SmartpushHit *)smartpushHit;
@property (weak, nonatomic) UIResponder<SmartpushSDKDelegate> * delegate;

@end
