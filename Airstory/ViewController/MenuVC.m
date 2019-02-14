//
//  MenuVC.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "MenuVC.h"
#import "MBProgressHUD.h"
#import "CustomAFNetworking.h"
#import "Utils.h"
#import "REFrostedViewController.h"

@interface MenuVC (){
    MBProgressHUD *hudView;
}

@end

@implementation MenuVC
@synthesize nameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    nameLabel.text = self.txtName;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didLogout:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
            hudView = [MBProgressHUD showHUDAddedTo:self.contentVC.view animated:YES];
            hudView.detailsLabelText = @"Signing you out from Airstory";
            hudView.dimBackground = YES;
            
            __weak MenuVC *weakSelf = self;
            
            [CustomAFNetworking sendRequestWithSharedCookie:@"GET" endPoint:kSignoutEndpoint headers:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [hudView hide:YES];

                dispatch_async(dispatch_get_main_queue(), ^(){
                    [weakSelf.contentVC popViewControllerAnimated:YES];
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [hudView hide:YES];
                
//                [Utils displaysErrorDialogWhenNotReachable];
            }];
        }];
    //    });
}

- (IBAction)didHideMenu:(id)sender {
    [self.frostedViewController hideMenuViewController];
}
@end
