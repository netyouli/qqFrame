//
//  OneVC.m
//  SideMenu
//
//  Created by 吴海超 on 15/4/10.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

#import "OneVC.h"
#import "OtherVC.h"
#import "WHC_SideNavigationControler.h"
@interface OneVC ()

@end

@implementation OneVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"oneVC";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAction:(UIButton*)sender{

    if(sender.tag == 0){
        [[WHC_SideNavigationControler sharedInstance]pushViewController:[OtherVC new] animated:YES];
    }else{
        [WHC_SideNavigationControler sharedInstance].menuMoveStyle = sender.tag;
    }
//    [self.navigationController pushViewController:vc animated:YES];
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
