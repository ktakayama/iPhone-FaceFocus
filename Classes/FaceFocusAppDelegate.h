//
//  FaceFocusAppDelegate.h
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright Kyosuke Takayama 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceFocusViewController.h"

@interface FaceFocusAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FaceFocusViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

