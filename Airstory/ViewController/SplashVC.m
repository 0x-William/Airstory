//
//  SplashVC.m
//  Airstory
//
//  Created by ProDev on 4/23/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "SplashVC.h"
#import "CustomAFNetworking.h"
#import "AddCardVC.h"
#import "Utils.h"

@interface SplashVC () <NSURLSessionDelegate>{
    NSArray *projects;
    MBProgressHUD *hudView;
}

@end

@implementation SplashVC

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    
    if ([defaults objectForKey:kFirstUse] == nil)
    {
        [self performSegueWithIdentifier:@"ToInstructionVC" sender:self];
        
        return;
    }
    
    __weak UIViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        hudView = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//        hudView.detailsLabelText = @"Signing you in to Airstory";
        hudView.dimBackground = YES;
    });
    
    
    
    [CustomAFNetworking sendRequestWithSharedCookie:@"GET" endPoint:@"mobile/iphone/v1/get-save-to-list" headers:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hudView hide:YES];

        
        if ([CustomAFNetworking isLoginPage:operation])
            [weakSelf performSegueWithIdentifier:@"ToLoginVCSegue" sender:weakSelf];
        else if ([Utils displaysResponseDialog:responseObject]) {
            [weakSelf performSegueWithIdentifier:@"ToLoginVCSegue" sender:weakSelf];
            return ;
        }
        else{
            [CustomAFNetworking saveTimestampToUserDefaults];
            projects = responseObject[@"results"];
            
            UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
            [weakSelf.navigationController pushViewController:loginVC animated:NO];
            [weakSelf performSegueWithIdentifier:@"SkipLoginVCSegue" sender:weakSelf];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hudView hide:YES];
        
//        [Utils displaysErrorDialog:error];

        [weakSelf performSegueWithIdentifier:@"ToLoginVCSegue" sender:weakSelf];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SkipLoginVCSegue"]) {
        AddCardVC *destVC = [segue destinationViewController];
        destVC.projects = projects;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
//        [session invalidateAndCancel];
        
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
    
    
    
}

@end
