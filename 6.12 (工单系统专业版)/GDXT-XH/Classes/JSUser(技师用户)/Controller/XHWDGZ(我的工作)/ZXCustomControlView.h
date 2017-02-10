//
//  ZXCustomControlView.h
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXCustomControlView;


@protocol ZXCustomControlViewDelegate <NSObject>
@optional
- (void)customControlViewCancelButtonDidClick:(ZXCustomControlView *)customView;
- (void)customControlViewUploadButtonDidClick:(ZXCustomControlView *)customView;
- (void)customControlViewPlayButtonDidClick:(ZXCustomControlView *)customView isSelected:(BOOL)selected;

@end
@interface ZXCustomControlView : UIView

@property (nonatomic,assign) CGFloat videoDuration;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isControlEnable;
@property (weak, nonatomic) IBOutlet UISlider *progress;
-(void)showWithClickHandle:(void (^)(NSInteger tag))clickHandle slideHandle:(void (^)(CGFloat interval,BOOL isFinished))slideHandle;

-(void)setSlideValue:(CGFloat)value;
@property (nonatomic ,strong) id<ZXCustomControlViewDelegate>delegate;
@end
