//
//  UIImage+Resize.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/11.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage *)resizeAspectFitWithSize:(CGSize)size;
- (UIImage *)clipRect:(CGRect)rect;
@end
