//
//  WHC_SideNavigationControler.m
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

#import "WHC_SideNavigationControler.h"
#define KWHC_OVER_VIEW_TAG (399320)
typedef enum:NSInteger{
    WHC_MENU_NONE = 0,
    WHC_MENU_LEFT,
    WHC_MENU_RIGHT
}WHC_Menu;

@interface WHC_SideNavigationControler ()<UINavigationControllerDelegate>{
    UIPanGestureRecognizer           *   _panGesture;
    UITapGestureRecognizer           *   _tapGesture;
    CGFloat                              _currentX;
    WHC_Menu                             _menu;                              //将要显示的菜单
    WHC_Menu                             _currentMenu;                       //已经显示的菜单
    BOOL                                 _didShowSideMenu;                   //菜单是否已经显示
    BOOL                                 _isOpenMenu;                        //菜单是否已经全部打开
    BOOL                                 _isShowLeftMenu;                    //是否显示左边菜单
    BOOL                                 _isShowRightMenu;                   //是否显示右边菜单
    BOOL                                 _isEnablePanMenu;                   //是否能够拉开菜单
    UIView                           *   _topView;                           //顶部视图
}

@end

static WHC_SideNavigationControler * whc_SideNavigation;
@implementation WHC_SideNavigationControler

+ (instancetype)sharedInstance{
    UIViewController  * rootVC = [[NSClassFromString(KWHC_Side_Menu_N_Main_VC_Name) alloc]init];
    return [WHC_SideNavigationControler sharedInstanceWithMainVC:rootVC];
}

+ (instancetype)sharedInstanceWithMainVC:(UIViewController*)mainVC{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        whc_SideNavigation = [[WHC_SideNavigationControler alloc]initWithRootViewController:mainVC];
        whc_SideNavigation.delegate = whc_SideNavigation;
    });
    return whc_SideNavigation;
}

#pragma mark - initMothed
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

#pragma mark - gestureMothed
- (void)registPanGesture:(BOOL)b{
    if(b){
        if(_panGesture == nil){
            _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
            [self.view addGestureRecognizer:_panGesture];
        }
    }else{
        if(_panGesture != nil){
            [self.view removeGestureRecognizer:_panGesture];
            _panGesture = nil;
        }
    }
}

- (void)enableTapGesture:(BOOL)enable{
    if(enable){
        if(_tapGesture == nil){
            _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
            [self.view addGestureRecognizer:_tapGesture];
        }
    }else{
        if(_tapGesture != nil){
            [self.view removeGestureRecognizer:_tapGesture];
            _tapGesture = nil;
        }
    }
}
- (void)handleTapGesture:(UITapGestureRecognizer*)tapGesture{
    [self closeSideMenu:YES margin:0];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture{
    if(!_isEnablePanMenu){
        if(_touchBorder){
            const CGFloat  touchX = [panGesture locationInView:panGesture.view].x;
            if(touchX > KWHC_Side_Menu_N_Touch_Border_Pading &&
               touchX < CGRectGetWidth(panGesture.view.frame) - KWHC_Side_Menu_N_Touch_Border_Pading && !_isOpenMenu){
                return;
            }else{
                _isEnablePanMenu = YES;
            }
        }else{
            _isEnablePanMenu = YES;
        }
    }
    if(self.view.transform.tx > 0){//向右滑动
        if(_menu != WHC_MENU_LEFT){
            _didShowSideMenu = NO;
        }
        _menu = WHC_MENU_LEFT;
    }else if(self.view.transform.tx < 0){//向左滑动
        if(_menu != WHC_MENU_RIGHT){
            _didShowSideMenu = NO;
        }
        _menu = WHC_MENU_RIGHT;
    }else{
        CGFloat  x = [panGesture velocityInView:self.view].x;
        if(x > 0){
            _menu = WHC_MENU_LEFT;
        }else if(x < 0){
            _menu = WHC_MENU_RIGHT;
        }else{
            _menu = WHC_MENU_NONE;
        }
    }
    if(!_didShowSideMenu){
        if(_menu == WHC_MENU_RIGHT){
            _isShowRightMenu = [self showRightMenu];
            if(_isShowRightMenu){
                if(_currentMenu != _menu){
                    if([self.view.window.subviews containsObject:_leftMenuVC.view]){
                        [_leftMenuVC.view removeFromSuperview];
                    }
                    [self loadOverViewWithMenu:WHC_MENU_RIGHT];
                    [self.view.window insertSubview:_rightMenuVC.view atIndex:0];
                }
            }else{
                CGAffineTransform  transaction = CGAffineTransformMakeTranslation(0.0, 0.0);
                self.view.transform = transaction;
                return;
            }
        }else{
            _isShowLeftMenu = [self showLeftMenu];
            if(_isShowLeftMenu){
                if(_currentMenu != _menu){
                    if([self.view.window.subviews containsObject:_rightMenuVC.view]){
                        [_rightMenuVC.view removeFromSuperview];
                    }
                    [self loadOverViewWithMenu:WHC_MENU_LEFT];
                    [self.view.window insertSubview:_leftMenuVC.view atIndex:0];
                }
            }else{
                CGAffineTransform  transaction = CGAffineTransformMakeTranslation(0.0, 0.0);
                self.view.transform = transaction;
                return;
            }
        }
        _didShowSideMenu = YES;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _currentX = self.view.transform.tx;
            _isShowRightMenu = [self showRightMenu];
            _isShowLeftMenu = [self showLeftMenu];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat  translationX = [panGesture translationInView:self.view].x;
            CGFloat  moveDistanceX = _currentX + translationX;
            if(_menu == WHC_MENU_LEFT){
                if(CGRectGetWidth(self.view.bounds) - moveDistanceX > KWHC_Side_Left_Menu_N_Margin &&
                   moveDistanceX > 0){
                    if(_isShowLeftMenu){
                        if([self mainViewEnbaleScale]){
                            CGFloat   rate = (moveDistanceX / (CGRectGetWidth(_leftMenuVC.view.frame) - KWHC_Side_Left_Menu_N_Margin));
                            self.view.transform = [self initAffineTransform:1.0 - rate * (1.0 - KWHC_Side_Menu_N_Main_Scale_Scale) x:moveDistanceX];
                        }else{
                            CGAffineTransform  transaction = CGAffineTransformMakeTranslation(moveDistanceX, 0.0);
                            self.view.transform = transaction;
                        }
                        [self handleTouchMoveMenu:_menu distanceX:moveDistanceX];
                    }
                }
            }else{
                if(CGRectGetWidth(self.view.bounds) + moveDistanceX > KWHC_Side_Right_Menu_N_Margin &&
                   moveDistanceX < 0){
                    if(_isShowRightMenu){
                        if([self mainViewEnbaleScale]){
                            CGFloat   rate = (-moveDistanceX / (CGRectGetWidth(_leftMenuVC.view.frame) - KWHC_Side_Right_Menu_N_Margin));
                            self.view.transform = [self initAffineTransform:1.0 - rate * (1.0 - KWHC_Side_Menu_N_Main_Scale_Scale) x:moveDistanceX];
                        }else{
                            CGAffineTransform  transaction = CGAffineTransformMakeTranslation(moveDistanceX, 0.0);
                            self.view.transform = transaction;
                        }
                        [self handleTouchMoveMenu:_menu distanceX:moveDistanceX];
                    }
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGFloat  menuMargin = KWHC_Side_Right_Menu_N_Margin;
            CGFloat  toMenuMargin = KWHC_Side_Right_Menu_N_Margin - CGRectGetWidth(self.view.bounds);
            if(_menu == WHC_MENU_LEFT){
                menuMargin = KWHC_Side_Left_Menu_N_Margin;
                toMenuMargin = CGRectGetWidth(self.view.bounds) - KWHC_Side_Left_Menu_N_Margin;
            }
            if(_isOpenMenu){
                if(_currentMenu == WHC_MENU_LEFT){
                    if(self.view.transform.tx < CGRectGetWidth(self.view.bounds) - KWHC_Side_Left_Menu_N_Margin){
                        [self closeSideMenu:YES margin:0];
                    }
                }else{
                    if(self.view.transform.tx > KWHC_Side_Right_Menu_N_Margin - CGRectGetWidth(self.view.bounds)){
                        [self closeSideMenu:YES margin:0];
                    }
                }
            }else{
                if((fabsf(self.view.transform.tx) / (CGRectGetWidth(self.view.bounds) - menuMargin)) < 0.5){
                    [self closeSideMenu:YES margin:0];
                }else if (fabsf(self.view.transform.tx) < (CGRectGetWidth(self.view.bounds) - menuMargin)){
                    [self closeSideMenu:NO margin:toMenuMargin];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ori
-(BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [self.visibleViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - customMothed
- (void)pushVC:(UIViewController*)vc animated:(BOOL)animated{
    UIViewController  * topVC = self.topViewController;
    [topVC.navigationController pushViewController:vc animated:animated];
}

- (void)popVC:(UIViewController*)vc animated:(BOOL)animated{
    UIViewController * topVC = self.topViewController;
    [topVC.navigationController popViewControllerAnimated:animated];
}

- (void)createOverViewWithMenu:(WHC_Menu)menu{
    if([self menuEnableFade]){
        CGRect  rc = _rightMenuVC.view.bounds;
        if(menu == WHC_MENU_LEFT){
            rc = _leftMenuVC.view.bounds;
        }
        UIView * overView = [[UIView alloc]initWithFrame:rc];
        overView.tag = KWHC_OVER_VIEW_TAG;
        overView.backgroundColor = [UIColor blackColor];
        overView.alpha = kWHC_Side_Menu_N_OVER_VIEW_ALPHA;
        
        if(menu == WHC_MENU_LEFT){
            UIView * deleteView = [_leftMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            if(deleteView != nil){
                [deleteView removeFromSuperview];
                deleteView = nil;
            }
            [_leftMenuVC.view addSubview:overView];
            [_leftMenuVC.view sendSubviewToBack:overView];
        }else{
            UIView * deleteView = [_rightMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            if(deleteView != nil){
                [deleteView removeFromSuperview];
                deleteView = nil;
            }
            [_rightMenuVC.view addSubview:overView];
            [_rightMenuVC.view sendSubviewToBack:overView];
        }
    }
    
}

- (void)loadOverViewWithMenu:(WHC_Menu)menu{
    if(menu == WHC_MENU_NONE){
        return;
    }
    [self createOverViewWithMenu:menu];
    if([self menuEnableSlide] ||
       _menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
        UIView * menuView = nil;
        CGRect  menuViewRC = CGRectZero;
        if(menu == WHC_MENU_LEFT){
            menuView = _leftMenuVC.view;
            menuViewRC = menuView.frame;
            if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
               _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE){
                menuViewRC.origin.x = -KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            }else if(_menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
                     _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
                menuView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Scale x:KWHC_Side_Left_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin];
                return;
            }else if(_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
                     _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
                UIView * slideView = [self findContentViewWithMenu:WHC_MENU_LEFT];
                menuViewRC = slideView.frame;
                menuViewRC.origin.x = -KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
                slideView.frame = menuViewRC;
                return;
            }
        }else{
            menuView = _rightMenuVC.view;
            menuViewRC = menuView.frame;
            if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
               _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE){
                
                menuViewRC.origin.x =  KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            }else if(_menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
                     _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
                menuView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Scale x:-KWHC_Side_Right_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin];
                return;
            }else if(_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
                     _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
                
                UIView * slideView = [self findContentViewWithMenu:WHC_MENU_RIGHT];
                menuViewRC = slideView.frame;
                menuViewRC.origin.x = KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
                slideView.frame = menuViewRC;
                return;
            }
        }
        menuView.frame = menuViewRC;
    }else if (_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE ||
              _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE){
        UIView * scaleView = [self findContentViewWithMenu:menu];
        if(scaleView != nil){
            if(menu == WHC_MENU_LEFT){
                scaleView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale x:-KWHC_Side_Left_Menu_N_Margin];
            }else{
                scaleView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale x:KWHC_Side_Right_Menu_N_Margin];
            }
        }
    }
}

- (CATransform3D)initTransform3D:(CGFloat)z x:(CGFloat)x{
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0 / 900.0;
    CATransform3D transform = CATransform3DMakeTranslation(x, 0.0, z);
    return CATransform3DConcat(transform, scale);
}

- (CGAffineTransform)initAffineTransform:(CGFloat)scale x:(CGFloat)x{
    CGAffineTransform   scaleAffine = CGAffineTransformMakeScale(1.0, scale);
    CGAffineTransform   transformAffine = CGAffineTransformMakeTranslation(x, 0.0);
    return CGAffineTransformConcat(transformAffine, scaleAffine);
}

- (UIView *)findContentViewWithMenu:(WHC_Menu)menu{
    UIView * contentView = nil;
    UIView * menuView = _rightMenuVC.view;
    if(menu == WHC_MENU_LEFT){
        menuView = _leftMenuVC.view;
    }
    for (UIView * view in menuView.subviews) {
        if(![view isEqual:[menuView viewWithTag:KWHC_OVER_VIEW_TAG]]){
            contentView = view;
            break;
        }
    }
    return contentView;
}

- (void)handleTouchMoveMenu:(WHC_Menu)menu distanceX:(CGFloat)distanceX{
    if(menu == WHC_MENU_NONE){
        return;
    }
    if([self menuEnableFade]){
        UIView * overView = nil;
        if(menu == WHC_MENU_LEFT){
            
            overView = [_leftMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            CGFloat  rate = (distanceX / (CGRectGetWidth(_leftMenuVC.view.frame) - KWHC_Side_Left_Menu_N_Margin));
            overView.alpha = rate * (1.0 - kWHC_Side_Menu_N_OVER_VIEW_ALPHA) + (1.0 - rate) * kWHC_Side_Menu_N_OVER_VIEW_ALPHA;
        }else{
            
            overView = [_rightMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            CGFloat  rate = (-distanceX / (CGRectGetWidth(_rightMenuVC.view.frame) - KWHC_Side_Right_Menu_N_Margin));
            overView.alpha = rate * (1.0 - kWHC_Side_Menu_N_OVER_VIEW_ALPHA) + (1.0 - rate) * kWHC_Side_Menu_N_OVER_VIEW_ALPHA;
        }
    }
    
    if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE){
        
        UIView * menuView = nil;
        CGRect   menuViewRC = CGRectZero;
        if(menu == WHC_MENU_LEFT){
            menuView = _leftMenuVC.view;
            menuViewRC = menuView.frame;
            menuViewRC.origin.x = (distanceX / (CGRectGetWidth(menuViewRC) - KWHC_Side_Left_Menu_N_Margin)) * KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate - KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
        }else{
            menuView = _rightMenuVC.view;
            menuViewRC = menuView.frame;
            menuViewRC.origin.x = KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate - (fabsf(distanceX) / (CGRectGetWidth(menuViewRC) - KWHC_Side_Right_Menu_N_Margin)) * KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
        }
        menuView.frame = menuViewRC;
    }else if(_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
             _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
        
        UIView * slideView = [self findContentViewWithMenu:menu];
        if(slideView != nil){
            
            CGRect   menuViewRC = slideView.frame;
            if(menu == WHC_MENU_LEFT){
                menuViewRC.origin.x = (distanceX / (CGRectGetWidth(menuViewRC) - KWHC_Side_Left_Menu_N_Margin)) * KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate - KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            }else{
                menuViewRC.origin.x = KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate - (fabsf(distanceX) / (CGRectGetWidth(menuViewRC) - KWHC_Side_Right_Menu_N_Margin)) * KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            }
            slideView.frame = menuViewRC;
        }
    }
    
    if(_menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
        if(menu == WHC_MENU_LEFT){
            
            CGFloat   rate = (distanceX / (CGRectGetWidth(_leftMenuVC.view.frame) - KWHC_Side_Left_Menu_N_Margin));
            _leftMenuVC.view.transform = [self initAffineTransform:KWHC_Side_Menu_N_Scale + rate * (1.0 - KWHC_Side_Menu_N_Scale) x:KWHC_Side_Left_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin - rate * KWHC_Side_Left_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin];
        }else{
            
            CGFloat   rate = (fabsf(distanceX) / (CGRectGetWidth(_rightMenuVC.view.frame) - KWHC_Side_Right_Menu_N_Margin));
            _rightMenuVC.view.transform = [self initAffineTransform: KWHC_Side_Menu_N_Scale + rate * (1.0 - KWHC_Side_Menu_N_Scale) x:-KWHC_Side_Right_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin + rate * KWHC_Side_Right_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin];
        }
    }else if (_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE ||
              _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE){
        
        UIView  * scaleView = [self findContentViewWithMenu:menu];
        if(scaleView != nil){
            if(menu == WHC_MENU_LEFT){
                
                CGFloat   rate = (distanceX / (CGRectGetWidth(_leftMenuVC.view.frame) - KWHC_Side_Left_Menu_N_Margin));
                scaleView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale + (1.0 - KWHC_Side_Menu_N_Main_Scale_Scale) * rate x:KWHC_Side_Left_Menu_N_Margin * (rate - 1.0)];
            }else{
                
                CGFloat   rate = (fabsf(distanceX) / (CGRectGetWidth(_rightMenuVC.view.frame) - KWHC_Side_Right_Menu_N_Margin));
                scaleView.transform = [self initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale + (1.0 - KWHC_Side_Menu_N_Main_Scale_Scale) * rate x:KWHC_Side_Right_Menu_N_Margin * (1.0 - rate)];
            }
        }
    }
}

- (void)closeSideMenu:(BOOL)isClose margin:(CGFloat)margin{
    
    _isOpenMenu = !isClose;
    _isEnablePanMenu = !isClose;
    [self registPanGesture:NO];
    __weak typeof(self) sf = self;
    if(isClose){
        
        [self enableTapGesture:NO];
        CGAffineTransform  transaction = CGAffineTransformMakeTranslation(0.0, 0.0);
        [UIView animateWithDuration:KWHC_Side_Menu_N_During delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.view.transform = transaction;
        }completion:^(BOOL finished) {
            _menu = WHC_MENU_NONE;
            _currentMenu = WHC_MENU_NONE;
            _didShowSideMenu = NO;
            [sf registPanGesture:YES];
        }];
        
        if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
           _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE){
            
            CGRect  menuViewRC = CGRectZero;
            UIView *menuView = _rightMenuVC.view;
            menuViewRC = menuView.frame;
            menuViewRC.origin.x = KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            if(_currentMenu == WHC_MENU_LEFT){
                menuView = _leftMenuVC.view;
                menuViewRC = menuView.frame;
                menuViewRC.origin.x = -KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
            }
            [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                menuView.frame = menuViewRC;
            }completion:^(BOOL finished) {
                [sf registPanGesture:YES];
            }];
        }else if (_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
                  _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
            
            CGRect  menuViewRC = CGRectZero;
            UIView * slideView = [self findContentViewWithMenu:_currentMenu];
            if(slideView != nil){
                
                menuViewRC = slideView.frame;
                menuViewRC.origin.x = KWHC_Side_Right_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
                if(_currentMenu == WHC_MENU_LEFT){
                    menuViewRC.origin.x = -KWHC_Side_Left_Menu_N_Margin * KWHC_Side_Menu_N_Slide_Rate;
                }
                [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    slideView.frame = menuViewRC;
                }completion:^(BOOL finished) {
                    [sf registPanGesture:YES];
                }];
            }
        }
        
        if(_menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
           _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
            
            UIView  * menuView = _rightMenuVC.view;
            CGFloat   x = -KWHC_Side_Right_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin;
            if(_currentMenu == WHC_MENU_LEFT){
                menuView = _leftMenuVC.view;
                x = KWHC_Side_Left_Menu_N_Margin / KWHC_Side_Menu_N_Scale_Margin;
            }

            [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                menuView.transform = [sf initAffineTransform:KWHC_Side_Menu_N_Scale x:x];
            }completion:^(BOOL finished) {
                [sf registPanGesture:YES];
            }];
            
        }else if(_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE ||
                 _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE){
            
            UIView * scaleView = [self findContentViewWithMenu:_currentMenu];
            CGFloat x = KWHC_Side_Right_Menu_N_Margin;
            if(_currentMenu == WHC_MENU_LEFT){
                x = -KWHC_Side_Left_Menu_N_Margin;
            }
            if(scaleView != nil){
        
                [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    scaleView.transform = [sf initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale x:x];
                } completion:^(BOOL finished) {
                    [sf registPanGesture:YES];
                }];
            }
        }
    }else{
        [self enableTapGesture:YES];
        CGAffineTransform  transaction = CGAffineTransformMakeTranslation(margin, 0.0);
        if([self mainViewEnbaleScale]){
            transaction = [self initAffineTransform:KWHC_Side_Menu_N_Main_Scale_Scale x:margin];
        }
        [UIView animateWithDuration:KWHC_Side_Menu_N_During delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sf.view.transform = transaction;
        }completion:^(BOOL finished) {
            _currentMenu = _menu;
            _menu = WHC_MENU_NONE;
            [sf registPanGesture:YES];
        }];
        
        if([self menuEnableFade]){
            UIView * overView = [_rightMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            if(_menu == WHC_MENU_LEFT){
                overView = [_leftMenuVC.view viewWithTag:KWHC_OVER_VIEW_TAG];
            }
            overView.alpha = 1.0 - kWHC_Side_Menu_N_OVER_VIEW_ALPHA;
        }
        
        if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
           _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE){
            
            CGRect  menuViewRC = CGRectZero;
            UIView *menuView = _rightMenuVC.view;
            if(_menu == WHC_MENU_LEFT){
                menuView = _leftMenuVC.view;
            }
            menuViewRC = menuView.frame;
            menuViewRC.origin.x = 0.0;
            [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                menuView.frame = menuViewRC;
            }completion:^(BOOL finished) {
                [sf registPanGesture:YES];
            }];
        }else if (_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
                  _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
            
            CGRect  menuViewRC = CGRectZero;
            UIView * slideView = [self findContentViewWithMenu:_menu];
            if(slideView != nil){
                
                menuViewRC = slideView.frame;
                menuViewRC.origin.x = 0.0;
                [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    slideView.frame = menuViewRC;
                }completion:^(BOOL finished) {
                    [sf registPanGesture:YES];
                }];
            }
        }
        
        if(_menuMoveStyle == WHC_Menu_Move_Style_SCALE ||
           _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE){
            
            UIView  * menuView = _rightMenuVC.view;
            if(_menu == WHC_MENU_LEFT){
                menuView = _leftMenuVC.view;
            }
    
            [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                menuView.transform = [sf initAffineTransform:1.0 x:0];
            }completion:^(BOOL finished) {
                [sf registPanGesture:YES];
            }];
        }else if (_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE ||
                  _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE){
            
            UIView * scaleView = [self findContentViewWithMenu:_menu];
            if(scaleView != nil){
                
                [UIView animateWithDuration:KWHC_Side_Menu_N_During / 2.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    scaleView.transform = [sf initAffineTransform:1.0 x:0];
                } completion:^(BOOL finished) {
                    [sf registPanGesture:YES];
                }];
            }
        }
    
    }
}

- (BOOL)menuEnableFade{
    if(_menuMoveStyle == WHC_Menu_Move_Style_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SCALE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
        return YES;
    }
    return NO;
}

- (BOOL)menuEnableSlide{
    if(_menuMoveStyle == WHC_Menu_Move_Style_SLIDE ||
       _menuMoveStyle == WHC_Menu_Move_Style_SLIDE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
        return YES;
    }
    return NO;
}

- (BOOL)mainViewEnbaleScale{
    if(_menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_FADE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SCALE_FADE||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE ||
       _menuMoveStyle == WHC_Menu_Move_Style_MAIN_VIEW_SCALE_SLIDE_FADE){
        return YES;
    }
    return NO;
}

- (BOOL)showLeftMenu{
    if([self.topViewController respondsToSelector:@selector(whcSlideNavigationControllerShouldShowLeftMenu)] &&
       [(UIViewController<WHC_SideNavigationControlerDelegate>*)self.topViewController whcSlideNavigationControllerShouldShowLeftMenu]){
        return YES;
    }
    return NO;
}

- (BOOL)showRightMenu{
    if([self.topViewController respondsToSelector:@selector(whcSlideNavigationControllerShouldShowRightMenu)] &&
       [(UIViewController<WHC_SideNavigationControlerDelegate>*)self.topViewController whcSlideNavigationControllerShouldShowRightMenu]){
        return YES;
    }
    return NO;
}

- (BOOL)showMenu{
    if([self showLeftMenu] && [self showRightMenu]){
        return YES;
    }
    return NO;
}

#pragma mark - overloadMothed
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    _topView = self.topViewController.view;
    _topView.userInteractionEnabled = NO;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(_isOpenMenu){
        [self closeSideMenu:YES margin:0];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(_topView != nil){
        _topView.userInteractionEnabled = YES;
    }
}

@end
