//
//  MUToolBar.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUToolBarDelegate <NSObject>
- (void)onTouchToolBarCamera:(UIBarButtonItem *)item;
- (void)onTouchToolBarReset:(UIBarButtonItem *)item;
- (void)onTouchToolBarColor:(UIBarButtonItem *)item;
- (void)onTouchToolBarShape:(UIBarButtonItem *)item;
@end

@interface MUToolBar : UIToolbar
@property(nonatomic, weak) id<MUToolBarDelegate> toolBarDelegate;
- (void)hide;
- (void)show;
@end
