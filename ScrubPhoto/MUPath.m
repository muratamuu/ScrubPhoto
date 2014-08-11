//
//  MUPath.m
//  ScrubPhoto
//
//  Created by muratamuu on 2014/08/10.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

#import "MUPath.h"

@implementation MUPath

@synthesize rect, color;

- (id)initWithRect:(CGRect)r color:(UIColor *)c
{
    if (self = [super init]) {
        rect = r;
        color = c;
    }
    return self;
}

@end
