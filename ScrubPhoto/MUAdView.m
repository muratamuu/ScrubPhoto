//
//  MUAdView.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUAdView.h"

#define MU_IAD_VIEW_STATUS_UNLOAD  (0)
#define MU_IAD_VIEW_STATUS_SHOW    (1)
#define MU_IAD_VIEW_STATUS_SHOWING (2)
#define MU_IAD_VIEW_STATUS_HIDING  (3)
#define MU_IAD_VIEW_STATUS_HIDE    (4)

#define MU_IAD_VIEW_HIDE_WAIT_TIME (5)

@implementation MUAdView {
    int status;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        status = MU_IAD_VIEW_STATUS_UNLOAD;
        self.alpha = 0.0;
    }
    return self;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.alpha = 1.0;
    status = MU_IAD_VIEW_STATUS_HIDE;
    [self show];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    status = MU_IAD_VIEW_STATUS_UNLOAD;
    self.alpha = 0.0;
}

- (void)show
{
    if (status == MU_IAD_VIEW_STATUS_HIDE) {
        status = MU_IAD_VIEW_STATUS_SHOWING;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(self.superview.frame.origin.x,
                                                     self.superview.frame.origin.y,
                                                     self.frame.size.width,
                                                     self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             status = MU_IAD_VIEW_STATUS_SHOW;
                         }];
    }
}

- (void)hide
{
    if (status == MU_IAD_VIEW_STATUS_SHOW) {
        status = MU_IAD_VIEW_STATUS_HIDING;
        [self performSelector:@selector(hideSub) withObject:nil afterDelay:MU_IAD_VIEW_HIDE_WAIT_TIME];
    }
}

- (void)hideSub
{
    [UIView animateWithDuration:0.7
                     animations:^{
                         self.frame = CGRectMake(self.superview.frame.origin.x,
                                                 self.superview.frame.origin.y - self.frame.size.height,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         status = MU_IAD_VIEW_STATUS_HIDE;
                     }];
}

@end
