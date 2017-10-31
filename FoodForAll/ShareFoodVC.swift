//
//  ShareFoodVC.swift
//  FoodForAll
//
//  Created by amit on 4/25/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation




class ShareFoodVC: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate,CLLocationManagerDelegate
{
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    @IBOutlet weak var foodShareBackView: UIView!
    var cell: FoodBankTebelCell!
    var FoodShareTableView = UITableView()
    @IBOutlet weak var segemnetBtn: UISegmentedControl!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var alertCtrl2: UIAlertController?
    var listArrayFoodShare = NSMutableArray()
    var listSeconds = NSArray()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var refreshTimer = Timer()
    var timerArr : NSMutableArray = []
    var secondsArr : NSMutableArray  = []
    var expireArr : NSMutableArray  = []
    var dict : NSDictionary  = [:]
    var locationManager = CLLocationManager()
    var value = NSString()
    
    var frontView = UIView()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var UserID = NSString()
    
    var Stringlab = UILabel()
    var DeviceToken=String()
    
    var Uselocationbutt = UIButton()
    var Uselocationbutt2 = UIButton()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
          //  NotificationButton.isHidden = true
        }
        


        
        
        self.tabBarController?.tabBar.isHidden = false
        
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

         self.revealViewController().delegate=self
        if revealViewController() != nil {
            
            revealViewController().rearViewRevealWidth = 260
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().delegate=self
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
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
                
              //  UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
                  UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                alertController.dismiss(animated: true, completion: nil)
            })
            
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        
       
        
        self.getAllShareMealAPImethod()
        
        
        perform(#selector(ShareFoodVC.showTableView), with: nil, afterDelay: 0.02)
        perform(#selector(ShareFoodVC.showMapView), with: nil, afterDelay: 0.02)
        
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
    
    func handleMaps() {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/google-maps-navigation-transport/id585027354?mt=8")!, options: [:], completionHandler: nil)
    }

    
    func validateTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableCells), userInfo: nil, repeats: true)
    }
    
    func reloadTableCells(_ timer: Timer) {
        for cell: UITableViewCell in FoodShareTableView.visibleCells {
            let path: IndexPath? = FoodShareTableView.indexPath(for: cell)
            if (path?.row)! < self.listArrayFoodShare.count {
                Timemanager.configureCell(cell, withTimerArr: timerArr, withSecondsArr: secondsArr, forAt: path)
            }
        }
    }
    
    
    
    @IBAction func NotificationButtonClicked(_ sender: Any)
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=get_user_notification&gcm_id=\(DeviceToken)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationlistViewController") as? NotificationlistViewController
                    myVC?.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.listArrayFoodBank = responceDic.object(forKey: "List") as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    myVC?.strpage = String(describing: number)
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

        
        self.lastCount = 1
        
        self.revealViewController().delegate=self
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        frontView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        
        self.navigationController?.isNavigationBarHidden = true
        Stringlab.isHidden=true;
        self.getAllShareMealAPImethod()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK:  getAllFoodBanksAPImethod
    
    func getAllShareMealAPImethod () -> Void
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=allsharemeal&user_id=\(strUserID)&lat=\(currentLatitude)&longt=\(currentLongitude)"
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                    self.timerArr.removeAllObjects()
                    self.secondsArr.removeAllObjects()
                    self.listArrayFoodShare.removeAllObjects()
                
                    self.Stringlab.isHidden=true
                    self.FoodShareTableView.isHidden=false
                    
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                   
                    
                    self.listArrayFoodShare = (responceDic.object(forKey: "sharemeallist") as? NSArray)! as! NSMutableArray
                    self.listArrayFoodShare=self.listArrayFoodShare as AnyObject as! NSMutableArray
                    self.listSeconds=(responceDic.object(forKey: "sharemeallist") as? NSArray)!
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        let doubleLat = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                        let doubleLong = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                        
                        let str: NSString = (self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "lat") as! String as NSString
                        
                        if str == ""
                        {
                        
                        }
                        else
                        {
                        self.marker = GMSMarker()
                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                        self.marker.title = ((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                        self.marker.userData = self.listArrayFoodShare.object(at: i) as? NSDictionary
                        self.marker.icon = UIImage(named: "map_pin36.png")!.withRenderingMode(.alwaysTemplate)
                        self.marker.map = self.mapView
                        }
                    }

            
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        var newDate: Date?
                        var value = NSNumber()
                        value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                        newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                        
                      
                        self.timerArr.add(newDate!)
                        self.secondsArr.add(newDate!)
                    }
                    
                    print(self.timerArr)
                    print(self.secondsArr)
                    
                   
                    
                    self.FoodShareTableView.reloadData()
                    
                     self.validateTimer()
                    
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                     self.listArrayFoodShare.removeAllObjects()
                    if Message == "share meal list not found."
                    {
                        if self.segemnetBtn.selectedSegmentIndex == 0 {
                            
                            self.FoodShareTableView.isHidden=false
                            self.mapView.isHidden=true
                            self.Uselocationbutt2.isHidden=true
                            
                            if self.listArrayFoodShare.count == 0
                            {
                                self.Stringlab.text="No List"
                                self.Stringlab.isHidden=false
                                self.FoodShareTableView.isHidden=true
                            }
                        }
                        else if self.segemnetBtn.selectedSegmentIndex == 1 {
                            self.FoodShareTableView.isHidden=true
                            self.mapView.isHidden=false
                            self.Uselocationbutt2.isHidden=false
                            
                            self.Stringlab.text=""
                            self.Stringlab.isHidden=true
                            
                            if self.listArrayFoodShare.count == 0
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
        
        
    }
    

    
    func showMapView()
    {
        Stringlab.text=""
        Stringlab.isHidden=true
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 5.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.foodShareBackView.frame.size.width, height: self.foodShareBackView.frame.size.height), camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.foodShareBackView.addSubview(mapView)
        self.mapView.isHidden=true
        
        //self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
    }
    
    
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        let markerDataAry: NSDictionary = marker.userData as! NSDictionary
        
        
        
        let  view = UIView()
        view.frame = CGRect(x:0, y:70, width:300, height:110)
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
        titlelabtext.text = String(format: ": %@", markerDataAry.object(forKey: "meal_title") as! CVarArg)
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
        Distancelabtext.text = String(format: ": %@ kms", markerDataAry.object(forKey: "distances") as! CVarArg)
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
        Directionlongitude = markerDataAry.object(forKey: "longt") as! String as NSString
        
        
        Uselocationbutt.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height-65)
        Uselocationbutt.addTarget(self, action: #selector(ShareFoodVC.multipleParamSelector(_:markerDataAry:)), for: .touchUpInside)
        view.addSubview(Uselocationbutt)
        
        
        Uselocationbutt2.frame = CGRect(x:self.view.frame.size.width-45, y:self.view.frame.size.height-90, width:35, height:35)
        Uselocationbutt2.setImage(#imageLiteral(resourceName: "google-2.png"), for: UIControlState.normal)
        Uselocationbutt2.addTarget(self, action: #selector(ShareFoodVC.multipleParamSelector2(_:markerDataAry:)), for: .touchUpInside)
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
            
            myVC?.foodbankID = markerDataAry.object(forKey: "fbank_id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "percentage") as! String
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = markerDataAry.object(forKey: "fbank_id") as! String
            myVC?.percentStr = markerDataAry.object(forKey: "percentage") as! String
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
        
        let idStr : String = markerDataAry.value(forKey: "share_meal_id") as! String
        
        print(idStr)
        
        
        let userID:String = markerDataAry.value(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            myVC?.SharedMealID=idStr as String
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        else
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
             myVC?.SharedMealID=idStr as String
            self.navigationController?.pushViewController(myVC!, animated: true)
        }

    }
    
    

    
    
    func showTableView()
    {
        FoodShareTableView.frame = CGRect(x:0, y:0, width:foodShareBackView.frame.size.width, height:foodShareBackView.frame.size.height)
        FoodShareTableView.delegate=self
        FoodShareTableView.dataSource=self
        FoodShareTableView.estimatedRowHeight = 120
        self.FoodShareTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        foodShareBackView.addSubview(FoodShareTableView)
    }

    
    
    // MARK:  LocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations.last!
        currentLatitude = (userLocation.coordinate.latitude)
        currentLongitude = (userLocation.coordinate.longitude)
        
        locationManager.stopUpdatingHeading()
        
        //print(currentLatitude,currentLongitude)
    }
    
    // MARK: 
    
    
    @IBAction func segmentShareBtnAction(_ sender: Any) {
        
        if segemnetBtn.selectedSegmentIndex == 0 {
            
            self.FoodShareTableView.isHidden=false
            self.mapView.isHidden=true
             Uselocationbutt2.isHidden=true
            
            if self.listArrayFoodShare.count == 0
            {
                Stringlab.text="No List"
                Stringlab.isHidden=false
                self.FoodShareTableView.isHidden=true
            }
        }
        else if segemnetBtn.selectedSegmentIndex == 1 {
            self.FoodShareTableView.isHidden=true
            self.mapView.isHidden=false
             Uselocationbutt2.isHidden=false
            
            Stringlab.text=""
            Stringlab.isHidden=true
            
            if self.listArrayFoodShare.count == 0
            {
                self.mapView.clear()
                
            }

        }
    }
    
    
    
    
    
    
    //MARK: TableView Delegates and Datasource:
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listArrayFoodShare.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "FoodBankTebelCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FoodBankTebelCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "FoodBankTebelCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FoodBankTebelCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_meal_image") as! String
        let url = NSURL(string:imageURL)
        cell.foodbankImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        cell.foodbankName.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "meal_title") as! String
        cell.foodBankUserName.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "username") as! String
        cell.foodbankCity.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
        cell.foodbankDistance.text! = String(format:"%@ kms",(self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "distances") as! String)
       
        cell.categeory.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as! String
        cell.Quantity.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "no_of_meal_hidden") as! String
        
        
        let Subcategeory: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_name") as! String
        if Subcategeory == ""
        {
             cell.subCategeory.text! = "Food4All"
        }
        else
        {
             cell.subCategeory.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_name") as! String
        }
        
        
        let categeory: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_image") as! String
        let url2 = NSURL(string:categeory)
        cell.SubCategeoryImage.sd_setImage(with: (url2)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        
        let categeory2: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_image") as! String
        let url3 = NSURL(string:categeory2)
        cell.CategeoryImage.sd_setImage(with: (url3)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        Timemanager.configureCell(cell, withTimerArr: timerArr, withSecondsArr: secondsArr, forAt: indexPath)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        value=(self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_meal_id") as! String as NSString
        
        print(value)
        
        let userID:String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            myVC?.SharedMealID=value as String
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            myVC?.SharedMealID=value as String
            self.navigationController?.pushViewController(myVC!, animated: true)
        }

//        self.FoodShareDetailsAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=get_sharemeal&share_meal_id=\(value)&lat=\(currentLatitude)&longt=\(currentLongitude)")
    }
    

    
    @objc private   func FoodShareDetailsAPIMethod (baseURL:String , params: String)
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
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
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
                
                let baseURL: String  = String(format:"%@",Constants.mainURL)
                let params = "method=allsharemeal&user_id=\(strUserID)&lat=\(currentLatitude)&longt=\(currentLongitude)&page=\(strpage)"
                
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
    
    func responsewithToken6(_ responseDict: NSDictionary) {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        if count == 1 {
            count = 2
            if (strpage == "2") {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "sharemeallist") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                
                self.timerArr.removeAllObjects()
                self.secondsArr.removeAllObjects()
            
                for i in 0..<self.listArrayFoodShare.count
                {
                    let doubleLat = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                    let doubleLong = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                    
                    self.marker.map = nil
                    self.marker = GMSMarker()
                    self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                    self.marker.title = ((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                    self.marker.userData = self.listArrayFoodShare.object(at: i) as? NSDictionary
                    self.marker.icon = UIImage(named: "map_pin36.png")!.withRenderingMode(.alwaysTemplate)
                    self.marker.map = self.mapView
                }
                
                for i in 0..<self.listArrayFoodShare.count
                {
                    var newDate: Date?
                    var value = NSNumber()
                    value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                    
                    
                    self.timerArr.add(newDate!)
                    self.secondsArr.add(newDate!)
                }
                self.validateTimer()
                
                self.FoodShareTableView.reloadData()

            }
            else
            {
                
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
                    arr = (responseDictionary.value(forKey: "sharemeallist") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                    
                    
                    self.timerArr.removeAllObjects()
                    self.secondsArr.removeAllObjects()
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        let doubleLat = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                        let doubleLong = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                        
                        self.marker.map = nil
                        self.marker = GMSMarker()
                        self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                        self.marker.title = ((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                        self.marker.userData = self.listArrayFoodShare.object(at: i) as? NSDictionary
                        self.marker.icon = UIImage(named: "map_pin36.png")!.withRenderingMode(.alwaysTemplate)
                        self.marker.map = self.mapView
                    }
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        var newDate: Date?
                        var value = NSNumber()
                        value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                        newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                        
                        
                        self.timerArr.add(newDate!)
                        self.secondsArr.add(newDate!)
                    }
                    self.validateTimer()
                    
                    self.FoodShareTableView.reloadData()
                    
                    
                    
                    lastCount = 2
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "sharemeallist") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                
                self.timerArr.removeAllObjects()
                self.secondsArr.removeAllObjects()
                
                for i in 0..<self.listArrayFoodShare.count
                {
                    let doubleLat = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "lat") as! String)
                    let doubleLong = Double((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "longt") as! String)
                    
                    self.marker.map = nil
                    self.marker = GMSMarker()
                    self.marker.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                    self.marker.title = ((self.listArrayFoodShare.object(at: i) as! NSDictionary).value(forKey: "address") as! String)
                    self.marker.userData = self.listArrayFoodShare.object(at: i) as? NSDictionary
                    self.marker.icon = UIImage(named: "map_pin36.png")!.withRenderingMode(.alwaysTemplate)
                    self.marker.map = self.mapView
                }
                
                for i in 0..<self.listArrayFoodShare.count
                {
                    var newDate: Date?
                    var value = NSNumber()
                    value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                    
                    
                    self.timerArr.add(newDate!)
                    self.secondsArr.add(newDate!)
                }
                self.validateTimer()
                
                self.FoodShareTableView.reloadData()
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
                    FoodShareTableView.tableFooterView = footerview2
                  //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
                   // loadLbl.text = "No More List"
                  //  actInd.stopAnimating()
                }
                else {
                  //  FoodShareTableView.tableFooterView = footerview2
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
    
    
    
    

    
    
    
    
    
    @IBAction func addSharFdBnkBtnAction(_ sender: Any) {
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let baseURL: String  = String(format:"%@",Constants.mainURL)
            let params = "method=share_meal_category"
            print(params)
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                    print(responceDic)
                    
                    if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SetpOneViewController") as? SetpOneViewController
                        myVC?.hidesBottomBarWhenPushed=true
                        myVC?.arrChildCategory = (responceDic.value(forKey: "categoryList") as? NSMutableArray)!
                        self.navigationController?.pushViewController(myVC!, animated: true)
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
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            proVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(proVC, animated: true)
        }
    
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


extension ShareFoodVC: SWRevealViewControllerDelegate
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

