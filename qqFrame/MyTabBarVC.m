//
//  MyTabBarVC.m
//  SideMenu
//
//  Created by 吴海超 on 15/4/10.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "MyTabBarVC.h"
#import "WHC_SideNavigationControler.h"
#import "OneVC.h"
#import "MyTabBarVC.h"
@interface MyTabBarVC ()<WHC_SideNavigationControlerDelegate>

@end

@implementation MyTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
//    self.tabBar.translucent = NO;
    self.title = @"oneVC";
//    self.view.backgroundColor = [UIColor redColor];
    OneVC  * onVc = [[OneVC alloc]init];
//    WHC_NavigationController02  * onNv = [[WHC_NavigationController02 alloc]initWithRootViewController:onVc];
    onVc.tabBarItem.title = @"我是海超";
    self.viewControllers = @[onVc];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)whcSlideNavigationControllerShouldShowRightMenu{
    return YES;
}
- (BOOL)whcSlideNavigationControllerShouldShowLeftMenu{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
