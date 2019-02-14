//
//  MenuVC.h
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVC : UIViewController

@property (weak, nonatomic) UINavigationController *contentVC;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *txtName;

- (IBAction)didLogout:(id)sender;

@end
