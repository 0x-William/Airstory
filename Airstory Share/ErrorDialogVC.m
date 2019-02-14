//
//  ErrorDialogVC.m
//  Airstory
//
//  Created by Guru on 27/05/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "ErrorDialogVC.h"


@interface ErrorDialogVC ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation ErrorDialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundView.layer.cornerRadius = 10;
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
- (IBAction)didClickOk:(id)sender {
    if (self.delegate){
        [self.delegate removeDialog];
    }
}
@end
