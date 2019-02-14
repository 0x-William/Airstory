//
//  LoginVC.m
//  Airstory
//
//  Created by ProDev on 4/16/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "LoginVC.h"
#import "MBProgressHUD.h"
#import "AddCardVC.h"
#import "GlobalHeader.h"
#import "CustomAFNetworking.h"
#import "Utils.h"

NSString* kLoginSegue = @"AddCardSegue";

@interface LoginVC (){
    UIView *dimView;
    UITextField *activeField;
    MBProgressHUD *hudView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LoginVC
@synthesize emailTextField, passwordTextField, scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emailTextField.delegate = self;
    passwordTextField.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    [defaults setObject:@"NO" forKey:kFirstUse];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)addLoadingView {
//    dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
//
//    [self.view addSubview:dimView];

    dispatch_async(dispatch_get_main_queue(), ^(){
        hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudView.detailsLabelText = @"Signing you in to Airstory";
        hudView.dimBackground = YES;
    });
}

- (void)removeLoadingView {
    [hudView hide:YES];
//    [dimView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)didLogin:(id)sender {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"AIRSTORY_IOS"];
    
//    NSDictionary *parameters = @{@"j_username": @"jilt.koeman@hotmail.com",
//                                 @"j_password": @"a123456",
//                                 @"_spring_security_remember_me": @"1"};
    
    NSDictionary *parameters = @{@"j_username": self.emailTextField.text,
                                 @"j_password": self.passwordTextField.text,
                                 @"_spring_security_remember_me": @"1"};

    
    [self addLoadingView];
	
    [manager POST:@"j_spring_security_check" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self removeLoadingView];
        
        NSString *convertedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([convertedString isEqualToString:@"success"]){
            [CustomAFNetworking saveCookiesToUserDefaults];
            
            [self performSegueWithIdentifier:kLoginSegue sender:self];
        }
        else if ([Utils displaysResponseDialog:responseObject])
            return ;
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Username/Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertView show];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [self removeLoadingView];
        
        [Utils displaysErrorDialog:error];
    }];
     

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    AddCardVC *destVC = [segue destinationViewController];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)didResetPassword:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kResetPasswordURL]];
}
- (IBAction)didRegister:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSignupURL]];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

@end
