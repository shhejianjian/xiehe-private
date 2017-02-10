

#import <Foundation/Foundation.h>

//url 192.168.7.100:8080
/** 根目录地址 */
NSString *const BaseUrl = @"http://115.28.239.33:80/hems";

/** 用户登录 */
NSString *const LoginUrl = @"http://115.28.239.33:80/hems/login";

/** 用户退出 */
NSString *const LogoutUrl = @"http://115.28.239.33:80/hems/logout";

/** 待接单 */
NSString *const DjdOrderUrl = @"api/v1/hems/workOrder/issue?";

/** 已接单 */
NSString *const ReceiveOrderUrl = @"api/v1/hems/workOrder/receive?";

/** 已挂起 */
NSString *const HangUpOrderUrl = @"api/v1/hems/workOrder/hangUp?";

/** 已完成 */
NSString *const CompleteOrderUrl = @"api/v1/hems/workOrder/complete?";

/** 领料的材料 */
NSString *const LingliaorUrl = @"api/v1/hems/material/supply?workOrderId";

/** 红色预警 */
NSString *const RedWarnOrderUrl = @"api/v1/hems/workOrderWarn?degree=1";

/** 黄色预警 */
NSString *const YellowWarnOrderUrl = @"api/v1/hems/workOrderWarn?degree=2";

/** 待指派 */
NSString *const ZGDZPOrderUrl = @"api/v1/hems/workOrder/issue/timeout?";

/** 待复核 */
NSString *const ZGDFHOrderUrl = @"api/v1/hems/workOrder/review?";

/** 主管已挂起 */
NSString *const ZGYGQOrderUrl = @"api/v1/hems/workOrder/hangUp?";

/** 查询结果 */
NSString *const SearchResultUrl = @"api/v1/hems/workOrder/info?";

/** 上传接口(视频、图片、录音、签字等) */
NSString *const uploadUrl = @"api/v1/system/file/upload";

/** 挂单选项(按钮) */
NSString *const hangupOptionUrl = @"api/v1/hems/workOrder/hangUp/options";

/** 录音选项(按钮) */
NSString *const recordOptionUrl = @"api/v1/hems/workOrder/attachment/options?type=WorkOrderSoundRecordOptions";

/** 拍照选项(按钮) */
NSString *const photoOptionUrl = @"api/v1/hems/workOrder/attachment/options?type=WorkOrderPictureOptions";

/** 视频选项(按钮) */
NSString *const vedioOptionUrl = @"api/v1/hems/workOrder/attachment/options?type=WorkOrderVideoOptions";

/** 汇总 */
 NSString *const summaryUrl = @"api/v1/hems/workOrder/summary?";

/** 汇总(每天) */
NSString *const summaryDayUrl = @"api/v1/hems/workOrder/statistics/day";





//通知
/** 待接单数量改变 */
NSString *const XHDJDOrderCountDidChangeNotification = @"XHDJDOrderCountDidChangeNotification";
NSString *const XHDJDOrderCount = @"XHDJDOrderCount";

/** 已接单数量改变 */
NSString *const XHYJDOrderCountDidChangeNotification = @"XHYJDOrderCountDidChangeNotification";
NSString *const XHYJDOrderCount = @"XHYJDOrderCount";

/** 已挂起数量改变 */
NSString *const XHYGQOrderCountDidChangeNotification = @"XHYGQOrderCountDidChangeNotification";
NSString *const XHYGQOrderCount = @"XHYGQOrderCount";

/** 已结单数量改变 */
NSString *const XHJDOrderCountDidChangeNotification = @"XHJDOrderCountDidChangeNotification";
NSString *const XHJDOrderCount = @"XHJDOrderCount";

/** 待指派数量改变 */
NSString *const XHDZPOrderCountDidChangeNotification = @"XHDZPOrderCountDidChangeNotification";
NSString *const XHDZPOrderCount = @"XHDZPOrderCount";

/** 待复核数量改变 */
NSString *const XHDFHOrderCountDidChangeNotification = @"XHDFHOrderCountDidChangeNotification";
NSString *const XHDFHOrderCount = @"XHDFHOrderCount";

/** 主管已挂起数量改变 */
NSString *const XHZGYGQOrderCountDidChangeNotification = @"XHZGYGQOrderCountDidChangeNotification";
NSString *const XHZGYGQOrderCount = @"XHZGYGQOrderCount";

/** 红色预警数量改变 */
NSString *const XHRedWarnOrderCountDidChangeNotification = @"XHRedWarnOrderCountDidChangeNotification";
NSString *const XHRedWarnOrderCount = @"XHRedWarnOrderCount";

/** 黄色预警数量改变 */
NSString *const XHYellowWarnOrderCountDidChangeNotification = @"XHYellowWarnOrderCountDidChangeNotification";
NSString *const XHYellowWarnOrderCount = @"XHYellowWarnOrderCount";

/** 周 */
NSString *const XHSumMenuWeekDidClickNotification = @"XHSumMenuWeekDidClickNotification";

/** 月 */
NSString *const XHSumMenuMonthDidClickNotification = @"XHSumMenuMonthDidClickNotification";

/** 年 */
NSString *const XHSumMenuYearDidClickNotification = @"XHSumMenuYearDidClickNotification";


/** 领料领取待复核或接单成功 通知已挂起控制器更新数据 */
NSString *const XHYGQUpdateDataNotification = @"XHYGQUpdateDataNotification";
/** 领料领取待复核或接单成功 通知已接单控制器更新数据 */
NSString *const XHYJDUpdateDateNotification = @"XHYJDUpdateDateNotification";

/** 签名签完了(马上上传) */
NSString *const XHSignatureFinishNotification = @"XHSignatureFinishNotification";
/** 签名图片 */
NSString *const XHSignatureImage = @"XHSignatureImage";



