//
//  StepTwoViewController.m
//  FoodForAll
//
//  Created by think360 on 01/08/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "StepTwoViewController.h"
#import "CategeoryViewCell2.h"
#import "Food4All.pch"

@interface StepTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
     NSMutableArray *arrcategeorys2;
     CategeoryViewCell2 *cell2;
    NSString *saftyString;
    BOOL checked;
}
@property(nonatomic,strong)NSMutableArray *arryDatalistidslist;
@end

@implementation StepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section2"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    arrcategeorys2=[[NSMutableArray alloc]init];
    _arryDatalistidslist=[[NSMutableArray alloc]init];
    
    _CategeoryTable.scrollEnabled = NO;
    _CategeoryTable.rowHeight = UITableViewAutomaticDimension;
    _CategeoryTable.estimatedRowHeight = 200.0;
    
    [self customtoggleview];
    
    checked = NO;
    
    saftyString = @"0";
    UIImage *btnImage2 = [UIImage imageNamed:@"UncheckBox"];
    [_safetybutt setImage:btnImage2 forState:UIControlStateNormal];

  
    
}

-(void)customtoggleview
{
    
    NSString *struseridnum=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cat1"]];
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
    
    [parameters setValue:@"meal_category_tips" forKey:@"method"];
    [parameters setValue:struseridnum forKey:@"category_id"];
   
    
    
    
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
    
    
    
    NSString *strurl=[NSString stringWithFormat:@"%@",BaseUrl];
    
    
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

-(void)responseOption4:(NSData*)responseData
{
    NSError *err;
    
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSLog(@"%@",responseDict);
    
    NSString *strsttus=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"responseCode"]];
    
    if ([strsttus isEqualToString:@"200"])
    {
        arrcategeorys2 = [responseDict valueForKey:@"TipList"];
       
        
        if (!expandedSections)
        {
            expandedSections = [[NSMutableIndexSet alloc] init];
        }
        
       
        
        _heightConstant.constant = (arrcategeorys2.count) * 60;
        
         [_CategeoryTable reloadData];
    }
    else
    {
        
    }
}





- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (tableView==_CategeoryTable)
    {
        for (int i=0; i<arrcategeorys2.count; i++)
        {
            if (section==i)
            {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_CategeoryTable)
    {
        return arrcategeorys2.count;
    }
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_CategeoryTable)
    {
        if ([self tableView:tableView canCollapseSection:section])
        {
            if ([expandedSections containsIndex:section])
            {
                return 2;// return rows when expanded
            }
            
            return 1; // only top row showing
        }
        
        // Return the number of rows in the section.
        return 1;
    }
    else{
        return 1;
    }
    return 1;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return UITableViewAutomaticDimension;
    
    if (tableView==_CategeoryTable)
    {
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                return 60;
            }
            else
            {
                
                UILabel *labeltwo = (UILabel *) [cell2 viewWithTag:4];
                
                NSString * htmlString = [[arrcategeorys2 objectAtIndex:indexPath.section] valueForKey:@"description"];
                NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                labeltwo.attributedText = attrStr;
                labeltwo.font = [UIFont fontWithName:@"Calibri" size:13];
                
                CGRect textRect3 = [labeltwo.text boundingRectWithSize:labeltwo.frame.size
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                                 context:nil];
                CGSize size3 = textRect3.size;
                CGSize descriptionSize3 = [labeltwo sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size3.height)];
                
                _heightConstant.constant = ((arrcategeorys2.count) * 60)+ (descriptionSize3.height+40);
                
                return descriptionSize3.height+40;
            }
        }
        else
        {
            return 60;
        }
    }
    else
    {
        
    }
    return UITableViewAutomaticDimension;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellClassName = @"CategeoryViewCell2";
    
    cell2 = (CategeoryViewCell2 *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
    
    if (cell2 == nil)
    {
        cell2 = [[CategeoryViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategeoryViewCell2"
                                                     owner:self options:nil];
        cell2 = [nib objectAtIndex:0];
        cell2.backgroundColor=[UIColor whiteColor];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            UILabel *Headlabel = (UILabel *) [cell2 viewWithTag:2];
            Headlabel.text=[[arrcategeorys2 valueForKey:@"heading"]objectAtIndex:indexPath.section];
            
            UIImageView *image=(UIImageView*)[cell2 viewWithTag:1];
            image.hidden=NO;
            
             UILabel *Headlabel1 = (UILabel *) [cell2 viewWithTag:5];
             UILabel *Headlabel2 = (UILabel *) [cell2 viewWithTag:6];
            
            
        
            if([self.arryDatalistidslist containsObject:indexPath])
            {
                image.image=[UIImage imageNamed:@"minus-symbol.png"];
                Headlabel.textColor =  [UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
                Headlabel1.backgroundColor= [UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
                Headlabel2.backgroundColor=[UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
                Headlabel2.hidden=NO;
            }
            else
            {
                Headlabel2.hidden=YES;
                image.image=[UIImage imageNamed:@"plus-sign.png"];
                Headlabel.textColor =  [UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
                Headlabel1.backgroundColor= [UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
                Headlabel2.backgroundColor=[UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
                
            }
        }
        else
        {
          //  NSArray *arlist=[[arrcategeorys objectAtIndex:indexPath.section] valueForKey:@"description"];
            UILabel *labeltwo = [[UILabel alloc] init];
            
            NSString * htmlString = [[arrcategeorys2 objectAtIndex:indexPath.section] valueForKey:@"description"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            labeltwo.attributedText = attrStr;
            labeltwo.font = [UIFont fontWithName:@"Calibri" size:16];
            
            UIImageView *image=(UIImageView*)[cell2 viewWithTag:1];
            image.hidden=YES;
            
            UILabel *Headlabel1 = (UILabel *) [cell2 viewWithTag:5];
            UILabel *Headlabel2 = (UILabel *) [cell2 viewWithTag:6];
            
            Headlabel1.hidden=YES;
            Headlabel2.hidden=YES;
            
            CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
            _heightConstant.constant = ((arrcategeorys2.count) * 60)+ (frame.size.height+40);
            //[self.view layoutIfNeeded];
        }
    }
    else
    {
        UILabel *Headlabel = (UILabel *) [cell2 viewWithTag:2];
        Headlabel.text=[[arrcategeorys2 valueForKey:@"heading"]objectAtIndex:indexPath.section];
        
        UIImageView *image=(UIImageView*)[cell2 viewWithTag:1];
        image.hidden=NO;
        
        UILabel *Headlabel1 = (UILabel *) [cell2 viewWithTag:5];
        UILabel *Headlabel2 = (UILabel *) [cell2 viewWithTag:6];
        
        
        if([self.arryDatalistidslist containsObject:indexPath])
        {
            image.image=[UIImage imageNamed:@"minus-symbol.png"];
            Headlabel.textColor =  [UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
            Headlabel1.backgroundColor= [UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
            Headlabel2.backgroundColor=[UIColor colorWithRed:141.0/255.0f green:197.0/255.0f blue:62.0/255.0f alpha:1.0];
            Headlabel2.hidden=NO;
        }
        else
        {
            image.image=[UIImage imageNamed:@"plus-sign.png"];
            Headlabel.textColor =  [UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
            Headlabel1.backgroundColor= [UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
            Headlabel2.backgroundColor=[UIColor colorWithRed:143.0/255.0f green:144.0/255.0f blue:155.0/255.0f alpha:1.0];
            Headlabel2.hidden=YES;
        }
    }
    
    tableView.backgroundColor=[UIColor whiteColor];
    cell2.backgroundColor=[UIColor clearColor];
    
    
    return cell2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_CategeoryTable)
    {
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSObject * object = [prefs objectForKey:@"section2"];
                if(object != nil)
                {
                    
                    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section2"]];
                    NSInteger section2 = indexPath.section;
                    NSString *strval=[NSString stringWithFormat:@"%ld",(long)section2];
                    if ([str isEqualToString:strval])
                    {
                        NSInteger section = indexPath.section;
                        BOOL currentlyExpanded = [expandedSections containsIndex:section];
                        NSInteger rows;
                        
                        NSMutableArray *tmpArray = [NSMutableArray array];
                        
                        if (currentlyExpanded)
                        {
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [expandedSections removeIndex:section];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections addIndex:section];
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [self.arryDatalistidslist addObject:indexPath];
                        }
                        
                        for (int i=1; i<rows; i++)
                        {
                            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                           inSection:section];
                            [tmpArray addObject:tmpIndexPath];
                        }
                        
                        //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        
                        if (currentlyExpanded)
                        {
                            [tableView deleteRowsAtIndexPaths:tmpArray
                                             withRowAnimation:UITableViewRowAnimationTop];
                            
                        }
                        else
                        {
                            [tableView insertRowsAtIndexPaths:tmpArray
                                             withRowAnimation:UITableViewRowAnimationTop];
                            
                        }
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section2"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                    else
                    {
                        
                        
                        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section2"]];
                        NSInteger section2 =[str integerValue];
                        BOOL currentlyExpanded2 = [expandedSections containsIndex:section2];
                        NSInteger rows2;
                        
                        NSMutableArray *tmpArray2 = [NSMutableArray array];
                        
                        if (currentlyExpanded2)
                        {
                            rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                            [expandedSections removeIndex:section2];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections addIndex:section2];
                            rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                            [self.arryDatalistidslist addObject:indexPath];
                        }
                        
                        for (int i=1; i<rows2; i++)
                        {
                            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                           inSection:section2];
                            [tmpArray2 addObject:tmpIndexPath];
                        }
                        
                        //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        
                        if (currentlyExpanded2)
                        {
                            [tableView deleteRowsAtIndexPaths:tmpArray2
                                             withRowAnimation:UITableViewRowAnimationTop];
                        }
                        else
                        {
                            [tableView insertRowsAtIndexPaths:tmpArray2
                                             withRowAnimation:UITableViewRowAnimationTop];
                        }
                        
                        [tableView beginUpdates];
                        
                        
                        NSInteger section = indexPath.section;
                        BOOL currentlyExpanded = [expandedSections containsIndex:section];
                        NSInteger rows;
                        
                        NSMutableArray *tmpArray = [NSMutableArray array];
                        
                        if (currentlyExpanded)
                        {
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [expandedSections removeIndex:section];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections addIndex:section];
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [self.arryDatalistidslist addObject:indexPath];
                            
                            NSInteger section = indexPath.section;
                            
                            [[NSUserDefaults standardUserDefaults]setInteger:section forKey:@"section2"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                        
                        for (int i=1; i<rows; i++)
                        {
                            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                           inSection:section];
                            [tmpArray addObject:tmpIndexPath];
                        }
                        
                        //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        
                        if (currentlyExpanded)
                        {
                            [tableView deleteRowsAtIndexPaths:tmpArray
                                             withRowAnimation:UITableViewRowAnimationTop];
                            
                            
                            
                        }
                        else
                        {
                            [tableView insertRowsAtIndexPaths:tmpArray
                                             withRowAnimation:UITableViewRowAnimationTop];
                            
                        }
                        
                        [tableView endUpdates];
                        
                    }
                    
                }
                else
                {
                    NSInteger section = indexPath.section;
                    BOOL currentlyExpanded = [expandedSections containsIndex:section];
                    NSInteger rows;
                    
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    
                    if (currentlyExpanded)
                    {
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                        [expandedSections removeIndex:section];
                        [self.arryDatalistidslist removeObject:indexPath];
                    }
                    else
                    {
                        [expandedSections addIndex:section];
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                        [self.arryDatalistidslist addObject:indexPath];
                        
                        NSInteger section = indexPath.section;
                        
                        [[NSUserDefaults standardUserDefaults]setInteger:section forKey:@"section2"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    
                    for (int i=1; i<rows; i++)
                    {
                        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                       inSection:section];
                        [tmpArray addObject:tmpIndexPath];
                    }
                    
                    //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (currentlyExpanded)
                    {
                        [tableView deleteRowsAtIndexPaths:tmpArray
                                         withRowAnimation:UITableViewRowAnimationTop];
                        
                    }
                    else
                    {
                        [tableView insertRowsAtIndexPaths:tmpArray
                                         withRowAnimation:UITableViewRowAnimationTop];
                        
                    }
                }
                
               // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(long)indexPath.row inSection:(long)indexPath.section];
                
               // float height = [self tableView:tableView heightForRowAtIndexPath:indexPath.section];
                
                
            }
            else {
                NSLog(@"Selected Section is %ld and subrow is %ld ",(long)indexPath.section ,(long)indexPath.row);
            
            }
            
            [self.arryDatalistidslist removeAllObjects];
            [self.arryDatalistidslist addObject:indexPath];
            [_CategeoryTable reloadData];
            
            
            UILabel *labeltwo = (UILabel *) [cell2 viewWithTag:4];
            
            NSString * htmlString = [[arrcategeorys2 objectAtIndex:indexPath.section] valueForKey:@"description"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            labeltwo.attributedText = attrStr;
            labeltwo.font = [UIFont fontWithName:@"Calibri" size:13];
            
            CGRect textRect3 = [labeltwo.text boundingRectWithSize:labeltwo.frame.size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                           context:nil];
            CGSize size3 = textRect3.size;
            CGSize descriptionSize3 = [labeltwo sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size3.height)];
            
            _heightConstant.constant = ((arrcategeorys2.count) * 60)+ (descriptionSize3.height+40);
            
            CGPoint bottomOffset = CGPointMake(0, _categoryScrollView.frame.origin.x);
            [_categoryScrollView setContentOffset:bottomOffset animated:YES];

        }
        else
        {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSObject * object = [prefs objectForKey:@"section2"];
            if(object != nil)
            {
                
                
                NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section2"]];
                NSInteger section2 = indexPath.section;
                NSString *strval=[NSString stringWithFormat:@"%ld",(long)section2];
                if ([str isEqualToString:strval])
                {
                    NSInteger section = indexPath.section;
                    BOOL currentlyExpanded = [expandedSections containsIndex:section];
                    NSInteger rows;
                    
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    
                    if (currentlyExpanded)
                    {
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                        [expandedSections removeIndex:section];
                        [self.arryDatalistidslist removeObject:indexPath];
                    }
                    else
                    {
                        
                    }
                    
                    
                    //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    
                    if (currentlyExpanded)
                    {
                        [tableView deleteRowsAtIndexPaths:tmpArray
                                         withRowAnimation:UITableViewRowAnimationTop];
                        
                    }
                    else
                    {
                        
                    }
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section2"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else
                {
                    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section2"]];
                    NSInteger section2 =[str integerValue];
                    BOOL currentlyExpanded2 = [expandedSections containsIndex:section2];
                    NSInteger rows2;
                    
                    NSMutableArray *tmpArray2 = [NSMutableArray array];
                    
                    if (currentlyExpanded2)
                    {
                        rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                        [expandedSections removeIndex:section2];
                        [self.arryDatalistidslist removeObject:indexPath];
                    }
                    else
                    {
                        
                    }
                    
                    for (int i=1; i<rows2; i++)
                    {
                        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                                       inSection:section2];
                        [tmpArray2 addObject:tmpIndexPath];
                    }
                    
                    if (currentlyExpanded2)
                    {
                        [tableView deleteRowsAtIndexPaths:tmpArray2
                                         withRowAnimation:UITableViewRowAnimationTop];
                        
                    }
                    else
                    {
                        
                    }
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section2"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
            }
            else
            {
                
            }
            
            _heightConstant.constant = (arrcategeorys2.count) * 60;
            
          
            [self.arryDatalistidslist removeAllObjects];
            [self.arryDatalistidslist addObject:indexPath];
            
            [_CategeoryTable reloadData];
        }
        
    }
    else
    {
        
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}










- (IBAction)radiobuttClicked:(id)sender
{
    if (checked ==NO)
    {
        [_safetybutt setImage:[UIImage imageNamed:@"CheckRightbox"] forState:UIControlStateNormal];
        checked =YES;
    }
    else
    {
        [_safetybutt setImage:[UIImage imageNamed:@"UncheckBox"] forState:UIControlStateNormal];
        checked =NO;
    }
}


- (IBAction)previousClicked:(id)sender
{
      [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextClicked:(id)sender
{
    if (checked !=YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please accept I assure food safety and quality" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepThreeShareFoodVC"];
        [self.navigationController pushViewController:tbc animated:YES];
    }
}

- (IBAction)backbuttClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
