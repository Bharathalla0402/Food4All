//
//  ChatingDetailsViewController.h
//  BoxBazar
//
//  Created by bharat on 19/12/16.
//  Copyright © 2016 Bharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondDelegate;
@protocol SecondDelegate <NSObject>

@optional
- (void)responsewithToken: (NSMutableDictionary *)responseToken;
@end


@interface ChatingDetailsViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *userid;
    NSString *driverid;
    
    NSMutableArray *tripdriverinfo;
    
    NSMutableArray *arrmessage;
    
    NSMutableArray *arrids;
    
    NSMutableArray *arrimage;
}
@property (nonatomic, assign) id <SecondDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *sendButt;

@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (weak, nonatomic) IBOutlet UITextField *TextMessage;

@property (weak, nonatomic) IBOutlet UITableView *ChatTable;

@property(nonatomic,retain) NSString *strConversionId;
@property(nonatomic,retain) NSString *strPostUserId;
@property(nonatomic,retain) NSString *checkString;
@property(nonatomic,retain) NSString *strpage;



@property(nonatomic,retain) NSString *StrChatMessageTypeId;
@property(nonatomic,retain) NSString *StrChatMessage;

- (void)next: (UIImage *)currentSelectedImage;
- (void)next2: (UIImage *)currentSelectedImage;

@end
