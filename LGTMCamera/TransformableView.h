//
//  TransformableView.h
//  LGTMCamera
//
//  Created by raozkulover on 2014/03/13.
//  Copyright (c) 2014年 raozkulover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransformableView : UIImageView

@property(nonatomic) CGFloat scale; //スタンプ拡大縮小
@property(nonatomic) CGFloat angle; //スタンプ拡大縮小
@property(nonatomic) BOOL isTransformable; //スタンプ拡大縮小フラグ

@end
