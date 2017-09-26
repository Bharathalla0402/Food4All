//
//  ChatingDetailsViewController.m
//  BoxBazar
//
//  Created by bharat on 19/12/16.
//  Copyright © 2016 Bharat. All rights reserved.
//

#import "ChatingDetailsViewController.h"
#import "Customcell4.h"
#import "SWRevealViewController.h"


@interface ChatingDetailsViewController ()
{
    Customcell4 *cell;

    UIView *topview;
    
    NSDictionary *userlist;
    
    NSString *tzName;
    
    int x;
    int count,lastCount;
    
    int scrool;
     UIActivityIndicatorView * actInd;
    UILabel *loadLbl;
    UIView *footerview2;
}
@end

@implementation ChatingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    x=1;
  
    count=1;
    scrool=1;
    lastCount=1;
   
    
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    tzName = [timeZone name];
    
    NSLog(@"%@",tzName);
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"backButton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"appear"];
    [[NSUserDefaults standardUserDefaults]synchronize];

   // userlist = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
    
    userlist=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    
    self.title=@"Chat";
    
    _TextMessage.delegate=self;
    
    arrmessage=[[NSMutableArray alloc]init];
    arrids=[[NSMutableArray alloc]init];
    arrimage=[[NSMutableArray alloc]initWithObjects:@"green.png",@"white.png", nil];
    tripdriverinfo=[[NSMutableArray alloc]init];
    
    self.ChatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  self.ChatTable.backgroundColor=[UIColor lightGrayColor];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Layer 1@2x.png"]];
    [tempImageView setFrame:self.ChatTable.frame];
    self.ChatTable.backgroundView = tempImageView;
    self.ChatTable.rowHeight=UITableViewAutomaticDimension;
    _ChatTable.transform = CGAffineTransformMakeRotation(-M_PI);
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    _ChatTable.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,0,self.view.frame.size.width-7);
    
    self.ChatTable.estimatedRowHeight=85;
    
    

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
    
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   
                                   initWithTarget:self
                                   
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method) object:nil];
    [self performSelector:@selector(method) withObject:nil afterDelay:0.1];

}


- (void) back
{
    NSString *strState=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CState"]];
    
    if ([strState isEqualToString:@"2"])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        SWRevealViewController *revel=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController pushViewController:revel animated:YES];
    }
}

#pragma mark - Back Clicked

-(IBAction)BackbuttClickedjf:(id)sender
{
//    
//    NSString *strState=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CState"]];
    
    if ([_checkString isEqualToString:@"1"])
    {
        SWRevealViewController *revel=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController pushViewController:revel animated:YES];
    }
    else
    {
        [self.view endEditing:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//   self.searchController.active=false;
}


-(void)method
{
    
    NSString *struseridnum=[NSString stringWithFormat:@"%@",[userlist valueForKey:@"id"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:@"get_conversation" forKey:@"method"];
    [parameters setValue:struseridnum forKey:@"user_id"];
    [parameters setValue:_strConversionId forKey:@"conversation_id"];
    [parameters setValue:tzName forKey:@"time_zone"];
    
    
    
    for (NSString *param in parameters)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    
    
    NSString *strurl=[NSString stringWithFormat:@"https://www.food4all.org/demo/webservices/Api.php"];
    
    
    // set URL
    [request setURL:[NSURL URLWithString:strurl]];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                
            } else
            {
                if(data != nil) {
                    [self responseOption4:data];
                }
            }
        });
    }] resume];

    
    

//        NSString *struseridnum=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]];
//        NSString *strtoken=[[NSUserDefaults standardUserDefaults]objectForKey:@"Token"];
//        NSString *strCityId=[[NSUserDefaults standardUserDefaults]objectForKey:@"CityId"];
//        NSString *strurl=[NSString stringWithFormat:@"%@%@/%@/%@/%@?user_id=%@&conversation_id=%@",BaseUrl,strtoken,getConversion,english,strCityId,struseridnum,_strConversionId];
//    [requested OptionRequest4:nil withUrl:strurl];
    
}


- (IBAction)ButtonClicked:(id)sender
{
    if (_TextMessage.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter any Message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
       [self.view endEditing:YES];
       
    _sendButt.userInteractionEnabled = NO;
       
     NSString *struseridnum=[NSString stringWithFormat:@"%@",[userlist valueForKey:@"id"]];
    _TextMessage.text=[_TextMessage.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    _TextMessage.text=[_TextMessage.text stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        //Set Params
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        
        //Create boundary, it can be anything
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:@"createchat" forKey:@"method"];
        [parameters setValue:struseridnum forKey:@"sender_id"];
        [parameters setValue:_strConversionId forKey:@"conversation_id"];
        [parameters setValue:_TextMessage.text forKey:@"message"];
        
        
        for (NSString *param in parameters)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        
        
        NSString *strurl=[NSString stringWithFormat:@"https://www.food4all.org/demo/webservices/Api.php"];
        
        
        // set URL
        [request setURL:[NSURL URLWithString:strurl]];
        
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    
                } else
                {
                    if(data != nil) {
                        [self responsewithToken2:data];
                    }
                }
            });
        }] resume];

    }
}



-(void)responsewithToken2:(NSData*)responseData
{
    NSError *err;
    
    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@",responseJSON);
    
    
    NSString *strsttus=[NSString stringWithFormat:@"%@",[responseJSON valueForKey:@"responseCode"]];
    
     [self.view endEditing:YES];
    _sendButt.userInteractionEnabled = YES;
    
    if ([strsttus isEqualToString:@"200"])
    {
        _TextMessage.text=@"";
        
        NSString *struseridnum=[NSString stringWithFormat:@"%@",[userlist valueForKey:@"id"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        //Set Params
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        
        //Create boundary, it can be anything
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:@"get_conversation" forKey:@"method"];
        [parameters setValue:struseridnum forKey:@"user_id"];
        [parameters setValue:_strConversionId forKey:@"conversation_id"];
        [parameters setValue:tzName forKey:@"time_zone"];
       
        
        
        for (NSString *param in parameters)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        
        
        NSString *strurl=[NSString stringWithFormat:@"https://www.food4all.org/demo/webservices/Api.php"];
        
        
        // set URL
        [request setURL:[NSURL URLWithString:strurl]];
        
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    
                } else
                {
                    if(data != nil) {
                        [self responseOption4:data];
                    }
                }
            });
        }] resume];
        
    }
    else
    {
       // [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


-(void)responseOption4:(NSData*)responseData
{
    NSError *err;
    
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@",responseDict);

    
    NSString *status = [responseDict valueForKey:@"responseCode"];
    
    if (![[NSString stringWithFormat:@"%@",status] isEqualToString:[NSString stringWithFormat:@"200"]])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method2) object:nil];
        [self performSelector:@selector(method2) withObject:nil afterDelay:0.1];
    }
    else if([[NSString stringWithFormat:@"%@",status] isEqualToString:[NSString stringWithFormat:@"200"]])
    {
        NSString *strmessage=[responseDict valueForKey:@"responseMessage"];
        
        if ([strmessage isEqualToString:@"No DATA_FOUND."])
        {
            
        }
        else
        {
            
            x=1;
            
            count=1;
            scrool=1;
            lastCount=1;
            
        _strpage= [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"nextPage"]];
        arrids=[responseDict valueForKey:@"List"];
        
        [_ChatTable reloadData];
        
//        NSIndexPath *lastIndexPath = [self lastIndexPath];
//        
//        [_ChatTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        if (arrids.count)
        {
          //  NSIndexPath *lastIndexPath = [self lastIndexPath];
            
           // [_ChatTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
       
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method2) object:nil];
        [self performSelector:@selector(method2) withObject:nil afterDelay:0.1];
        }
    }
}


-(void)goToBottom
{
    if (arrids.count)
    {
       // NSIndexPath *lastIndexPath = [self lastIndexPath];
        
       // [_ChatTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [_ChatTable numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [_ChatTable numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label1=[[UILabel alloc] init];
    label1.numberOfLines=0;
    NSArray *arr=[arrids objectAtIndex:indexPath.row];
    label1.text=[arr valueForKey:@"message"];
    CGSize labelSize = [label1.text sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight = labelSize.height;
    CGSize descriptionSize = [label1 sizeThatFits:CGSizeMake(250,labelHeight)];
    CGFloat height=descriptionSize.height+43;
   
    
    return height;
    
   //  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrids.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str=[NSString stringWithFormat:@"%@",[[arrids valueForKey:@"type"]objectAtIndex:indexPath.row]];
    
    if ([str isEqualToString:@"sender"])
    {
        static NSString *CellClassName = @"Customcell4";
        cell = (Customcell4 *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
        
        if (cell == nil)
        {
            cell = [[Customcell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Customcell4"
                                                         owner:self options:nil];
            cell = [nib objectAtIndex:0];
            self.ChatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        UILabel *label1=[[UILabel alloc] init];
        UILabel *label2=[[UILabel alloc]init];
        UIImageView *_bubbleImage=[[UIImageView alloc] init];
        
      
        
        label1.textColor=[UIColor blackColor];
        label1.numberOfLines=0;
        label1.textAlignment=NSTextAlignmentRight;
        [label1 setAdjustsFontSizeToFitWidth:YES];
        label1.transform = CGAffineTransformMakeRotation(M_PI);
        
        label2.textAlignment=NSTextAlignmentRight;
        label2.textColor=[UIColor lightGrayColor];
        label2.font=[UIFont systemFontOfSize:12];
        label2.transform = CGAffineTransformMakeRotation(M_PI);
        
        CGSize labelSize = [label1.text sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        
        NSArray *arr=[arrids objectAtIndex:indexPath.row];
        
        _bubbleImage.image = [[self imageNamed:@"bubbleMine"]
                              stretchableImageWithLeftCapWidth:17 topCapHeight:14];
        _bubbleImage.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        label1.text=[arr valueForKey:@"message"];
        label2.text=[arr valueForKey:@"dateTime"];
        
        
        
        label2.frame = CGRectMake(10,10, self.view.frame.size.width-20, 20);
        
        CGSize descriptionSize = [label1 sizeThatFits:CGSizeMake(250,labelHeight)];
        label1.frame = CGRectMake(25,35, descriptionSize.width, descriptionSize.height);
        
       
        _bubbleImage.frame = CGRectMake(10,30, descriptionSize.width+25, descriptionSize.height+10);
       
       
        
        [cell addSubview:_bubbleImage];
        [cell addSubview:label1];
        [cell addSubview:label2];
        
        
      
        
        
    }
    
    else if ([str isEqualToString:@"reciver"])
    {
        static NSString *CellClassName = @"Customcell4";
        
        cell = (Customcell4 *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
        
        if (cell == nil)
        {
            cell = [[Customcell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Customcell4"
                                                         owner:self options:nil];
            cell = [nib objectAtIndex:0];
            self.ChatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *label1=[[UILabel alloc] init];
        UILabel *label2=[[UILabel alloc]init];
        UIImageView *_bubbleImage=[[UIImageView alloc] init];
        
    
        label1.textColor=[UIColor blackColor];
        label1.numberOfLines=0;
        label1.textAlignment=NSTextAlignmentLeft;
        [label1 setAdjustsFontSizeToFitWidth:YES];
        label1.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        label2.textAlignment=NSTextAlignmentLeft;
        label2.textColor=[UIColor lightGrayColor];
        label2.font=[UIFont systemFontOfSize:12];
        label2.transform = CGAffineTransformMakeRotation(M_PI);
        
        CGSize labelSize = [label1.text sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        
        NSArray *arr=[arrids objectAtIndex:indexPath.row];
        
        _bubbleImage.image = [[self imageNamed:@"bubbleSomeone"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        _bubbleImage.transform = CGAffineTransformMakeRotation(M_PI);
        
        label1.text=[arr valueForKey:@"message"];
        label2.text=[arr valueForKey:@"dateTime"];
        
        
        
        label2.frame = CGRectMake(12,10, self.view.frame.size.width-20, 20);
        
        CGSize descriptionSize = [label1 sizeThatFits:CGSizeMake(250,labelHeight)];
        label1.frame =  CGRectMake(self.view.frame.size.width-15-descriptionSize.width,35, descriptionSize.width, descriptionSize.height);
        
        _bubbleImage.frame = CGRectMake(self.view.frame.size.width-25-descriptionSize.width,30, descriptionSize.width+25, descriptionSize.height+10);
        
        
        
        [cell addSubview:_bubbleImage];
        [cell addSubview:label1];
        [cell addSubview:label2];
        
        
        
        
        
       

    }
    return cell;
}

-(UIImage *)imageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName
                      inBundle:[NSBundle bundleForClass:[self class]]
 compatibleWithTraitCollection:nil];
}


- (void)dismissKeyboard
{
    [_TextMessage resignFirstResponder];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
        {
            
            if ([_strpage isEqualToString:@"0"])
            {
                loadLbl.text=@"No More List";
                [actInd stopAnimating];
            }
            else
            {
                NSString *struseridnum=[NSString stringWithFormat:@"%@",[userlist valueForKey:@"id"]];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                
                //Set Params
                [request setHTTPShouldHandleCookies:NO];
                [request setTimeoutInterval:60];
                [request setHTTPMethod:@"POST"];
                
                //Create boundary, it can be anything
                NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
                
                // set Content-Type in HTTP header
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                // post body
                NSMutableData *body = [NSMutableData data];
                
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                
                [parameters setValue:@"get_conversation" forKey:@"method"];
                [parameters setValue:struseridnum forKey:@"user_id"];
                [parameters setValue:_strConversionId forKey:@"conversation_id"];
                [parameters setValue:tzName forKey:@"time_zone"];
                [parameters setValue:_strpage forKey:@"page"];
                
                
                
                for (NSString *param in parameters)
                {
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                
                //Close off the request with the boundary
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // setting the body of the post to the request
                [request setHTTPBody:body];
                
                
                
                NSString *strurl=[NSString stringWithFormat:@"https://www.food4all.org/demo/webservices/Api.php"];
                
                
                // set URL
                [request setURL:[NSURL URLWithString:strurl]];
                
                
                
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    dispatch_async (dispatch_get_main_queue(), ^{
                        
                        if (error)
                        {
                            
                        } else
                        {
                            if(data != nil) {
                                [self responseLogin:data];
                            }
                        }
                    });
                }] resume];

            }
        }
}



-(void)responseLogin:(NSData *)responseData
{
    NSError *err;
    
    NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];

   // NSMutableDictionary *responseDictionary=[[NSMutableDictionary alloc]init];
  //  responseDictionary=responseDict;
    NSLog(@"Dict Response: %@",responseDictionary);
    
    if (count==1)
    {
        count=2;
        if ([_strpage isEqualToString:@"2"])
        {
            NSArray *arr=[responseDictionary valueForKey:@"List"];
            
            arrids=[[arrids arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [_ChatTable reloadData];
        }
        else
        {
            
        }
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
    }
    else
    {
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
        
        if ([_strpage isEqualToString:@"0"])
        {
            if (lastCount==1)
            {
                NSArray *arr=[responseDictionary valueForKey:@"List"];
                
                arrids=[[arrids arrayByAddingObjectsFromArray:arr] mutableCopy];
                
                [_ChatTable reloadData];
                lastCount=2;
            }
        }
        else
        {
            NSArray *arr=[responseDictionary valueForKey:@"List"];
            
            arrids=[[arrids arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [_ChatTable reloadData];
        }
    }
}


#pragma mark  ActivityIndicator At Bottom:

-(void)initFooterView
{
    footerview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
    actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 5.0, 20.0, 20.0);
    actInd.hidden=YES;
    [actInd performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:30.0];
    [footerview2 addSubview:actInd];
    loadLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 25, 200, 20)];
    loadLbl.textAlignment=NSTextAlignmentCenter;
    loadLbl.textColor=[UIColor lightGrayColor];
    // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
    [loadLbl setFont:[UIFont systemFontOfSize:12]];
    [footerview2 addSubview:loadLbl];
    actInd = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrool==1)
    {
        BOOL endOfTable = (scrollView.contentOffset.y >= 0);
        if ( endOfTable && !scrollView.dragging && !scrollView.decelerating)
        {
            if ([_strpage isEqualToString:@"0"])
            {
                _ChatTable.tableFooterView = footerview2;
                [(UIActivityIndicatorView *)[footerview2 viewWithTag:10] stopAnimating];
                loadLbl.text=@"No More List";
                [actInd stopAnimating];
            }
            else
            {
                _ChatTable.tableFooterView = footerview2;
                [(UIActivityIndicatorView *)[footerview2 viewWithTag:10] startAnimating];
            }
        }
        
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrool==1)
    {
        footerview2.hidden=YES;
        loadLbl.hidden=YES;
    }
}





-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -250., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +250., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)method2
{
    
    NSString *struseridnum=[NSString stringWithFormat:@"%@",[userlist valueForKey:@"id"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:@"get_conversation_count" forKey:@"method"];
    [parameters setValue:struseridnum forKey:@"user_id"];
    [parameters setValue:_strConversionId forKey:@"conversation_id"];
   
    
    
    
    for (NSString *param in parameters)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    
    
    NSString *strurl=[NSString stringWithFormat:@"https://www.food4all.org/demo/webservices/Api.php"];
    
    
    // set URL
    [request setURL:[NSURL URLWithString:strurl]];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                
            } else
            {
                if(data != nil) {
                    [self responseOption5:data];
                }
            }
        });
    }] resume];
    


}


-(void)responseOption5:(NSData*)responseData
{
    
    NSError *err;
    
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@",responseDict);

    NSString *strsttus=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"responseCode"]];
    
    if ([strsttus isEqualToString:@"200"])
    {
        NSString *strMessageCount=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"new_message_count"]];
        
        if ([strMessageCount isEqualToString:@"0"])
        {
            
        }
        else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method) object:nil];
            [self performSelector:@selector(method) withObject:nil afterDelay:0.1];
        }
        
        NSString *strvalue=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"appear"]];
        
        if ([strvalue isEqualToString:@"1"])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method2) object:nil];
            [self performSelector:@selector(method2) withObject:nil afterDelay:2.0];
        }
    }
    else
    {
        NSString *strvalue=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"appear"]];
        
        if ([strvalue isEqualToString:@"1"])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method2) object:nil];
            [self performSelector:@selector(method2) withObject:nil afterDelay:2.0];
        }
    }
}







-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"appear"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(method2) object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
