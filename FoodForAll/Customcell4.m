//
//  Customcell4.m
//  GetUsHere For Rider
//
//  Created by bharat on 16/05/16.
//  Copyright © 2016 bharat. All rights reserved.
//

#import "Customcell4.h"

@implementation Customcell4

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _labwidth.constant=40;
    [_lab1 sizeToFit];
    
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
