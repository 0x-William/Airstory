//
//  ErrorDialogVC.h
//  Airstory
//
//  Created by Guru on 27/05/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainVCDelegate <NSObject>

- (void) removeDialog;

@end

@interface ErrorDialogVC : UIViewController

@property (weak, nonatomic) id<MainVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@end
