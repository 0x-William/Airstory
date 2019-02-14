//
//  SelectProjectVC.h
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProjectVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* projects;
@property (nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UITableView *projectsTableView;

@end
