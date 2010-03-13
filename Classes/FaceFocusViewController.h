//
//  FaceFocusViewController.h
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright 2010 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImagePickerControllerWithFaceFocus.h"

@interface FaceFocusViewController : UIImagePickerControllerWithFaceFocus
               <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
   UIActivityIndicatorView *indicator;
}

@end
