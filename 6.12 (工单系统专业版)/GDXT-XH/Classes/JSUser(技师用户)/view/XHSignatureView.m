//
//  XHSignatureView.m
//  sign
//
//  Created by 谢琰 on 16/5/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSignatureView.h"
#import "XHConst.h"
@interface XHSignatureView()
{
    UIBezierPath *_path;
}

@end
@implementation XHSignatureView
static UIWindow *_window;

+ (instancetype)signatureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self initGesture];
    return self;
}
- (void)awakeFromNib
{
    [self initGesture];

}
+ (void)show
{
    // 创建窗口
    _window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    _window.hidden = NO;
    
    // 添加窗口界面
    XHSignatureView *signatureView = [XHSignatureView signatureView];
    signatureView.frame = CGRectMake(20, 20, _window.frame.size.width - 2 * 20, _window.frame.size.height - 2 * 30);
    [_window addSubview:signatureView];
}

- (void)initGesture
{
    _path = [UIBezierPath bezierPath];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
    // 长按清除
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(erase)]];

}
- (IBAction)erase {
    _path = [UIBezierPath bezierPath];
    [self setNeedsDisplay];
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [_path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged)
        [_path addLineToPoint:currentPoint];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    [_path stroke];
}
- (IBAction)btnSureClick:(id)sender {
    
        if (self.returnSignatureBlock) {
     self.returnSignatureBlock([NSString stringWithFormat:@"%@",_path]);
    }
    //隐藏窗口
    _window.hidden = YES;
    
    // 销毁窗口
    _window = nil;
    
    //1.开启上下文
    UIGraphicsBeginImageContext(self.bounds.size);
    //2.将图片渲染到上下文
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //3.保存截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"签名%@",image);
    [XHNotificationCenter postNotificationName:XHSignatureFinishNotification object:nil userInfo:@{XHSignatureImage:image}];
        //4.结束上下文
    UIGraphicsEndImageContext();

}
- (IBAction)dismiss:(id)sender {
    NSLog(@"销毁窗口");
    //隐藏窗口
    _window.hidden = YES;

    // 销毁窗口
    _window = nil;
}


@end
