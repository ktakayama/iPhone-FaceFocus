//
//  FaceFocusAppDelegate.m
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright Kyosuke Takayama 2010. All rights reserved.
//

#import "FaceFocusAppDelegate.h"
#import <opencv/cv.h>

@implementation FaceFocusAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    viewController = [[FaceFocusViewController alloc] init];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
