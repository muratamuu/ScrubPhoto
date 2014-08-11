//
//  MUScrubView.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUScrubView.h"
#import "MUPath.h"
#import "MUToast.h"
#import "MUCommonDefine.h"
#import "UIImage+Resize.h"

@implementation MUScrubView {
    UIImage *origImage_;
    UIImage *viewImage_;
    NSMutableArray *pathTable_;
    CGPoint lastPoint_;
    CGFloat adjustX_;
    CGFloat adjustY_;
    CGRect mosaicRect_;
    int shapeMode_; // 0:rect 1:ellipse
    int colorMode_; // 0:color 1:mono
    int imageType_; // 0:gogh 1:monarisa 2:original
    CGFloat resizeRatio_;
    MUPath* resetPath_;
    MUToast* toast_;
    UIActivityIndicatorView* indicator_;
    BOOL isSaving;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // create toast view
        toast_ = [[MUToast alloc] initWithParentView:self];
        
        // create indicator view
        indicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator_.center = self.center;
        [self addSubview:indicator_];
        isSaving = NO;
        
        imageType_ = 1;
        [self resetImage];
        
        // set double tap gesture
        self.multipleTouchEnabled = YES;
        UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
    }
    return self;
}

- (void) handleDoubleTapGesture:(UITapGestureRecognizer*)sender
{
    if ([self.delegate respondsToSelector:@selector(onDoubleTap)]) {
        [self.delegate onDoubleTap];
    }
}

- (void)changeColor
{
    colorMode_ = (colorMode_ + 1) % 2;
    if (colorMode_ == 0) {
        toast_.text = @"color";
    } else {
        toast_.text = @"gray";
    }
    [self setNeedsDisplay];
}

- (void)changeShape
{
    shapeMode_ = (shapeMode_ + 1) % 2;
    if (shapeMode_ == 0) {
        toast_.text = @"circle";
    } else {
        toast_.text = @"square";
    }
    [self setNeedsDisplay];
}

- (void)resetImage
{
    imageType_ = (imageType_ + 1) % 2;
    if (imageType_ == 0)
        self.image = [UIImage imageNamed:@"gogh.jpg"];
    else
        self.image = [UIImage imageNamed:@"monarisa.jpg"];
}

- (void)resetMosaic
{
    if (imageType_ < 2)
        [self resetImage];
    
    [pathTable_ removeAllObjects];
    [pathTable_ addObject:resetPath_];
    [self setNeedsDisplay];
}

- (void)registOrignalImage:(UIImage *)image
{
    imageType_ = 2;
    self.image = image;
}

- (void)setImage:(UIImage *)image
{
    shapeMode_ = 1; // rect
    colorMode_ = 0; // color
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    origImage_ = image;
    viewImage_ = [origImage_ resizeAspectFitWithSize:appFrame.size]; //[self resizeAspectFitWithSize:origImage_ size:appFrame.size];
    resizeRatio_ = viewImage_.size.width / origImage_.size.width;
    adjustX_ = floor((appFrame.size.width - viewImage_.size.width) / 2.f) + appFrame.origin.x;
    adjustY_ = floor((appFrame.size.height - viewImage_.size.height) / 2.f) + appFrame.origin.y;
    mosaicRect_ = CGRectMake(adjustX_, adjustY_, viewImage_.size.width, viewImage_.size.height);
    UIColor *resetColor = [self getAverageColorImage:viewImage_ rect:mosaicRect_];
    
    resetPath_ = [[MUPath alloc] initWithRect:mosaicRect_ color:resetColor];
    
    lastPoint_ = CGPointMake(0, 0);
    
    pathTable_ = [[NSMutableArray alloc] init];
    [pathTable_ addObject:resetPath_];
    
    [self setNeedsDisplay];
}

- (UIImage *)image
{
    return origImage_;
}

- (void)saveImage
{
    isSaving = YES;
    [indicator_ startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContext(origImage_.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (MUPath *item in pathTable_) {
            CGRect rect = item.rect;
            CGRect origRect;
            origRect = CGRectMake(ceil((rect.origin.x - adjustX_) / resizeRatio_),
                                  ceil((rect.origin.y - adjustY_) / resizeRatio_),
                                  ceil(rect.size.width / resizeRatio_),
                                  ceil(rect.size.height / resizeRatio_));
            
            CGContextSetFillColorWithColor(context, item.color.CGColor);
            [self drawPathInContext:context rect:origRect];
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:), NULL);
    });
}

- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [indicator_ stopAnimating];
    toast_.text = @"Save";
    isSaving = NO;
}

- (UIColor *)getAverageColorImage:(UIImage *)image rect:(CGRect)rect
{
    UIImage* clippedImage = [image clipRect:rect];
    if (clippedImage == nil) {
        NSLog(@"ERROR!! clippedImage %@ image.size %@", NSStringFromCGRect(rect), NSStringFromCGSize(image.size));
        return nil;
    }
    return [self getAverageColorImage:clippedImage];
}

- (UIColor *)getAverageColorImage:(UIImage *)image
{
    UIColor *color;
    CGFloat red, green, blue, alpha;
    [self getAverageColorImageSub:image red:&red green:&green blue:&blue alpha:&alpha];
    
    if (colorMode_ == 0) {
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } else {
        CGFloat brightness = ((77 * (red * 255) + 28 * (green * 255) + 151 * (blue * 255)) / 256) / 255.f;
        color = [UIColor colorWithRed:brightness green:brightness blue:brightness alpha:alpha];
    }
    return color;
}

- (void)getAverageColorImageSub:(UIImage *)image
                            red:(CGFloat *)red
                          green:(CGFloat *)green
                           blue:(CGFloat *)blue
                          alpha:(CGFloat *)alpha
{
    CGImageRef imageRef = image.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8* buffer = (UInt8*)CFDataGetBytePtr(data);
    
    CGImageAlphaInfo alphainfo = CGImageGetAlphaInfo(imageRef);
    int rfirst = 0;
    switch (alphainfo) {
        case kCGImageAlphaFirst:              // 4:BGRA
        case kCGImageAlphaPremultipliedFirst: // 2:BGRA
        case kCGImageAlphaNoneSkipFirst:      // 6:BGR_
            rfirst = 0; // BGRA
            break;
            
        case kCGImageAlphaLast:               // 3:RGBA
        case kCGImageAlphaPremultipliedLast:  // 1:RGBA
        case kCGImageAlphaNone:               // 0:RGB_
        case kCGImageAlphaNoneSkipLast:       // 5:RGB_
            rfirst = 1;
            break;
        default:
            break;
    }
    
    NSUInteger r = 0, g = 0, b = 0, a = 0;
    for (NSUInteger y = 0; y < height; y++) {
        for (NSUInteger x = 0; x < width; x++) {
            UInt8* tmp = buffer + y * bytesPerRow + x * 4;
            if (rfirst == 0) {
                b += *(tmp + 0);
                g += *(tmp + 1);
                r += *(tmp + 2);
                a += *(tmp + 3);
            } else {
                r += *(tmp + 0);
                g += *(tmp + 1);
                b += *(tmp + 2);
                a += *(tmp + 3);
            }
        }
    }
    
    NSUInteger max = width * height;
    *red   = (r / max) / 255.f;
    *green = (g / max) / 255.f;
    *blue  = (b / max) / 255.f;
    *alpha = (a / max) / 255.f;
    
    CFRelease(data);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (MUPath *item in pathTable_) {
        CGRect subrect = item.rect;
        if (CGRectContainsRect(rect, subrect)) {
            CGRect imagerect = CGRectMake(subrect.origin.x - adjustX_, subrect.origin.y - adjustY_,
                                          subrect.size.width, subrect.size.height);
            item.color = [self getAverageColorImage:viewImage_ rect:imagerect];
            CGContextSetFillColorWithColor(context, item.color.CGColor);
            [self drawPathInContext:context rect:subrect];
        }
    }
}

- (void)drawPathInContext:(CGContextRef)context rect:(CGRect)rect
{
    if (shapeMode_ == 0)
        CGContextFillEllipseInRect(context, rect);
    else
        CGContextFillRect(context, rect);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(onTouchBegin)]) {
        [self.delegate onTouchBegin];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isSaving) return;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGFloat dist = sqrt(pow(location.x - lastPoint_.x, 2) + pow(location.y - lastPoint_.y, 2));
    if (dist > 10) {
        lastPoint_ = location;
        [self splitPath:location];
    }
}

- (void)splitPath:(CGPoint)point
{
    for (MUPath *item in pathTable_) {
        CGRect rect = item.rect;
        if (CGRectContainsPoint(rect, point)) {
            if (rect.size.width <= 5 && rect.size.height <= 5)
                break;
            CGRect div1, div2;
            [self splitRect:rect div1:&div1 div2:&div2];
            [pathTable_ removeObject:item];
            if (!CGRectIsEmpty(div1)) {
                [pathTable_ addObject:[[MUPath alloc] initWithRect:div1 color:nil]];
            }
            if (!CGRectIsEmpty(div2)) {
                [pathTable_ addObject:[[MUPath alloc] initWithRect:div2 color:nil]];
            }
            [self setNeedsDisplayInRect:rect];
            break;
        }
    }
}

- (void)splitRect:(CGRect)src div1:(CGRect *)div1 div2:(CGRect *)div2
{
    if (src.size.width > src.size.height) {
        // landscape
        div1->origin.x = src.origin.x;
        div1->origin.y = src.origin.y;
        div1->size.width = ceil(src.size.width / 2.f);
        div1->size.height = src.size.height;
        
        div2->origin.x = src.origin.x + ceil(src.size.width / 2.f);
        div2->origin.y = src.origin.y;
        div2->size.width = floor(src.size.width / 2.f);
        div2->size.height = src.size.height;
    } else {
        // portrait
        div1->origin.x = src.origin.x;
        div1->origin.y = src.origin.y;
        div1->size.width = src.size.width;
        div1->size.height = ceil(src.size.height / 2.f);
        
        div2->origin.x = src.origin.x;
        div2->origin.y = src.origin.y + ceil(src.size.height / 2.f);
        div2->size.width = src.size.width;
        div2->size.height = floor(src.size.height / 2.f);
    }
}

@end
