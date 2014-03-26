//
//  ViewController.m
//  LGTMCamera
//
//  Created by raozkulover on 2014/03/10.
//  Copyright (c) 2014年 raozkulover. All rights reserved.
//

// 以下のエントリなどを切り貼りしました。みなさま、ソースコメントからですがありがとうございました。
//
// 【DECOPIC風】画像にスタンプを挿入できる機能を実装する http://himaratsu.hatenablog.com/entry/objc/stamp
//  iOSのスクリーンで２本指を使いUIViewの回転、拡大/縮小を同時に行う http://qiita.com/yuky_az/items/e999003d72b42b0f6865
//  iOSのカメラ機能を使う方法まとめ【13日目】 http://dev.classmethod.jp/smartphone/ios-camera-intro/
//  [iOS 7] 自作アプリにFlickrとVimeo投稿機能を実装する http://dev.classmethod.jp/references/ios7_flickr_vimeo2/
//  iOS7でナビゲーションバーやステータスバーをカスタマイズする http://qiita.com/yimajo/items/7051af0919b5286aecfe

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //iOS6/7対応
    if ([[[[UIDevice currentDevice] systemVersion]
          componentsSeparatedByString:@"."][0] intValue] >= 7) //iOS7 later
    {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height + self.navigationController.navigationBar.frame.size.height;
        
        CGRect original = self.showImageView.frame;
        
        CGRect new = CGRectMake(original.origin.x,  original.origin.y + heightPadding,
                                original.size.width,  original.size.height - heightPadding);
        
        self.showImageView.frame = new;
    }
    
    
    //ナビゲーションバー
    self.headerNavBar.delegate = self;
    if ( IOS_VERSION >= 7.0f ) {
        self.headerNavBar.barTintColor = [UIColor colorWithRed:0.000 green:0.549 blue:0.890 alpha:1.000];
        self.headerNavBar.tintColor = [UIColor whiteColor];
        self.headerNavBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    } else {
        self._headerMargin.constant = 0;
    }

    
    // 初期スタンプ
    self.stampName = @"horizonStamp.png";
    
    //スタンプ切り替え
    //0が横,1が縦
    __stampSwitchFlag = 0;

    // 横スタンプ
    self.horizontalStamp.normalBackgroundColor = [UIColor clearColor];
    self.horizontalStamp.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.horizontalStamp.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.horizontalStamp.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.horizontalStamp.cornerRadius = 12.0f;
    self.horizontalStamp.borderWidth = 1.0f;
    self.horizontalStamp.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.horizontalStamp.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.horizontalStamp setFlatTitle:@"landscape"];
    
    // 縦スタンプ
    self.verticalStamp.normalBackgroundColor = [UIColor clearColor];
    self.verticalStamp.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.verticalStamp.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.verticalStamp.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.verticalStamp.cornerRadius = 12.0f;
    self.verticalStamp.borderWidth = 1.0f;
    self.verticalStamp.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.verticalStamp.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.verticalStamp setFlatTitle:@"portrait"];
    
    //　-ボタン
    self.decreaseFrameSize.normalBackgroundColor = [UIColor clearColor];
    self.decreaseFrameSize.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.decreaseFrameSize.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.decreaseFrameSize.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.decreaseFrameSize.cornerRadius = 12.0f;
    self.decreaseFrameSize.borderWidth = 1.0f;
    self.decreaseFrameSize.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.decreaseFrameSize.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.decreaseFrameSize setFlatImage:[UIImage imageNamed:@"view_refresh.png"]];
    [self.decreaseFrameSize setFlatTitle:@""];
    
    //Multiple touch
    self.view.multipleTouchEnabled = YES;
    
    // iPhone5以降とそれ以前。基本画像初期化。
    if([[UIScreen mainScreen]bounds].size.height==568){
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 395)];
    } else {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 310)];
    }
    //ベースとなる画像の貼り付け
    _showImageView.image = [UIImage imageNamed:@"base.png"];
    [self.view addSubview:_showImageView];
    
    //初回はカメラ起動なので隠しておく
    self.view.hidden = YES;
    
    //スタンプ画像は最初はセットしない
    _currentStampView = nil;
    
    //最初はスタンプモードでない
    __isPressStamp = NO;

    // 1本タッチ
    __isTouchCount = NO;
    
    // 回転フラグは切っておく
    __isRotate = NO;
    
    //最初はカメラ起動
    __isOpenCamera = YES;

    //スタンプ切り替え
    __stampSwitchFlag = 0;
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // オープン時にカメラ起動
    if (__isOpenCamera) {
        [self startCamera];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark -
# pragma mark StatusBar
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    //文字を白くする
    return UIStatusBarStyleLightContent;
}

# pragma mark -
# pragma mark UINavigationBar
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

# pragma mark -
# pragma mark Camera
- (void)startCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && __isOpenCamera) {
        UIImagePickerController*  imagePicker = [[UIImagePickerController alloc] init];
        // デリゲート化
        imagePicker.delegate = self;
        //画像の取得先をカメラへ
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //画像取得後に編集するか否か
        imagePicker.allowsEditing = YES;
        //カメラ表示
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Application Error"
                              message:@"Failed to launch camera"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        NSLog(@"カメラを起動できませんでした。");
    }
    
}

- (IBAction)startRetakeCamera:(id)sender {
    
    // もろもろ初期化
    __isOpenCamera = YES;
    __isPressStamp = NO;
    __stampSwitchFlag = 0;
    _currentStampView.image = nil;
    _currentStampView = nil;
    // カメラ起動
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && __isOpenCamera) {
        UIImagePickerController*  imagePicker = [[UIImagePickerController alloc] init];
        // デリゲート化
        imagePicker.delegate = self;
        //画像の取得先をカメラへ
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //画像取得後に編集するか否か
        imagePicker.allowsEditing = YES;
        //カメラ表示
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Application Error"
                              message:@"Failed to launch camera"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
        NSLog(@"カメラを起動できませんでした。");
    }
    
}

// 写真撮影後orサムネイル選択後に呼ばれる処理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 初回に隠していたviewを表示
    if (self.view.hidden) {
        self.view.hidden = NO;
    }
    
    //元画像
    UIImage* originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    _showImageView.image = originalImage;
    
    //カメラの起動フラグのオフ
    __isOpenCamera = NO;
    
    //モーダルの破棄
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//画像の保存完了時に呼ばれるメソッド
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context {
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 初回に隠していたviewを表示
    if (self.view.hidden) {
        self.view.hidden = NO;
    }
    
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //カメラの起動フラグのオフ
    __isOpenCamera = NO;
}


# pragma mark -
# pragma mark TouchEvents
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!__isPressStamp) {

        // タッチされた座標取得
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:_showImageView];
        
        // スタンプをセットの準備
        _currentStampView.isTransformable = YES;
        _currentStampView = [TransformableView new];
        _currentStampView = [[TransformableView alloc] initWithFrame:CGRectMake(point.x - 70.0, point.y, 200, 70)];

        // 回転されていた場合はboundsもセット
        if (__isRotate) {
            _currentStampView.bounds = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, 200, 70);
        }
        
        // スタンプをセット
        _currentStampView.image = [UIImage imageNamed:self.stampName];
        [self.view addSubview:_currentStampView];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // タッチされた座標を取得
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:_showImageView];

    //スタンプの位置変更
    //２本指のときは拡大縮小
    if(__isTouchCount && [touches count] == 2) {
        
        //１本指フラグを倒す
        __isPressStamp = NO;
        
        //Touches
        NSArray *touchesArray = [touches allObjects];
        UITouch *touch1 = touchesArray[0];
        UITouch *touch2 = touchesArray[1];
        
        //Point 1
        CGPoint prePoint1 = [touch1 previousLocationInView:self.view];
        CGPoint locationPoint1 = [touch1 locationInView:self.view];
        
        //Point2
        CGPoint prePoint2 = [touch2 previousLocationInView:self.view];
        CGPoint locationPoint2 = [touch2 locationInView:self.view];
        
        //Distance
        CGFloat preDistance = sqrtf(powf(prePoint2.x-prePoint1.x, 2)+
                                    powf(prePoint2.y-prePoint1.y, 2));
        CGFloat locationDistance = sqrtf(powf(locationPoint2.x-locationPoint1.x, 2)+
                                         powf(locationPoint2.y-locationPoint1.y, 2));
        
        //Scale increment
        _currentStampView.scale *= locationDistance/preDistance;
        
    //１本指の時はスタンプ移動
    } else if (__isPressStamp && [touches count] == 1) {
        
        //２本指フラグを倒す
        __isTouchCount = NO;
        
        //回転してないときはframeのみ指定
        if (!__isRotate) {
            
            if (__stampSwitchFlag == 0) {
                _currentStampView.frame = CGRectMake(point.x - 150.0, point.y, _currentStampView.frame.size.width, _currentStampView.frame.size.height);
            } else if (__stampSwitchFlag == 1) {
                _currentStampView.frame = CGRectMake(point.x - 30.0, point.y - 30.0, _currentStampView.frame.size.width, _currentStampView.frame.size.height);
            }
            
        //回転してるときはboundsも指定
        } else {
            
            // 横向きスタンプ
            if (__stampSwitchFlag == 0) {
                _currentStampView.frame = CGRectMake(point.x - 150, point.y, 200, 70);
                _currentStampView.bounds = CGRectMake(point.x, point.y, 200, 70);
            // 縦向きスタンプ
            } else if (__stampSwitchFlag == 1) {
                _currentStampView.frame = CGRectMake(point.x - 30, point.y, 70, 200);
                _currentStampView.bounds = CGRectMake(point.x, point.y, 70, 200);
            }
            
        }
    }
}

//スタンプ終了
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    __isPressStamp = YES;
    __isTouchCount = YES;
}

//スタンプ終了
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    __isPressStamp = YES;
    __isTouchCount = YES;
}

#pragma mark -
#pragma mark modifiedStampSize

// 右回転させる
- (IBAction)smaller:(id)sender {
    __isRotate = YES;
    _currentStampView.transform = CGAffineTransformIdentity;
    _currentStampView.angle -= 1;
}

#pragma mark -
#pragma mark switchStamp
// 回転周りでかなりてこずったので無駄なソース残りまくってます...
- (IBAction)isHorizontal:(id)sender {
    
    if (_currentStampView) {

        //動的に横縦を変化
        CGFloat large;
        CGFloat small;
        if (_currentStampView.frame.size.height > _currentStampView.frame.size.width) {
            large = _currentStampView.frame.size.height;
            small = _currentStampView.frame.size.width;
        } else {
            large = _currentStampView.frame.size.width;
            small = _currentStampView.frame.size.height;
        }
        
        // スタンプ横フラグ
        __stampSwitchFlag = 0;
        
        _currentStampView.frame = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, large, small);
        if (__isRotate) {
            _currentStampView.bounds = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, 200, 70);
        }
        _currentStampView.image = [UIImage imageNamed:@"horizonStamp.png"];
        [self.view addSubview:_currentStampView];
        
    } else {
        // スタンプ横フラグ
        __stampSwitchFlag = 0;

        // スタンプをセットの準備
        _currentStampView.isTransformable = YES;
        _currentStampView = [TransformableView new];
        _currentStampView = [[TransformableView alloc] initWithFrame:CGRectMake(80, 100, 200, 70)];
            
        // 回転されていた場合はboundsもセット
        if (__isRotate) {
            _currentStampView.bounds = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, 200, 70);
        }
            
        // スタンプをセット
        _currentStampView.image = [UIImage imageNamed:self.stampName];
        [self.view addSubview:_currentStampView];
        
        __isPressStamp = YES;

    }
    
}

- (IBAction)isVertical:(id)sender {

    if (_currentStampView) {

        //動的に横縦を変化
        CGFloat large;
        CGFloat small;
        if (_currentStampView.frame.size.height > _currentStampView.frame.size.width) {
            large = _currentStampView.frame.size.height;
            small = _currentStampView.frame.size.width;
        } else {
            large = _currentStampView.frame.size.width;
            small = _currentStampView.frame.size.height;
        }
        
        // スタンプ縦フラグ
        __stampSwitchFlag = 1;
        
        _currentStampView.frame = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, small, large);
        if (__isRotate) {
            _currentStampView.bounds = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, 70, 200);
        }
        _currentStampView.image = [UIImage imageNamed:@"verticalStamp.png"];
        [self.view addSubview:_currentStampView];
        
    } else {

        // スタンプ縦フラグ
        __stampSwitchFlag = 1;
        
        // スタンプをセットの準備
        _currentStampView.isTransformable = YES;
        _currentStampView = [TransformableView new];
        _currentStampView = [[TransformableView alloc] initWithFrame:CGRectMake(80, 100, 70, 200)];
            
        // 回転されていた場合はboundsもセット
        if (__isRotate) {
            _currentStampView.bounds = CGRectMake(_currentStampView.frame.origin.x, _currentStampView.frame.origin.y, 70, 200);
        }
            
        // スタンプをセット
        _currentStampView.image = [UIImage imageNamed:@"verticalStamp.png"];
        [self.view addSubview:_currentStampView];
            
        __isPressStamp = YES;
            
    }
    
}

#pragma mark -
#pragma mark capture
-(UIImage *)captureImage {
    
    //描画領域の設定
    CGSize size = CGSizeMake(_showImageView.frame.size.width, _showImageView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    //グラフィックスコンテキスト
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // コンテキストの位置を切り取り開始位置に合わせる
    CGPoint point = _showImageView.frame.origin;
    CGAffineTransform affineMoveLeftTop = CGAffineTransformMakeTranslation(-(int)point.x, -(int)point.y);
    CGContextConcatCTM(context, affineMoveLeftTop);
    
    //viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 切り取った内容をUIImageとして取得
    UIImage *cnvImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //コンテキストの破棄
    UIGraphicsEndImageContext();
    return cnvImg;
    
}

#pragma mark -
#pragma mark saveImage
- (void)saveCameraRoll:(UIImage *)image {
    
    //保存
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}

#pragma mark -
#pragma mark shareToSNS
- (IBAction)bsend:(id)sender {
    
    NSString *body = @"#LGTMCam";
    UIImage *sendImage = [self captureImage];
    NSArray *items = @[body,sendImage];
    
    //カメラロールに保存
    [self saveCameraRoll:sendImage];
    
    //SNSへ投稿
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[]];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

@end
