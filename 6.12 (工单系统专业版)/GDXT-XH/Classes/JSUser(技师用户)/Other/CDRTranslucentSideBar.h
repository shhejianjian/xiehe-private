

#import <UIKit/UIKit.h>

@class CDRTranslucentSideBar;
@protocol CDRTranslucentSideBarDelegate <NSObject>
@optional
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated;
@end

@interface CDRTranslucentSideBar : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL translucent;
@property (nonatomic) UIBarStyle translucentStyle;
@property (nonatomic) CGFloat translucentAlpha;
@property (nonatomic, strong) UIColor *translucentTintColor;
@property (readonly) BOOL hasShown;
@property (readonly) BOOL showFromRight;
@property BOOL isCurrentPanGestureTarget;
@property NSInteger tag;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<CDRTranslucentSideBarDelegate> delegate;

- (id)init;
- (id)initWithDirection:(BOOL)showFromRight;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView;

- (void)setContentViewInSideBar:(UIView *)contentView;

@end
