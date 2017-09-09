//
//  DropImage.h
//  Printer3D
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UIView+MddDraggle.h"
@class DropImage;
@protocol DropImageDataDelegate
//可选
@optional
//点击事件
-(void) mddDropImageOkCallBack:(DropImage *) pView;
-(void) mddDropImageCancelCallBack:(DropImage *) pView;
@end

/*
 拖动视图
 */
@interface DropImage : UIView<DropImageDataDelegate>
{
    //代理
    id <DropImageDataDelegate> mddDelegate;
}
#pragma mark 成员
@property (nonatomic,strong) id<DropImageDataDelegate> mddDelegate;
#pragma mark ib
@property (weak, nonatomic) IBOutlet UIImageView *mUiStartImage;
@property (weak, nonatomic) IBOutlet UIImageView *mUiEndImage;
@property (weak, nonatomic) IBOutlet UILabel *mUiInfoLabel;
//动画效果
@property (weak, nonatomic) IBOutlet UIImageView *mUiAnimation1;
@property (weak, nonatomic) IBOutlet UIImageView *mUiAnimation2;
@property (weak, nonatomic) IBOutlet UIImageView *mUiAnimation3;


+(id) initForNib;
+(id) initForNibWithView:(UIView *) pFatherView center:(CGPoint) pCenter;
+(id) initForNibWithView:(UIView *) pFatherView;
+(id) initForNibWithView:(UIView *) pFatherView WithDelegate:(id<DropImageDataDelegate>) pDelegate;
#pragma mark data
//原始位置
@property(nonatomic,assign) CGRect rawFrame;
//目标位置
@property(nonatomic,assign) CGRect dirFrame;
@property(nonatomic,assign) CGAffineTransform rawtransfrom;
@property(nonatomic,assign) CGPoint rawCenter;
@property(nonatomic,assign) CGPoint dirCenter;

@end
