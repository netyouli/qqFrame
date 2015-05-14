//
//  OtherVC.m
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

#import "OtherVC.h"
#import "WHC_SideNavigationControler.h"
@interface OtherVC ()<WHC_SideNavigationControlerDelegate,UITableViewDataSource,UITableViewDelegate>{

}

@end

@implementation OtherVC
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"other";

    
    CGFloat  width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat  height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    UITableView * vc = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStylePlain];
    vc.delegate = self;
    vc.dataSource = self;
    [self.view addSubview:vc];
}

- (BOOL)whcSlideNavigationControllerShouldShowRightMenu{
    return YES;
}
- (BOOL)whcSlideNavigationControllerShouldShowLeftMenu{
    return NO;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell = @"whcCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"whc%ld",(long)indexPath.row];
    return cell;
}
@end
