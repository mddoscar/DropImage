//
//  UIView+MddDraggle.h
//  Printer3D
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCallBackNoti @"MddNotification_GetUserProfileSuccess"
#define kCallBackNotiView @"MddCallBackNotiView"
#define kCallBackNotiGesture @"MddCallBackNotiGesture"

@interface UIView (MddDraggle)
/**
 *  Make view draggable.
 *
 *  @param view    Animator reference view, usually is super view.
 *  @param damping Value from 0.0 to 1.0. 0.0 is the least oscillation. default is 0.4.
 */
- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping;
- (void)makeDraggable;

/**
 *  Disable view draggable.
 */
- (void)removeDraggable;
//@property(nonatomic,strong)
//-(void) setMyDraggableEndCallBack:(void (^)(UIView *view)) pEndCallBack;
//@property (copy) void (^DraggableEndCallBack)(UIView *view);
@end
