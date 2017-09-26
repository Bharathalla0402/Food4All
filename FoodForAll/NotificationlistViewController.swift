//
//  NotificationlistViewController.swift
//  FoodForAll
//
//  Created by think360 on 04/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class NotificationlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var NotificationBackView: UIView!
    var cell: NotificationCell!
    var NotificationTableView = UITableView()
    
    var strUserID = NSString()
    var myArray = NSDictionary()
     var DeviceToken=String()
    
    var listArrayFoodBank = NSMutableArray()
    
    var strpage = String()
    var footerview2: UIView!
    var loadLbl: UILabel!
    var locationNamelabel: UILabel!
    var actInd: UIActivityIndicatorView!
    var scrool = 1
    var count = 1
    var lastCount = 1

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            strUserID=myArray.value(forKey: "id") as! NSString
        }
        else
        {
            strUserID = ""
        }
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = ""
        }

        
        perform(#selector(NotificationlistViewController.showTableView), with: nil, afterDelay: 0.02)
        
         UserDefaults.standard.set("0", forKey: "NCount")
        
    }
    
    
    
    
     
    
    @objc private  func showTableView()
    {
        NotificationTableView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height-64)
        NotificationTableView.delegate=self
        NotificationTableView.dataSource=self
        NotificationTableView.estimatedRowHeight = 126
        self.NotificationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(NotificationTableView)
    }
    
    
    
    
    //MARK: TableView Delegates and Datasource:
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 126
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listArrayFoodBank.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "NotificationCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
        let url = NSURL(string:imageURL)
        cell.fimage.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        
        
        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type") as! String
        if userID == "1" as String
        {
           // cell.CategeoryType.text! = String(format : "Categeory: Food Bank")
            
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let regularAttributedString = NSAttributedString(string: "A New Food Bank ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String, attributes: boldAttribute)
            
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            mutableAttributedString.append(boldAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
            
        }
        else if (userID == "2" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let regularAttributedString = NSAttributedString(string: "A New Food Share ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String, attributes: boldAttribute)
            
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            mutableAttributedString.append(boldAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }
        else if (userID == "4" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let regularAttributedString = NSAttributedString(string: "A New Event ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String, attributes: boldAttribute)
            
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            mutableAttributedString.append(boldAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }

        else if (userID == "5" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let regularAttributedString = NSAttributedString(string: "Your Event ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " has ended. Please Share surplus food on Food4All", attributes: regularAttribute)
          
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }
        else if (userID == "6" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let regularAttributedString = NSAttributedString(string: "Your food sharing ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " has expired. Please update or delete your sharing", attributes: regularAttribute)
            
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }
        else if (userID == "7" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as! String, attributes: boldAttribute)
            let regularAttributedString = NSAttributedString(string: " Wants to connect with ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " as a Volunteer", attributes: regularAttribute)
            
            mutableAttributedString.append(boldAttributedString2)
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }
        else if (userID == "8" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as! String, attributes: boldAttribute)
            let regularAttributedString = NSAttributedString(string: " Wants to collect ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            let regularAttributedString2 = NSAttributedString(string: " shared by you", attributes: regularAttribute)
            
            mutableAttributedString.append(boldAttributedString2)
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            mutableAttributedString.append(regularAttributedString2)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }
        else if (userID == "9" as String)
        {
            let mutableAttributedString = NSMutableAttributedString()
            let boldAttribute = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            let regularAttribute = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
                ] as [String : Any]
            
            
            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as! String, attributes: boldAttribute)
            let regularAttributedString = NSAttributedString(string: " Wants to get updates on surplus food from ", attributes: regularAttribute)
            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
            
            mutableAttributedString.append(boldAttributedString2)
            mutableAttributedString.append(regularAttributedString)
            mutableAttributedString.append(boldAttributedString)
            
            cell.LocationAddress?.attributedText = mutableAttributedString
        }

        


       // cell.Title.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String
        
       // cell.LocationAddress.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
        
                
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type") as! String
        
        if userID == "1" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
               // myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
            else
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
               // myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "2" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.SharedMealID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.SharedMealID = quantity
                }

               // myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
            else
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.SharedMealID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.SharedMealID = quantity
                }
              //  myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "4" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
                
              //  myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
            else{
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsViewController") as? EventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
                {
                    let strval: NSString = (quantity: quantity.stringValue) as NSString
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
                
              //  myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "5" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
            {
                let strval: NSString = (quantity: quantity.stringValue) as NSString
                myVC?.foodbankID = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
            {
                myVC?.foodbankID = quantity
            }
            
           // myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
        }
        else if userID == "6" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
            {
                let strval: NSString = (quantity: quantity.stringValue) as NSString
                myVC?.SharedMealID = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
            {
                myVC?.SharedMealID = quantity
            }
            
          //  myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
        }
        else if userID == "7" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
            {
                let strval: NSString = (quantity: quantity.stringValue) as NSString
                myVC?.foodbankID = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
            {
                myVC?.foodbankID = quantity
            }
            
           // myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
          //  myVC?.percentStr = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_detail_id") as! String
        }
        else if userID == "8" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
            {
                let strval: NSString = (quantity: quantity.stringValue) as NSString
                myVC?.SharedMealID = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
            {
                myVC?.SharedMealID = quantity
            }
            
           // myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
        }
        else if userID == "9" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? NSNumber
            {
                let strval: NSString = (quantity: quantity.stringValue) as NSString
                myVC?.foodbankID = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as? String
            {
                myVC?.foodbankID = quantity
            }
           // myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath)
    {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
            if (strpage == "0") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else if (strpage == "") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else
            {
                let baseURL: String  = String(format:"%@",Constants.mainURL)
                let params = "method=get_user_notification&gcm_id=\(DeviceToken)&page=\(strpage)"
                
                print(params)
                
                // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        print(responceDic)
                        
                        
                        if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                        {
                            self.responsewithToken6(responceDic)
                        }
                        else
                        {
                            
                        }
                    }
                    
                }) { (error) in
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                    //print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func responsewithToken6(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        if count == 1 {
            count = 2
            if (strpage == "2") {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                NotificationTableView.reloadData()
            }
            else {
                
            }
            
            let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
            self.strpage = String(describing: number)
        }
        else {
            let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
            self.strpage = String(describing: number)
            
            if (strpage == "0") {
                if lastCount == 1 {
                    var arr = NSMutableArray()
                    arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                    NotificationTableView.reloadData()
                    lastCount = 2
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                NotificationTableView.reloadData()
                
            }
        }
    }
    
    
    
    func initFooterView() {
        footerview2 = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(view.frame.size.width), height: CGFloat(50.0)))
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: CGFloat(view.frame.size.width / 2 - 10), y: CGFloat(5.0), width: CGFloat(20.0), height: CGFloat(20.0))
        actInd.isHidden = true
        //actInd.performSelector(#selector(removeFromSuperview), withObject: nil, afterDelay: 30.0)
        footerview2.addSubview(actInd)
        loadLbl = UILabel(frame: CGRect(x: CGFloat(view.frame.size.width / 2 - 100), y: CGFloat(25), width: CGFloat(200), height: CGFloat(20)))
        loadLbl.textAlignment = .center
        loadLbl.textColor = UIColor.lightGray
        // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
        loadLbl.font = UIFont.systemFont(ofSize: CGFloat(12))
        footerview2.addSubview(loadLbl)
        actInd = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrool == 1 {
            let endOfTable: Bool = (scrollView.contentOffset.y >= 0)
            if endOfTable && !scrollView.isDragging && !scrollView.isDecelerating {
                if (strpage == "0") {
                    NotificationTableView.tableFooterView = footerview2
                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
                    //  loadLbl.text = "No More List"
                    //   actInd.stopAnimating()
                }
                else {
                    NotificationTableView.tableFooterView = footerview2
                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.startAnimating()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrool == 1 {
            footerview2.isHidden = true
            // loadLbl.isHidden = true
        }
    }
    
    
    
    
    @IBAction func backbuttClicked(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
