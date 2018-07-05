//
//  EventsDetailsVC.swift
//  FoodForAll
//
//  Created by amit on 5/10/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import LCBannerView
import SDWebImage


class EventsDetailsVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,LCBannerViewDelegate,UITextFieldDelegate
{
 @IBOutlet var iconView: UIView!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapBackGrndView: UIView!
    @IBOutlet weak var imageBanerView: UIView!
    
    var imagesArray = NSArray()
    var listDicFoodBank = NSDictionary()
    var SharedMealID = String()
    
    @IBOutlet weak var SubCategeoryImage: UIImageView!
    
    @IBOutlet weak var CategeoryImage: UIImageView!
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    var Uselocationbutt = UIButton()
    var alertCtrl2: UIAlertController?

    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var subCategeory: UILabel!
    @IBOutlet weak var categeory: UILabel!
    @IBOutlet weak var hourslab: UILabel!
    @IBOutlet weak var MinsLab: UILabel!
    @IBOutlet weak var Secondalab: UILabel!
    @IBOutlet weak var foodBankName: UILabel!
   
    @IBOutlet weak var Datelab: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var Quantity: UILabel!
    @IBOutlet weak var DescriptionView: UITextView!
    @IBOutlet weak var mainScroolView: UIScrollView!
    
    @IBOutlet weak var foodbankMangView: UIView!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIdentity: UILabel!
    var identityVal = String()
    @IBOutlet weak var DescriptionLab: UILabel!
    @IBOutlet weak var pickuplocationlab: UILabel!
    @IBOutlet weak var pickuplocationbutt: UIButton!
    
    var timerArr2 : NSMutableArray = []
    var timerArr3 : NSMutableArray = []
    var secondsArr2 : NSMutableArray  = []
    var expireArr2 : NSMutableArray  = []
    var refreshTimer = Timer()
    var timerLabel = UILabel()
    var seconds = 60
    var timer = Timer()
    var myArray = NSDictionary()
    var strUserID = String()
    var UserID = NSString()
    var number=NSString()
    var posturl=NSString()
    var foodid = String()
    
     var ZoomButton = UIButton()
    
    
    var CheckCondition=String()
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var forgotPassWordTF = ACFloatingTextfield()
    var CancelButton2 = UIButton()
    var DoneButton2 = UIButton()
    var checkString = String()
    
    var VolunteerStatus = NSString()
    
     var ShareUrl = String()
    var StrChatMessage = String()
    var StrChatMessageTypeId = String()
    
     @IBOutlet weak var ShareView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //ShareView.isHidden = true
        iconView.isHidden = true
         self.setupAlertCtrl2()
        
        self.tabBarController?.tabBar.isHidden = true
        
        callButton.isHidden=true
        chatButton.isHidden=true
        
         posturl="1"
        
        
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
        
        
        
        
        let userInterface = UIDevice.current.userInterfaceIdiom
        
        if(userInterface == .pad)
        {
            ZoomButton.frame = CGRect(x:self.view.frame.size.width-50, y:290, width:40, height:40)
        }
        else
        {
            ZoomButton.frame = CGRect(x:self.view.frame.size.width-50, y:130, width:40, height:40)
        }
        ZoomButton.setImage(UIImage(named: "ic_aspect_ratio_white_3x.png"), for: .normal)
        ZoomButton.addTarget(self, action: #selector(self.zoomImageBtnAction(_:)), for: UIControlEvents.touchUpInside)
        self.mainScroolView.addSubview(ZoomButton)
        
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

      

        self.SharedFoodBankDetailAPImethod()
    }

  @objc private  func showMapView()
    {
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapBackGrndView.frame.size.width, height: self.mapBackGrndView.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        //self.mapView.isUserInteractionEnabled = false
        self.mapBackGrndView.addSubview(mapView)
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.title = ""
        self.marker.icon = UIImage(named: "map_pin36.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.map = self.mapView
        
        
        let DirectionImage = UIImageView()
        DirectionImage.frame = CGRect(x:self.mapBackGrndView.frame.size.width-50, y:self.mapBackGrndView.frame.size.height-50, width:40, height:40)
        DirectionImage.image = UIImage(named: "google-2.png")
        DirectionImage.contentMode = .scaleAspectFit
        self.mapBackGrndView.addSubview(DirectionImage)
        
        Uselocationbutt.frame = CGRect(x:self.mapBackGrndView.frame.size.width-50, y:self.mapBackGrndView.frame.size.height-50, width:40, height:40)
        Uselocationbutt.addTarget(self, action: #selector(EventsDetailsVC.multipleParamSelector2), for: .touchUpInside)
        self.mapBackGrndView.addSubview(Uselocationbutt)
        
    }
    
    func multipleParamSelector2()
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
        
        if imagesDataArray.count == 1
        {
            let bannerview = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageBanerView.frame.size.width, height: self.imageBanerView.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 500, currentPageIndicatorTintColor: UIColor.clear, pageIndicatorTintColor: UIColor.clear)
            bannerview?.clipsToBounds = true
            bannerview?.notScrolling = true
            bannerview?.contentMode = .scaleAspectFill
            imageBanerView.addSubview(bannerview!)
        }
        else
        {
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageBanerView.frame.size.width, height: self.imageBanerView.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        banner?.clipsToBounds = true
        banner?.contentMode = .scaleAspectFill
        imageBanerView.addSubview(banner!)
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        
        let  view = UIView()
        view.frame = CGRect(x:0, y:100, width:300, height:100)
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
        titlelabtext.text = String(format: ": %@", self.listDicFoodBank.object(forKey: "title") as! CVarArg)
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
        if let quantity = self.listDicFoodBank.object(forKey: "distance") as? NSNumber
        {
            Distancelabtext.text =  String(format: ": %@ Kms",String(describing: quantity))
        }
        else if let quantity = self.listDicFoodBank.object(forKey: "distance")  as? String
        {
            Distancelabtext.text = String(format: ": %@ Kms",quantity)
        }
        //Distancelabtext.text = String(format: ": %@ kms", self.listDicFoodBank.object(forKey: "distances") as! CVarArg)
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
        Locationlabtext.text = String(format: "%@", self.listDicFoodBank.object(forKey: "address") as! CVarArg)
        Locationlabtext.font =  UIFont(name:"Helvetica", size: 12)
        Locationlabtext.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Locationlabtext.isScrollEnabled=false
        Locationlabtext.textAlignment = .left
        Headview.addSubview(Locationlabtext)
        
        Directionlatitude = self.listDicFoodBank.object(forKey: "lat") as! String as NSString
        Directionlongitude = self.listDicFoodBank.object(forKey: "long") as! String as NSString
        
        
        
        return view
    }

    
    
    
    // MARK:  FoodBanks Details API method
    
    func SharedFoodBankDetailAPImethod () -> Void
    {
         var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&foodsharing_id=\(SharedMealID)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodsharingDetail",params)
        
        print(baseURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                //  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    print(responceDic)
                    self.listDicFoodBank = (responceDic.object(forKey: "foodSharing") as? NSDictionary)!
                    
                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "long") as! String)!
                    
                    self.Directionlatitude = self.listDicFoodBank.object(forKey: "lat") as! String as NSString
                    self.Directionlongitude = self.listDicFoodBank.object(forKey: "long") as! String as NSString
                    
                    self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "title") as! String)
                    
                    
                  //  self.categeory.text! = (self.listDicFoodBank.object(forKey: "food_type") as! NSDictionary).value(forKey: "name") as? String ?? "Food4All"
                    
                    let categeoryname: String = (self.listDicFoodBank.object(forKey: "food_type") as! NSDictionary).value(forKey: "name") as? String ?? ""
                    if categeoryname == ""
                    {
                        self.categeory.text!  = "Food4All"
                    }
                    else
                    {
                        self.categeory.text!  = categeoryname
                    }
                    
                    let categeoryi: String = (self.listDicFoodBank.object(forKey: "food_type") as! NSDictionary).value(forKey: "image") as? String ?? ""
                    if categeoryi == ""
                    {
                        self.CategeoryImage.image = UIImage(named: "PlcHldrSmall")
                    }
                    else
                    {
                        let url2 = NSURL(string:categeoryi)
                        self.CategeoryImage.sd_setImage(with: (url2)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
                    }
                    
                    
                   // self.subCategeory.text! = (self.listDicFoodBank.object(forKey: "food_category") as! NSDictionary).value(forKey: "name") as? String ?? "Food4All"
                    
                    let subcategeoryname: String = (self.listDicFoodBank.object(forKey: "food_category") as! NSDictionary).value(forKey: "name") as? String ?? ""
                    if subcategeoryname == ""
                    {
                        self.subCategeory.text! = "Food4All"
                    }
                    else
                    {
                        self.subCategeory.text! = subcategeoryname
                    }
                    
                    let scategeory: String = (self.listDicFoodBank.object(forKey: "food_category") as! NSDictionary).value(forKey: "image") as? String ?? ""
                    if scategeory == ""
                    {
                        self.SubCategeoryImage.image = UIImage(named: "PlcHldrSmall")
                    }
                    else
                    {
                        let url2 = NSURL(string:scategeory)
                        self.SubCategeoryImage.sd_setImage(with: (url2)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
                    }
                    
            
                   // self.categeory.text! = (self.listDicFoodBank.value(forKey: "category_name") as! String)
                    
                    self.Quantity.text! = self.listDicFoodBank.value(forKey: "quantity") as? String ?? ""
                    
                    self.Datelab.text! = self.listDicFoodBank.value(forKey: "created") as? String ?? ""
                    
                    
                    
                    let straddress =  self.listDicFoodBank.value(forKey: "address") as? String ?? ""
                    let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                    self.address.text!  = stradd
                    
                    
                    if let quantity = self.listDicFoodBank.object(forKey: "distance") as? NSNumber
                    {
                        self.Distance.text! =  String(format: "%@ Kms Away",String(describing: quantity))
                    }
                    else if let quantity = self.listDicFoodBank.object(forKey: "distance")  as? String
                    {
                        self.Distance.text! = String(format: "%@ Kms Away",quantity)
                    }
                    
                    self.phonenumber.text! = String(format:"%@",(self.listDicFoodBank .value(forKey: "phone_no") as? String ?? ""))
                    self.number = String(format:"%@",(self.listDicFoodBank .value(forKey: "phone_no") as? String ?? "")) as NSString
                    
                    self.UserID=(self.listDicFoodBank.value(forKey: "user_id") as! String as NSString)
                    
                    self.DescriptionLab.text! = (self.listDicFoodBank.value(forKey: "desc") as! String)
                    
                    self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
                    
                    let strname1 = self.listDicFoodBank.object(forKey: "first_name") as? String ?? ""
                    let strname2 = self.listDicFoodBank.object(forKey: "last_name") as? String ?? ""
                    self.userName.text! = strname1+" "+strname2
                    

                    let stringUrl = self.listDicFoodBank.value(forKey: "user_image") as? NSString ?? ""
                    let url = URL.init(string:stringUrl as String)
                    self.userPic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
                    
                    self.identityVal=self.listDicFoodBank.value(forKey: "identity_hidden") as? String ?? ""
                    
                    // self.identityVal = "1"
                    
                    if self.identityVal == "0"
                    {
                        self.userPic.isHidden = false
                        self.userName.isHidden = false
                        self.phonenumber.isHidden = false
                        self.userIdentity.isHidden = true
                    }
                    else
                    {
                        self.userPic.isHidden = true
                        self.userName.isHidden = true
                        self.phonenumber.isHidden = true
                        self.userIdentity.isHidden = false
                    }
                    
                    let Sharewith: String = self.listDicFoodBank.value(forKey: "share_with") as? String ?? ""
                    
                    if Sharewith == "0"
                    {
                        self.pickuplocationlab.text = String(format:"Delivered To: \n%@",(self.listDicFoodBank .value(forKey: "foodbank_title") as! String))
                        self.pickuplocationbutt.isHidden = false
                    }
                    else
                    {
                        self.pickuplocationbutt.isHidden = true
                    }
                    
                    
                    if self.UserID as String == self.strUserID
                    {
                        self.chatButton.isHidden=true
                        self.callButton.isHidden=true
                    }
                    else
                    {
                        self.chatButton.isHidden=false
                        self.callButton.isHidden=false
                    }
                    
                    
                    var newDate: Date?
                    var value = NSNumber()
                    value=(self.listDicFoodBank.value(forKey: "remaining_time") as! NSNumber)
                    self.seconds=(Int(self.listDicFoodBank.value(forKey: "remaining_time") as! NSNumber))
                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                    
                    self.timerArr3.add(value)
                    self.timerArr2.add(newDate!)
                    self.secondsArr2.add(newDate!)
                    
                    
                    
                    self.perform(#selector(EventsDetailsVC.showMapView), with: nil, afterDelay: 0.01)
                    
                    self.imagesArray = self.listDicFoodBank.value(forKey: "images") as! NSArray
                    print(self.imagesArray)
                    
                    if self.imagesArray.count == 0
                    {
                        self.imagesArray = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
                        self.perform(#selector(EventsDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
                    }else{
                        self.perform(#selector(EventsDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
                    }
                    
                    
                    self.validateTimer()
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
//         var localTimeZoneName: String { return TimeZone.current.identifier }
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=get_sharemeal&share_meal_id=\(SharedMealID)&lat=\(currentLatitude)&longt=\(currentLongitude)&user_id=\(strUserID)&time_zone=\(localTimeZoneName)"
//
//        print(params)
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    print(responceDic)
//                    self.listDicFoodBank = (responceDic.object(forKey: "sharemeallist") as? NSDictionary)!
//
//                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
//                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "longt") as! String)!
//
//                    self.Directionlatitude = self.listDicFoodBank.object(forKey: "lat") as! String as NSString
//                    self.Directionlongitude = self.listDicFoodBank.object(forKey: "longt") as! String as NSString
//
//                    self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "meal_title") as! String)
//
//                    self.categeory.text! = (self.listDicFoodBank.value(forKey: "category_name") as! String)
//                    self.Quantity.text! = (self.listDicFoodBank.value(forKey: "no_of_meal_hidden") as! String)
//
//                    self.Datelab.text! = (self.listDicFoodBank.value(forKey: "created") as! String)
//                    self.address.text! = (self.listDicFoodBank.value(forKey: "address") as! String)
//                    self.Distance.text! = String(format:"%@ kms Away",(self.listDicFoodBank .value(forKey: "distances") as! String))
//                    self.phonenumber.text! = String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String))
//                    self.number = String(format:"%@%@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String)) as NSString
//
//                    self.UserID=(self.listDicFoodBank.value(forKey: "user_id") as! String as NSString)
//
//                    self.DescriptionLab.text! = (self.listDicFoodBank.value(forKey: "meal_desc") as! String)
//
//                     self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
//
//                    self.userName.text! = (self.listDicFoodBank.value(forKey: "username") as! String)
//                    let stringUrl = self.listDicFoodBank.value(forKey: "user_pic") as? NSString ?? ""
//                    let url = URL.init(string:stringUrl as String)
//                    self.userPic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
//
//                    self.identityVal=(self.listDicFoodBank.value(forKey: "identity_hidden") as! String as NSString)
//
//                   // self.identityVal = "1"
//
//                    if self.identityVal == "1"
//                    {
//                        self.userPic.isHidden = false
//                        self.userName.isHidden = false
//                        self.phonenumber.isHidden = false
//                        self.userIdentity.isHidden = true
//                    }
//                    else
//                    {
//                        self.userPic.isHidden = true
//                        self.userName.isHidden = true
//                        self.phonenumber.isHidden = true
//                        self.userIdentity.isHidden = false
//                    }
//
//                   let Sharewith: String = (self.listDicFoodBank.value(forKey: "share_with") as! String)
//
//                    if Sharewith == "0"
//                    {
//                        self.pickuplocationlab.text = String(format:"Delivered To: \n%@",(self.listDicFoodBank .value(forKey: "food_bank_name") as! String))
//                        self.pickuplocationbutt.isHidden = false
//                    }
//                    else
//                    {
//                       self.pickuplocationbutt.isHidden = true
//                    }
//
//                    let Subcategeory: String = (self.listDicFoodBank.value(forKey: "food_type_name") as! String)
//                    if Subcategeory == ""
//                    {
//                        self.subCategeory.text! = "Food4All"
//                    }
//                    else
//                    {
//                       self.subCategeory.text! = (self.listDicFoodBank.value(forKey: "food_type_name") as! String)
//                    }
//
//
//                    let categeory: String = (self.listDicFoodBank.value(forKey: "food_type_image") as! String)
//                    let url2 = NSURL(string:categeory)
//                    self.SubCategeoryImage.sd_setImage(with: (url2)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
//
//
//                    let categeory2: String = (self.listDicFoodBank.value(forKey: "category_image") as! String)
//                    let url3 = NSURL(string:categeory2)
//                    self.CategeoryImage.sd_setImage(with: (url3)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
//
//
//
//
//
//
//                    if self.UserID as String == self.strUserID
//                    {
//                        self.chatButton.isHidden=true
//                        self.callButton.isHidden=true
//                    }
//                    else
//                    {
//                        self.chatButton.isHidden=false
//                        self.callButton.isHidden=false
//                    }
//
//
//                    var newDate: Date?
//                    var value = NSNumber()
//                    value=(self.listDicFoodBank.value(forKey: "seconds") as! NSNumber)
//                    self.seconds=(Int(self.listDicFoodBank.value(forKey: "seconds") as! NSNumber))
//                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
//
//                    self.timerArr3.add(value)
//                    self.timerArr2.add(newDate!)
//                    self.secondsArr2.add(newDate!)
//
//
//
//                    self.perform(#selector(EventsDetailsVC.showMapView), with: nil, afterDelay: 0.01)
//
//                    self.imagesArray = (self.listDicFoodBank.object(forKey: "share_meal_image") as? NSArray)!.value(forKey: "share_meal_image") as! NSArray
//                    print(self.imagesArray)
//
//                    if self.imagesArray.count == 0
//                    {
//                        self.imagesArray = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
//                        self.perform(#selector(EventsDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }else{
//                        self.perform(#selector(EventsDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }
//
//
//                     self.validateTimer()
//                }
//                else
//                {
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
//
//                    AFWrapperClass.svprogressHudDismiss(view: self)
//                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
//                }
//            }
//        }) { (error) in
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
    }

    func validateTimer() {
        
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //MARK: - Public Method
    func updateTimer(){
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        hourslab.text=String(format:"%02i", hours)
        MinsLab.text=String(format:"%02i", minutes)
        Secondalab.text=String(format:"%02i", seconds)
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
    @IBAction func FoodbankDetailClicked(_ sender: UIButton)
    {
        let userID:String = self.listDicFoodBank.object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = self.listDicFoodBank.object(forKey: "food_bankid") as! String
            
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = self.listDicFoodBank.object(forKey: "food_bankid") as! String
        }
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        if checkString == "1"
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
            self.navigationController?.pushViewController(myVC!, animated: true)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func callButtonClicked(_ sender: Any)
    {
        if self.number==""
        {
            var Message=String()
            Message = "Mobile Number Not Avalilable"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
        guard let number = URL(string: "telprompt://" + (self.number as String) ) else { return }
        UIApplication.shared.open(number)
        }
    }
    
    @IBAction func chatButtonClicked(_ sender: Any)
    {
       self.ChatCommunicate()
    }
    
    func ChatCommunicate()
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            
            let baseURL: String  = String(format:"%@%@",Constants.mainURL,"addChat")
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(self.UserID, forKey: "sender_id")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue("foodsharings", forKey: "entity")
            PostDataValus.setValue(SharedMealID, forKey: "entity_id")
            
            
            
            
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
            
            // let baseURL: String  = String(format:"%@",Constants.mainURL)
            //  let params = "method=set_conversation&buyer_id=\(strUserID)&post_id=\(SharedMealID)&selling_id=\(self.UserID)&post_url=\(posturl)"
            
            //  print(params)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                    print(responceDic)
                    if (responceDic.object(forKey: "status") as! NSNumber) == 1
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController
                        
                        if let quantity = responceDic.object(forKey: "chat_id") as? NSNumber
                        {
                            self.foodid =  String(describing: quantity)
                        }
                        else if let quantity = responceDic.object(forKey: "chat_id") as? String
                        {
                            self.foodid = quantity
                        }
                        myVC?.strChatMessageTypeId = self.StrChatMessageTypeId
                        myVC?.strChatMessage = self.StrChatMessage
                        myVC?.strConversionId=self.foodid
                        self.navigationController?.pushViewController(myVC!, animated: false)
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
            var Message=String()
            Message = "Please Login into account to Communicate with chat"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
    }
    
    
    
    
    @IBAction func zoomImageBtnAction(_ sender: Any)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "BannerViewFullSizeVC") as? BannerViewFullSizeVC
        self.navigationController?.pushViewController(myVC!, animated: false)
        
        myVC?.imagesArrayFul = imagesArray
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    
    @IBAction func ShareButtClicked(_ sender: UIButton)
    {
      //    let text = self.ShareUrl + "\n\n" + "Click below link to download Food4All app from the App Store\n" + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8"
        
         let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
        
       //  let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func ReportButtClicked(_ sender: UIButton)
    {
        if self.strUserID == ""
        {
            let alert = UIAlertController(title: "Food4All", message: "Please login to Report this foodshare", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Login", style: UIAlertActionStyle.default,handler: { action in
                self.loginmethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            
            let alert = UIAlertController(title: "Food4All", message: "Are you sure want to Report this FoodSharing", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Yes", style: UIAlertActionStyle.default,handler: { action in
                self.CheckCondition = "1"
                self.ReportRequestMethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"No", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
          //  self.CheckCondition = "1"
          //  ReportRequestMethod()
        }

    }
    
    @IBAction func RequestButtClicked(_ sender: UIButton)
    {
        if self.strUserID == ""
        {
            let alert = UIAlertController(title: "Food4All", message: "Please login to Request this foodshare", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Login", style: UIAlertActionStyle.default,handler: { action in
                self.loginmethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let alert = UIAlertController(title: "Food4All", message: "Are you sure want to Request this FoodSharing", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Yes", style: UIAlertActionStyle.default,handler: { action in
                self.StrChatMessageTypeId = "1"
                self.StrChatMessage = "Hey, I am interested in this food shared by you."
                self.ChatCommunicate()
            })
            
            let alertCancelAction=UIAlertAction(title:"No", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
           
            
            
//            if UserDefaults.standard.object(forKey: "volunteerstatus") != nil
//            {
//                VolunteerStatus = UserDefaults.standard.object(forKey: "volunteerstatus") as! NSString
//
//                if VolunteerStatus == "1"
//                {
//                    self.CheckCondition = "2"
//                    ReportRequestMethod()
//                }
//                else
//                {
//                    var Message=String()
//                    Message = "Please Become a Volunteer to Request this foodshare"
//
//                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
//                }
//            }
//            else
//            {
//
//            }
        }
    }
    
    func loginmethod()
    {
        let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        proVC.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(proVC, animated: true)
    }
    
    
    
    
    func ReportRequestMethod()
    {
        popview.isHidden=false
        footerView.isHidden=false
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
        forgotPassWordTF.removeFromSuperview()
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView.backgroundColor = UIColor.white
        footerView.layer.cornerRadius = 4.0
        footerView.clipsToBounds = true
        popview.addSubview(footerView)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        if self.CheckCondition == "1"
        {
            forgotlab.text="Report"
        }
        else
        {
            forgotlab.text="Request"
        }
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView.addSubview(labUnderline)
        
        
        
        forgotPassWordTF = ACFloatingTextfield()
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
        forgotPassWordTF.delegate = self
        if self.CheckCondition == "1"
        {
            forgotPassWordTF.placeholder = "Type Here"
        }
        else
        {
            forgotPassWordTF.text = "I wish to collect this food donation"
        }
        forgotPassWordTF.font =  UIFont(name:"Helvetica", size: 12)
        forgotPassWordTF.placeHolderColor=UIColor.lightGray
        forgotPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.lineColor=UIColor.lightGray
        forgotPassWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.keyboardType=UIKeyboardType.emailAddress
        forgotPassWordTF.autocorrectionType = .no
        forgotPassWordTF.autocapitalizationType = .none
        forgotPassWordTF.spellCheckingType = .no
        footerView.addSubview(forgotPassWordTF)
        
        
        CancelButton2.frame = CGRect(x:10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        CancelButton2.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton2.setTitle("Cancel", for: .normal)
        CancelButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton2.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton2.titleLabel?.textAlignment = .center
        CancelButton2.layer.cornerRadius = 4.0
        CancelButton2.clipsToBounds = true
        CancelButton2.addTarget(self, action: #selector(EventsDetailsVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(CancelButton2)
        
        
        DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton2.setTitle("Done", for: .normal)
        DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton2.titleLabel?.textAlignment = .center
        DoneButton2.layer.cornerRadius = 4.0
        DoneButton2.clipsToBounds = true
        DoneButton2.addTarget(self, action: #selector(EventsDetailsVC.forgotDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(DoneButton2)
        
        forgotPassWordTF.text = ""
        self.addDoneButtonOnKeyboard()
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
        
        self.forgotPassWordTF.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    // MARK: Cancel Button Action :
    func cancelButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    
    // MARK: Done Button Action :
    func forgotDoneButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (forgotPassWordTF.text?.isEmpty)!
        {
            message = "Please Enter Description"
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            if self.CheckCondition == "1"
            {
                
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                PostDataValus.setValue("foodsharings", forKey: "entity")
                PostDataValus.setValue(SharedMealID, forKey: "entity_id")
                PostDataValus.setValue(strUserID, forKey: "user_id")
                PostDataValus.setValue(forgotPassWordTF.text, forKey: "message")
                
                var jsonStringValues = String()
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
                if jsonData == nil {
                    
                }
                else {
                    jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
                    print("jsonString: \(jsonStringValues)")
                }
                
                
                
                print(jsonStringValues)
                
                self.ForgotAPIMethod(baseURL: String(format:"%@%@",Constants.mainURL,"reportissue") , params: jsonStringValues)
                
                
                //self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=report_issue&message=\(forgotPassWordTF.text!)&type_id=\(SharedMealID)&user_id=\(strUserID)&type=2")
            }
            else
            {
                self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=request&message=\(forgotPassWordTF.text!)&type_id=\(SharedMealID)&user_id=\(strUserID)&type=2")
            }
        }
    }
    
    
    @objc private  func ForgotAPIMethod (baseURL:String , params: String)
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
                    
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
