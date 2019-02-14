//
//  AddCardVC.h
//  Airstory
//
//  Created by ProDev on 4/16/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "SVGKImage.h"
#import "SVGKFastImageView.h"
#import "SVGKLayeredImageView.h"

#import "SVGKSourceURL.h"
#import "SVGKSourceLocalFile.h"
#import "SVGKSourceNSData.h"
#import "SVGKSourceString.h"

@interface AddCardVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *popoverContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (strong, nonatomic) NSArray* projects;

@property (weak, nonatomic) IBOutlet UITableView *projectsTableView;
@property (weak, nonatomic) IBOutlet UITextField *cardTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *cardContentTextView;

- (IBAction) willRewind:(UIStoryboardSegue *)segue;

@end
