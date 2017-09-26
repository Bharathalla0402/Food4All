//
//  StepTwoViewController.h
//  FoodForAll
//
//  Created by think360 on 01/08/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTwoViewController : UIViewController
{
    NSMutableIndexSet *expandedSections;
}
@property (weak, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (weak, nonatomic) IBOutlet UIButton *safetybutt;

@property (weak, nonatomic) IBOutlet UITableView *CategeoryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;

@end
