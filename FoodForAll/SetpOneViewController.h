//
//  SetpOneViewController.h
//  FoodForAll
//
//  Created by think360 on 31/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetpOneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableIndexSet *expandedSections,*expandedSections2;
}

@property (weak, nonatomic) IBOutlet UIScrollView *MainScrool;
@property(nonatomic,retain) NSMutableArray *arrChildCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstaint;

@property (weak, nonatomic) IBOutlet UITableView *categeorytableView;

@property (weak, nonatomic) IBOutlet UILabel *foodSafetyTipslab;


@property (weak, nonatomic) IBOutlet UIButton *safetybutt;

@property (weak, nonatomic) IBOutlet UITableView *CategeoryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;

@property (weak, nonatomic) IBOutlet UILabel *ensurelab;
@property (weak, nonatomic) IBOutlet UIButton *nextbutt;
@property (weak, nonatomic) IBOutlet UILabel *UpdateLab;

@property (weak, nonatomic) IBOutlet NSArray *imagesArray;
@property (weak, nonatomic) IBOutlet NSDictionary *listDetailBank;
@property (weak, nonatomic) IBOutlet NSString *StrEditMode;

@end
