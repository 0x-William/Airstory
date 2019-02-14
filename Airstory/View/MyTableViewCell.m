//
//  MyTableViewCell.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
@synthesize dotView, textLabel;

- (void)awakeFromNib {
    // Initialization code
    dotView.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        dotView.hidden = NO;
    }
    else
    {
        dotView.hidden = YES;
    }
    
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    if (highlighted) {
//        dotView.hidden = NO;
//    }
//    else
//        dotView.hidden = YES;
//}

@end
