//
//  NotificationlistViewController.swift
//  FoodForAll
//
//  Created by think360 on 04/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class NotificationlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate
{

    @IBOutlet weak var NotificationBackView: UIView!
    var cell: NotificationCell!
    var NotificationTableView = UITableView()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var locationManager = CLLocationManager()
    
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
    var NotificationId = String()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
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
        
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
        }else{
            let alertController = UIAlertController(title: "Food4All", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                // UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                alertController.dismiss(animated: true, completion: nil)
            })
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(self.strUserID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listNotifications",params)
        print(baseURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.scrool = 1
                    self.count = 1
                    self.lastCount = 1
                    
                    self.listArrayFoodBank = responceDic.object(forKey: "NotificationList") as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.NotificationTableView.reloadData()
                }
                else
                {
                    let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
                    let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
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
        
        let imageURL: String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as? String ?? ""
        let url = NSURL(string:imageURL)
        cell.fimage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        cell.LocationAddress?.text = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "notification") as? String ?? ""
        
        var strId = String()
        
        if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "status") as? NSNumber
        {
            strId = String(describing: quantity)
        }
        else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "status") as? String
        {
            strId = quantity
        }
        
        if strId == "1"
        {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
        else
        {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
//
//        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity") as! String
//        if userID == "foodbanks" as String
//        {
//           // cell.CategeoryType.text! = String(format : "Categeory: Food Bank")
//
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let regularAttributedString = NSAttributedString(string: "A New Food Bank ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
//            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String ?? "", attributes: boldAttribute)
//
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//            mutableAttributedString.append(boldAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//
//
//        }
//        else if (userID == "foodsharings" as String)
//        {
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let regularAttributedString = NSAttributedString(string: "A New Food Share ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
//            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String, attributes: boldAttribute)
//
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//            mutableAttributedString.append(boldAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//        }
//        else if (userID == "events" as String)
//        {
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let regularAttributedString = NSAttributedString(string: "A New Event ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " is added to Food4All at ", attributes: regularAttribute)
//            let boldAttributedString2 = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String, attributes: boldAttribute)
//
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//            mutableAttributedString.append(boldAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//        }
//
//        else if (userID == "volunteers" as String)
//        {
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let regularAttributedString = NSAttributedString(string: "Your Event ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " has ended. Please Share surplus food on Food4All", attributes: regularAttribute)
//
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//        }
//        else if (userID == "chats" as String)
//        {
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let regularAttributedString = NSAttributedString(string: "Your food sharing ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " has expired. Please update or delete your sharing", attributes: regularAttribute)
//
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//        }
//        else
//        {
//            let mutableAttributedString = NSMutableAttributedString()
//            let boldAttribute = [
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//            let regularAttribute = [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
//                NSForegroundColorAttributeName: UIColor.black
//                ] as [String : Any]
//
//
//            let str1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
//            let str2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
//            let strname = str1+" "+str2
//
//            let boldAttributedString2 = NSAttributedString(string: strname, attributes: boldAttribute)
//            let regularAttributedString = NSAttributedString(string: " Wants to connect with ", attributes: regularAttribute)
//            let boldAttributedString = NSAttributedString(string: (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String, attributes: boldAttribute)
//            let regularAttributedString2 = NSAttributedString(string: " as a Volunteer", attributes: regularAttribute)
//
//            mutableAttributedString.append(boldAttributedString2)
//            mutableAttributedString.append(regularAttributedString)
//            mutableAttributedString.append(boldAttributedString)
//            mutableAttributedString.append(regularAttributedString2)
//
//            cell.LocationAddress?.attributedText = mutableAttributedString
//        }
//

        


       // cell.Title.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String
        
       // cell.LocationAddress.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
        
                
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity") as? String ?? ""
        
        if userID == "foodbanks" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as? String ?? ""
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                   // let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
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
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                  //  let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
               // myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "foodsharings" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as? String ?? ""
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                  //  let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.SharedMealID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
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
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                   // let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.SharedMealID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
                {
                    myVC?.SharedMealID = quantity
                }
              //  myVC?.SharedMealID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "events" as String
        {
            let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as? String ?? ""
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                  // let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
                
              //  myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
            else{
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsViewController") as? EventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
                {
                  //  let strval: String = (quantity: quantity.stringValue) as! String
                    let strval = String(describing: quantity)
                    myVC?.foodbankID = strval as String
                }
                else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
                {
                    myVC?.foodbankID = quantity
                }
                
              //  myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "type_id") as! String
            }
        }
        else if userID == "chats" as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
            {
                //  let strval: String = (quantity: quantity.stringValue) as! String
                let strval = String(describing: quantity)
                myVC?.strConversionId = strval as String
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
            {
                myVC?.strConversionId = quantity
            }
        }
        else if userID == "volunteers" as String
        {
            var VolunteerID = String()
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? NSNumber
            {
                VolunteerID = String(describing: quantity)
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "entity_id") as? String
            {
                VolunteerID = quantity
            }
            
            var localTimeZoneName: String { return TimeZone.current.identifier }
            let strkey = Constants.ApiKey
            let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(VolunteerID)&time_zone=\(localTimeZoneName)"
            let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"volunteerDetail",params)
            print(baseURL)
            self.VolunteerDetailAPIMethod(baseURL: String(format:"%@",baseURL))
        }
        
        if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
        {
            NotificationId = String(describing: quantity)
        }
        else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
        {
            NotificationId = quantity
        }
        
        
        self.NotificationAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"notification_read") , params: "notice_id=\(self.NotificationId)")
        
    }
    
    
    
    @objc private   func NotificationAPIMethod (baseURL:String , params: String)
    {
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
     
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"readNotifications")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(NotificationId, forKey: "notice_id")
       
        
        
        var jsonStringValues = String()
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        if jsonData == nil {
            
        }
        else {
            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
            print("jsonString: \(jsonStringValues)")
        }
        
        
        print(baseURL)
        print(jsonStringValues)
        
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let strkey = Constants.ApiKey
                    let params = "api_key=\(strkey)&user_id=\(self.strUserID)"
                    let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listNotifications",params)
                    print(baseURL)
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                      
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "status") as! NSNumber) == 1
                            {
                                self.scrool = 1
                                self.count = 1
                                self.lastCount = 1
                                
                                self.listArrayFoodBank = responceDic.object(forKey: "NotificationList") as! NSMutableArray
                                let number = responceDic.object(forKey: "nextPage") as! NSNumber
                                self.strpage = String(describing: number)
                                
                                self.NotificationTableView.reloadData()
                            }
                            else
                            {
                                let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
                                let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
                                
                                AFWrapperClass.svprogressHudDismiss(view: self)
                                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                            }
                        }
                    }) { (error) in
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        //print(error.localizedDescription)
                    }
                }
                else
                {
//                    let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
//                    let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
//
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    @objc private   func VolunteerDetailAPIMethod (baseURL:String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "VolunteerDetailsViewController") as? VolunteerDetailsViewController
                    myVC?.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.VolunteerDetails = responceDic.object(forKey: "volunteerDetail") as! NSDictionary
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
            }
        })
        { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
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
                let strkey = Constants.ApiKey
                let params = "api_key=\(strkey)&user_id=\(strUserID)&page=\(self.strpage)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listNotifications",params)
                
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        print(responceDic)
                        if (responceDic.object(forKey: "status") as! NSNumber) == 1
                        {
                             self.responsewithToken7(responceDic)
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
    
    
    func responsewithToken7(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "NotificationList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
        
        let number = responseDict.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
      
        
        NotificationTableView.reloadData()
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
         //   footerview2.isHidden = true
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
