//
//  UIImage+Resize.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/11.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizeAspectFitWithSize:(CGSize)size
{
    CGFloat widthRatio  = size.width  / self.size.width;
    CGFloat heightRatio = size.height / self.size.height;
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    CGFloat width = floor(self.size.width*ratio);
    CGFloat height = floor(self.size.height*ratio);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)clipRect:(CGRect)rect
{
    CGImageRef srcImgRef = [self CGImage];
    CGRect cliprect = CGRectMake(rect.origin.x,
                                 rect.origin.y,
                                 rect.size.width,
                                 rect.size.height);
    CGImageRef imgRef = CGImageCreateWithImageInRect(srcImgRef, cliprect);
    UIImage* clipImage = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return clipImage;
}

@end
