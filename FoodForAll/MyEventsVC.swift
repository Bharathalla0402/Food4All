//
//  MyEventsVC.swift
//  FoodForAll
//
//  Created by think360 on 05/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MyEventsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate {

    @IBOutlet weak var foodBnkBackView: UIView!
    var cell: EventTableCell!
    var eventsTableView = UITableView()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var strfoodbankid = NSString()
    var listArrayFoodBank : NSMutableArray  = []
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var locationManager = CLLocationManager()
    
    var Stringlab = UILabel()
    
    var strpage = String()
    var footerview2: UIView!
    var loadLbl: UILabel!
    var locationNamelabel: UILabel!
    var actInd: UIActivityIndicatorView!
    var scrool = 1
    var count = 1
    var lastCount = 1
    
    var imagesArray = NSArray()
    var listDetailBank = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Stringlab.frame = CGRect(x:self.view.frame.size.width/2-100, y:self.view.frame.size.height/2-10, width:200, height:20)
        Stringlab.backgroundColor = UIColor.clear
        Stringlab.text="No List"
        Stringlab.font =  UIFont(name:"Helvetica-Bold", size: 16)
        Stringlab.textColor=UIColor.black
        Stringlab.textAlignment = .center
        Stringlab.isHidden=true;
        self.view.addSubview(Stringlab)
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
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
        
        
        let data = UserDefaults.standard.object(forKey: "UserId") as? Data
        myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
      //  print(myArray)
        strUserID=myArray.value(forKey: "id") as! NSString
        
        perform(#selector(MyFoodBankVC.showTableView), with: nil, afterDelay: 0.02)
       // self.getAllEventsApiMethod()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllEventsApiMethod()
    }
    
    func showTableView()
    {
        eventsTableView.frame = CGRect(x:0, y:0, width:foodBnkBackView.frame.size.width, height:foodBnkBackView.frame.size.height)
        eventsTableView.delegate=self
        eventsTableView.dataSource=self
        eventsTableView.estimatedRowHeight = 196
        self.eventsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        foodBnkBackView.addSubview(eventsTableView)
    }
    
    
    func getAllEventsApiMethod () -> Void
    {
          var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"myEvents",params)
        
        print(baseURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.listArrayFoodBank.removeAllObjects()
                    
                    self.Stringlab.isHidden=true
                    self.eventsTableView.isHidden=false
                    
                    self.listArrayFoodBank = ((responceDic.object(forKey: "eventList") as? NSArray)! as? NSMutableArray)!
                    //print(self.listArrayFoodBank )
                    self.listArrayFoodBank=self.listArrayFoodBank as AnyObject as! NSMutableArray
                    
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.eventsTableView.reloadData()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    self.listArrayFoodBank.removeAllObjects()
                    
                    if Message == "No Events found."
                    {
                        self.listArrayFoodBank.removeAllObjects()
                        self.eventsTableView.reloadData()
                        self.Stringlab.text="No List"
                        self.Stringlab.isHidden=false
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                    }
                    
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
        
        
        
//
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=myEvent&user_id=\(strUserID)&lat=\(currentLatitude)&lon=\(currentLongitude)"
//
//      //  print(params)
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//             //   print(responceDic)
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//
//                    self.listArrayFoodBank.removeAllObjects()
//                    self.listArrayFoodBank = ((responceDic.object(forKey: "eventList") as? NSArray)! as? NSMutableArray)!
//                    //print(self.listArrayFoodBank )
//                    self.listArrayFoodBank=self.listArrayFoodBank as AnyObject as! NSMutableArray
//
//                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
//                    self.strpage = String(describing: number)
//
//                    self.eventsTableView.reloadData()
//                }
//                else
//                {
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
//
//                    if Message == "Event list not found."
//                    {
//                        self.Stringlab.isHidden=false;
//                    }
//                    else
//                    {
//                        AFWrapperClass.svprogressHudDismiss(view: self)
//                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
//                    }
//
//                }
//            }
//
//        }) { (error) in
//
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
    }

    
    
    
    //MARK: TableView Delegates and Datasource:
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listArrayFoodBank.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "EventTableCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "EventTableCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: NSArray = ((self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "images") as? NSArray)!
        if imageURL.count == 0
        {
            cell.EventImage.image = UIImage(named: "Logo")
        }
        else
        {
            let strurl = imageURL.object(at: 0)
            let url = NSURL(string: strurl as! String )
            cell.EventImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        }
        
        
        cell.EventTitle.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String ?? ""
        
        let strname1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
        let strname2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
        cell.EventUserName.text! = strname1+" "+strname2
        
        
        
        let straddress = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String ?? ""
        let stradd = straddress.replacingOccurrences(of: "\n", with: "")
        cell.EventAddress.text! = stradd
        
        
        if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? NSNumber
        {
            //   let strval: String = (quantity: quantity.stringValue) as! String
            let strval = String(describing: quantity)
            cell.EventDistance.text! = strval as String + " kms"
            
        }
        else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? String
        {
            cell.EventDistance.text! = quantity+" Kms"
        }
        
        let StrStartDate = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_datetime") as? String ?? ""
        if StrStartDate == ""
        {
            
        }
        else
        {
            let startDateArray:NSArray = StrStartDate.components(separatedBy: " ") as NSArray
            if startDateArray.count > 1
            {
                cell.EventStartDate.text! = (startDateArray.object(at: 0) as? String)!
                cell.EventStartTime.text! = (startDateArray.object(at: 1) as? String)!
            }
            else
            {
                cell.EventStartDate.text! = (startDateArray.object(at: 0) as? String)!
            }
        }
        
        let StrEndDate = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "end_datetime") as? String ?? ""
        if StrEndDate == ""
        {
            
        }
        else
        {
            let EndDateArray:NSArray = StrEndDate.components(separatedBy: " ") as NSArray
            if EndDateArray.count > 1
            {
                cell.EventEndDate.text! = (EndDateArray.object(at: 0) as? String)!
                cell.EventEndTime.text! = (EndDateArray.object(at: 1) as? String)!
            }
            else
            {
                cell.EventEndDate.text! = (EndDateArray.object(at: 0) as? String)!
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        }
        else
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsViewController") as? EventsDetailsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        }
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
//    {
//
//        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
//
//            self.strfoodbankid=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String as NSString
//
//            let alert = UIAlertController(title: "Event", message: "Are You Sure Want to Delete Event", preferredStyle: UIAlertControllerStyle.alert)
//
//            let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
//                self.deletemethod()
//            })
//
//            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
//
//            })
//
//            alert.addAction(alertOKAction)
//            alert.addAction(alertCancelAction)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//        deleteAction.backgroundColor = .red
//
//        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
//
//
//
//        }
//        editAction.backgroundColor = .blue
//
//        return [deleteAction, editAction]
//    }
//
    
    
    
    
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: cell.frame.size.height))
        backView.backgroundColor = #colorLiteral(red: 0.933103919, green: 0.08461549133, blue: 0.0839477703, alpha: 1)

        let myImage = UIImageView(frame: CGRect(x: backView.frame.size.width/2-10, y: backView.frame.size.height/2-20, width: 20, height: 20))
        myImage.image = UIImage(named: "DeleteI")
        backView.addSubview(myImage)

        let label = UILabel(frame: CGRect(x: 0, y: myImage.frame.origin.y+16, width: backView.frame.size.width, height: 25))
        label.text = "Delete"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: label.font.fontName, size: 15)
        backView.addSubview(label)

        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let delete = UITableViewRowAction(style: .destructive, title: "           ") { (action, indexPath) in

            self.strfoodbankid=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String as NSString
            
            let alert = UIAlertController(title: "Event", message: "Are You Sure Want to Delete Event", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
                self.deletemethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }

        delete.backgroundColor = UIColor(patternImage: newImage)

        let backViewEdit = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: cell.frame.size.height))
        backViewEdit.backgroundColor = #colorLiteral(red: 0.1318215132, green: 0.01255247556, blue: 0.8887208104, alpha: 1)

        let editImage = UIImageView(frame: CGRect(x: backViewEdit.frame.size.width/2-10, y: backViewEdit.frame.size.height/2-20, width: 20, height: 20))
        editImage.image = UIImage(named: "Edit")
        backViewEdit.addSubview(editImage)

        let editLabel = UILabel(frame: CGRect(x: 0, y: myImage.frame.origin.y+16, width: backViewEdit.frame.size.width, height: 25))
        editLabel.text = "Edit  "
        editLabel.textAlignment = .center
        editLabel.textColor = UIColor.white
        editLabel.font = UIFont(name: label.font.fontName, size: 15)
        backViewEdit.addSubview(editLabel)

        let imgSizeEdit: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSizeEdit, false, UIScreen.main.scale)
        let contextEdit = UIGraphicsGetCurrentContext()
        backViewEdit.layer.render(in: contextEdit!)
        let newImageEdit: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let EditB = UITableViewRowAction(style: .normal, title: "          ") { (action, indexPath) in

            self.strfoodbankid=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String as NSString
            
            let alert = UIAlertController(title: "Event", message: "Are You Sure Want to Edit this Event", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Edit", style: UIAlertActionStyle.default,handler: { action in
                self.Editmethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }

        EditB.backgroundColor = UIColor(patternImage: newImageEdit)
       // return [delete]
        return [delete, EditB]
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//
//            strfoodbankid=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String as NSString
//
//            let alert = UIAlertController(title: "Event", message: "Are You Sure Want to Delete Event", preferredStyle: UIAlertControllerStyle.alert)
//
//            let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
//                self.deletemethod()
//            })
//
//            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
//
//            })
//
//            alert.addAction(alertOKAction)
//            alert.addAction(alertCancelAction)
//
//            self.present(alert, animated: true, completion: nil)
//
//        }
//    }
    
    
    func Editmethod()
    {
        var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&event_id=\(strfoodbankid)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"eventDetail",params)
        
        print(baseURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                //  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.listDetailBank = (responceDic.object(forKey: "eventDetail") as? NSDictionary)!
                    self.imagesArray = (self.listDetailBank.object(forKey: "images") as? NSArray)!
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "AddEventsViewController") as? AddEventsViewController
                    foodVC?.listDetailBank = self.listDetailBank
                    foodVC?.imagesArray = self.imagesArray
                    foodVC?.StrEditMode = "1"
                    self.navigationController?.pushViewController(foodVC!, animated: true)
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
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
    
    
    
    
    
    func deletemethod()
    {
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"deleteEvent")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserID, forKey: "user_id")
        PostDataValus.setValue(strfoodbankid, forKey: "event_id")
        
        var jsonStringValues = String()
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        if jsonData == nil {
            
        }
        else
        {
            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
            print("jsonString: \(jsonStringValues)")
        }
        
        
      //  let baseURL: String  = String(format:"%@",Constants.mainURL)
     //   let params = "method=deleteEvent&user_id=\(strUserID)&event_id=\(strfoodbankid)"
        
     //   print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
            //    print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                   self.getAllEventsApiMethod()
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
                var localTimeZoneName: String { return TimeZone.current.identifier }
                let strkey = Constants.ApiKey
                let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&page=\(self.strpage)&time_zone=\(localTimeZoneName)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"myEvents",params)
                
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        //  print(responceDic)
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
        arr = (responseDictionary.value(forKey: "eventList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
        
        
    
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
        eventsTableView.reloadData()
        
    }
    
    
    
    func responsewithToken6(_ responseDict: NSDictionary) {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        if count == 1 {
            count = 2
            if (strpage == "2") {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "eventList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                eventsTableView.reloadData()
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
                    arr = (responseDictionary.value(forKey: "eventList") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                    eventsTableView.reloadData()
                    lastCount = 2
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "eventList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                eventsTableView.reloadData()
                
            }
        }
    }
    
    
    
//    func initFooterView() {
//        footerview2 = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(view.frame.size.width), height: CGFloat(50.0)))
//        actInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        actInd.tag = 10
//        actInd.frame = CGRect(x: CGFloat(view.frame.size.width / 2 - 10), y: CGFloat(5.0), width: CGFloat(20.0), height: CGFloat(20.0))
//        actInd.isHidden = true
//        //actInd.performSelector(#selector(removeFromSuperview), withObject: nil, afterDelay: 30.0)
//        footerview2.addSubview(actInd)
//        loadLbl = UILabel(frame: CGRect(x: CGFloat(view.frame.size.width / 2 - 100), y: CGFloat(25), width: CGFloat(200), height: CGFloat(20)))
//        loadLbl.textAlignment = .center
//        loadLbl.textColor = UIColor.lightGray
//        // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
//        loadLbl.font = UIFont.systemFont(ofSize: CGFloat(12))
//        footerview2.addSubview(loadLbl)
//        actInd = nil
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrool == 1 {
//            let endOfTable: Bool = (scrollView.contentOffset.y >= 0)
//            if endOfTable && !scrollView.isDragging && !scrollView.isDecelerating {
//                if (strpage == "0") {
//                    eventsTableView.tableFooterView = footerview2
//                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
//                    //  loadLbl.text = "No More List"
//                    //   actInd.stopAnimating()
//                }
//                else {
//                    eventsTableView.tableFooterView = footerview2
//                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.startAnimating()
//                }
//            }
//        }
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if scrool == 1 {
//           // footerview2.isHidden = true
//            // loadLbl.isHidden = true
//        }
//    }
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        //      self.navigationController?.pushViewController(foodVC!, animated: true)
        
        self.navigationController?.popViewController(animated: true)
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
