//
//  SelectProjectVC.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "SelectProjectVC.h"
#import "SVGKit.h"
#import "MyTableViewCell.h"
#import "CustomAFNetworking.h"
#import "AppDelegate.h"

@interface SelectProjectVC (){
    NSInteger index;
}

@end

@implementation SelectProjectVC
@synthesize projects, projectsTableView, selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Select Project"];
    [self initView];
    
    projectsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;

    index = selectedIndex;
    [projectsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [projectsTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL_ID"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentVC = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didCancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIImage *addImage = [UIImage imageNamed:@"Icon_Add"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 23, 20)];
    [rightButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didCancel {
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)didSave {
    selectedIndex = index;
    [self performSegueWithIdentifier:@"RewindFromSelectProjectVCSegue" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return projects.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    index = indexPath.row;
    
//    MyTableViewCell *cell = (MyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyTableViewCell *cell = (MyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
////    if (selected) {
////        dotView.hidden = NO;
////        self.selectionStyle = UITableViewCellSelectionStyleNone;
////    }
////    else
////    {
////        dotView.hidden = YES;
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
////    }
//    
//    return indexPath;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
//
//    if (cell == nil) {
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
//    }
    

    cell.textLabel.text = [projects[indexPath.row] valueForKey:@"name"];
    
    return cell;
}

- (void)willEnterActive {
    selectedIndex = [CustomAFNetworking availableProjectIndexFromList:projects];
    [projectsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


@end
