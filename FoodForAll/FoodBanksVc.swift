   //
//  FoodBanksVc.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class FoodBanksVc: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate,CLLocationManagerDelegate
{
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    @IBOutlet weak var foodBnkBackView: UIView!
    var cell: FBtableCell!
    var FoodBankTableView = UITableView()
    @IBOutlet weak var segemnetBtn: UISegmentedControl!
    @IBOutlet weak var setUpFoodBtnAction: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var alertCtrl2: UIAlertController?
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var locationManager = CLLocationManager()
    
    var listArrayFoodBank = NSMutableArray()
    //var listArrayFoodBank : NSMutableArray? = NSMutableArray()
    
    var myArray = NSDictionary()
    var strUserID = String()
    var UserID = NSString()
    
    var Stringlab = UILabel()
    var frontView = UIView()
    var strId = NSString()
    var Uselocationbutt = UIButton()
    var Uselocationbutt2 = UIButton()
    var DeviceToken=String()
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    
    var NoticationLab = UILabel()
    var NotificationButton = UIButton()
    
    
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
    var StrEditMode = String()
    
    
    //var Directionlatitude: Float = 0.0
    //var Directionlongitude: Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
        self.setupAlertCtrl2()
        
        Stringlab.frame = CGRect(x:self.view.frame.size.width/2-100, y:self.view.frame.size.height/2-10, width:200, height:20)
        Stringlab.backgroundColor = UIColor.clear
        Stringlab.text="No List"
        Stringlab.font =  UIFont(name:"Helvetica-Bold", size: 16)
        Stringlab.textColor=UIColor.black
        Stringlab.textAlignment = .center
        Stringlab.isHidden=true;
        self.view.addSubview(Stringlab)
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        
        
        NoticationLab = UILabel(frame: CGRect(x: CGFloat(self.view.frame.size.width - 32), y: CGFloat(18), width: CGFloat(24), height: CGFloat(24)))
        NoticationLab.backgroundColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0))
        NoticationLab.layer.masksToBounds = true
        NoticationLab.layer.cornerRadius = 12.0
        NoticationLab.textColor = UIColor.white
        NoticationLab.font = UIFont.systemFont(ofSize: CGFloat(11))
        NoticationLab.textAlignment = .center
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
            strUserID = ""
        }
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = "hgkdjsg"
        }

        
        
        if revealViewController() != nil {
            
            revealViewController().rearViewRevealWidth = 260
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().delegate=self
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                firstLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
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
        
       // self.getAllFoodBanksAPImethod()
        
        perform(#selector(FoodBanksVc.showTableView), with: nil, afterDelay: 0.02)
        perform(#selector(FoodBanksVc.showMapView), with: nil, afterDelay: 0.02)
        
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
    
    
    
    func setupAlertCtrl2() {
        alertCtrl2 = UIAlertController(title: "Please install Google Maps - Navigation & Transport app from iTunes store before Navigation", message: nil, preferredStyle: .actionSheet)
        //Create an action
        let Report = UIAlertAction(title: "Install", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.handleMaps()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: { _ in })
        })
        alertCtrl2?.addAction(Report)
        alertCtrl2?.addAction(cancel)
    }
    
    func handleMaps()
    {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/google-maps-navigation-transport/id585027354?mt=8")!, options: [:], completionHandler: nil)
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
        
          self.lastCount = 1
        
        self.getAllFoodBanksAPImethod()
        
         self.navigationController?.isNavigationBarHidden = true
        Stringlab.isHidden=true;
        
        self.tabBarController?.tabBar.isHidden = false
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
    

    
  @objc private  func showMapView()
  {
        Stringlab.text=""
        Stringlab.isHidden=true
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 5.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.foodBnkBackView.frame.size.width, height: self.foodBnkBackView.frame.size.height), camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.foodBnkBackView.addSubview(mapView)
        self.mapView.isHidden=true
        
       // self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        let markerDataAry: NSDictionary = marker.userData as! NSDictionary
        
        
        let  view = UIView()
        view.frame = CGRect(x:0, y:100, width:300, height:130)
        view.backgroundColor = UIColor.clear
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:5, y:5, width:view.frame.size.width-10, height:95)
        Headview.backgroundColor = UIColor.white
        view.addSubview(Headview)
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:10, y:5, width:60, height:20)
        titlelab.text = "Name"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 12)
        titlelab.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titlelab.textAlignment = .left
        Headview.addSubview(titlelab)
        
        let titlelabtext = UILabel()
        titlelabtext.frame = CGRect(x:70, y:5, width:Headview.frame.size.width-80, height:20)
        titlelabtext.text = String(format: ": %@", markerDataAry.object(forKey: "title") as! CVarArg)
        titlelabtext.font =  UIFont(name:"Helvetica", size: 12)
        titlelabtext.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        titlelabtext.textAlignment = .left
        Headview.addSubview(titlelabtext)
        
        let Distancelab = UILabel()
        Distancelab.frame = CGRect(x:10, y:titlelab.frame.size.height+titlelab.frame.origin.y+1, width:60, height:20)
        Distancelab.text = "Distance"
        Distancelab.font =  UIFont(name:"Helvetica-Bold", size: 12)
        Distancelab.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Distancelab.textAlignment = .left
        Headview.addSubview(Distancelab)
        
        let Distancelabtext = UILabel()
        Distancelabtext.frame = CGRect(x:70, y:titlelab.frame.size.height+titlelab.frame.origin.y+1, width:Headview.frame.size.width-80, height:20)
        if let quantity = markerDataAry.object(forKey: "distance") as? NSNumber
        {
            Distancelabtext.text =  String(format: ": %@ Kms",String(describing: quantity))
        }
        else if let quantity = markerDataAry.object(forKey: "distance") as? String
        {
            Distancelabtext.text = String(format: ": %@ Kms",quantity)
        }
       // Distancelabtext.text = String(format: ": %@ kms", markerDataAry.object(forKey: "distance") as! CVarArg)
        Distancelabtext.font =  UIFont(name:"Helvetica", size: 12)
        Distancelabtext.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Distancelabtext.textAlignment = .left
        Headview.addSubview(Distancelabtext)
        
        let locationlab = UILabel()
        locationlab.frame = CGRect(x:10, y:Distancelab.frame.size.height+Distancelab.frame.origin.y+1, width:60, height:20)
        locationlab.text = "Location"
        locationlab.font =  UIFont(name:"Helvetica-Bold", size: 12)
        locationlab.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationlab.textAlignment = .left
        Headview.addSubview(locationlab)
        
        let Loccoltext = UILabel()
        Loccoltext.frame = CGRect(x:70, y:Distancelab.frame.size.height+Distancelab.frame.origin.y+1, width:2, height:20)
        Loccoltext.text = String(format: ":")
        Loccoltext.font =  UIFont(name:"Helvetica", size: 12)
        Loccoltext.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Loccoltext.numberOfLines=0
        Loccoltext.textAlignment = .left
        Headview.addSubview(Loccoltext)
        
        let Locationlabtext = UITextView()
        Locationlabtext.frame = CGRect(x:73, y:Distancelab.frame.size.height+Distancelab.frame.origin.y-5, width:Headview.frame.size.width-80, height:50)
        Locationlabtext.text = String(format: "%@", markerDataAry.object(forKey: "address") as! CVarArg)
        Locationlabtext.font =  UIFont(name:"Helvetica", size: 12)
        Locationlabtext.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Locationlabtext.isScrollEnabled=false
        Locationlabtext.textAlignment = .left
        Headview.addSubview(Locationlabtext)
        
        
        let getDirectionlab = UILabel()
        getDirectionlab.frame = CGRect(x:10, y:Locationlabtext.frame.size.height+Locationlabtext.frame.origin.y+5, width:120, height:15)
        getDirectionlab.text = "Get Directions"
        getDirectionlab.font =  UIFont(name:"Helvetica-Bold", size: 12)
        getDirectionlab.textColor=#colorLiteral(red: 0.1807585061, green: 0.6442081332, blue: 0.8533658385, alpha: 1)
        getDirectionlab.textAlignment = .left
        getDirectionlab.isHidden=true
        Headview.addSubview(getDirectionlab)
        
        let linelab = UILabel()
        linelab.frame = CGRect(x:11, y:getDirectionlab.frame.size.height+getDirectionlab.frame.origin.y+1, width:85, height:2)
        linelab.backgroundColor=#colorLiteral(red: 0.1807585061, green: 0.6442081332, blue: 0.8533658385, alpha: 1)
        linelab.isHidden=true
        Headview.addSubview(linelab)
        
        let downImage = UIImageView()
        downImage.frame = CGRect(x:Headview.frame.size.width/2-5, y:Headview.frame.size.height+Headview.frame.origin.y-5, width:20, height:20)
        downImage.image = UIImage(named: "down-arrow-2.png")
        downImage.contentMode = .scaleAspectFit
        view.addSubview(downImage)
        
        Directionlatitude = markerDataAry.object(forKey: "lat") as! String as NSString
        Directionlongitude = markerDataAry.object(forKey: "long") as! String as NSString
        
    
        Uselocationbutt.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height-65)
        Uselocationbutt.addTarget(self, action: #selector(FoodBanksVc.multipleParamSelector(_:markerDataAry:)), for: .touchUpInside)
        view.addSubview(Uselocationbutt)
        
    
        Uselocationbutt2.frame = CGRect(x:self.view.frame.size.width-45, y:self.view.frame.size.height-90, width:35, height:35)
        Uselocationbutt2.setImage(#imageLiteral(resourceName: "google-2.png"), for: UIControlState.normal)
        Uselocationbutt2.addTarget(self, action: #selector(FoodBanksVc.multipleParamSelector2(_:markerDataAry:)), for: .touchUpInside)
        self.view.addSubview(Uselocationbutt2)
        
        return view
    }
    
    
    func multipleParamSelector(_ sender: AnyObject, markerDataAry: AnyObject)
    {
        let markerDataAry: NSDictionary = markerDataAry as! NSDictionary
        
        let userID:String = markerDataAry.object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = markerDataAry.object(forKey: "id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "capacity_status") as! String
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = markerDataAry.object(forKey: "id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "capacity_status") as! String
        }
    }
    
    func multipleParamSelector2(_ sender: AnyObject, markerDataAry: AnyObject)
    {
        let googleMapUrlString: String? = "comgooglemaps://?.saddr=\("")&daddr=\(Directionlatitude),\(Directionlongitude)&directionsmode=driving"
        let trimmedString: String? = googleMapUrlString?.replacingOccurrences(of: " ", with: "")
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: trimmedString!)!, options: [:], completionHandler: nil)
        }
        else {
            alertCtrl2?.popoverPresentationController?.sourceView = view
            present(alertCtrl2!, animated: true, completion: {() -> Void in
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        
        let markerDataAry: NSDictionary = marker.userData as! NSDictionary
        
        let userID:String = markerDataAry.object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = markerDataAry.object(forKey: "id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "capacity_status") as! String
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = markerDataAry.object(forKey: "id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "capacity_status") as! String
        }

    }

    
    @nonobjc func mapView(_ mapView: GMSMapView, didTapMarker marker: GMSMarker)
    {
       
    }

    
    
  @objc private  func showTableView()
    {
        FoodBankTableView.frame = CGRect(x:0, y:0, width:foodBnkBackView.frame.size.width, height:foodBnkBackView.frame.size.height)
        FoodBankTableView.delegate=self
        FoodBankTableView.dataSource=self
        FoodBankTableView.estimatedRowHeight = 112
        self.FoodBankTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        foodBnkBackView.addSubview(FoodBankTableView)
    }
    
// MARK:  LocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations.last!
        currentLatitude = (userLocation.coordinate.latitude)
        currentLongitude = (userLocation.coordinate.longitude)
        
        locationManager.stopUpdatingHeading()
        
        //print(currentLatitude,currentLongitude)
    }
    
// MARK:  SegmentBtn Action:
    
    @IBAction func segmentBtnAction(_ sender: Any) {
        
        if segemnetBtn.selectedSegmentIndex == 0
        {
            self.FoodBankTableView.isHidden=false
            self.mapView.isHidden=true
            Uselocationbutt2.isHidden=true
            
            if self.listArrayFoodBank.count == 0
            {
                Stringlab.text="No List"
                Stringlab.isHidden=false
                self.FoodBankTableView.isHidden=true
            }
        
        }
        else if segemnetBtn.selectedSegmentIndex == 1 {
            self.FoodBankTableView.isHidden=true
            self.mapView.isHidden=false
            Uselocationbutt2.isHidden=false
            
            Stringlab.text=""
            Stringlab.isHidden=true
            
            if self.listArrayFoodBank.count == 0
            {
               self.mapView.clear()
               
            }
        }
    }
    
    // MARK:  getAllFoodBanksAPImethod
    
    func getAllFoodBanksAPImethod () -> Void
    {
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=all_FoodBanks&lat=\(currentLatitude)&longt=\(currentLongitude)&user_id=\(strUserID)"
        
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listFoodbanks",params)
        
        print(baseURL)
        
        if self.listArrayFoodBank.count == 0
        {
           AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.listArrayFoodBank.removeAllObjects()
                    
                    self.Stringlab.isHidden=true
                    self.FoodBankTableView.isHidden=false
                    
                    self.listArrayFoodBank = ((responceDic.object(forKey: "foodbankList") as? NSArray)! as? NSMutableArray)!
                    //print(self.listArrayFoodBank )
                    self.listArrayFoodBank=self.listArrayFoodBank as AnyObject as! NSMutableArray
                    
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    
                    
                    for i in 0..<self.listArrayFoodBank.count
                    {
                        let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as? String ?? "")
                        let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "long") as? String ?? "")
                        
                        let str1 = (self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as? String ?? ""
                        let str2 = (self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "long") as? String ?? ""
                        
                        if str1 == "" || str2 == ""
                        {
                            
                        }
                        else
                        {
                        self.marker = GMSMarker()
                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                        self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as? String ?? "")
                        self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
                        self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
                        self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
                        self.marker.map = self.mapView
                        }
                    }
                    //   print(self.listArrayFoodBank)
                    
                    self.FoodBankTableView.reloadData()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    self.listArrayFoodBank.removeAllObjects()
                    
                    if Message == "No Foodbank found."
                    {
                        if self.segemnetBtn.selectedSegmentIndex == 0
                        {
                            self.FoodBankTableView.isHidden=false
                            self.mapView.isHidden=true
                            self.Uselocationbutt2.isHidden=true
                            
                            if self.listArrayFoodBank.count == 0
                            {
                                self.Stringlab.text="No List"
                                self.Stringlab.isHidden=false
                                self.FoodBankTableView.isHidden=true
                            }
                            
                        }
                        else if self.segemnetBtn.selectedSegmentIndex == 1 {
                            self.FoodBankTableView.isHidden=true
                            self.mapView.isHidden=false
                            self.Uselocationbutt2.isHidden=false
                            
                            self.Stringlab.text=""
                            self.Stringlab.isHidden=true
                            
                            if self.listArrayFoodBank.count == 0
                            {
                                self.mapView.clear()
                                
                            }
                        }
                        
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
//        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"all_FoodBanks")
//        let strkey = Constants.ApiKey
//        let params = "api_key=\(strkey)&lat=\(currentLatitude)&longt=\(currentLongitude)&user_id=\(strUserID)"
//
//
//      //  print(params)
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//              //  print(responceDic)
//
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    self.listArrayFoodBank.removeAllObjects()
//
//                    self.Stringlab.isHidden=true
//                    self.FoodBankTableView.isHidden=false
//
//                    self.listArrayFoodBank = ((responceDic.object(forKey: "FoodbankList") as? NSArray)! as? NSMutableArray)!
//                   //print(self.listArrayFoodBank )
//                    self.listArrayFoodBank=self.listArrayFoodBank as AnyObject as! NSMutableArray
//
//                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
//                    self.strpage = String(describing: number)
//
//
//
//                    for i in 0..<self.listArrayFoodBank.count
//                    {
//                        let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
//                        let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
//
//                        self.marker = GMSMarker()
//                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
//                        self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
//                        self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
//                        self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
//                        self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
//                        self.marker.map = self.mapView
//                    }
//                 //   print(self.listArrayFoodBank)
//
//                    self.FoodBankTableView.reloadData()
//                }
//                else
//                {
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
//                     self.listArrayFoodBank.removeAllObjects()
//
//                    if Message == "Foodbank list not found."
//                    {
//                        if self.segemnetBtn.selectedSegmentIndex == 0
//                        {
//                            self.FoodBankTableView.isHidden=false
//                            self.mapView.isHidden=true
//                            self.Uselocationbutt2.isHidden=true
//
//                            if self.listArrayFoodBank.count == 0
//                            {
//                                self.Stringlab.text="No List"
//                                self.Stringlab.isHidden=false
//                                self.FoodBankTableView.isHidden=true
//                            }
//
//                        }
//                        else if self.segemnetBtn.selectedSegmentIndex == 1 {
//                            self.FoodBankTableView.isHidden=true
//                            self.mapView.isHidden=false
//                            self.Uselocationbutt2.isHidden=false
//
//                            self.Stringlab.text=""
//                            self.Stringlab.isHidden=true
//
//                            if self.listArrayFoodBank.count == 0
//                            {
//                                self.mapView.clear()
//
//                            }
//                        }
//
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
        let identifier = "FBtableCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FBtableCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "FBtableCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FBtableCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        let imageURL: String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "header_image") as? String ?? ""
        if imageURL == ""
        {
            cell.imageViewUser.image = UIImage(named: "Logo")
        }
        else
        {
            let url = NSURL(string:imageURL)
            cell.imageViewUser.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
        }
        
        cell.foodBankName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String ?? ""
        
        
//        let foodbankManage = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_user") as? String ?? ""
//        if foodbankManage == "2"
//        {
//            let strname1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
//            let strname2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
//             cell.foodBnkUserName.text! = strname1+" "+strname2
//        }
//        else
//        {
//             cell.foodBnkUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
//        }
        
        let foodbankManage = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
        if foodbankManage == ""
        {
            let strname1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
            let strname2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
            cell.foodBnkUserName.text! = strname1+" "+strname2
        }
        else
        {
            cell.foodBnkUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
        }
        
        let straddress =  (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String ?? ""
        let stradd = straddress.replacingOccurrences(of: "\n", with: "")
        cell.locationLabel.text!  = stradd
      
        
        
        let sliderValue = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "capacity_status") as? String ?? ""
        if sliderValue == "" {
            cell.sliderFdBnk.value = 0
            cell.percentLbl.text! = "0"
        }else{
           cell.sliderFdBnk.value = Float(sliderValue)!
           cell.percentLbl.text! = String(format:"%@%@",sliderValue,"%")

        }
        
        if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? NSNumber
        {
              cell.milesLabel.text! =  String(format: "%@ Kms",String(describing: quantity))
        }
        else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance")  as? String
        {
              cell.milesLabel.text! = String(format: "%@ Kms",quantity)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userID:String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
            myVC?.percentStr = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "capacity_status") as! String
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
            myVC?.percentStr = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "capacity_status") as! String
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
                let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&page=\(self.strpage)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"listFoodbanks",params)
                
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
        arr = (responseDictionary.value(forKey: "foodbankList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
       
        
        
        for i in 0..<self.listArrayFoodBank.count
        {
            let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as? String ?? "")
            let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "long") as? String ?? "")
            
            let str1 = (self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as? String ?? ""
            let str2 = (self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "long") as? String ?? ""
            
            if str1 == "" || str2 == ""
            {
                
            }
            else
            {
                self.marker = GMSMarker()
                self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as? String ?? "")
                self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
                self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
                self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
                self.marker.map = self.mapView
            }
        }
        
        
        
    
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
         FoodBankTableView.reloadData()
     }
    
    
    
    
    func responsewithToken6(_ responseDict: NSDictionary) {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        if count == 1 {
            count = 2
            if (strpage == "2") {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                FoodBankTableView.reloadData()
                
                
                for i in 0..<self.listArrayFoodBank.count
                {
                    let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                    let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                    
                    self.marker.map = nil
                    self.marker = GMSMarker()
                    self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                    self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                    self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
                    self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
                    self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
                    self.marker.map = self.mapView
                }

                
                
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
                    arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                    FoodBankTableView.reloadData()
                    lastCount = 2
                    
                    for i in 0..<self.listArrayFoodBank.count
                    {
                        let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                        let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                        
                        self.marker.map = nil
                        self.marker = GMSMarker()
                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                        self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                        self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
                        self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
                        self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
                        self.marker.map = self.mapView
                    }

                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                FoodBankTableView.reloadData()
                
                for i in 0..<self.listArrayFoodBank.count
                {
                    let doubleLat = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                    let doubleLong = Double((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                    
                    self.marker.map = nil
                    self.marker = GMSMarker()
                    self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                    self.marker.title = ((self.listArrayFoodBank.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                    self.marker.infoWindowAnchor = CGPoint(x: CGFloat(0.45), y: CGFloat(0.45))
                    self.marker.userData = self.listArrayFoodBank.object(at: i) as? NSDictionary
                    self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
                    self.marker.map = self.mapView
                }
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
//                    FoodBankTableView.tableFooterView = footerview2
//                  //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
//                  //  loadLbl.text = "No More"
//                 //   actInd.stopAnimating()
//                }
//                else {
//                    FoodBankTableView.tableFooterView = footerview2
//                  //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.startAnimating()
//                }
//            }
//        }
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if scrool == 1 {
//          //  footerview2.isHidden = true
//           // loadLbl.isHidden = true
//        }
//    }

    
    
    
    
  
    @IBAction func setUpfoodBankBtnAction(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SetupFoodBankVC") as? SetupFoodBankVC
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
   

   extension FoodBanksVc: SWRevealViewControllerDelegate
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
        if position == FrontViewPositionLeft
        {
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

