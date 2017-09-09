//
//  DropImage.m
//  Printer3D
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "DropImage.h"


#define kMinDistance 20//最小间距10像素
#define kFrmWidth 100
#define kFrmHeight 400
#define kCicleR 100
#define kOffset 64
#define NIBNAME @"DropImage"
@implementation DropImage
@synthesize mUiStartImage;
@synthesize mUiEndImage;
@synthesize mUiInfoLabel;
@synthesize mddDelegate=_mddDelegate;

-(void)awakeFromNib
{
    [self doInitEvent];
    [self doSaveFrame];
    [self doSetAnimation];
    [super awakeFromNib];
}
-(void) doInitEvent
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.mUiStartImage setUserInteractionEnabled:YES];
    [self.mUiStartImage addGestureRecognizer:pan];
    
    //[self.mUiStartImage makeDraggable];
    
    //   [self.mUiStartImage setMyDraggableEndCallBack:^(UIView *view) {
    //        [self doDistance];
    //    }];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDistance) name:kCallBackNoti object:nil];
}


- (void) handlePan: (UIPanGestureRecognizer *)rec{
    NSLog(@"xxoo---xxoo---xxoo");
    CGPoint point = [rec translationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    /*
     高度限制
     */
    CGFloat newY=rec.view.center.y + point.y;
    if (newY-kCicleR/2<0) {
        newY=-kCicleR/2;
    }
    if (newY>self.frame.size.height-kCicleR/2) {
        newY=self.frame.size.height-kCicleR/2;
    }
    rec.view.center = CGPointMake(rec.view.center.x /*+ point.x*/, newY);

    
    [rec setTranslation:CGPointMake(0, 0) inView:self];
    if (rec.state == UIGestureRecognizerStateEnded ||
             rec.state == UIGestureRecognizerStateCancelled ||
             rec.state == UIGestureRecognizerStateFailed)
    {
            [self doDistance];
    }
}
- (id)init{
    if(self=[super init]){
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:NIBNAME owner:self options:nil];
        [self addSubview:[views objectAtIndex:0]];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        self.userInteractionEnabled=YES;
        self.layer.borderWidth=0.0;
        self.layer.borderColor=[UIColor clearColor].CGColor;
        self.clipsToBounds=YES;
        self.layer.cornerRadius=self.frame.size.width/2;
        //self.alpha=0.5;
        //self.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
        
    }
    return  self;
}
-(void) doSaveFrame
{
    if (self.rawFrame.size.width<=0&&self.rawFrame.size.height<=0) {
            self.rawFrame=self.mUiStartImage.frame;
    }
    if (self.dirFrame.size.width<=0&&self.dirFrame.size.height<=0) {
        self.dirFrame=self.mUiEndImage.frame;
    }
    if (self.rawCenter.x<=0&&self.rawCenter.y<=0) {
        self.rawCenter=self.mUiStartImage.center;
    }
    if (self.dirCenter.x<=0&&self.dirCenter.y<=0) {
        self.dirCenter=self.mUiEndImage.center;
    }
    self.rawtransfrom=self.mUiStartImage.transform;
}

+(id) initForNib
{
    return  [[[NSBundle mainBundle] loadNibNamed:NIBNAME owner:nil options:nil] lastObject];
}
+(id) initForNibWithView:(UIView *) pFatherView center:(CGPoint) pCenter
{
    DropImage * v=[[[NSBundle mainBundle] loadNibNamed:NIBNAME owner:nil options:nil] lastObject];
    v.frame=CGRectMake(pCenter.x-kFrmWidth/2, pCenter.y-kFrmHeight/2-kOffset, kFrmWidth, kFrmHeight);
    return v;
}
+(id) initForNibWithView:(UIView *) pFatherView
{
    return [[self class] initForNibWithView:pFatherView center:pFatherView.center];
}
+(id) initForNibWithView:(UIView *) pFatherView WithDelegate:(id<DropImageDataDelegate>) pDelegate
{
    DropImage *v=[[self class] initForNibWithView:pFatherView center:pFatherView.center];
    [v setMddDelegate:pDelegate];
    return v;
    
}

//判断距离
-(void) doDistance
{
    NSLog(@"判断距离");
    //判断圆心距离
    //距离够小
    if (sqrt(pow(self.mUiStartImage.center.y-self.dirCenter.y,2)+pow(self.mUiStartImage.center.x-self.dirCenter.x,2))<kMinDistance) {
        //修改
        self.mUiStartImage.center=self.dirCenter;
        self.mUiStartImage.frame=self.dirFrame;
        self.mUiStartImage.transform=self.rawtransfrom;// CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        //取消拖拽
        //[self.mUiStartImage removeDraggable];
        [self.mddDelegate mddDropImageOkCallBack:self];
    }else{
        //还原
        self.mUiStartImage.center=self.rawCenter;
        self.mUiStartImage.frame=self.rawFrame;
        self.mUiStartImage.transform= self.rawtransfrom;//CGAffineTransformMake(1, 0, 0, 1, 0, 0);//
        [self.mddDelegate mddDropImageCancelCallBack:self];
    }
}

-(void) mddDropImageOkCallBack:(DropImage *) pView
{
    [self.mddDelegate mddDropImageOkCallBack:self];
}
-(void) mddDropImageCancelCallBack:(DropImage *) pView
{
    [self.mddDelegate mddDropImageCancelCallBack:self];
}
-(void) doSetAnimation
{
    /**
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 0.1;
    transition1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition1.type = kCATransitionFade;
    [self.mUiAnimation1.layer addAnimation:transition1 forKey:@"a"];
    CATransition *transition2 = [CATransition animation];
    transition2.duration = 0.6;
    transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition2.type = kCATransitionFade;
    [self.mUiAnimation2.layer addAnimation:transition2 forKey:@"b"];
    CATransition *transition3 = [CATransition animation];
    transition3.duration = 1.1;
    transition3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition3.type = kCATransitionFade;
    [self.mUiAnimation3.layer addAnimation:transition3 forKey:@"c"];
     **/
    /*
    CABasicAnimation *basic1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basic1.beginTime=1.0f;
    [basic1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [basic1 setFromValue:[NSNumber numberWithFloat:1]];
    [basic1 setToValue:[NSNumber numberWithFloat:.3]];
    [basic1 setDuration:100];
    [self.mUiAnimation1.layer addAnimation:basic1 forKey:@"animationKey"];
     */
    /*
    [UIView animateWithDuration:2.0 animations:^{
        self.mUiAnimation1.alpha=0.3;
    } completion:^(BOOL finished) {
        
    }];
    
    CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
     basic2.beginTime=2.0f;
    [basic2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [basic2 setFromValue:[NSNumber numberWithFloat:1]];
    [basic2 setToValue:[NSNumber numberWithFloat:.3]];
    [basic2 setDuration:1000];
    [self.mUiAnimation2.layer addAnimation:basic1 forKey:@"animationKey"];
    CABasicAnimation *basic3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
     basic2.beginTime=3.0f;
    [basic3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [basic3 setFromValue:[NSNumber numberWithFloat:1]];
    [basic3 setToValue:[NSNumber numberWithFloat:.3]];
    [basic3 setDuration:1000];
    [self.mUiAnimation3.layer addAnimation:basic1 forKey:@"animationKey"];
     */
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationRepeatAutoreverses:YES];
    self.mUiAnimation1.alpha=1;
    self.mUiAnimation2.alpha=0.7;
    self.mUiAnimation3.alpha=0.2;
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
