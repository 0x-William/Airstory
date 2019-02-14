//
//  ProjectSelectorTableVC.h
//  Airstory
//
//  Created by ProDev on 4/29/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadConfigurationDelegate <NSObject>

- (void) reloadConfiguration : (NSUInteger)index;

@end

@interface ProjectSelectorTableVC : UITableViewController

@property (nonatomic, weak) NSArray *projects;
@property (nonatomic, weak) id<ReloadConfigurationDelegate> delegate;

@end
