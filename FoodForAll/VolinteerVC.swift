


//
//  VolinteerVC.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AddressBookUI

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var VolunteerImage: UIImageView!
    @IBOutlet weak var VolunteerName: UILabel!
}


class VolinteerVC: UIViewController,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate {

    
    var cell: CollectionCell!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var mapView2 = GMSMapView()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    var searchViewController = ABCGooglePlacesSearchViewController()
    
    
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var popview3 = UIView()
    var footerView3 = UIView()
    var locationlab = UILabel()
    var citylab = UILabel()
    var CancelButton2 = UIButton()
    var DoneButton2 = UIButton()
    var locationButt = UIButton()
    var ValunteerButt = UIButton()
    var ValunteerButt2 = UIButton()
    var TextDescription = UITextView()
    var tablfooter = UIView()
    var frontView = UIView()
    
    var DeviceToken=String()
   // var cell: VolunterrTblCell!
   // @IBOutlet weak var volunterFbTblView: UITableView!
    
    @IBOutlet weak var volunteerCollectionView: UICollectionView!
    var NoticationLab = UILabel()
    var NotificationButton = UIButton()
    var strpage = String()
    
    var myArray = NSDictionary()
    var strUserID = String()
    var listArrayValunteer = NSMutableArray()
    
     var listArraySettings = NSDictionary()
     var strvalinter = String()
    
    var switchlab = UISwitch()
    var txtemailfield = UITextField()
     var Headview2 = UIView()
    var foodbanklistbutt = UIButton()
    var foodbankNamelab = UILabel()
    var strFoodbankId = NSString()
    var strChecklist = NSString()
    var strfoodbankname = NSString()
    
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?
    
     lazy var geocoder = CLGeocoder()
    
   //  @IBOutlet weak var ValunteerButt: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
        if revealViewController() != nil {
            
            revealViewController().rearViewRevealWidth = 260
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().delegate=self
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        
        ValunteerButt.frame = CGRect(x:0, y:self.view.frame.size.height-94, width:self.view.frame.size.width, height:45)
        ValunteerButt.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        ValunteerButt.setTitle("I Want To Become Volunteer", for: .normal)
        ValunteerButt.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        ValunteerButt.setTitleColor(UIColor.white, for: .normal)
        ValunteerButt.titleLabel?.textAlignment = .center
        ValunteerButt.addTarget(self, action: #selector(VolinteerVC.becomeVolntrBtnAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(ValunteerButt)
        
        
        ValunteerButt2.frame = CGRect(x:0, y:self.view.frame.size.height-94, width:self.view.frame.size.width, height:45)
        ValunteerButt2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        ValunteerButt2.setTitle("Invite friends to become Volunteers", for: .normal)
        ValunteerButt2.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        ValunteerButt2.setTitleColor(UIColor.white, for: .normal)
        ValunteerButt2.titleLabel?.textAlignment = .center
        ValunteerButt2.addTarget(self, action: #selector(VolinteerVC.becomeVolntrBtnAction2(_:)), for: UIControlEvents.touchUpInside)
        ValunteerButt2.isHidden = true
        self.view.addSubview(ValunteerButt2)
        
        
        
        NoticationLab = UILabel(frame: CGRect(x: CGFloat(self.view.frame.size.width - 32), y: CGFloat(18), width: CGFloat(24), height: CGFloat(24)))
        NoticationLab.backgroundColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0))
        NoticationLab.layer.masksToBounds = true
        NoticationLab.layer.cornerRadius = 12.0
        NoticationLab.textColor = UIColor.white
        NoticationLab.font = UIFont.systemFont(ofSize: CGFloat(11))
        NoticationLab.textAlignment = .center
        NoticationLab.isHidden = true
        self.view.addSubview(NoticationLab)
        
        
        NotificationButton = UIButton(frame: CGRect(x: CGFloat(self.view.frame.size.width - 50), y: CGFloat(10), width: CGFloat(60), height: CGFloat(60)))
        NotificationButton.addTarget(self, action: #selector(self.NotificationButtonClicked), for: .touchUpInside)
        NotificationButton.backgroundColor = UIColor.clear
        self.view.addSubview(NotificationButton)
        
        if UserDefaults.standard.object(forKey: "NCount") != nil
        {
            let str:String = (UserDefaults.standard.object(forKey: "NCount") as? String)!
            
            if str == "0"
            {
                NoticationLab.isHidden = true
                NotificationButton.isHidden = false
            }
            else
            {
                NoticationLab.text = UserDefaults.standard.object(forKey: "NCount") as? String
                NoticationLab.isHidden = false
                NotificationButton.isHidden = false
            }

        }
        else
        {
            NoticationLab.text = "0"
            NoticationLab.isHidden = true
           // NotificationButton.isHidden = true
        }
        
        
       

        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = "ghjgj"
        }

        
        
        
       
        
//        volunterTblView.estimatedRowHeight = 50
//        volunterTblView.rowHeight = UITableViewAutomaticDimension
//        volunterTblView.backgroundColor=UIColor.white
//        tablfooter.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:45)
//        tablfooter.backgroundColor = UIColor.white
//        volunterTblView.tableFooterView = tablfooter
        
        
//        volunteerCollectionView.register(VolunteerCell.self, forCellWithReuseIdentifier: "VolunteerCell")
        
        
        searchViewController.delegate=self
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
           // currentLatitude = (locationManager.location?.coordinate.latitude)!
          //  currentLongitude = (locationManager.location?.coordinate.longitude)!
          //  firstLatitude = (locationManager.location?.coordinate.latitude)!
          //  firstLongitude = (locationManager.location?.coordinate.longitude)!
            
            
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                firstLatitude = lat
                myLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
                myLongitude = long
            }else {
                
            }
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
    
    func Notificationmethod()
    {
        if UserDefaults.standard.object(forKey: "NCount") != nil
        {
            let data = UserDefaults.standard.object(forKey: "NCount") as! NSNumber
            let orderInt  = data.intValue
            self.NoticationLab.text = String(describing: orderInt)
        }
    }
    
    
    @IBAction func NotificationButtonClicked(_ sender: Any)
    {
        if strUserID == ""
        {
            
        }
        else{
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(strUserID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listNotifications",params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationlistViewController") as? NotificationlistViewController
                    myVC?.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.listArrayFoodBank = responceDic.object(forKey: "NotificationList") as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    myVC?.strpage = String(describing: number)
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
        
        
        
        
        //        let baseURL: String  = String(format:"%@",Constants.mainURL)
        //        let params = "method=get_user_notification&gcm_id=\(DeviceToken)"
        
        //        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"get_user_notification")
        //        let strkey = Constants.ApiKey
        //
        //        let PostDataValus = NSMutableDictionary()
        //        PostDataValus.setValue(strkey, forKey: "api_key")
        //        PostDataValus.setValue(DeviceToken, forKey: "gcm_id")
        //
        //        var jsonStringValues = String()
        //        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        //        if jsonData == nil {
        //
        //        }
        //        else {
        //            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
        //            print("jsonString: \(jsonStringValues)")
        //        }
        //
        //        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        //        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
        //
        //            DispatchQueue.main.async {
        //                AFWrapperClass.svprogressHudDismiss(view: self)
        //                let responceDic:NSDictionary = jsonDic as NSDictionary
        //              //  print(responceDic)
        //
        //                if (responceDic.object(forKey: "status") as! NSNumber) == 1
        //                {
        //                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationlistViewController") as? NotificationlistViewController
        //                    myVC?.hidesBottomBarWhenPushed=true
        //                    self.navigationController?.pushViewController(myVC!, animated: true)
        //
        //                    myVC?.listArrayFoodBank = responceDic.object(forKey: "List") as! NSMutableArray
        //                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
        //                    myVC?.strpage = String(describing: number)
        //                }
        //                else
        //                {
        //                    var Message=String()
        //                    Message = responceDic.object(forKey: "responseMessage") as! String
        //
        //                    AFWrapperClass.svprogressHudDismiss(view: self)
        //                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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
    

    
    
    @objc private  func ProfileSettinglistAPIMethod (baseURL:String , params: String)
    {
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"dashboard")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(DeviceToken, forKey: "gcm_id")
        PostDataValus.setValue("ios", forKey: "device_type")
        PostDataValus.setValue(strUserID, forKey: "user_id")
        PostDataValus.setValue(strlat, forKey: "lat")
        PostDataValus.setValue(strlong, forKey: "long")
        
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
        
        
        
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
              //  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.strvalinter=(responceDic.object(forKey: "dashboardDetails") as? NSDictionary)?.value(forKey: "volunteer_status") as? String ?? ""
                    
                   
                    
                    UserDefaults.standard.set(self.strvalinter, forKey: "volunteerstatus")
                    
                    if self.strUserID == ""
                    {
                        
                    }
                    else
                    {
                        if self.strvalinter == "1"
                        {
                            self.ValunteerButt.isHidden=true
                            self.ValunteerButt2.isHidden=false
                        }
                        else
                        {
                            self.ValunteerButt.isHidden=false
                            self.ValunteerButt2.isHidden=true
                        }
                    }
                    
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

    
    
    
    @objc private  func GetVolunteerAPIMethod (baseURL:String , params: String)
    {
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(strUserID)&lat=\(myLatitude)&long=\(myLongitude)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listVolunteers",params)
        
        print(baseURL)
        
        
        if self.listArrayValunteer.count == 0
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        
        
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.listArrayValunteer.removeAllObjects()
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    self.listArrayValunteer = (responceDic.object(forKey: "volunteerList") as? NSArray)! as! NSMutableArray
                    self.volunteerCollectionView.reloadData()
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
        
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//                print(responceDic)
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    self.listArrayValunteer = (responceDic.object(forKey: "VolunteerList") as? NSArray)!
//                    self.volunteerCollectionView.reloadData()
//                }
//                else
//                {
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
//
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if UserDefaults.standard.object(forKey: "NCount") != nil
        {
            let str:String = (UserDefaults.standard.object(forKey: "NCount") as? String)!
            
            if str == "0"
            {
                NoticationLab.isHidden = true
                NotificationButton.isHidden = false
            }
            else
            {
                NoticationLab.text = UserDefaults.standard.object(forKey: "NCount") as? String
                NoticationLab.isHidden = false
                NotificationButton.isHidden = false
            }
        }
        else
        {
            
            NoticationLab.isHidden = true
            // NotificationButton.isHidden = true
        }

        
        
        self.revealViewController().delegate=self
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        frontView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        
        self.tabBarController?.tabBar.isHidden = false
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
            if let quantity = myArray.value(forKey: "id") as? NSNumber
            {
                strUserID = String(describing: quantity)
            }
            else if let quantity = myArray.value(forKey: "id") as? String
            {
                strUserID = quantity
            }
        }
        else
        {
            strUserID=""
        }
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
            
            if let quantity = myArray.value(forKey: "id") as? NSNumber
            {
                strUserID = String(describing: quantity)
            }
            else if let quantity = myArray.value(forKey: "id") as? String
            {
                strUserID = quantity
            }
            
            self.ProfileSettinglistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=get_sliderDashboard&gcm_id=\(DeviceToken)&device_type=ios&user_id=\(strUserID)&lat=\(currentLatitude)&lon=\(currentLongitude)")
        }
        else
        {
            self.ValunteerButt.isHidden=false
            self.ValunteerButt.isUserInteractionEnabled=true
            self.ValunteerButt2.isHidden=true
            ValunteerButt.setTitle("Login To become Volunteer", for: .normal)
            ValunteerButt.addTarget(self, action: #selector(VolinteerVC.becomeVolntrBtnAction(_:)), for: UIControlEvents.touchUpInside)
        }
        
        self.GetVolunteerAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=volunteerList&user_id=\(strUserID)")

        
       //  ValunteerButt.isUserInteractionEnabled = false
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let userInterface = UIDevice.current.userInterfaceIdiom
        
        if(userInterface == .pad)
        {
           return CGSize(width: self.view.frame.size.width / 4 - 25, height: 150)
            
        }
         return CGSize(width: self.view.frame.size.width / 3 - 15 , height: 150)
        
//        if UI_USER_INTERFACE_IDIOM() == .phone
//        {
//            return CGSize(width: self.view.frame.size.width / 3 - 15 , height: 150)
//        }
//        return CGSize(width: self.view.frame.size.width / 5 - 30, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.listArrayValunteer.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        let strname1 = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
        let strname2 = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
        cell.VolunteerName.text! = strname1+" "+strname2
       // cell.VolunteerName.text! = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as! String
        
        let imageURL: String = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
        let url = NSURL(string:imageURL)
        cell.VolunteerImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        let foodbankAdmin: String = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_foodbank_admin") as? String ?? ""
        
        if foodbankAdmin == "1"
        {
            cell.VolunteerImage.borderColor = #colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        }
        else
        {
            cell.VolunteerImage.borderColor = UIColor.clear
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let VolunteerID:String = (self.listArrayValunteer.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        
          var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(VolunteerID)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"volunteerDetail",params)
         print(baseURL)
       self.VolunteerDetailAPIMethod(baseURL: String(format:"%@",baseURL))
        
     //  self.GetVolunteerDetailslistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=volunteerDetail&user_id=\(VolunteerID)&lat=\(firstLatitude)&lon=\(firstLongitude)")
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
    
    
    
    
    @objc private  func GetVolunteerDetailslistAPIMethod (baseURL:String , params: String)
    {
        print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "VolunteerDetailsViewController") as? VolunteerDetailsViewController
                    myVC?.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.VolunteerDetails = responceDic.object(forKey: "VolunteerList") as! NSDictionary
                    
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

    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let lastSectionIndex: Int = collectionView.numberOfSections - 1
        let lastRowIndex: Int = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)
        {
            if (strpage == "0")
            {
                
            }
            else if (strpage == "")
            {
                
            }
            else
            {
                let strkey = Constants.ApiKey
                let params = "api_key=\(strkey)&user_id=\(strUserID)&page=\(self.strpage)&lat=\(myLatitude)&long=\(myLongitude)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listVolunteers",params)
                
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
        arr = (responseDictionary.value(forKey: "volunteerList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayValunteer.addObjects(from: arr as [AnyObject])
        
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
        self.volunteerCollectionView.reloadData()
    }
    
    
   

    
    
    
    
    

    // MARK: Facebook Share Action :
    func FacebookShareButtonAction(_ sender: UIButton!)
    {
        var Message=String()
        Message = "We Will Update Soon"
        
        AFWrapperClass.svprogressHudDismiss(view: self)
        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
    }
    
     // MARK: Invite Friends Action:
    
    @IBAction func becomeVolntrBtnAction2(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as? ContactsViewController
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            proVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(proVC, animated: true)
        }
    }
    
    
    @IBAction func becomeVolntrBtnAction(_ sender: Any)
    {
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            popview.isHidden=false
            footerView.isHidden=false
            strFoodbankId = ""
            
            
            popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
            popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
            self.view.addSubview(popview)
            
            footerView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height-50)
            footerView.backgroundColor = UIColor.white
            popview.addSubview(footerView)
            
            
            let bglab = UILabel()
            bglab.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:70)
            bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
            footerView.addSubview(bglab)
            
            
            let forgotlab = UILabel()
            forgotlab.frame = CGRect(x:0, y:10, width:footerView.frame.size.width, height:60)
            forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
            forgotlab.text="Want To Become Volunteer?"
            forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
            forgotlab.textColor=UIColor.white
            forgotlab.textAlignment = .center
            footerView.addSubview(forgotlab)
            
            
        
            
            let userProfile = UIView()
            userProfile.frame = CGRect(x:0, y:forgotlab.frame.size.height+forgotlab.frame.origin.y, width:footerView.frame.size.width, height:150  )
            userProfile.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            footerView.addSubview(userProfile)
            
            var  bgimage : UIImageView
            bgimage  = UIImageView(frame:CGRect(x:0, y:0, width:userProfile.frame.size.width, height:userProfile.frame.size.height));
            bgimage.image = UIImage(named: "profile-bg")
            bgimage.contentMode = .scaleToFill
            userProfile.addSubview(bgimage)
            
            
            var Userimage : UIImageView
            Userimage  = UIImageView(frame:CGRect(x:userProfile.frame.size.width/2-50, y:10, width:100, height:100));
            let stringUrl = myArray.value(forKey: "image") as! NSString
            let url = URL.init(string:stringUrl as String)
            Userimage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
            Userimage.layer.cornerRadius = 50
            Userimage.clipsToBounds = true
            Userimage.contentMode = .scaleAspectFill
            userProfile.addSubview(Userimage)
            
            let UserNamelab = UILabel()
            UserNamelab.frame = CGRect(x:15, y:Userimage.frame.size.height+Userimage.frame.origin.y+10, width:userProfile.frame.size.width-30, height:20)
            UserNamelab.numberOfLines=0
            let str1 = myArray.value(forKey: "first_name") as! String?
            let str2 = myArray.value(forKey: "last_name") as! String?
            let strname = str1!+" "+str2!
            UserNamelab.text=strname
            UserNamelab.font =  UIFont(name:"Helvetica", size: 14)
            UserNamelab.textColor=UIColor.white
            UserNamelab.textAlignment = .center
            userProfile.addSubview(UserNamelab)
            
            
            let labUnderline = UILabel()
            labUnderline.frame = CGRect(x:0, y:userProfile.frame.origin.y+userProfile.frame.size.height+1, width:footerView.frame.size.width, height:2)
           // labUnderline.backgroundColor = UIColor.darkGray
            labUnderline.backgroundColor = UIColor.clear
            footerView.addSubview(labUnderline)
            
            
            
            let Descriptionlab = UILabel()
            Descriptionlab.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:footerView.frame.size.width-20, height:15)
            Descriptionlab.text = "About Me"
             Descriptionlab.textColor = UIColor.lightGray
            footerView.addSubview(Descriptionlab)
            
            TextDescription.frame = CGRect(x:10, y:Descriptionlab.frame.size.height+Descriptionlab.frame.origin.y+5, width:footerView.frame.size.width-20, height:50)
            TextDescription.delegate = self
            TextDescription.textAlignment = .left
            TextDescription.text = "Enter your text here.."
            TextDescription.textColor = UIColor.lightGray
            TextDescription.layer.borderColor = UIColor.lightGray.cgColor
            footerView.addSubview(TextDescription)
            
            let linelab = UILabel()
            linelab.frame = CGRect(x:10, y:TextDescription.frame.size.height+TextDescription.frame.origin.y, width:footerView.frame.size.width-20, height:1)
            linelab.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            footerView.addSubview(linelab)
            
            
            let locationlab = UILabel()
            locationlab.frame = CGRect(x:10, y:linelab.frame.size.height+linelab.frame.origin.y+15, width:footerView.frame.size.width-20, height:15)
            locationlab.text = "Address"
            locationlab.textColor = UIColor.lightGray
            footerView.addSubview(locationlab)
            locationlab.isHidden = true
            
            
            let Cityview = UIView()
            Cityview.frame = CGRect(x:10, y:locationlab.frame.size.height+locationlab.frame.origin.y+5, width:footerView.frame.size.width-20, height:50)
            Cityview.layer.borderWidth=1.0
            Cityview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
            footerView.addSubview(Cityview)
            Cityview.isHidden = true
            
            
            citylab.frame = CGRect(x:5, y:5, width:Cityview.frame.size.width-10, height:40)
            citylab.text = " Select Location"
            citylab.textAlignment = .center
            citylab.font =  UIFont(name:"Helvetica", size: 15)
            citylab.numberOfLines = 2
            Cityview.addSubview(citylab)
            
            locationButt.frame = CGRect(x:0, y:0, width:Cityview.frame.size.width, height:Cityview.frame.size.height)
            locationButt.backgroundColor=UIColor.clear
            locationButt.addTarget(self, action: #selector(VolinteerVC.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
            Cityview.addSubview(locationButt)
            locationButt.isHidden = true
            
          
            
            
            let Headview = UIView()
            Headview.frame = CGRect(x:10, y:Cityview.frame.size.height+Cityview.frame.origin.y+15, width:footerView.frame.size.width-80, height:50)
            Headview.layer.borderWidth=1.0
            Headview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
            footerView.addSubview(Headview)
            
            
            
            foodbankNamelab.frame = CGRect(x:5, y:5, width:Headview.frame.size.width-10, height:40)
            foodbankNamelab.text="Connect me to a Food Bank as Volunteer"
            foodbankNamelab.font =  UIFont(name:"Helvetica", size: 15)
            foodbankNamelab.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            foodbankNamelab.numberOfLines = 0
            foodbankNamelab.textAlignment = .left
            Headview.addSubview(foodbankNamelab)
            
            
            switchlab.frame = CGRect(x:footerView.frame.size.width-60, y:Cityview.frame.size.height+Cityview.frame.origin.y+25, width:40, height:30)
            switchlab.setOn(false, animated: false)
            switchlab.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
            footerView.addSubview(switchlab)
            
            
            
            
            
            foodbanklistbutt.frame = CGRect(x:10, y:Cityview.frame.size.height+Cityview.frame.origin.y+15, width:footerView.frame.size.width-80, height:50)
            foodbanklistbutt.backgroundColor=UIColor.clear
            foodbanklistbutt.addTarget(self, action: #selector(VolinteerVC.foodbanklistlistClicked(_:)), for: UIControlEvents.touchUpInside)
            foodbanklistbutt.isHidden = true
            footerView.addSubview(foodbanklistbutt)
            
            
            CancelButton2.frame = CGRect(x:10, y:footerView.frame.size.height-50, width:footerView.frame.size.width/2-15, height:40)
            CancelButton2.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            CancelButton2.setTitle("Cancel", for: .normal)
            CancelButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
            CancelButton2.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
            CancelButton2.titleLabel?.textAlignment = .center
            CancelButton2.addTarget(self, action: #selector(VolinteerVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
            footerView.addSubview(CancelButton2)
            
            
            DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:footerView.frame.size.height-50, width:footerView.frame.size.width/2-15, height:40)
            DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
            DoneButton2.setTitle("Become Volunteer", for: .normal)
            DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
            DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            DoneButton2.titleLabel?.textAlignment = .center
            DoneButton2.addTarget(self, action: #selector(VolinteerVC.VolunteerDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
            footerView.addSubview(DoneButton2)
            
            self.setUsersClosestCity()
            
            self.addDoneButtonOnKeyboard()
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            proVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(proVC, animated: true)
        }
        
    }
    
    // MARK: TextView Delegates:
    func textViewDidBeginEditing(_ textView: UITextView) {
        if TextDescription.textColor == UIColor.lightGray {
            TextDescription.text = nil
            TextDescription.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if TextDescription.text.isEmpty {
            TextDescription.text = "Enter your text here.."
            TextDescription.textColor = UIColor.lightGray
        }
    }
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.TextDescription.inputAccessoryView = doneToolbar
        
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    func foodbanklistlistClicked(_ sender: UIButton!)
    {
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=&lat=\(currentLatitude)&long=\(currentLongitude)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchFoodbank",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.arrChildCategory.removeAllObjects()
                    self.arrChildCategory = (responceDic.object(forKey: "foodbankList") as? NSArray)! as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.foodbanklistView()
                }
                else
                {
                    self.arrChildCategory.removeAllObjects()
                    
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
        
        
        //
        //
        //
        //        let baseURL: String  = String(format:"%@",Constants.mainURL)
        //        let params = "method=Search_FoodBanks&lat=\(currentLatitude)&longt=\(currentLongitude)&text="
        //
        //        print(params)
        //
        //        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        //        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
        //
        //            DispatchQueue.main.async {
        //                AFWrapperClass.svprogressHudDismiss(view: self)
        //                let responceDic:NSDictionary = jsonDic as NSDictionary
        //                print(responceDic)
        //
        //                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
        //                {
        //                    self.arrChildCategory = (responceDic.object(forKey: "FoodbankList") as? NSArray)! as! NSMutableArray
        //
        //                    self.foodbanklistView()
        //                }
        //                else
        //                {
        //                    var Message=String()
        //                    Message = responceDic.object(forKey: "responseMessage") as! String
        //
        //                    AFWrapperClass.svprogressHudDismiss(view: self)
        //                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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
        //
        
    }


    
    func foodbanklistView ()
    {
        popview2.isHidden=false
        footerView2.isHidden=false
        
        popview2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview2.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview2)
        
        footerView2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height-50)
        footerView2.backgroundColor = UIColor.white
        popview2.addSubview(footerView2)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerView2.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView2.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerView2.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Select FoodBank"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView2.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerView2.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(VolinteerVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(VolinteerVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerView2.frame.size.width, height: footerView2.frame.size.height-70)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        volunterFbTblView.tableFooterView = UIView()
        footerView2.addSubview(volunterFbTblView)
        
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search FoodBanks"
        theSearchBar?.showsCancelButton = false
        volunterFbTblView.tableHeaderView = theSearchBar
        theSearchBar?.isUserInteractionEnabled = true

        self.addDoneButtonOnKeyboard3()
    }
    
    func addDoneButtonOnKeyboard3()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.theSearchBar?.inputAccessoryView = doneToolbar
    }
    
//    func doneButtonAction()
//    {
//        self.view.endEditing(true)
//    }
    
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
        
        self.arrChildCategory.removeAllObjects()
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
    }
    

    
    
    func switchValueDidChange()
    {
        if switchlab.isOn
        {
            foodbanklistbutt.isHidden = false
            strChecklist = "2"
            
            if strfoodbankname == ""
            {
                foodbankNamelab.text="Connect me to a Food Bank as Volunteer"
            }
            else
            {
               foodbankNamelab.text = strfoodbankname as String
            }
        }
        else
        {
           foodbanklistbutt.isHidden = true
            strChecklist = "1"
            foodbankNamelab.text="Connect me to a Food Bank as Volunteer"
        }
    }

    
    
    
    
    // MARK: location Button Action :
    func locationButtonAction(_ sender: UIButton!)
    {
        tabBarController?.tabBar.isHidden=true
        
        popview3.isHidden=false
        footerView3.isHidden=false
        
        popview3.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview3.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview3)
        
        footerView3.frame = CGRect(x:0, y:0, width:popview3.frame.size.width, height:popview3.frame.size.height)
        footerView3.backgroundColor = UIColor.white
        popview3.addSubview(footerView3)
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView3.frame.size.width, height: footerView3.frame.size.height), camera: camera)
        mapView2.delegate = self
        self.mapView2.settings.compassButton = true
        footerView3.addSubview(mapView2)
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView3.frame.size.width, height:60)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView3.addSubview(Headview)
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:Headview.frame.size.width/2-100, y:15, width:200, height:40)
        titlelab.text="Location"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        titlelab.textColor=UIColor.white
        titlelab.textAlignment = .center
        Headview.addSubview(titlelab)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:Headview.frame.size.width-35, y:25, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(VolinteerVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(VolinteerVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x:self.view.frame.size.width/2-25, y:self.view.frame.size.height/2-25, width:50, height:50));
        imageView.image = UIImage(named:"map_pin96.png")
        imageView.contentMode = .scaleAspectFit
        footerView3.addSubview(imageView)
        
        
        
        
        let locationView = UIView()
        locationView.frame = CGRect(x:20, y:75, width:footerView3.frame.size.width-40, height:100)
        locationView.backgroundColor=#colorLiteral(red: 0.3215386271, green: 0.3215884566, blue: 0.3215229511, alpha: 1)
        locationView.layer.cornerRadius=8.0
        footerView3.addSubview(locationView)
        
        
        let titlelab2 = UILabel()
        titlelab2.frame = CGRect(x:10, y:5, width:locationView.frame.size.width-20, height:40)
        titlelab2.numberOfLines=0
        titlelab2.text="Move the map to approximate location or search for places below"
        titlelab2.font =  UIFont(name:"Helvetica", size: 14)
        titlelab2.textColor=UIColor.white
        titlelab2.textAlignment = .center
        locationView.addSubview(titlelab2)
        
        
        locationlab.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationlab.numberOfLines=0
        locationlab.backgroundColor=UIColor.white
        locationlab.text = self.citylab.text!
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(VolinteerVC.locationButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        locationView.addSubview(locationbutt)
        
        
        
        let uselocation = UIView()
        uselocation.frame = CGRect(x:5, y:footerView3.frame.size.height-45, width:footerView3.frame.size.width-10, height:40  )
        uselocation.backgroundColor=#colorLiteral(red: 0.9528647065, green: 0.009665175341, blue: 0.3223749697, alpha: 1)
        uselocation.layer.cornerRadius=4.0
        footerView3.addSubview(uselocation)
        
        let uselab = UILabel()
        uselab.frame = CGRect(x:10, y:0, width:uselocation.frame.size.width-20, height:40)
        uselab.numberOfLines=0
        uselab.text="Use this location"
        uselab.font =  UIFont(name:"Helvetica", size: 16)
        uselab.textColor=UIColor.white
        uselab.textAlignment = .center
        uselocation.addSubview(uselab)
        
        let Uselocationbutt = UIButton()
        Uselocationbutt.frame = CGRect(x:0, y:0, width:uselocation.frame.size.width, height:40)
        Uselocationbutt.addTarget(self, action: #selector(VolinteerVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        uselocation.addSubview(Uselocationbutt)
        
        
        
        let NotifyMe = UIView()
        NotifyMe.frame = CGRect(x:footerView3.frame.size.width/2-55  , y:footerView3.frame.size.height-80, width:110, height:30  )
        NotifyMe.backgroundColor=#colorLiteral(red: 0.2156647146, green: 0.2157005072, blue: 0.2156534195, alpha: 1)
        NotifyMe.layer.cornerRadius=4.0
        footerView3.addSubview(NotifyMe)
        
        var Currentimage : UIImageView
        Currentimage  = UIImageView(frame:CGRect(x:5, y:5, width:20, height:20));
        Currentimage.image = UIImage(named:"ray.png")
        NotifyMe.addSubview(Currentimage)
        
        let Locatemelab = UILabel()
        Locatemelab.frame = CGRect(x:30, y:5, width:75, height:20)
        Locatemelab.numberOfLines=0
        Locatemelab.text="Locate me"
        Locatemelab.font =  UIFont(name:"Helvetica", size: 14)
        Locatemelab.textColor=UIColor.white
        Locatemelab.textAlignment = .center
        NotifyMe.addSubview(Locatemelab)
        
        let locatemebutt = UIButton()
        locatemebutt.frame = CGRect(x:0, y:0, width:NotifyMe.frame.size.width, height:30)
        locatemebutt.addTarget(self, action: #selector(VolinteerVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        NotifyMe.addSubview(locatemebutt)
    }
    
    
    
    func CloseButtonAction2(_ sender: UIButton!)
    {
        tabBarController?.tabBar.isHidden=false
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    func locationButtonAction2(_ sender: UIButton!)
    {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        present(navigationController, animated: true, completion: { _ in })
    }
    
    
    func UselocationButtonAction(_ sender: UIButton!)
    {
        tabBarController?.tabBar.isHidden=false
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    func locatemeButtonAction(_ sender: UIButton!)
    {
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        self.mapView2.animate(to: camera)

        self.setUsersClosestCity()
    }

    
    
    
    // MARK: Cancel Button Action :
    func cancelButtonAction(_ sender: UIButton!)
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    
    // MARK: Done Button Action :
    func VolunteerDoneButtonAction(_ sender: UIButton!)
    {
        if switchlab.isOn
        {
            var message = String()
            if ((TextDescription.text?.isEmpty)! || TextDescription.text! == "Enter your text here..")
            {
                message = "Please enter description"
            }
            else if (strfoodbankname == "")
            {
                message = "Please Select Foodbank"
            }
            
            if message.characters.count > 1
            {
                AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            }
            else
            {
              //  let strlat = "\(firstLatitude)"
              //  let strlong = "\(firstLongitude)"
                
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                PostDataValus.setValue(strUserID, forKey: "user_id")
                PostDataValus.setValue("1", forKey: "connect_foodbank")
                PostDataValus.setValue(strFoodbankId, forKey: "foodbank_id")
              //  PostDataValus.setValue(citylab.text!, forKey: "address")
                PostDataValus.setValue(TextDescription.text!, forKey: "description")
              //  PostDataValus.setValue(strlat, forKey: "lat")
              //  PostDataValus.setValue(strlong, forKey: "long")
                
                
                
                var jsonStringValues = String()
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
                if jsonData == nil {
                    
                }
                else {
                    jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
                    print("jsonString: \(jsonStringValues)")
                }
                
                
                
                print(jsonStringValues)
                
                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"addVolunteer") , params: jsonStringValues)
            }
        }
        else
        {
            var message = String()
            if ((TextDescription.text?.isEmpty)! || TextDescription.text! == "Enter your text here..")
            {
                message = "Please enter description"
            }
            if message.characters.count > 1
            {
                AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            }
            else
            {
                let strlat = "\(firstLatitude)"
                let strlong = "\(firstLongitude)"
                
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                PostDataValus.setValue(strUserID, forKey: "user_id")
                PostDataValus.setValue("0", forKey: "connect_foodbank")
                PostDataValus.setValue("", forKey: "foodbank_id")
                PostDataValus.setValue(citylab.text!, forKey: "address")
                PostDataValus.setValue(TextDescription.text!, forKey: "description")
                PostDataValus.setValue(strlat, forKey: "lat")
                PostDataValus.setValue(strlong, forKey: "long")
                
                
                
                var jsonStringValues = String()
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
                if jsonData == nil {
                    
                }
                else {
                    jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
                    print("jsonString: \(jsonStringValues)")
                }
                
                
                
                print(jsonStringValues)
                
                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"addVolunteer") , params: jsonStringValues)
            }
        }
    }
    
    
    @objc private  func BecomeVolunteerAPIMethod (baseURL:String , params: String)
    {
        print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.popview.isHidden=true
                    self.footerView.isHidden=true
                    self.ValunteerButt.isHidden=true
                    self.ValunteerButt2.isHidden=false
                    
                    self.strvalinter = "1"
                    
                    UserDefaults.standard.set(self.strvalinter, forKey: "volunteerstatus")
                    
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
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
    

    
    
    
    func setUsersClosestCity()
    {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
//        geoCoder.reverseGeocodeLocation(location)
//        {
//            (placemarks, error) -> Void in
//            if ((error) != nil)
//            {
//                self.citylab.text! = ""
//                print("Locarion Error :\((error?.localizedDescription)! as String)")
//                //     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
//            }
//            else{
//                let placeArray = placemarks as [CLPlacemark]!
//                var placeMark: CLPlacemark!
//                placeMark = placeArray?[0]
//                
//                if placeMark.isoCountryCode != nil
//                {
//                    let locationNameFul =
//                        String(format:"%@, %@",placeMark.subLocality! as String,placeMark.locality! as String)
//                    
//                    self.citylab.text! = locationNameFul
//                }
//            }
//        }
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
                
                self.citylab.text! = formattedAddress.joined(separator: ", ")
                self.locationlab.text = formattedAddress.joined(separator: ", ")
            }
            
        })

    }

    

    
//  MARK: searchbar Delegates and Datasource:
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let str = searchText
        var encodeUrl = String()
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let escapedString = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            encodeUrl = escapedString
        }
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(currentLatitude)&long=\(currentLongitude)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchFoodbank",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.arrChildCategory.removeAllObjects()
                    self.arrChildCategory = (responceDic.object(forKey: "foodbankList") as? NSArray)! as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.volunterFbTblView.reloadData()
                }
                else
                {
                    self.arrChildCategory.removeAllObjects()
                    self.volunterFbTblView.reloadData()
                    
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
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        theSearchBar?.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }

    
    
    
  //  MARK: TableView Delegates and Datasource:
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
             return 70
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            if volunterFbTblView.tag == 2
            {
                return searchResults.count
            }
            else {
                return arrChildCategory.count
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cellIdetifier: String = "Cell"
            Fbcell = UITableViewCell(style: .default, reuseIdentifier: cellIdetifier)
            
            if volunterFbTblView.tag == 2
            {
                let titlelab = UILabel()
                titlelab.frame = CGRect(x:15, y:5, width:((Fbcell?.frame.size.width)!-30), height:20)
                titlelab.text=(self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
                titlelab.font =  UIFont(name:"Helvetica", size: 15)
                titlelab.textColor=UIColor.black
                titlelab.textAlignment = .left
                Fbcell?.addSubview(titlelab)
                
                
                let addresslab = UILabel()
                addresslab.frame = CGRect(x:15, y:titlelab.frame.size.height+titlelab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
                addresslab.text=(self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as? String
                addresslab.font =  UIFont(name:"Helvetica", size: 15)
                addresslab.textColor=UIColor.black
                addresslab.textAlignment = .left
                Fbcell?.addSubview(addresslab)
                
                
                let Distancelab = UILabel()
                Distancelab.frame = CGRect(x:15, y:addresslab.frame.size.height+addresslab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
                if let quantity = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? NSNumber
                {
                    
                    let strval = String(describing: quantity)
                    Distancelab.text = String(format:"%@ Kms", strval)
                    
                }
                else if let quantity = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? String
                {
                    Distancelab.text = String(format:"%@ Kms", quantity)
                    
                }
                //    Distancelab.text =  String(format: "%@ Kms ",((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? NSNumber)!)
                Distancelab.font =  UIFont(name:"Helvetica", size: 15)
                Distancelab.textColor=UIColor.black
                Distancelab.textAlignment = .left
                Fbcell?.addSubview(Distancelab)
            }
            else
            {
                let titlelab = UILabel()
                titlelab.frame = CGRect(x:15, y:5, width:((Fbcell?.frame.size.width)!-30), height:20)
                titlelab.text=(self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
                titlelab.font =  UIFont(name:"Helvetica", size: 15)
                titlelab.textColor=UIColor.black
                titlelab.textAlignment = .left
                Fbcell?.addSubview(titlelab)
                
                let addresslab = UILabel()
                addresslab.frame = CGRect(x:15, y:titlelab.frame.size.height+titlelab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
                addresslab.text=(self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as? String
                addresslab.font =  UIFont(name:"Helvetica", size: 15)
                addresslab.textColor=UIColor.black
                addresslab.textAlignment = .left
                Fbcell?.addSubview(addresslab)
                
                
                let Distancelab = UILabel()
                Distancelab.frame = CGRect(x:15, y:addresslab.frame.size.height+addresslab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
                if let quantity = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? NSNumber
                {
                    
                    let strval = String(describing: quantity)
                    Distancelab.text = String(format:"%@ Kms", strval)
                    
                }
                else if let quantity = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? String
                {
                    Distancelab.text = String(format:"%@ Kms", quantity)
                    
                }
                //Distancelab.text =  String(format: "%@ Kms ",((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? NSNumber)!)
                Distancelab.font =  UIFont(name:"Helvetica", size: 15)
                Distancelab.textColor=UIColor.black
                Distancelab.textAlignment = .left
                Fbcell?.addSubview(Distancelab)
            }
            return Fbcell!
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if volunterFbTblView.tag == 2
            {
                foodbankNamelab.text = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
                strfoodbankname = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString
                strFoodbankId = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! NSString
                
                popview2.isHidden=true
                footerView2.isHidden=true
                
                self.arrChildCategory.removeAllObjects()
                self.searchResults.removeAllObjects()
                volunterFbTblView.removeFromSuperview()
            }
            else
            {
                foodbankNamelab.text = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
                strfoodbankname = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString
                strFoodbankId = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! NSString
                
                popview2.isHidden=true
                footerView2.isHidden=true
                
                self.arrChildCategory.removeAllObjects()
                self.searchResults.removeAllObjects()
                volunterFbTblView.removeFromSuperview()
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
                //    loadLbl.text = "No More List"
                //   actInd.stopAnimating()
            }
            else
            {
                let strkey = Constants.ApiKey
                
                
                let str:String = theSearchBar?.text ?? ""
                var encodeUrl = String()
                let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
                if let escapedString = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    encodeUrl = escapedString
                }
                
                let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(currentLatitude)&long=\(currentLongitude)&page=\(self.strpage)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchFoodbank",params)
                
                print(baseURL)
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        //  print(responceDic)
                        if (responceDic.object(forKey: "status") as! NSNumber) == 1
                        {
                            self.responsewithToken8(responceDic)
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
    
    func responsewithToken8(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "foodbankList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.arrChildCategory.addObjects(from: arr as [AnyObject])
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
        self.volunterFbTblView.reloadData()
        
    }
    

    
    @IBAction func addGroupBtnAction(_ sender: Any)
    {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension VolinteerVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView.delegate = self;
        
        
        firstLatitude=position.target.latitude
        firstLongitude=position.target.longitude
        
        
        self.citylab.text! = "Featching Address..."
        locationlab.text = "Featching Address..."
        
        self.marker.position = CLLocationCoordinate2D(latitude: firstLatitude, longitude: firstLongitude)
        self.marker.map = self.mapView
        
        camera = GMSCameraPosition.camera(withLatitude: firstLatitude, longitude: firstLongitude, zoom: 8.0)
        self.mapView.animate(to: camera)
        
        
        let location = CLLocation(latitude: firstLatitude, longitude: firstLongitude)
        
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    
    private func mapView(mapView:GMSMapView!,idleAtCameraPosition position:GMSCameraPosition!)
    {
        print(position)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
             self.citylab.text! = "Unable to Find Address for Location"
            locationlab.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.citylab.text! = placemark.compactAddress!
                locationlab.text = placemark.compactAddress!
                print( self.citylab.text!)
            } else {
                 self.citylab.text! = "No Matching Addresses Found"
                locationlab.text = "No Matching Addresses Found"
            }
        }
    }
}



extension VolinteerVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        citylab.text=place.formatted_address
        locationlab.text = place.formatted_address
        firstLatitude=place.location.coordinate.latitude
        firstLongitude=place.location.coordinate.longitude
        
        
        //        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        //        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView3.frame.size.width, height: footerView3.frame.size.height), camera: camera)
        //        mapView2.delegate = self
        //        self.mapView2.settings.compassButton = true
        //        footerView3.addSubview(mapView2)
        
        // self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView2.delegate = self
        mapView2.camera=camera
        
        // mapView.reloadInputViews()
    }
}

extension VolinteerVC: SWRevealViewControllerDelegate
{
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
    
    func revealController(_ revealController: SWRevealViewController, didMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
}


