//
//  WHC_SideNavigationControler.h
//  SideMenu
//
//  Created by 吴海超 on 15/4/8.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import <UIKit/UIKit.h>
#define KWHC_Side_Left_Menu_N_Margin (150.0)             //显示左菜单时主视图显示的宽度
#define KWHC_Side_Right_Menu_N_Margin (100.0)            //显示右菜单时主视图显示的宽度
#define KWHC_Side_Menu_N_During (0.15)                   //动画周期
#define KWHC_Side_Menu_N_Z (-100.0)                      //暂时弃用
#define KWHC_Side_Menu_N_Scale (0.9)                     //主视图没缩放的情况菜单缩放系数
#define KWHC_Side_Menu_N_Main_Scale_Scale (0.8)          //主视图缩放的情况菜单缩放系数
#define kWHC_Side_Menu_N_OVER_VIEW_ALPHA (0.8)           //阴影系数
#define KWHC_Side_Menu_N_Slide_Rate (1.5)                //菜单随动系数
#define KWHC_Side_Menu_N_Scale_Margin (6.0)              //主视图没有缩放的情况菜单的缩放间距
#define KWHC_Side_Menu_N_Touch_Border_Pading (20.0)      //触摸边距
#define KWHC_Side_Menu_N_Main_VC_Name (@"MyTabBarVC")    //主视图类名称

typedef enum:NSInteger{
    WHC_Menu_Move_Style_NONE = 0,                        //没有效果
    WHC_Menu_Move_Style_SLIDE,                           //拉动时菜单随动效果
    WHC_Menu_Move_Style_FADE,                            //拉动时菜单阴影效果
    WHC_Menu_Move_Style_SLIDE_FADE,                      //拉动时菜单随动和阴影效果
    WHC_Menu_Move_Style_SCALE,                           //拉动时菜单有缩放效果
    WHC_Menu_Move_Style_SCALE_FADE,                      //拉动时菜单有缩放和阴影效果
    
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE,                 //拉动时主视图有缩放效果
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE,           //拉动时主视图有缩放菜单随动效果
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE_FADE,            //拉动时主视图有缩放菜单阴影效果
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE,      //拉动时主视图有缩放菜单随动和阴影效果
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE,           //拉动时主视图有缩放菜单有缩放和随动效果
    WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE,      //拉动时主视图有缩放菜单有缩放随动和阴影效果
}WHC_Menu_Move_Style;

//note:"在模式:WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE,WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE
//菜单内容视图必须包含到一个中间视图然后再把中间视图包含到主视图中"

//WHC_SideNavigationControlerDelegate  协议主要是控制当前控制器是否支持拉开菜单
@protocol WHC_SideNavigationControlerDelegate <NSObject>
@optional
- (BOOL)whcSlideNavigationControllerShouldShowRightMenu;                  //return YES 表示能够拉开右菜单 否则不能
- (BOOL)whcSlideNavigationControllerShouldShowLeftMenu;                   //return YES 表示能够拉开左菜单 否则不能
@end

@interface WHC_SideNavigationControler : UINavigationController
@property (nonatomic, strong) UIViewController         * rightMenuVC;     //右菜单
@property (nonatomic, strong) UIViewController         * leftMenuVC;      //左菜单
@property (nonatomic, assign) WHC_Menu_Move_Style        menuMoveStyle;   //菜单拉开样式
@property (nonatomic, assign) BOOL                       touchBorder;     //是否从边缘拉开菜单

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithMainVC:(UIViewController*)mainVC;
- (void)pushVC:(UIViewController*)vc animated:(BOOL)animated;
- (void)popVC:(UIViewController*)vc animated:(BOOL)animated;
@end
