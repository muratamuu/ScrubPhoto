//
//  MUToast.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUToast.h"

#define MU_TOAST_WIDTH (100)
#define MU_TOAST_HEIGHT (50)

@implementation MUToast {
    UIToolbar* toolBar_;
    UILabel* textLbl_;
}

- (id)initWithParentView:(UIView *)parent
{
    CGRect frame = CGRectMake((parent.frame.size.width + MU_TOAST_WIDTH) / 2 - MU_TOAST_WIDTH,
                              (parent.frame.size.height) * 9 / 10 - MU_TOAST_HEIGHT,
                              MU_TOAST_WIDTH, MU_TOAST_HEIGHT);
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10.0;
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithHue:0.6 saturation:0.5 brightness:0.8 alpha:0.7];
        textLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MU_TOAST_WIDTH, MU_TOAST_HEIGHT)];
        textLbl_.textAlignment = NSTextAlignmentCenter;
        textLbl_.text = @"";
        textLbl_.textColor = [UIColor whiteColor];
        [self addSubview:textLbl_];
        [parent addSubview:self];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    textLbl_.text = text;
    self.alpha = 1.0;
    [UIView animateWithDuration:1.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{ self.alpha = 0; }
                     completion:nil];
}

- (NSString*)text
{
    return textLbl_.text;
}

@end
