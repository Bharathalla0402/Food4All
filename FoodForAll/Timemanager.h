//
//  Timemanager.h
//  MultlipleTimer
//
//  Created by think360 on 19/05/17.
//  Copyright © 2017 Slack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Timemanager : NSObject


+ (void)configureCell:(UITableViewCell *)cell withTimerArr:(NSMutableArray *)timerArr withSecondsArr:(NSMutableArray *)secondsArr forAtIndexPath:(NSIndexPath *)indexPath;



@end
