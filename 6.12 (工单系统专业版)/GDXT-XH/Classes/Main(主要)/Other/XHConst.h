
#import <Foundation/Foundation.h>

#ifdef DEBUG //调试阶段
#define XHLog(...) NSLog(__VA_ARGS__)
#else  //发布阶段
#define XHLog(...)
#endif

#define XHLogFunc XHLog(@"%s", __func__)

#define XHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define XHGlobalColor XHColor(39, 165, 156)
#define XHWhiteColor XHColor(230, 230, 230)
#define XHXDColor XHColor(21, 150, 241)
#define XHGZZColor XHColor(54, 145, 242)
#define XHYJDColor XHColor(65, 168, 156)
#define XHWWCColor XHColor(169, 77, 188)
#define XHGDColor XHColor(220, 91, 96)
#define XHXSHColor XHColor(254, 168, 62)
#define XHLeftColor XHColor(250, 250, 250)
#define XHVoiceColor XHColor(94, 193, 218)
#define XHHeaderViewColor XHColor(231, 232, 234)
#define XHTitleLabelColor XHColor(16, 120, 104)
#define XHTitleLabelTextColor XHColor(154, 207, 200)
#define XHYeollowColor XHColor(232, 156, 56)
#define XHOrderCountColor XHColor(64, 166, 243)
#define XHNotificationCenter [NSNotificationCenter defaultCenter]
/** 根目录地址 */
extern NSString *const BaseUrl;

/** 用户登录 */
extern NSString *const LoginUrl;

/** 用户退出 */
extern NSString *const LogoutUrl;

/** 待接单 */
extern NSString *const DjdOrderUrl;

/** 已接单 */
extern NSString *const ReceiveOrderUrl;

/** 已挂起 */
extern NSString *const HangUpOrderUrl;

/** 已完成 */
extern NSString *const CompleteOrderUrl;

/** 领料的材料 */
extern NSString *const LingliaorUrl;

/** 红色预警 */
extern NSString *const RedWarnOrderUrl;

/** 黄色预警 */
extern NSString *const YellowWarnOrderUrl;

/** 待指派 */
extern NSString *const ZGDZPOrderUrl;

/** 待复核 */
extern NSString *const ZGDFHOrderUrl;

/** 主管已挂起 */
extern NSString *const ZGYGQOrderUrl;

/** 查询结果 */
extern NSString *const SearchResultUrl;

/** 上传接口(视频、图片、录音、签字等) */
extern NSString *const uploadUrl;

/** 挂单选项(按钮) */
extern NSString *const hangupOptionUrl;

/** 录音选项(按钮) */
extern NSString *const recordOptionUrl;

/** 拍照选项(按钮) */
extern NSString *const photoOptionUrl;

/** 视频选项(按钮) */
extern NSString *const vedioOptionUrl;

/** 汇总 */
extern NSString *const summaryUrl;

/** 汇总(每天) */
extern NSString *const summaryDayUrl;

//通知
/** 待接单数量改变 */
extern NSString *const XHDJDOrderCountDidChangeNotification;
extern NSString *const XHDJDOrderCount;

/** 已接单数量改变 */
extern NSString *const XHYJDOrderCountDidChangeNotification;
extern NSString *const XHYJDOrderCount;

/** 已挂起数量改变 */
extern NSString *const XHYGQOrderCountDidChangeNotification;
extern NSString *const XHYGQOrderCount;

/** 已结单数量改变 */
extern NSString *const XHJDOrderCountDidChangeNotification;
extern NSString *const XHJDOrderCount;

/** 待指派数量改变 */
extern NSString *const XHDZPOrderCountDidChangeNotification;
extern NSString *const XHDZPOrderCount;

/** 待复核数量改变 */
extern NSString *const XHDFHOrderCountDidChangeNotification;
extern NSString *const XHDFHOrderCount;
/** 主管已挂起数量改变 */
extern NSString *const XHZGYGQOrderCountDidChangeNotification;
extern NSString *const XHZGYGQOrderCount;

/** 红色预警数量改变 */
extern NSString *const XHRedWarnOrderCountDidChangeNotification;
extern NSString *const XHRedWarnOrderCount;

/** 黄色预警数量改变 */
extern NSString *const XHYellowWarnOrderCountDidChangeNotification;
extern NSString *const XHYellowWarnOrderCount;
/** 周 */
extern NSString *const XHSumMenuWeekDidClickNotification;
/** 月 */
extern NSString *const XHSumMenuMonthDidClickNotification;
/** 年 */
extern NSString *const XHSumMenuYearDidClickNotification;

/** 领料领取待复核或接单成功 通知已挂起控制器更新数据 */
extern NSString *const XHYGQUpdateDataNotification;
/** 领料领取待复核或接单成功 通知已接单控制器更新数据 */
extern NSString *const XHYJDUpdateDateNotification;

/** 签名签完了(马上上传) */
extern NSString *const XHSignatureFinishNotification;
/** 签名图片 */
extern NSString *const XHSignatureImage;


