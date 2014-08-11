//
//  MUScrubView.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUScrubViewDelegate <NSObject>
- (void)onTouchBegin;
- (void)onDoubleTap;
@end

@interface MUScrubView : UIView
@property(nonatomic, weak) id<MUScrubViewDelegate> delegate;
@property UIImage *image;
- (void)changeColor;
- (void)changeShape;
- (void)resetImage;
- (void)resetMosaic;
- (void)saveImage;
- (void)registOrignalImage:(UIImage *)image;
@end
