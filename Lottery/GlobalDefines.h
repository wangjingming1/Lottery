//
//  GlobalDefines.h
//  Lottery
//  为保持界面统一性,这里定义了一些默认值及通用宏
//  Created by wangjingming on 2020/1/1.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#ifndef GlobalDefines_h
#define GlobalDefines_h

/**默认圆角*/
#define kCornerRadius           10
/**边距10*/
#define kPadding10              10
/**边距15*/
#define kPadding15              15
/**边距20*/
#define kPadding20              20

/**weakSelf*/
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
 
/**获取Documents路径*/
#define kDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/**10进制的RGB*/
#define kUIColorFromRGB10(r,g,b)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
/**10进制的RGBA*/
#define kUIColorFromRGBA10(r,g,b,a)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
/**16进制的RGB*/
#define kUIColorFromRGB16(rgbValue)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**获取一个随机颜色*/
#define kUIColorFromRandomRBG               UIColorFromRGB10(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


/**系统默认字号*/
#define kSystemFontOfSize                   [UIFont systemFontSize]

/**默认文字颜色(选中)*/
#define kTintTextColor                      kUIColorFromRGB16(0xd81e06)
/**默认文字颜色*/
#define kUnselectedItemTintTextColor        kUIColorFromRGB16(0x333333)
/**标题文本颜色*/
#define kTitleTintTextColor                 kUIColorFromRGB10(62, 63, 64)
/**小标题f文本颜色*/
#define kSubtitleTintTextColor              kUIColorFromRGB10(165, 166, 167)


#endif /* GlobalDefines_h */
