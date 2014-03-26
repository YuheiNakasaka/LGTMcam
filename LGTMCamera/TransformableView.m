//
//  TransformableView.m
//  LGTMCamera
//
//  Created by raozkulover on 2014/03/13.
//  Copyright (c) 2014年 raozkulover. All rights reserved.
// 

#import "TransformableView.h"

@implementation TransformableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scale = 1.0;
        _angle = 0.0;
        _isTransformable = YES;
    }
    return self;
}

-(void)setScale:(CGFloat)scale{
    if (!_isTransformable) {
        return;
    }
    //Minimum scale
    if (scale<0.5) {
        scale = 0.5;
    }
    //Max scale
    if (scale>2.0) {
        scale = 2.0;
    }
    _scale = scale;
    [self doTransform];
}

-(void)setAngle:(CGFloat)angle{
    if (!_isTransformable) {
        return;
    }
    _angle = angle;
    [self doTransform];
}

-(void)doTransform{
    CGAffineTransform pinchTransform = CGAffineTransformMakeScale(_scale, _scale);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(_angle);
    self.transform = CGAffineTransformConcat(pinchTransform, rotationTransform);
}

@end
