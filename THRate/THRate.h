//
//  THRate.h
//  THRateDemo
//
//  Created by viico_mac on 15/5/14.
//  Copyright (c) 2015年 HomTang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THRate : NSObject

+ (instancetype)sharedInstance;

+ (void)rateForApp:(NSString *)appID;

+ (void)registerWithTitle:(NSString *)title
                  message:(NSString *)message
               rateButton:(NSString *)rateButton
             nextRateButton:(NSString *)nextRateButton
             cancelButton:(NSString *)cancelButton
              launchTimes:(NSInteger)times
        autoIncreaseTimes:(NSInteger)increaseTimes
                    appID:(NSString *)appID;

@end
