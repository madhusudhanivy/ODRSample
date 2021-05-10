//
//  RCTBridge.m
//  StartingPoint
//
//  Created by Eros Reale on 27/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EurobetGiochi-Bridging-Header.h"


#pragma mark Adobe
@interface RCT_EXTERN_MODULE(deviceBridge, NSObject)
  + (BOOL)requiresMainQueueSetup
  {
    return NO;
  }
  RCT_EXTERN_METHOD(shareDeviceId)
@end

#pragma mark Geolock
@interface RCT_EXTERN_MODULE(geoLockBridge, NSObject)
  + (BOOL)requiresMainQueueSetup
  {
    return NO;
  }
  RCT_EXTERN_METHOD(askGeolocationPermission)
  RCT_EXTERN_METHOD(checkGeolock:(NSArray *)allowedCountries
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject)
@end

#pragma mark EmbeddedGame
@interface RCT_EXTERN_MODULE(EmbeddedGameBridge, NSObject)
  RCT_EXTERN_METHOD(getGamesCore:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

  RCT_EXTERN_METHOD(openEmbeddedGame:(NSString *)tagName
                                       webServerPort:(nonnull NSNumber *)webServerPort
                                      gameLaunchUrl:(NSString *)gameLaunchUrl
                                      resolver:(RCTPromiseResolveBlock)resolver
                                      rejecter:(RCTPromiseRejectBlock)rejecter)

  RCT_EXTERN_METHOD(openPlaytechLive:(NSString *)username password:(NSString *)password tag:(NSString *)tag)

  RCT_EXTERN_METHOD(openPlaytechNGMEmbeddedGame:(NSString *)tagName
                    webServerPort:(nonnull NSNumber *)webServerPort
                    isForRealMode:(nonnull NSNumber *)isForRealMode
                    gameLaunchUrl:(NSString *)gameLaunchUrl
                    resolver:(RCTPromiseResolveBlock)resolver
                    rejecter:(RCTPromiseRejectBlock)rejecter)

  RCT_EXTERN_METHOD(openPlaytechGPASEmbeddedGame:(NSString *)tagName
                    webServerPort:(nonnull NSNumber *)webServerPort
                    isForRealMode:(nonnull NSNumber *)isForRealMode
                    playtechEmbeddedGameUrl:(NSString *)gameLaunchUrl
                    resolver:(RCTPromiseResolveBlock)resolver
                    rejecter:(RCTPromiseRejectBlock)rejecter)

@end

#pragma mark Orientation
@interface RCT_EXTERN_MODULE(OrientationBridge, NSObject)
  + (BOOL)requiresMainQueueSetup
  {
    return NO;
  }

  RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getOrientation)
  {
    return UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation) ? @"LANDSCAPE" : @"PORTRAIT";
  }

  RCT_EXTERN_METHOD(lockPortrait)
  RCT_EXTERN_METHOD(lockLandscape)
  RCT_EXTERN_METHOD(unlockOrientation)

@end

#pragma mark DeepLinkingBridge
@interface RCT_EXTERN_MODULE(DeepLinkingBridge, NSObject)
  RCT_EXTERN_METHOD(test)
@end

#pragma mark Authentication
@interface RCT_EXTERN_MODULE(keychainBridge, NSObject)
  + (BOOL)requiresMainQueueSetup
  {
    return NO;
  }

  RCT_EXTERN_METHOD(getKeychainCredentials:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)

  RCT_EXTERN_METHOD(setKeychainCredentials:(NSString *)username password:(NSString *)password resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
@end

#pragma mark Biometric Auth
@interface RCT_EXTERN_MODULE(biometricBridge, NSObject)
  + (BOOL)requiresMainQueueSetup
  {
    return NO;
  }

  RCT_EXTERN_METHOD(performBiometricAuth:(NSString *)faceIDReason message:(NSString *)message retry:(NSString *)retry cancel:(NSString *)cancel resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)

  RCT_EXTERN_METHOD(isBiometricAuthAvailable:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
@end


@interface ReactNativeEventEmitter
@end
