//
//  MUViewController.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUToolBar.h"
#import "MUScrubView.h"
#import "MUAdView.h"

@interface MUViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MUToolBarDelegate, MUScrubViewDelegate>
@property (strong, nonatomic) IBOutlet MUScrubView *scrubView;
@property (weak, nonatomic) IBOutlet MUAdView *adView;
@property (weak, nonatomic) IBOutlet MUToolBar *toolBar;

@end
