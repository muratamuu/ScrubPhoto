//
//  MUViewController.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUViewController.h"

@interface MUViewController ()

@end

@implementation MUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _scrubView.delegate = self;
    _toolBar.toolBarDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchBegin
{
    [_toolBar hide];
    //[_adView hide];
}

- (void)onDoubleTap
{
    [_toolBar show];
    //[_adView show];
}

- (void)onTouchToolBarCamera:(UIBarButtonItem *)item
{
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Photo Library", @"Camera", @"Save", @"Trash", nil];
    [actionSheet showInView:self.view];
}

- (void)onTouchToolBarReset:(UIBarButtonItem *)item
{
    [_scrubView resetMosaic];
}

- (void)onTouchToolBarColor:(UIBarButtonItem *)item
{
    [_scrubView changeColor];
}

- (void)onTouchToolBarShape:(UIBarButtonItem *)item
{
    [_scrubView changeShape];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 4)
        return;
    
    UIImagePickerControllerSourceType sourceType = 0;
    
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            [_scrubView saveImage];
            return;
        case 3:
            [_scrubView resetImage];
            return;
        default:
            break;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
        return;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_scrubView registOrignalImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
