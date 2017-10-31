//
//  SetpOneViewController.m
//  FoodForAll
//
//  Created by think360 on 31/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

#import "SetpOneViewController.h"
#import "CategeoryViewCell.h"
#import "CategeoryViewCell2.h"



@interface SetpOneViewController ()
{
    NSMutableArray *arrcategeorys;
  //  UITableView *categeorytableView;
    CategeoryViewCell *cell;
    NSString *strCategeotyId;
    NSString *subCategeoryId;
    NSString *CheckStr;
    
    NSMutableArray *arrcategeorys2;
    CategeoryViewCell2 *cell2;
    NSString *saftyString;
    BOOL checked;
}
@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSArray *headers;
@property(nonatomic,strong)NSMutableArray *arryDatalistids;
@property(nonatomic,strong)NSMutableArray *arryDatalistids2;
@property(nonatomic,strong)NSMutableArray *arryDatalistidslist;
@property (nonatomic, strong) NSArray <NSDictionary *> *productsList1;
@end

@implementation SetpOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CheckStr=@"1";
    
    arrcategeorys=[[NSMutableArray alloc]init];
    
    _productsList1=_arrChildCategory;
    
    arrcategeorys=[_productsList1 valueForKey:@"name"];
    
     self.arryDatalistids=[[NSMutableArray alloc]init];
     self.arryDatalistids2=[[NSMutableArray alloc]init];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cat1"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cat2"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

//    categeorytableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 153, self.view.frame.size.width, 319)];
//    categeorytableView.delegate=self;
//    categeorytableView.dataSource=self;
//    categeorytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    categeorytableView.rowHeight=UITableViewAutomaticDimension;
//    categeorytableView.estimatedRowHeight=85;
//    categeorytableView.showsHorizontalScrollIndicator = NO;
//    categeorytableView.showsVerticalScrollIndicator = NO;
//    categeorytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//   
//    [_MainScrool addSubview:categeorytableView];
    
   
    if (!expandedSections)
    {
      expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    if (!expandedSections2)
    {
        expandedSections2 = [[NSMutableIndexSet alloc] init];
    }

    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    _heightConstaint.constant = (arrcategeorys.count) * 50;
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section2"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    arrcategeorys2=[[NSMutableArray alloc]init];
    _arryDatalistidslist=[[NSMutableArray alloc]init];
    
    _CategeoryTable.scrollEnabled = NO;
    _CategeoryTable.rowHeight = UITableViewAutomaticDimension;
    _CategeoryTable.estimatedRowHeight = 200.0;
    _heightConstant.constant=-100;
    _foodSafetyTipslab.hidden=true;
    _ensurelab.hidden=true;
    _safetybutt.hidden=true;
    _nextbutt.hidden=true;
    
    checked = NO;
    
    saftyString = @"0";
    UIImage *btnImage2 = [UIImage imageNamed:@"UncheckBox"];
    [_safetybutt setImage:btnImage2 forState:UIControlStateNormal];
    
}


- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (tableView==_categeorytableView)
    {
        for (int i=0; i<arrcategeorys.count; i++)
        {
            if (section==i)
            {
                NSString *strcount=[NSString stringWithFormat:@"%@",[[_productsList1 objectAtIndex:i] valueForKey:@"hasChild"]];
                int i=(int)[strcount integerValue];
                if (i==0)
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
        }
        return NO;
    }
    else if (tableView==_CategeoryTable)
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
    if (tableView==_categeorytableView)
    {
        return arrcategeorys.count;
    }
    else if (tableView==_CategeoryTable)
    {
        return arrcategeorys2.count;
    }
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_categeorytableView)
    {
        if ([self tableView:tableView canCollapseSection:section])
        {
            if ([expandedSections containsIndex:section])
            {
                NSString *strcount=[NSString stringWithFormat:@"%lu",[[[_productsList1 objectAtIndex:section]valueForKey:@"child"] count]];
                int i=(int)[strcount integerValue];
                i=i+1;
                NSLog(@"%d",i);
                return i;// return rows when expanded
            }
            
            return 1; // only top row showing
        }
        
        // Return the number of rows in the section.
        return 1;
    }
    else if (tableView==_CategeoryTable)
    {
        if ([self tableView:tableView canCollapseSection:section])
        {
            if ([expandedSections2 containsIndex:section])
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
    
    if (tableView==_categeorytableView)
    {
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                return 50;
            }
            else
            {
                return 50;
            }
        }
        else
        {
            return 50;
        }
    }
    else if (tableView==_CategeoryTable)
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
    if (tableView==_categeorytableView)
    {
        static NSString *CellClassName = @"CategeoryViewCell";
        
        cell = (CategeoryViewCell *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
        
        if (cell == nil)
        {
            cell = [[CategeoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategeoryViewCell"
                                                         owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                UILabel *Headlabel = (UILabel *) [cell viewWithTag:2];
                Headlabel.text=[arrcategeorys objectAtIndex:indexPath.section];
                
                UIImageView *image=(UIImageView*)[cell viewWithTag:1];
                image.hidden=NO;
                UIImageView *image2=(UIImageView*)[cell viewWithTag:3];
                image2.hidden=YES;
                
                if([self.arryDatalistids containsObject:indexPath])
                {
                    image.image=[UIImage imageNamed:@"Radio-clicked copy"];
                }
                else
                {
                    image.image=[UIImage imageNamed:@"radio_unclicked"];
                }
            }
            else
            {
                NSArray *arlist=[[[_productsList1 objectAtIndex:indexPath.section] valueForKey:@"child"] valueForKey:@"name"];
                
                UILabel *labeltwo = (UILabel *) [cell viewWithTag:4];
                labeltwo.text=[arlist objectAtIndex:indexPath.row-1];
                
                UIImageView *image=(UIImageView*)[cell viewWithTag:1];
                image.hidden=YES;
                UIImageView *image2=(UIImageView*)[cell viewWithTag:3];
                image2.hidden=NO;
                
                if([self.arryDatalistids2 containsObject:indexPath])
                {
                    image2.image=[UIImage imageNamed:@"Radio-clicked copy"];
                }
                else
                {
                    image2.image=[UIImage imageNamed:@"radio_unclicked"];
                }
                
            }
        }
        else
        {
            UILabel *Headlabel = (UILabel *) [cell viewWithTag:2];
            Headlabel.text=[arrcategeorys objectAtIndex:indexPath.section];
            
            UIImageView *image=(UIImageView*)[cell viewWithTag:1];
            image.hidden=NO;
            UIImageView *image2=(UIImageView*)[cell viewWithTag:3];
            image2.hidden=YES;
            
            if([self.arryDatalistids containsObject:indexPath])
            {
                image.image=[UIImage imageNamed:@"Radio-clicked copy"];
            }
            else
            {
                image.image=[UIImage imageNamed:@"radio_unclicked"];
            }
        }
        tableView.backgroundColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor clearColor];
        
        
        return cell;

    }
    else if (tableView==_CategeoryTable)
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
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_categeorytableView)
    {
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSObject * object = [prefs objectForKey:@"section"];
                if(object != nil)
                {
                    
                    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section"]];
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
                            [self.arryDatalistids removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections addIndex:section];
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [self.arryDatalistids addObject:indexPath];
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
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section"];
                        [[NSUserDefaults standardUserDefaults]synchronize];

                    }
                    else
                    {
                    
                    
                    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section"]];
                    NSInteger section2 =[str integerValue];
                    BOOL currentlyExpanded2 = [expandedSections containsIndex:section2];
                    NSInteger rows2;
                    
                    NSMutableArray *tmpArray2 = [NSMutableArray array];
                    
                    if (currentlyExpanded2)
                    {
                        rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                        [expandedSections removeIndex:section2];
                        [self.arryDatalistids removeObject:indexPath];
                    }
                    else
                    {
                        [expandedSections addIndex:section2];
                        rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                        [self.arryDatalistids addObject:indexPath];
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
                         [self.arryDatalistids removeObject:indexPath];
                    }
                    else
                    {
                        [expandedSections addIndex:section];
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                         [self.arryDatalistids addObject:indexPath];
                        
                        NSInteger section = indexPath.section;
                        
                        [[NSUserDefaults standardUserDefaults]setInteger:section forKey:@"section"];
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
                        [self.arryDatalistids removeObject:indexPath];
                    }
                    else
                    {
                        [expandedSections addIndex:section];
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                         [self.arryDatalistids addObject:indexPath];
                        
                        NSInteger section = indexPath.section;
                        
                        [[NSUserDefaults standardUserDefaults]setInteger:section forKey:@"section"];
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
                
                [self.arryDatalistids removeAllObjects];
                [self.arryDatalistids2 removeAllObjects];
                [self.arryDatalistids addObject:indexPath];
                [_categeorytableView reloadData];
                
                CheckStr=@"2";
                
                strCategeotyId =[NSString stringWithFormat:@"%@",[[_productsList1 objectAtIndex:indexPath.section] valueForKey:@"id"]];
                subCategeoryId=@"";
                
                NSLog(@"%@",strCategeotyId);
                NSLog(@"%@",subCategeoryId);
        
                
                NSArray *arlist=[[_productsList1 objectAtIndex:indexPath.section] valueForKey:@"child"];
                
                 _heightConstaint.constant = (arrcategeorys.count+arlist.count) * 50;
                
               
                
                }
            else {
                NSLog(@"Selected Section is %ld and subrow is %ld ",(long)indexPath.section ,(long)indexPath.row);
                
                strCategeotyId =[NSString stringWithFormat:@"%@",[[_productsList1 objectAtIndex:indexPath.section] valueForKey:@"id"]];
                subCategeoryId=[NSString stringWithFormat:@"%@",[[[[_productsList1 objectAtIndex:indexPath.section]objectForKey:@"child"]valueForKey:@"id"] objectAtIndex:indexPath.row-1]];
                
                [self.arryDatalistids2 removeAllObjects];
                [self.arryDatalistids2 addObject:indexPath];
                 [_categeorytableView reloadData];
                
                 [self customtoggleview];
                
                NSLog(@"%@",strCategeotyId);
                NSLog(@"%@",subCategeoryId);
            }
        }
        else
        {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSObject * object = [prefs objectForKey:@"section"];
            if(object != nil)
            {
            
            
            NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section"]];
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
                     [self.arryDatalistids removeObject:indexPath];
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
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"section"]];
                NSInteger section2 =[str integerValue];
                BOOL currentlyExpanded2 = [expandedSections containsIndex:section2];
                NSInteger rows2;
                
                NSMutableArray *tmpArray2 = [NSMutableArray array];
                
                if (currentlyExpanded2)
                {
                    rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                    [expandedSections removeIndex:section2];
                    [self.arryDatalistids removeObject:indexPath];
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"section"];
                [[NSUserDefaults standardUserDefaults]synchronize];

            }
        }
        else
        {
           
        }
            
             _heightConstaint.constant = (arrcategeorys.count) * 50;
            
            CheckStr=@"1";
            [self.arryDatalistids2 removeAllObjects];
            [self.arryDatalistids removeAllObjects];
            [self.arryDatalistids addObject:indexPath];
            
            [_categeorytableView reloadData];
            
            strCategeotyId =[NSString stringWithFormat:@"%@",[[_productsList1 objectAtIndex:indexPath.section] valueForKey:@"id"]];
            subCategeoryId=@"";
            
            [self customtoggleview];
            
            NSLog(@"%@",strCategeotyId);
            NSLog(@"%@",subCategeoryId);
    }
        
      
    }
    else if (tableView==_CategeoryTable)
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
                        BOOL currentlyExpanded = [expandedSections2 containsIndex:section];
                        NSInteger rows;
                        
                        NSMutableArray *tmpArray = [NSMutableArray array];
                        
                        if (currentlyExpanded)
                        {
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [expandedSections2 removeIndex:section];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections2 addIndex:section];
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
                        BOOL currentlyExpanded2 = [expandedSections2 containsIndex:section2];
                        NSInteger rows2;
                        
                        NSMutableArray *tmpArray2 = [NSMutableArray array];
                        
                        if (currentlyExpanded2)
                        {
                            rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                            [expandedSections2 removeIndex:section2];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections2 addIndex:section2];
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
                        BOOL currentlyExpanded = [expandedSections2 containsIndex:section];
                        NSInteger rows;
                        
                        NSMutableArray *tmpArray = [NSMutableArray array];
                        
                        if (currentlyExpanded)
                        {
                            rows = [self tableView:tableView numberOfRowsInSection:section];
                            [expandedSections2 removeIndex:section];
                            [self.arryDatalistidslist removeObject:indexPath];
                        }
                        else
                        {
                            [expandedSections2 addIndex:section];
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
                    BOOL currentlyExpanded = [expandedSections2 containsIndex:section];
                    NSInteger rows;
                    
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    
                    if (currentlyExpanded)
                    {
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                        [expandedSections2 removeIndex:section];
                        [self.arryDatalistidslist removeObject:indexPath];
                    }
                    else
                    {
                        [expandedSections2 addIndex:section];
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
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections2 containsIndex:section];
            
            if (currentlyExpanded)
            {
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
            }
            else
            {
                [self.arryDatalistidslist removeAllObjects];
                 [_CategeoryTable reloadData];
                _heightConstant.constant = ((arrcategeorys2.count) * 60);
            }
            
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
                    BOOL currentlyExpanded = [expandedSections2 containsIndex:section];
                    NSInteger rows;
                    
                    NSMutableArray *tmpArray = [NSMutableArray array];
                    
                    if (currentlyExpanded)
                    {
                        rows = [self tableView:tableView numberOfRowsInSection:section];
                        [expandedSections2 removeIndex:section];
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
                    BOOL currentlyExpanded2 = [expandedSections2 containsIndex:section2];
                    NSInteger rows2;
                    
                    NSMutableArray *tmpArray2 = [NSMutableArray array];
                    
                    if (currentlyExpanded2)
                    {
                        rows2 = [self tableView:tableView numberOfRowsInSection:section2];
                        [expandedSections2 removeIndex:section2];
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



-(void)customtoggleview
{
    
   // NSString *struseridnum=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cat1"]];
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
    [parameters setValue:strCategeotyId forKey:@"category_id"];
    
    
    
    
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
    
    
    
    NSString *strurl=[NSString stringWithFormat:@"http://think360.in/Food4All/webservices/Api.php"];
    
    
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
    
    _foodSafetyTipslab.hidden=false;
    _ensurelab.hidden=false;
    _safetybutt.hidden=false;
    _nextbutt.hidden=false;
    
    NSString *strsttus=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"responseCode"]];
    
    if ([strsttus isEqualToString:@"200"])
    {
        arrcategeorys2 = [responseDict valueForKey:@"TipList"];
        
        
        if (!expandedSections2)
        {
            expandedSections2 = [[NSMutableIndexSet alloc] init];
        }
        
        
        
        _heightConstant.constant = (arrcategeorys2.count) * 60;
        
        [_CategeoryTable reloadData];
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


- (IBAction)nextbuttClicked:(id)sender
{
    if ([CheckStr isEqualToString:@"1"])
    {
        if (strCategeotyId == (id)[NSNull null] || strCategeotyId.length == 0 )
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please Select Categeory" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (checked !=YES)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please accept I ensure food safety and quality" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepThreeShareFoodVC"];
            [self.navigationController pushViewController:tbc animated:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:strCategeotyId forKey:@"cat1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    else
    {
        if (strCategeotyId == (id)[NSNull null] || strCategeotyId.length == 0 )
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please Select Categeory" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (subCategeoryId == (id)[NSNull null] || subCategeoryId.length == 0 )
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please Select Sub Categeory" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (checked !=YES)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Food4All" message:@"Please accept I ensure food safety and quality" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepThreeShareFoodVC"];
            [self.navigationController pushViewController:tbc animated:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:strCategeotyId forKey:@"cat1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults]setObject:subCategeoryId forKey:@"cat2"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}


- (IBAction)backbuttonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
