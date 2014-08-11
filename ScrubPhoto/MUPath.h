//
//  MUPath.h
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUPath : NSObject
@property CGRect rect;
@property UIColor *color;
- (id)initWithRect:(CGRect)r color:(UIColor *)c;
@end
