//
//  UIImagePickerControllerWithFaceFocus.h
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright 2010 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv/cv.h>

#define DidDetectFace @"DidDetectFace"

@interface UIImagePickerControllerWithFaceFocus : UIImagePickerController {
   UIView *plPreviewView;
   CGPoint lastPoint;
   CvHaarClassifierCascade *cascade;
   CvMemStorage *storage;
}

- (void) faceDetectPool;
- (void) faceDetect;
- (IplImage *) createIplImage:(CGImageRef)imageRef;

@end
