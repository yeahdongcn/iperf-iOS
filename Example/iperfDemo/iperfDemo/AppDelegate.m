//
//  AppDelegate.m
//  iperfDemo
//
//  Created by R0CKSTAR on 15/3/31.
//  Copyright (c) 2015年 P.D.Q. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

#include "iperf_config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#include <netinet/tcp.h>

#include "iperf.h"
#include "iperf_api.h"
#include "units.h"
#include "iperf_locale.h"
#include "net.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"iperf3.XXXXXX"];
        char buf[PATH_MAX];
        [path getCString:buf maxLength:PATH_MAX encoding:NSUTF8StringEncoding];
        
        struct iperf_test *test = iperf_new_test();
        char *error = NULL;
        if (!test) {
            error = iperf_strerror(i_errno);
            iperf_err(NULL, "create new test error - %s", error);
        }
        
        iperf_defaults(test);
        iperf_set_verbose(test, 1);
        iperf_set_test_role(test, 'c');
        // Switch the iPerf3 server from https://iperf.fr/iperf-servers.php
        iperf_set_test_server_hostname(test, "iperf.scottlinux.com");
        iperf_set_test_server_port(test, 5201);
        iperf_set_test_template(test, buf);
//        iperf_set_test_authentication(test, "authentication");
        // Comment out this line to see to realtime log
        iperf_set_test_json_output(test, 1);
        
        if (iperf_run_client(test) < 0) {
            error = iperf_strerror(i_errno);
            iperf_err(test, "error - %s", error);
        }
        
        NSString *output = nil;
        if (iperf_get_test_json_output_string(test)) {
            output = @(iperf_get_test_json_output_string(test));
        }
        iperf_free_test(test);
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
