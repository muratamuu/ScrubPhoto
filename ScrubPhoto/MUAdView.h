//
//  MUAdView.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <iAd/iAd.h>

@interface MUAdView : ADBannerView<ADBannerViewDelegate>
- (void)hide;
- (void)show;
@end
