//
//  InstructionContentVC.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "InstructionContentVC.h"
#import "GlobalHeader.h"

@interface InstructionContentVC ()

@end

@implementation InstructionContentVC
@synthesize introTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"Welcome to Airstory."];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"Use this app to jot down ideas and send them to your projects."];
    
    NSLog(@"%@", [UIFont fontNamesForFamilyName:@"AppleSDGothicNeo"]);
    UIFont *font1 = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16];
    [str1 addAttribute:NSFontAttributeName
                value:font1
                  range:NSMakeRange(0, [str1 length])];
    
    UIFont *font2 = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [str2 addAttribute:NSFontAttributeName
                value:font2
                range:NSMakeRange(0, [str2 length])];
    
    [str1 appendAttributedString:str2];
    introTextView.attributedText = str1;
     */
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

- (IBAction)didSignUp:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSignupURL]];
}

@end
