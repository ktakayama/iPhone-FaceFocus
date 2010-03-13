//
//  UIImagePickerControllerWithFaceFocus.m
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright 2010 Kyosuke Takayama. All rights reserved.
//

#import "UIImagePickerControllerWithFaceFocus.h"

CGImageRef UIGetScreenImage();

@implementation UIImagePickerControllerWithFaceFocus

- (void) viewDidLoad {
   [super viewDidLoad];

   [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(didDetectFace:) name:DidDetectFace object:nil];

   [self performSelector:@selector(launchCamera) withObject:nil afterDelay:2.0f];
}

- (void) launchCamera {
   plPreviewView =
      [[[[[[[[[[self.view subviews] objectAtIndex:0] subviews]
         objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];
   [plPreviewView retain];
   [self performSelectorInBackground:@selector(faceDetectPool) withObject:nil];
}

- (void) faceDetectPool {
   @synchronized(self) {
      NSLog(@"faceDetectPool");
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

      // Load XML
      NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
      cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
      storage = cvCreateMemStorage(0);
      [pool release];

      while(1) {
         pool = [[NSAutoreleasePool alloc] init];
         [self faceDetect];
         [pool release];
         usleep(500000);
      }
   }
}

- (void) faceDetect {
   NSLog(@"detect");
   IplImage *image = [self createIplImage:UIGetScreenImage()];

   // Scaling down
   IplImage *small_image = cvCreateImage(cvSize(320/2.0f, 426/2.0f), IPL_DEPTH_8U, 3);
   cvPyrDown(image, small_image, CV_GAUSSIAN_5x5);
   cvReleaseImage(&image);

   // Detect faces and draw rectangle on them
   CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(20, 20));
   cvReleaseImage(&small_image);

   // Draw results on the iamge
   float boxSize = 0;
   CGPoint facePoint;
   for(int i = 0; i < faces->total; i++) {
      // Calc the rect of faces
      CvRect cvrect = *(CvRect*)cvGetSeqElem(faces, i);
      float size = cvrect.width * cvrect.height;
      if(boxSize < size) {
         facePoint = CGPointMake(cvrect.x * 2 + cvrect.width, cvrect.y * 2 + cvrect.height);
         boxSize = size;
      }
   }

   if(boxSize > 0) {
      NSDictionary *dict = [NSDictionary dictionaryWithObject:NSStringFromCGPoint(facePoint) forKey:@"rect"];
      [[NSNotificationCenter defaultCenter]
         postNotificationName:DidDetectFace object:self userInfo:dict];
   }
}

- (IplImage *) createIplImage:(CGImageRef)imageRef {
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   IplImage *iplimage = cvCreateImage(cvSize(320, 427), IPL_DEPTH_8U, 4);
   CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
         iplimage->depth, iplimage->widthStep,
         colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
   CGContextDrawImage(contextRef, CGRectMake(0, 0, 320, 427), imageRef);
   CGContextRelease(contextRef);
   CGColorSpaceRelease(colorSpace);

   IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
   cvCvtColor(iplimage, ret, CV_RGBA2BGR);
   cvReleaseImage(&iplimage);

   return ret;
}

- (void) didDetectFace:(NSNotification *)info {
   NSDictionary *dict = [info userInfo];
   [self performSelectorOnMainThread:@selector(updateFacePoint:) withObject:dict waitUntilDone:YES];
}

- (void) updateFacePoint:(NSDictionary *)dict {
   CGPoint newPoint = CGPointFromString([dict objectForKey:@"rect"]);
   if(abs(newPoint.x - lastPoint.x) + abs(newPoint.y - lastPoint.y) < 30) {
      return;
   }
   [plPreviewView _focusAtPoint:CGPointMake(newPoint.y, 320-newPoint.x)];
   lastPoint = newPoint;
}

- (void)dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   cvReleaseMemStorage(&storage);
   cvReleaseHaarClassifierCascade(&cascade);
   [plPreviewView release];
   [super dealloc];
}

@end
