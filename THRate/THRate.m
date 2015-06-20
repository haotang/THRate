//
//  THRate.m
//  THRateDemo
//
//  Created by viico_mac on 15/5/14.
//  Copyright (c) 2015年 HomTang. All rights reserved.
//

#import "THRate.h"

#define kTHRateCurrentLaunchTimes           @"THRateCurrentLaunchTimes"
#define kTHRateCurrentRequiredLaunchTimes    @"THRateCurrentRequiredLaunchTimes"
#define kTHRateNevelShowRated                     @"THRateNevelShowRated"
#define kTHRateLastShowRateDate             @"THRateLastShowRateDate"

@interface THRate ()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, assign) NSInteger increaseTimes;
@property (nonatomic, assign) NSInteger currentRequiredTimes;

@end

@implementation THRate

+ (instancetype)sharedInstance {
    static THRate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)registerWithTitle:(NSString *)title
                  message:(NSString *)message
               rateButton:(NSString *)rateButton
           nextRateButton:(NSString *)nextRateButton
             cancelButton:(NSString *)cancelButton
              launchTimes:(NSInteger)times
        autoIncreaseTimes:(NSInteger)increaseTimes
                    appID:(NSString *)appID {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kTHRateNevelShowRated]) {
        return;
    }
    
    [THRate sharedInstance].appID = appID;
    [THRate sharedInstance].increaseTimes = increaseTimes;
    NSInteger currentTimes = [[NSUserDefaults standardUserDefaults] integerForKey:kTHRateCurrentLaunchTimes];
    currentTimes++;
    [[NSUserDefaults standardUserDefaults] setInteger:currentTimes forKey:kTHRateCurrentLaunchTimes];
    
    NSInteger currentRequiredTimes = [[NSUserDefaults standardUserDefaults] integerForKey:kTHRateCurrentRequiredLaunchTimes];
    
    if (times > currentRequiredTimes) {
        currentRequiredTimes = times;
        [[NSUserDefaults standardUserDefaults] setInteger:times forKey:kTHRateCurrentRequiredLaunchTimes];
    }
    
    if (currentTimes >= currentRequiredTimes) {
        // Save new launch required times
        currentRequiredTimes += increaseTimes;
        [[NSUserDefaults standardUserDefaults] setInteger:currentRequiredTimes forKey:kTHRateCurrentRequiredLaunchTimes];
        
        // Reset current launch times
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kTHRateCurrentLaunchTimes];
        
        BOOL canShowAlert = NO;
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970];

        if ([[NSUserDefaults standardUserDefaults] objectForKey:kTHRateLastShowRateDate]) {
            NSTimeInterval last = [[[NSUserDefaults standardUserDefaults] objectForKey:kTHRateLastShowRateDate] doubleValue];
            NSTimeInterval time = current - last;
            if (time > 24 * 60 * 60) {
                canShowAlert = YES;
            }
        } else {
            canShowAlert = YES;
        }
        
        if (canShowAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:[THRate sharedInstance] cancelButtonTitle:nextRateButton otherButtonTitles:rateButton, cancelButton, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:current] forKey:kTHRateLastShowRateDate];
        }
    }
}

+ (void)rateForApp:(NSString *)appID {
    NSString *str = @"";
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
    } else {
        str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (instancetype)init {
    if (self = [super init]) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kTHRateCurrentLaunchTimes]) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kTHRateCurrentLaunchTimes];
        }
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kTHRateCurrentRequiredLaunchTimes]) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kTHRateCurrentRequiredLaunchTimes];
        }
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        // refuse rate
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTHRateNevelShowRated];
    } else if (buttonIndex == 1) {
        // go rate
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTHRateNevelShowRated];
        [THRate rateForApp:[THRate sharedInstance].appID];
    }
}

@end
