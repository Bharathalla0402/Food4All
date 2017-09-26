//
//  Timemanager.m
//  MultlipleTimer
//
//  Created by think360 on 19/05/17.
//  Copyright © 2017 Slack. All rights reserved.
//

#import "Timemanager.h"

@implementation Timemanager



+ (void)configureCell:(UITableViewCell *)cell withTimerArr:(NSMutableArray *)timerArr withSecondsArr:(NSMutableArray *)secondsArr forAtIndexPath:(NSIndexPath *)indexPath{
    
    if (timerArr.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *timerLbl = (UILabel *)[cell.contentView viewWithTag:1];
            UILabel *timerLbl2 = (UILabel *)[cell.contentView viewWithTag:2];
            UILabel *timerLbl3 = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *circularTimerLbl;
            
            if (![timerArr[indexPath.row] isKindOfClass:[NSDate class]]) {
                [timerLbl  setText:@"00"];
                [timerLbl2  setText:@"00"];
                [timerLbl3  setText:@"00"];
                [circularTimerLbl setText:@"00:00"];
                return ;
            }
            
            NSInteger time = [timerArr[indexPath.row] timeIntervalSinceDate: [NSDate date]];
            NSInteger hour = time / 3600;
            NSInteger minute = (time / 60) % 60;
            NSInteger second = time % 60;
            
        
//            let hours = Int(time) / 3600
//            let minutes = Int(time) / 60 % 60
//            let seconds = Int(time) % 60
//            hourslab.text=String(format:"%02i", hours)
//            MinsLab.text=String(format:"%02i", minutes)
//            Secondalab.text=String(format:"%02i", seconds)
//            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            

            
            if (hour <= 0 && minute <= 0 && second <= 0) {
                [timerLbl  setText:@"00"];
                [timerLbl2  setText:@"00"];
                [timerLbl3  setText:@"00"];
                [circularTimerLbl setText:@"Over"];
                
                return ;
            }
            
            NSString *hrs, *minutes, *seconds;
            if (hour > 0) {
                hrs = [NSString stringWithFormat:@"%ld", (long)hour];
                if (hrs.length < 2) {
                    hrs = [NSString stringWithFormat:@"0%@", hrs];
                }
                
                minutes = [NSString stringWithFormat:@"%ld", (long)minute];
                if (minutes.length < 2) {
                    minutes = [NSString stringWithFormat:@"0%@", minutes];
                }
                
                seconds = [NSString stringWithFormat:@"%ld", (long)second];
                if (seconds.length < 2) {
                    seconds = [NSString stringWithFormat:@"0%@", seconds];
                }
                
                
                [timerLbl setText:[NSString stringWithFormat:@"%@", hrs]];
                [timerLbl2 setText:[NSString stringWithFormat:@"%@", minutes]];
                [timerLbl3 setText:[NSString stringWithFormat:@"%@", seconds]];
                [circularTimerLbl setText:[NSString stringWithFormat:@"%@:%@:%@", hrs, minutes,seconds]];
            }
            else
            {
                hrs = [NSString stringWithFormat:@"%ld", (long)hour];
                if (hrs.length < 2) {
                    hrs = [NSString stringWithFormat:@"0%@", hrs];
                }
                
                minutes = [NSString stringWithFormat:@"%ld", (long)minute];
                if (minutes.length < 2) {
                    minutes = [NSString stringWithFormat:@"0%@", minutes];
                }
                
                seconds = [NSString stringWithFormat:@"%ld", (long)second];
                if (seconds.length < 2) {
                    seconds = [NSString stringWithFormat:@"0%@", seconds];
                }
                
                [timerLbl setText:[NSString stringWithFormat:@"%@", hrs]];
                [timerLbl2 setText:[NSString stringWithFormat:@"%@", minutes]];
                [timerLbl3 setText:[NSString stringWithFormat:@"%@", seconds]];
                [circularTimerLbl setText:[NSString stringWithFormat:@"%@:%@:%@", hrs, minutes,seconds]];
            }
            
        });
    }
}


@end
