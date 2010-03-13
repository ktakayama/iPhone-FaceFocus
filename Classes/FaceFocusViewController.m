//
//  FaceFocusViewController.m
//  FaceFocus
//
//  Created by Kyosuke Takayama on 10/02/05.
//  Copyright 2010 Kyosuke Takayama. All rights reserved.
//

#import "FaceFocusViewController.h"

@implementation FaceFocusViewController

- (void) viewDidLoad {
   [super viewDidLoad];

   if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      self.sourceType = UIImagePickerControllerSourceTypeCamera;
      self.delegate = self;
   }

   UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480-53,320,53)];
   bar.backgroundColor = [UIColor redColor];
   bar.barStyle = UIBarStyleBlackOpaque;
   [self.view addSubview:bar];

   UIBarButtonItem *flexible = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithTitle:@"(^^)"
         style:UIBarButtonItemStylePlain target:self action:@selector(takePicture)];
   [bar setItems:[NSArray arrayWithObjects:flexible, cameraButton, flexible, nil] animated:NO];
   [flexible release];
   [cameraButton release];
   [bar release];

   indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   indicator.center = CGPointMake(300, 450);
   [self.view addSubview:indicator];
}

- (void) takePicture {
   self.showsCameraControls = NO;
   [super takePicture];
}

- (void) imagePickerController:(UIImagePickerController *)picker
            didFinishPickingMediaWithInfo:(NSDictionary *)info {
   UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
   [indicator startAnimating];
   UIImageWriteToSavedPhotosAlbum(image, self, @selector(didSaved:didFinishSavingWithError:contextInfo:), nil);
   self.showsCameraControls = YES;
}

- (void) didSaved:(UIImage *)image
      didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
   [indicator stopAnimating];
}

- (void)dealloc {
   [indicator release];
   [super dealloc];
}

@end
