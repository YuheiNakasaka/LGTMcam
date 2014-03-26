//
//  ViewController.h
//  LGTMCamera
//
//  Created by raozkulover on 2014/03/10.
//  Copyright (c) 2014年 raozkulover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"
#import "TransformableView.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_headerMargin; //ヘッダー
@property (weak, nonatomic) IBOutlet UINavigationBar *headerNavBar; //ナビバー
@property (nonatomic,strong) UIImageView *showImageView; //画像貼り付け用
@property (weak, nonatomic) IBOutlet UIView *buttonView; //ボタンの基礎
@property (nonatomic,strong) TransformableView *currentStampView; //スタンプ画像
@property (nonatomic,strong) UIImage *saveImage;
@property (weak, nonatomic) IBOutlet UIButton *saveAndShareButton; //shareボタン
@property (weak, nonatomic) IBOutlet UIButton *retakeButton; //撮り直しボタン
@property (nonatomic, strong) NSString *stampName; // スタンプ初期画像
@property (weak, nonatomic) IBOutlet JSQFlatButton *horizontalStamp; //横スタンプ
@property (weak, nonatomic) IBOutlet JSQFlatButton *verticalStamp; //縦スタンプ
@property (weak, nonatomic) IBOutlet JSQFlatButton *decreaseFrameSize; //スタンプ大きさ-

@property CGFloat *stampPointX; //スタンプX
@property CGFloat *stampPointY; //スタンプY

@property BOOL _isPressStamp; //スタンプ貼り付けフラグ
@property BOOL _isOpenCamera; //カメラ起動フラグ
@property BOOL _isTouchCount; //タッチの本数
@property BOOL _isRotate; //タッチの本数
@property NSInteger _stampSwitchFlag; //スタンプ切り替え

@property (nonatomic,strong) UIAlertView *alert;


//カメラ使用開始
- (void)startCamera;
//撮り直し時カメラ起動
- (IBAction)startRetakeCamera:(id)sender;
//カメラロールに保存
//- (IBAction)saveCameraRoll:(id)sender;
//SNSに投稿する
- (IBAction)bsend:(id)sender;
//横スタンプ
- (IBAction)isHorizontal:(id)sender;
//縦スタンプ
- (IBAction)isVertical:(id)sender;
//スタンプ縮小
- (IBAction)smaller:(id)sender;
@end
