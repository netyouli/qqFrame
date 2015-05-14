//
//  WHC_RightVC.m
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

#import "WHC_RightVC.h"
#import "WHC_SideNavigationControler.h"
#import "OtherVC.h"

#define  kWHC_TABLE_VIEW_Y (50.0)     //列表的y坐标

@interface WHC_RightVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray  *   menuItemTitles;
}

@end
@implementation WHC_RightVC
- (instancetype)init{
    self = [super init];
    if(self != nil){
        
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"right.jpg"]];
    
    menuItemTitles = @[@"right_one",@"skidkdiakdkslsodldosloslsoright_two",@"right_three"];
    
    UITableView  * leftMenuTV = [[UITableView alloc]initWithFrame:CGRectMake(0.0, kWHC_TABLE_VIEW_Y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kWHC_TABLE_VIEW_Y) style:UITableViewStylePlain];
    leftMenuTV.userInteractionEnabled = YES;
    leftMenuTV.backgroundColor = [UIColor clearColor];
    leftMenuTV.delegate = self;
    leftMenuTV.dataSource = self;
    [self.view addSubview:leftMenuTV];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuItemTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString  * strIdent = @"whc";
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:strIdent];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdent];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.text = menuItemTitles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
        default:
        {
            OtherVC * vc = [OtherVC new];
            [[WHC_SideNavigationControler sharedInstance] pushVC:vc animated:YES];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

@end
