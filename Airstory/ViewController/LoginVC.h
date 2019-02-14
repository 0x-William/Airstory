//
//  LoginVC.h
//  Airstory
//
//  Created by ProDev on 4/16/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)didLogin:(id)sender;

@end
