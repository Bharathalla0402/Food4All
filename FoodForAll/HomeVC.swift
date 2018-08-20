//
//  HomeVC.swift
//  FoodForAll
//
//  Created by amit on 4/24/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage
import GoogleMaps
import GooglePlaces
import CoreLocation
import WebKit




class HomeVC: UIViewController,LCBannerViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIWebViewDelegate,UITextViewDelegate,UITextFieldDelegate {

    
    @IBOutlet weak var topView: UINavigationBar!
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
    
     var listArraySettings = NSDictionary()
    
    @IBOutlet weak var scrollViewHome: UIScrollView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageViewhome: UIView!
    @IBOutlet weak var navgivationView: UIView!
    
    @IBOutlet var playerView: YouTubePlayerView!
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var foodBankLabel: UILabel!
    @IBOutlet weak var foodShareLbl: UILabel!
    @IBOutlet weak var VolunteerLal: UILabel!
    @IBOutlet weak var AboutTitle: UILabel!
    @IBOutlet weak var Eventlabel: UILabel!
    @IBOutlet weak var MoreDetailLabel: UILabel!
    
    @IBOutlet weak var ValunteerButt: UIButton!
    @IBOutlet weak var FoodBankTabl: UITableView!
    @IBOutlet weak var FoodBankTablHeight: NSLayoutConstraint!
    @IBOutlet weak var EventsTabl: UITableView!
    @IBOutlet weak var EventTablHeight: NSLayoutConstraint!
    @IBOutlet weak var MoreDetailView: UIView!
   // @IBOutlet weak var videofromurl: VideoFromURL!
    
    @IBOutlet var TopVideoViewHeight: NSLayoutConstraint!
    @IBOutlet var NearFoodBankLab: UILabel!
    @IBOutlet var UpcomingEventLab: UILabel!
    @IBOutlet var NearFoodBankHeight: NSLayoutConstraint!
    @IBOutlet var UpcomingEventHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var FoodbankLab: UILabel!
    @IBOutlet weak var FoodShareLab: UILabel!
    @IBOutlet weak var EventsLab: UILabel!
    @IBOutlet weak var VolunteersLab: UILabel!
    
    
    var Foodcell: FBtableCell!
     var Eventcell: EventTableCell!
    
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
    
    
    
    
    var TextDescription = UITextView()
    var frontView = UIView()
    
    var myArray = NSDictionary()
    var strUserID = String()
    
    var DeviceToken=String()
    
    var strvalinter = String()
    
    
    var imagesArray = NSArray()
    var dataDic = NSDictionary()
    
    var NoticationLab = UILabel()
    var NotificationButton = UIButton()
    
    lazy var geocoder = CLGeocoder()
    
    
    var switchlab = UISwitch()
    var txtemailfield = UITextField()
    var Headview2 = UIView()
    var foodbanklistbutt = UIButton()
    var foodbankNamelab = UILabel()
    var strFoodbankId = NSString()
    var strChecklist = NSString()
    var strfoodbankname = NSString()
    
    var ValunteerButt2 = UIButton()
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    var listArrayFoodBank = NSMutableArray()
    var listArrayFoodEvent = NSMutableArray()
     var strpage = String()
     var strVideoUrl = String()
    var strwidth = String()
    
    var addressCheck = String()
    var popupcheck = String()
    var popview4 = UIView()
    var footerView4 = UIView()
    var updatelat = Double()
    var updatelong = Double()
    var CancelButton4 = UIButton()
    var DoneButton4 = UIButton()
    var forgotPassWordTF = ACFloatingTextfield()
    
    var popview5 = UIView()
    var footerView5 = UIView()
    var rememberButton = UIButton()
    var CancelButton5 = UIButton()
    var DoneButton5 = UIButton()
    
    @IBOutlet var VideoWebView: WKWebView!
    @IBOutlet weak var DataWebView: UIWebView!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDefaults: UserDefaults? = UserDefaults.standard
        currentDefaults?.set("yes", forKey: "txt")
        
        playerView.isHidden = true
        playButton.isHidden = true
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        
        FoodBankTabl.tag = 3
        EventsTabl.tag = 4
       
        FoodBankTabl.rowHeight = UITableViewAutomaticDimension
        FoodBankTabl.estimatedRowHeight = 160
        FoodBankTabl.tableFooterView = UIView()
        FoodBankTabl.separatorStyle = .none
        
        EventsTabl.rowHeight = UITableViewAutomaticDimension
        EventsTabl.estimatedRowHeight = 200
        EventsTabl.tableFooterView = UIView()
        EventsTabl.separatorStyle = .none
        
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
       // NotificationButton.isHidden = true
        self.view.addSubview(NotificationButton)
        
        
       
        
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
             DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
             DeviceToken = "afghg"
        }

       
        
         NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.getDashBoardAPImethod), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
           NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
            
          //  myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            
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
           ValunteerButt.isHidden=true
        }

              
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 270
            menuButton.target = revealViewController()
            self.revealViewController().delegate=self
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
//      self.tabBarController?.tabBar.isTranslucent = true
//      self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
//      self.tabBarController?.tabBar.unselectedItemTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        searchViewController.delegate=self
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
      //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
       
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                firstLatitude = lat
                updatelat = lat
                myLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
                 updatelong = long
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

        self.locationmethod()
       // self.getDashBoardAPImethod()
    }
    
    @IBAction func PlayButtClicked(_ sender: Any) {
        if playerView.ready {
            if playerView.playerState != YouTubePlayerState.Playing {
                playerView.play()
              //  playButton.setTitle("Pause", forState: .Normal)
            } else {
                playerView.pause()
               // playButton.setTitle("Play", forState: .Normal)
            }
        }
    }
    
    // web Delegate methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: imageViewhome)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       // AFWrapperClass.svprogressHudDismiss(view: imageViewhome)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (error.localizedDescription == "The Internet connection appears to be offline.") {
         //   AFWrapperClass.svprogressHudDismiss(view: imageViewhome)
            AFWrapperClass.alert("NetWork Error!", message: "Please check your mobile data/WiFi Connection", view: self)
        }
        if (error.localizedDescription == "The request timed out.") {
          //  AFWrapperClass.svprogressHudDismiss(view: imageViewhome)
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
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.navigationController?.isNavigationBarHidden = true
        
        searchViewController.delegate=self
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                firstLatitude = lat
                updatelat = lat
                 myLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
                updatelong = long
                 myLongitude = long
            }else {
                
            }
        }
        
       
        self.popview.isHidden=true
        self.footerView.isHidden=true
        
        frontView.removeFromSuperview()
        self.revealViewController().delegate=self
        
        frontView.frame = CGRect(x:0, y:65, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        frontView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        frontView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = "afghg"
        }
        
        frontView.isHidden=true
        
        self.tabBarController?.tabBar.isHidden = false
        self.getDashBoardAPImethod()
        
        // self.locationmethod()
        
        //  ValunteerButt.isUserInteractionEnabled = false
    }
    
    
    @objc private  func ProfileSettinglistAPIMethod (baseURL:String , params: String)
    {
        
      //  print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
             //   print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.listArraySettings = (responceDic.object(forKey: "settingDetail") as? NSDictionary)!
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

    
    
  @objc private  func showBannerView()
    {
        let imagesDataArray = NSMutableArray()
        for i in 0..<imagesArray.count
        {
            let image: String = imagesArray.object(at: i) as! String
            //as! NSDictionary).object(forKey: "link") as! String
            let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
            imagesDataArray.add(image1 as Any)
        }
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageViewhome.frame.size.width, height: self.imageViewhome.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        banner?.clipsToBounds = true
        imageViewhome.addSubview(banner!)
        //banner?.notScrolling = true
    }
    
    func locationmethod () -> Void
    {
        
      //  print("location method")
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
                firstLatitude = lat
                updatelat = lat
                 myLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
                updatelong = long
                 myLongitude = long
            }else {
                
            }
             self.getDashBoardAPImethod()
        }
        else
        {
            //  print("location method2")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
               self.locationmethod()
            }
        }
    }

    
    // MARK: Dashboard Api :
    
    func getDashBoardAPImethod () -> Void
    {
//                let baseURL: String  = String(format:"%@",Constants.mainURL)
//                let params = "method=get_sliderDashboard&gcm_id=\(DeviceToken)&device_type=ios&user_id=\(strUserID)&lat=\(currentLatitude)&lon=\(currentLongitude)"
        
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
        
        if self.listArrayFoodBank.count == 0
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDics:NSDictionary = jsonDic as NSDictionary
                print(responceDics)
                if (responceDics.object(forKey: "status") as! NSNumber) == 1
                {
                    let responceDic:NSDictionary = (responceDics.object(forKey: "dashboardDetails") as? NSDictionary)!
                    
                    if let quantity = responceDic.object(forKey: "foodbank_count") as? NSNumber
                    {
                        self.foodBankLabel.text! =  String(describing: quantity)
                    }
                    else if let quantity = responceDic.object(forKey: "foodbank_count") as? String
                    {
                        self.foodBankLabel.text! = quantity
                    }
                    
                    if let quantity = responceDic.object(forKey: "foodsharing_count") as? NSNumber
                    {
                        self.foodShareLbl.text! =  String(describing: quantity)
                    }
                    else if let quantity = responceDic.object(forKey: "foodsharing_count") as? String
                    {
                        self.foodShareLbl.text! = quantity
                    }
                    
                    if let quantity = responceDic.object(forKey: "events_count") as? NSNumber
                    {
                        self.Eventlabel.text! =  String(describing: quantity)
                    }
                    else if let quantity = responceDic.object(forKey: "events_count") as? String
                    {
                        self.Eventlabel.text! = quantity
                    }
                    
                    if let quantity = responceDic.object(forKey: "volunteers_count") as? NSNumber
                    {
                        self.VolunteerLal.text! =  String(describing: quantity)
                    }
                    else if let quantity = responceDic.object(forKey: "volunteers_count") as? String
                    {
                        self.VolunteerLal.text! = quantity
                    }
                    
                    
                    
                    
                    //  let number = responceDic.object(forKey: "Notification") as! NSString
                    
                    
                    self.strvalinter = responceDic.object(forKey: "volunteer_status") as? String ?? ""
                    
                    UserDefaults.standard.set(self.strvalinter, forKey: "volunteerstatus")
                    
                    
                    if self.strUserID == ""
                    {
                        self.ValunteerButt.isHidden=true
                    }
                    else
                    {
                        if self.strvalinter == "1"
                        {
                            self.ValunteerButt.setTitle("Invite friends to become Volunteers", for: .normal)
                            self.ValunteerButt.addTarget(self, action: #selector(HomeVC.becomeVolntrBtnAction2(_:)), for: UIControlEvents.touchUpInside)
                        }
                        else
                        {
                            self.ValunteerButt.setTitle("I Want To Become Volunteer", for: .normal)
                            self.ValunteerButt.addTarget(self, action: #selector(HomeVC.becomeVolunteerClicked(_:)), for: UIControlEvents.touchUpInside)
                        }
                    }
                    
                    
                    
                    if let quantity = responceDic.object(forKey: "notifications") as? NSNumber
                    {
                        //let strval: String = (quantity: quantity.stringValue) as! String
                        
                        let strval = String(describing: quantity)
                        
                        if strval == "0"
                        {
                            self.NoticationLab.isHidden = true
                            UserDefaults.standard.set(strval, forKey: "NCount")
                            // self.NotificationButton.isHidden = false
                        }
                        else
                        {
                            self.NoticationLab.text = strval
                            UserDefaults.standard.set(strval, forKey: "NCount")
                            self.NoticationLab.isHidden = false
                            self.NotificationButton.isHidden = false
                        }
                    }
                    else if let quantity = responceDic.object(forKey: "notifications") as? String
                    {
                        if quantity == "0"
                        {
                            self.NoticationLab.isHidden = true
                            UserDefaults.standard.set(quantity, forKey: "NCount")
                            // self.NotificationButton.isHidden = true
                        }
                        else
                        {
                            self.NoticationLab.text = quantity
                            UserDefaults.standard.set(quantity, forKey: "NCount")
                            self.NoticationLab.isHidden = false
                            self.NotificationButton.isHidden = false
                        }
                    }
                    
                 
                    
                    let strtitle = "  "
                    let strtitle2 = responceDic.object(forKey: "heading") as? String ?? "Food4All.Org"
                    self.AboutTitle.text = strtitle+strtitle2
                    
                    
                    let htmlText2 = (responceDic.object(forKey: "description") as? String)!
                    
                    if let htmlData2 = htmlText2.data(using: String.Encoding.unicode) {
                        do {
                            let attributedText = try NSAttributedString(data: htmlData2, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                            self.discriptionLabel.attributedText = attributedText
                            self.discriptionLabel.font = UIFont(name: "Helvetica", size: 16.0)!
                            
                        } catch let e as NSError {
                            print("Couldn't translate \(htmlText2): \(e.localizedDescription) ")
                        }
                    }
                    
                    self.strVideoUrl = responceDic.object(forKey: "header_video") as? String ?? ""
                    
                    self.DataWebView.isOpaque = false;
                    self.DataWebView.backgroundColor = UIColor.clear
                    self.DataWebView.allowsInlineMediaPlayback = true
                    self.DataWebView.scrollView.isScrollEnabled = false
                    self.DataWebView.scrollView.bounces = false
                    
                    
                    
                    let width = self.view.bounds.size.width
                    print(width)
                    
                    if(width == 320)
                    {
                        self.TopVideoViewHeight.constant = 175
                        self.strwidth = "175"
                    }
                    else if (width == 375)
                    {
                        self.TopVideoViewHeight.constant = 220
                        self.strwidth = "220"
                    }
                    else
                    {
                        self.TopVideoViewHeight.constant = 220
                        self.strwidth = "220"
                    }
                    
                    
                    
                    let userInterface = UIDevice.current.userInterfaceIdiom
                    
                    if(userInterface == .pad)
                    {
                        self.TopVideoViewHeight.constant = 320
                        let width = self.view.frame.size.width
                        
                        
                        let str1 =  "<html><body><iframe src=\""
                        let str2 = "?playsinline=1\" width=\""
                        let str3 = String(describing: width)
                        let str4 = "\" height=\"320\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
                        let embededHTML = str1+self.strVideoUrl+str2+str3+str4
                        self.DataWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
                    }
                    else
                    {
                        let width = self.view.frame.size.width
                        let str1 =  "<html><body><iframe src=\""
                        let str2 = "?playsinline=1\" width=\""
                        let str3 = String(describing: width)
                        let str4 = "\" height=\""
                        let str5 = "\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
                        //  let str6 = "\" height=\"175\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
                        let embededHTML = str1+self.strVideoUrl+str2+str3+str4+self.strwidth+str5
                        
                        print(embededHTML)
                        self.DataWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
                    }
                    
                    self.listArrayFoodBank = responceDic.object(forKey: "nearest_foodbank") as! NSMutableArray
                    self.listArrayFoodEvent = responceDic.object(forKey: "upcoming_event") as! NSMutableArray
                    
                    if self.listArrayFoodBank.count == 0
                    {
                        self.FoodBankTablHeight.constant = 0
                        self.NearFoodBankLab.isHidden = true
                        self.NearFoodBankHeight.constant = 0
                    }
                    else
                    {
                        self.FoodBankTablHeight.constant = CGFloat((self.listArrayFoodBank.count) * 190)
                        self.NearFoodBankLab.isHidden = false
                        self.NearFoodBankHeight.constant = 42
                    }
                    
                    if self.listArrayFoodEvent.count == 0
                    {
                        self.EventTablHeight.constant = 0
                        self.UpcomingEventLab.isHidden = true
                        self.UpcomingEventHeight.constant = 0
                    }
                    else
                    {
                        self.EventTablHeight.constant = CGFloat((self.listArrayFoodEvent.count) * 220)
                        self.UpcomingEventLab.isHidden = false
                        self.UpcomingEventHeight.constant = 42
                    }
                    
                    self.FoodBankTabl.reloadData()
                    self.EventsTabl.reloadData()
                    
                    self.imagesArray = responceDic.object(forKey: "sliders") as! NSArray
                    
                    
                    if self.view.bounds.size.width == 320.0
                    {
                        self.FoodbankLab.font = UIFont.systemFont(ofSize: 10)
                        self.FoodShareLab.font = UIFont.systemFont(ofSize: 10)
                        self.EventsLab.font = UIFont.systemFont(ofSize: 10)
                        self.VolunteersLab.font = UIFont.systemFont(ofSize: 10)
                    }
                    else if self.view.bounds.size.width == 375.0
                    {
                        self.FoodbankLab.font = UIFont.systemFont(ofSize: 12)
                        self.FoodShareLab.font = UIFont.systemFont(ofSize: 12)
                        self.EventsLab.font = UIFont.systemFont(ofSize: 12)
                        self.VolunteersLab.font = UIFont.systemFont(ofSize: 12)
                    }
                    else if self.view.bounds.size.width == 414.0
                    {
                        self.FoodbankLab.font = UIFont.systemFont(ofSize: 13)
                        self.FoodShareLab.font = UIFont.systemFont(ofSize: 13)
                        self.EventsLab.font = UIFont.systemFont(ofSize: 13)
                        self.VolunteersLab.font = UIFont.systemFont(ofSize: 13)
                    }
                    
                    
                    
                    
                    if let quantity = responceDic.object(forKey: "address") as? NSNumber
                    {
                        self.addressCheck =  String(describing: quantity)
                    }
                    else if let quantity = responceDic.object(forKey: "address") as? String
                    {
                        self.addressCheck = quantity
                    }
                    
                    if self.addressCheck == "1"
                    {
                        if UserDefaults.standard.object(forKey: "UserId") != nil
                        {
                            self.addaddress()
                        }
                    }
                    else if self.addressCheck == "2"
                    {
                        if UserDefaults.standard.object(forKey: "UserId") != nil
                        {
                            if UserDefaults.standard.object(forKey: "Popupshow") != nil
                            {
                                
                            }
                            else
                            {
                                self.Switchaddress()
                            }
                        }
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                    
                    //print(self.imagesArray)
//                    if self.imagesArray.count == 0
//                    {
//                        self.imagesArray = ["http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
//                        self.perform(#selector(HomeVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }else{
//                        self.perform(#selector(HomeVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }
                }
                else
                {
                    let strerror = responceDics.object(forKey: "error") as? String ?? "Server error"
                    let Message = responceDics.object(forKey: "responseMessage") as? String ?? strerror
                    
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
    
     // MARK: Switch Address
    
    func Switchaddress()
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        popview5.isHidden=false
        footerView5.isHidden=false
       
        
        popview5.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview5.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview5)
        
        footerView5.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:220)
        footerView5.backgroundColor = UIColor.white
        footerView5.layer.cornerRadius = 8.0
        footerView5.clipsToBounds = true
        popview5.addSubview(footerView5)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView5.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Food4All"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView5.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView5.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView5.addSubview(labUnderline)
        
        
        let label2 = UILabel()
        label2.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
        label2.text = "Are you sure want to switch the address?"
        label2.numberOfLines = 0
        label2.textAlignment = .center
        footerView5.addSubview(label2)
        
        rememberButton.frame = CGRect(x:10, y:label2.frame.size.height+label2.frame.origin.y+20, width:30, height:30)
        rememberButton.backgroundColor = UIColor.clear
        rememberButton.setImage(UIImage(named: "UncheckBox"), for: UIControlState.normal)
        rememberButton.addTarget(self, action: #selector(self.rememberButtonAction(_:)), for: UIControlEvents.touchUpInside)
        rememberButton.isSelected = false
        footerView5.addSubview(rememberButton)
        
        let rememberLabel = UILabel()
        rememberLabel.frame = CGRect(x:rememberButton.frame.origin.x+30, y:rememberButton.frame.origin.y, width:200, height:30)
        rememberLabel.backgroundColor = UIColor.clear
        rememberLabel.text="Don't show this message again"
        rememberLabel.font =  UIFont(name:"Helvetica", size: 14)
        rememberLabel.textAlignment = .left
        rememberLabel.textColor=UIColor.darkGray
        footerView5.addSubview(rememberLabel)
        
        
        CancelButton5.frame = CGRect(x:10, y:rememberLabel.frame.size.height+rememberLabel.frame.origin.y+20, width:footerView5.frame.size.width/2-15, height:40)
        CancelButton5.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton5.setTitle("No", for: .normal)
        CancelButton5.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton5.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton5.titleLabel?.textAlignment = .center
        CancelButton5.addTarget(self, action: #selector(self.switchcanceladdressButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView5.addSubview(CancelButton5)
        
        
        DoneButton5.frame = CGRect(x:CancelButton5.frame.size.width+CancelButton5.frame.origin.x+10, y:rememberLabel.frame.size.height+rememberLabel.frame.origin.y+20, width:footerView5.frame.size.width/2-15, height:40)
        DoneButton5.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton5.setTitle("Yes", for: .normal)
        DoneButton5.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton5.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton5.titleLabel?.textAlignment = .center
        DoneButton5.addTarget(self, action: #selector(self.switchaddressDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView5.addSubview(DoneButton5)
    }
    
    // MARK: remember Button Action :
    func rememberButtonAction(_ sender: UIButton!)
    {
        if sender.isSelected
        {
            rememberButton.setImage(UIImage(named: "UncheckBox"), for: .normal)
            sender.isSelected = false
        }
        else
        {
            rememberButton.setImage(UIImage(named: "CheckRightbox"), for: .normal)
            sender.isSelected = true
        }
    }
    
    // MARK: Cancel Button Action :
    func switchcanceladdressButtonAction(_ sender: UIButton!)
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        popview5.isHidden=true
        footerView5.isHidden=true
        
         UserDefaults.standard.set("true", forKey: "Popupshow")
    }
    
    
    // MARK: Done Button Action :
    func switchaddressDoneButtonAction(_ sender: UIButton!)
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        popview5.isHidden=true
        footerView5.isHidden=true
        
        if rememberButton.isSelected
        {
            UserDefaults.standard.set("true", forKey: "Popupshow")
        }
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
             self.addaddress()
        }
    }
    
    
     // MARK: videobutt Clicked :
    
    @IBAction func VideoButtClicked(_ sender: UIButton)
    {
        if strVideoUrl == ""
        {
            AFWrapperClass.alert(Constants.applicationName, message: "No Video Found", view: self)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
            proVC.strwebUrl = self.strVideoUrl
            proVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(proVC, animated: true)
        }
    }
    
    
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

    
    
    @IBAction func NotificationButtonClicked(_ sender: Any)
    {
        if strUserID == ""
        {
            
        }
        else
        {
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(strUserID)"
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
    
      // MARK: list Count Clicked:
     
    @IBAction func foodBanklistButtonClicked(_ sender: Any)
    {
       _ = self.tabBarController?.selectedIndex = 1

    }
    
    @IBAction func foodSharinglistClicked(_ sender: Any)
    {
       _ = self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func EventlistButtonClicked(_ sender: UIButton)
    {
         _ = self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func VolunteerlistButtonClicked(_ sender: UIButton)
    {
         _ = self.tabBarController?.selectedIndex = 4
    }
    
     // MARK: Add Location
    
    func addaddress()
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        popupcheck = "2"
        
        popview4.isHidden=false
        footerView4.isHidden=false
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
        forgotPassWordTF.removeFromSuperview()
        
        popview4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview4.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview4)
        
        footerView4.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView4.backgroundColor = UIColor.white
        popview4.addSubview(footerView4)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView4.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Address"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView4.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView4.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView4.addSubview(labUnderline)
        
        
        
        forgotPassWordTF = ACFloatingTextfield()
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
        forgotPassWordTF.delegate = self
        forgotPassWordTF.placeholder = "Please Select address"
        forgotPassWordTF.placeHolderColor=UIColor.lightGray
        forgotPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.lineColor=UIColor.lightGray
        forgotPassWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.font = UIFont.systemFont(ofSize: 14)
        forgotPassWordTF.keyboardType=UIKeyboardType.emailAddress
        forgotPassWordTF.autocorrectionType = .no
        forgotPassWordTF.autocapitalizationType = .none
        forgotPassWordTF.spellCheckingType = .no
        footerView4.addSubview(forgotPassWordTF)
        
        let selectbutt = UIButton()
        selectbutt.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
        selectbutt.backgroundColor=UIColor.clear
        selectbutt.addTarget(self, action: #selector(HomeVC.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(selectbutt)
        
        
        CancelButton4.frame = CGRect(x:10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView4.frame.size.width/2-15, height:40)
        CancelButton4.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton4.setTitle("Cancel", for: .normal)
        CancelButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton4.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton4.titleLabel?.textAlignment = .center
        CancelButton4.addTarget(self, action: #selector(self.canceladdressButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(CancelButton4)
        CancelButton4.isHidden = true
        
        DoneButton4.frame = CGRect(x:10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView4.frame.size.width-20, height:40)
        DoneButton4.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton4.setTitle("Done", for: .normal)
        DoneButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton4.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton4.titleLabel?.textAlignment = .center
        DoneButton4.addTarget(self, action: #selector(self.addaddressDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(DoneButton4)
        
        self.forgotPassWordTF.text = ""
        
         self.setUsersClosestCity()
        
        self.addDoneButtonOnKeyboard2()
        
    }
    
    func addDoneButtonOnKeyboard2()
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
        
        self.forgotPassWordTF.inputAccessoryView = doneToolbar
    }
    
   
    
    // MARK: Cancel Button Action :
    func canceladdressButtonAction(_ sender: UIButton!)
    {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        popview4.isHidden=true
        footerView4.isHidden=true
        self.popupcheck = "1"
    }
    
    
    // MARK: Done Button Action :
    func addaddressDoneButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (forgotPassWordTF.text?.isEmpty)!
        {
            message = "Please Select the address"
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=forgetPassword&email=\(forgotPassWordTF.text!)")
        }
        
    }
    
    
    @objc private  func ForgotAPIMethod (baseURL:String , params: String)
    {
        //  print(params);
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateAddress")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(self.strUserID, forKey: "user_id")
        PostDataValus.setValue(updatelat, forKey: "lat")
        PostDataValus.setValue(updatelong, forKey: "long")
        PostDataValus.setValue(forgotPassWordTF.text, forKey: "address")
        
        
        
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
                 self.tabBarController?.tabBar.isUserInteractionEnabled = true
                self.popupcheck = "1"
                let responceDic:NSDictionary = jsonDic as NSDictionary
                   print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.popview4.isHidden=true
                    self.footerView4.isHidden=true
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
    
    
    

    
    
    // MARK: Become volunteer:
    
    @IBAction func becomeVolunteerClicked(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            popupcheck = "1"
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
            TextDescription.textAlignment = .left
            TextDescription.delegate = self
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
            locationlab.isHidden = true
            footerView.addSubview(locationlab)
            
            let Cityview = UIView()
            Cityview.frame = CGRect(x:10, y:locationlab.frame.size.height+locationlab.frame.origin.y+5, width:footerView.frame.size.width-20, height:50)
            Cityview.layer.borderWidth=1.0
            Cityview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
            footerView.addSubview(Cityview)
            Cityview.isHidden = true
            
            
            citylab.frame = CGRect(x:5, y:5, width:Cityview.frame.size.width-10, height:40)
            citylab.text = " Select Location"
            citylab.textAlignment = .left
            citylab.font =  UIFont(name:"Helvetica", size: 15)
            citylab.numberOfLines = 2
            Cityview.addSubview(citylab)
            
            locationButt.frame = CGRect(x:0, y:0, width:Cityview.frame.size.width, height:Cityview.frame.size.height)
            locationButt.backgroundColor=UIColor.clear
            locationButt.addTarget(self, action: #selector(HomeVC.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
            foodbanklistbutt.addTarget(self, action: #selector(HomeVC.foodbanklistlistClicked(_:)), for: UIControlEvents.touchUpInside)
            foodbanklistbutt.isHidden = true
            footerView.addSubview(foodbanklistbutt)
            
            
            CancelButton2.frame = CGRect(x:10, y:footerView.frame.size.height-50, width:footerView.frame.size.width/2-15, height:40)
            CancelButton2.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            CancelButton2.setTitle("Cancel", for: .normal)
            CancelButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
            CancelButton2.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
            CancelButton2.titleLabel?.textAlignment = .center
            CancelButton2.addTarget(self, action: #selector(HomeVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
            footerView.addSubview(CancelButton2)
            
            
            DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:footerView.frame.size.height-50, width:footerView.frame.size.width/2-15, height:40)
            DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
            DoneButton2.setTitle("Become Volunteer", for: .normal)
            DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
            DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            DoneButton2.titleLabel?.textAlignment = .center
            DoneButton2.addTarget(self, action: #selector(HomeVC.VolunteerDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        
        print(baseURL)
        
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
        crossbutt.addTarget(self, action: #selector(HomeVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(HomeVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerView2.frame.size.width, height: footerView2.frame.size.height-70)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.tag = 1
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
        
        self.addDoneButtonOnKeyboardn()
    }
    
    
    func addDoneButtonOnKeyboardn()
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
        
        
        camera = GMSCameraPosition.camera(withLatitude: myLatitude, longitude: myLongitude, zoom: 8.0)
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
        crossbutt.addTarget(self, action: #selector(HomeVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(HomeVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
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
        if self.popupcheck == "2"
        {
            locationlab.text = self.forgotPassWordTF.text
        }
        else
        {
            locationlab.text = self.citylab.text!
        }
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(HomeVC.locationButtonAction2(_:)), for: UIControlEvents.touchUpInside)
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
        Uselocationbutt.addTarget(self, action: #selector(HomeVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        locatemebutt.addTarget(self, action: #selector(HomeVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
      //  locationManager.startUpdatingLocation()
        
        currentLatitude = (locationManager.location?.coordinate.latitude)!
        currentLongitude = (locationManager.location?.coordinate.longitude)!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
            updatelat =  (locationManager.location?.coordinate.latitude)!
            updatelong = (locationManager.location?.coordinate.latitude)!
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
//                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=Becomevolenteer&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&description=\(TextDescription.text!)&address=\(citylab.text!)&foodbankid=\(strFoodbankId)&is_foodbank=1")
                
               // let strkey = Constants.ApiKey
              
                
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
//                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=Becomevolenteer&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&description=\(TextDescription.text!)&address=\(citylab.text!)&is_foodbank=0")
                
               
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
                
                
                
                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"addVolunteer") , params: jsonStringValues)
                
                
                
            }
        }
    }
    
    
    @objc private  func BecomeVolunteerAPIMethod (baseURL:String , params: String)
    {
        
     //   print(params);
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
              //  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    
                    self.strvalinter = "1"
                    
                    UserDefaults.standard.set(self.strvalinter, forKey: "volunteerstatus")
                    
                    self.popview.isHidden=true
                    self.footerView.isHidden=true
                   // self.ValunteerButt.isHidden=true
                    self.ValunteerButt.setTitle("Invite friends to become Volunteers", for: .normal)
                    self.ValunteerButt.addTarget(self, action: #selector(HomeVC.becomeVolntrBtnAction2(_:)), for: UIControlEvents.touchUpInside)
                    
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
        let location = CLLocation(latitude: myLatitude, longitude: myLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
              //  print(formattedAddress.joined(separator: ", "))
                
                if self.popupcheck == "2"
                {
                      self.forgotPassWordTF.text = formattedAddress.joined(separator: ", ")
                     self.locationlab.text = formattedAddress.joined(separator: ", ")
                }
                else
                {
                    self.citylab.text! = formattedAddress.joined(separator: ", ")
                    self.locationlab.text = formattedAddress.joined(separator: ", ")
                }
               
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
        if tableView.tag == 3 || tableView.tag == 4
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 3
        {
            return listArrayFoodBank.count
        }
        else if tableView.tag == 4
        {
             return listArrayFoodEvent.count
        }
        else if tableView.tag == 2
        {
            return searchResults.count
        }
        else
        {
            return arrChildCategory.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView.tag == 3
        {
            let identifier = "FBtableCell"
            Foodcell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FBtableCell
            
            if Foodcell == nil
            {
                tableView.register(UINib(nibName: "FBtableCell", bundle: nil), forCellReuseIdentifier: identifier)
                Foodcell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FBtableCell
            }
           
            Foodcell.selectionStyle = UITableViewCellSelectionStyle.none
            
//            if self.listArrayFoodBank.count == 1 || self.listArrayFoodBank.count == 0
//            {
//                Foodcell.Bottomlbl.backgroundColor = UIColor.white
//            }
//            else
//            {
//                 Foodcell.Bottomlbl.backgroundColor = UIColor.lightGray
//            }
            
            let imageURL: String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "header_image") as! String
            let url = NSURL(string:imageURL)
            Foodcell.imageViewUser.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            
            Foodcell.foodBankName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as! String
            
            
//            let foodbankManage = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_user") as? String ?? ""
//            if foodbankManage == ""
//            {
//                let strname1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
//                let strname2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
//                Foodcell.foodBnkUserName.text! = strname1+" "+strname2
//            }
//            else
//            {
//                Foodcell.foodBnkUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
//            }
            
            let foodbankManage = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
            if foodbankManage == ""
            {
                let strname1 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
                let strname2 = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
                Foodcell.foodBnkUserName.text! = strname1+" "+strname2
            }
            else
            {
                Foodcell.foodBnkUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_other_contact") as? String ?? ""
            }
           
            
            
            let straddress =  (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String ?? ""
            let stradd = straddress.replacingOccurrences(of: "\n", with: "")
            Foodcell.locationLabel.text!  = stradd
            
            
            let sliderValue = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "capacity_status") as? String ?? ""
            if sliderValue == "" {
                Foodcell.sliderFdBnk.value = 0
                Foodcell.percentLbl.text! = "0"
            }else{
                Foodcell.sliderFdBnk.value = Float(sliderValue)!
                Foodcell.percentLbl.text! = String(format:"%@%@",sliderValue,"%")
                
            }
            
            if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? NSNumber
            {
                 Foodcell.milesLabel.text! =  String(format: "%@ Kms",String(describing: quantity))
            }
            else if let quantity = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance")  as? String
            {
                 Foodcell.milesLabel.text! = String(format: "%@ Kms",quantity)
            }
            
            return Foodcell
        }
        else if tableView.tag == 4
        {
            let identifier = "EventTableCell"
            Eventcell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableCell
            
            if Eventcell == nil
            {
                tableView.register(UINib(nibName: "EventTableCell", bundle: nil), forCellReuseIdentifier: identifier)
                Eventcell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EventTableCell
            }
            
            Eventcell.selectionStyle = UITableViewCellSelectionStyle.none
            
//            if self.listArrayFoodEvent.count == 1 || self.listArrayFoodEvent.count == 0
//            {
//                Eventcell.Bottomlbl.backgroundColor = UIColor.white
//            }
//            else
//            {
//                Eventcell.Bottomlbl.backgroundColor = UIColor.lightGray
//            }
            
            let imageURL: NSArray = ((self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "images") as? NSArray)!
            if imageURL.count == 0
            {
                Eventcell.EventImage.image = UIImage(named: "Logo")
            }
            else
            {
                let strurl = imageURL.object(at: 0)
                let url = NSURL(string: strurl as! String )
                Eventcell.EventImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            }
           
            
            Eventcell.EventTitle.text! = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String ?? ""
            
            let strname1 = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
            let strname2 = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
            Eventcell.EventUserName.text! = strname1+" "+strname2
            
           
            
            let straddress = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String ?? ""
            let stradd = straddress.replacingOccurrences(of: "\n", with: "")
             Eventcell.EventAddress.text! = stradd
            
            
            
            if let quantity = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? NSNumber
            {
                //   let strval: String = (quantity: quantity.stringValue) as! String
                let strval = String(describing: quantity)
                Eventcell.EventDistance.text! = strval as String + " kms"
                
            }
            else if let quantity = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "distance") as? String
            {
                Eventcell.EventDistance.text! = quantity+" Kms"
            }
            
            let StrStartDate = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "start_datetime") as? String ?? ""
            if StrStartDate == ""
            {
                
            }
            else
            {
                let startDateArray:NSArray = StrStartDate.components(separatedBy: " ") as NSArray
                if startDateArray.count > 1
                {
                    Eventcell.EventStartDate.text! = (startDateArray.object(at: 0) as? String)!
                    Eventcell.EventStartTime.text! = (startDateArray.object(at: 1) as? String)!
                }
                else
                {
                    Eventcell.EventStartDate.text! = (startDateArray.object(at: 0) as? String)!
                }
            }
            
            let StrEndDate = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "end_datetime") as? String ?? ""
            if StrEndDate == ""
            {
                
            }
            else
            {
                let EndDateArray:NSArray = StrEndDate.components(separatedBy: " ") as NSArray
                if EndDateArray.count > 1
                {
                    Eventcell.EventEndDate.text! = (EndDateArray.object(at: 0) as? String)!
                    Eventcell.EventEndTime.text! = (EndDateArray.object(at: 1) as? String)!
                }
                else
                {
                    Eventcell.EventEndDate.text! = (EndDateArray.object(at: 0) as? String)!
                }
            }
            return Eventcell
        }
        else
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 3
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
        else if tableView.tag == 4
        {
            let userID:String = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
            if userID == strUserID as String
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                myVC?.foodbankID = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
            }
            else
            {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailsViewController") as? EventsDetailsViewController
                myVC?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                myVC?.foodbankID = (self.listArrayFoodEvent.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
            }
        }
        else
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
                if tableView.tag == 3
                {
                    
                }
                else if tableView.tag == 4
                {
                    
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
    }
    
    func responsewithToken7(_ responseDict: NSDictionary)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




extension HomeVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView.delegate = self;
        
        firstLatitude=position.target.latitude
        firstLongitude=position.target.longitude
        
        updatelat = position.target.latitude
        updatelong = position.target.longitude
        
        if popupcheck == "2"
        {
            self.forgotPassWordTF.text = "Featching Address..."
            locationlab.text = "Featching Address..."
        }
        else
        {
            self.citylab.text! = "Featching Address..."
            locationlab.text = "Featching Address..."
        }
       
        
        
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
       // print(position)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
         //   print("Unable to Reverse Geocode Location (\(error))")
            
            if popupcheck == "2"
            {
                locationlab.text = "Unable to Find Address for Location"
                self.forgotPassWordTF.text = "Unable to Find Address for Location"
            }
            else
            {
                self.citylab.text! = "Unable to Find Address for Location"
                locationlab.text = "Unable to Find Address for Location"
            }
            
           
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                
                if popupcheck == "2"
                {
                    locationlab.text = placemark.compactAddress!
                    self.forgotPassWordTF.text = placemark.compactAddress!
                }
                else
                {
                    self.citylab.text! = placemark.compactAddress!
                    locationlab.text = placemark.compactAddress!
                }
               
              //  print( self.citylab.text!)
            } else {
                
                if popupcheck == "2"
                {
                    locationlab.text = "No Matching Addresses Found"
                    self.forgotPassWordTF.text = "No Matching Addresses Found"
                }
                else
                {
                    self.citylab.text! = "No Matching Addresses Found"
                    locationlab.text = "No Matching Addresses Found"
                }
                
            }
        }
    }
}






extension HomeVC: ABCGooglePlacesSearchViewControllerDelegate {
   
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        citylab.text=place.formatted_address
        locationlab.text = place.formatted_address
        firstLatitude=place.location.coordinate.latitude
        firstLongitude=place.location.coordinate.longitude
        
        updatelat = place.location.coordinate.latitude
        updatelong = place.location.coordinate.longitude
//        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
//        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView3.frame.size.width, height: footerView3.frame.size.height), camera: camera)
//        mapView2.delegate = self
//        self.mapView2.settings.compassButton = true
//        footerView3.addSubview(mapView2)
        
       // self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: firstLatitude, longitude: firstLongitude, zoom: 10.0)
        mapView2.delegate = self
        mapView2.camera=camera
     
       // mapView.reloadInputViews()
        
    }
}


extension HomeVC: SWRevealViewControllerDelegate
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


