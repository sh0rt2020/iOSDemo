//
//  NBGlobalDefines.h
//  NBTableView
//
//  Created by sunwell on 2016/11/9.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#ifndef NBGlobalDefines_h
#define NBGlobalDefines_h

#define DEFINE_PROPERTY_KEY(key)            static void const *kNB##key = &kNB##key
#define DEFINE_NSString(str)                static NSString * const kNB##str = @""#str;
#define DEFINE_NOTIFICATION_MESSAGE(str)    static NSString * const kNBNotification_##str = @""#str;

#define DEFINE_PROPERTY(nbKind, type, name)   @property (nonatomic, nbKind) type name
#define DEFINE_PROPERTY_ASSIGN(type, name)    DEFINE_PROPERTY(assign, type, name)
#define DEFINE_PROPERTY_ASSIGN_FLOAT(name)    DEFINE_PROPERTY_ASSIGN(float, name)
#define DEFINE_PROPERTY_ASSIGN_DOUBLE(name)   DEFINE_PROPERTY_ASSIGN(double, name)
#define DEFINE_PROPERTY_ASSIGN_INT64(name)    DEFINE_PROPERTY_ASSIGN(int64_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT32(name)    DEIFNE_PROPERTY_ASSIGN(int32_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT16(name)    DEFINE_PROPERTY_ASSIGN(int16_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT8(name)     DEFINE_PROPERTY_ASSIGN(int8_t, name)

#define DEFINE_PROPERTY_STRONG(type, name)         DEFINE_PROPERTY(strong, type, name)
#define DEFINE_PROPERTY_STRONG_UILABEL(name)       DEFINE_PROPERTY_STRONG(UILabel *, name)
#define DEFINE_PROPERTY_STRONG_NSSTRING(name)      DEFINE_PROPERTY_STRONG(NSString *, name)
#define DEFINE_PROEPRTY_STRONG_UIIMAGEVIEW(name)   DEFINE_PROPERTY_STRONG(UIImageView *, name)

#define DEFINE_PROPERTY_WEAK(type, name)           DEFINE_PROPERTY(weak, type, name)

#define INIT_SUBVIEW(nbView, class, name)       name = [[class alloc] init]; [nbView addSubview:name];
#define INIT_SUBVIEW_UILABEL(nbView, name)      INIT_SUBVIEW(nbView, UILabel, name)
#define INIT_SUBVIEW_UIIMAGEVIEW(nbView, name)  INIT_SUBVIEW(nbView, UIImageView, name)

#define INIT_SUBVIEW_SELF(class, name)          INIT_SUBVIEW(self, class, name)
#define INIT_SUBVIEW_SELF_UILABEL(name)         INIT_SUBVIEW_SELF(UILabel, name)
#define INIT_SUBVIEW_SELF_UIIMAGEVIEW(name)     INIT_SUBVIEW_SELF(UIImageView, name)


#define INIT_GESTURE_TAP_IN_VIEW(name, nbView)    name=[[UITapGestureRecognizer alloc] init];\
name.numberOfTapsRequired = 1;\
name.numberOfTouchesRequired = 1;\
[nbView addGestureRecognizer:name];

#define INIT_GESTURE_TAP_IN_SELF(name)          INIT_GESTURE_TAP_IN_VIEW(name, self)


//顶部固定高度，铺满width的布局
#define LAYOUT_VIEW_TOP_FILL_WIDTH(view, sView__, xMargin, yMargin, refHeight__)  CGRect rect##view = CGRectZero;\
rect##view.origin.x = xMargin;\
rect##view.origin.y = yMargin;\
rect##view.size.width = CGRectGetWidth(sView__.bounds) - xMargin*2;\
rect##view.size.height = refHeight__ - yMargin;\
view.frame = rect##view;

#define LAYOUT_SUBVIEW_TOP_FILL_WIDTH(view, xMargin, yMargin, refHeight__)  LAYOUT_VIEW_TOP_FILL_WIDTH(view, self, xMargin, yMargin, refHeight__)



//顶部固定高度，铺满width的布局
#define LAYOUT_VIEW_BOTTOM_FILL_WIDTH(view, sView__, xMargin, yMargin, refHeight__)  CGRect rect##view = CGRectZero;\
rect##view.origin.x = xMargin;\
rect##view.origin.y = CGRectGetHeight(sView__.bounds) - refHeight__;\
rect##view.size.width = CGRectGetWidth(sView__.bounds) - xMargin*2;\
rect##view.size.height = refHeight__ - yMargin;\
view.frame = rect##view;

#define LAYOUT_SUBVIEW_BOTTOM_FILL_WIDTH(view, xMargin, yMargin, refHeight__)  LAYOUT_VIEW_BOTTOM_FILL_WIDTH(view, self, xMargin, yMargin, refHeight__)

#define SCREENWIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT  [[UIScreen mainScreen] bounds].size.height

#endif /* NBGlobalDefines_h */
