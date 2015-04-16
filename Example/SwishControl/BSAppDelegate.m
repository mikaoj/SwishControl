//
//  BSAppDelegate.m
//  SwishControl
//
//  Created by CocoaPods on 04/14/2015.
//  Copyright (c) 2014 Joakim Gyllstrom. All rights reserved.
//

#import "BSAppDelegate.h"
#import <SwishControl/SwishControl.h>

@implementation BSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    [[UIControl appearance] bs_setAudioWithPath:clickPath forEvent:UIControlEventTouchUpInside];
    
    return YES;
}

@end
