//
//  MUToolBar.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUToolBar.h"
#import "UIImage+Resize.h"

@implementation MUToolBar {
    UIBarButtonItem *btnCamera;
    UIBarButtonItem *btnReset;
    UIBarButtonItem *btnColor;
    UIBarButtonItem *btnShape;
    UIBarButtonItem *flexibleSp;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
        btnReset  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
        //btnColor  = [[UIBarButtonItem alloc] initWithTitle:@"Color" style:UIBarButtonItemStylePlain  target:nil action:nil];
        btnColor  = [[UIBarButtonItem alloc]
                     initWithImage:[[UIImage imageNamed:@"colorButton.png"] resizeAspectFitWithSize:CGSizeMake(self.frame.size.height / 2, self.frame.size.height / 2)]
                     style:UIBarButtonItemStylePlain target:nil action:nil];
        btnShape  = [[UIBarButtonItem alloc]
                     initWithImage:[[UIImage imageNamed:@"shapeButton.png"] resizeAspectFitWithSize:CGSizeMake(self.frame.size.height / 2, self.frame.size.height / 2)]
                     style:UIBarButtonItemStylePlain target:nil action:nil];
        
        flexibleSp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.items = [NSArray arrayWithObjects:btnCamera, flexibleSp, btnColor, flexibleSp, btnShape, flexibleSp, btnReset, nil];
    }
    return self;
}

- (void)setToolBarDelegate:(id<MUToolBarDelegate>)delegate
{
    _toolBarDelegate = delegate;
    
    btnCamera.target = delegate; btnCamera.action = @selector(onTouchToolBarCamera:);
    btnReset.target = delegate; btnReset.action = @selector(onTouchToolBarReset:);
    btnColor.target = delegate; btnColor.action = @selector(onTouchToolBarColor:);
    btnShape.target = delegate; btnShape.action = @selector(onTouchToolBarShape:);
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.superview.frame.origin.x,
                                self.superview.frame.size.height - self.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.7 animations:^{
        self.frame = CGRectMake(self.superview.frame.origin.x,
                                self.superview.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

@end
