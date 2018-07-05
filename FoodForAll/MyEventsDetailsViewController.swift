//
//  MyEventsDetailsViewController.swift
//  FoodForAll
//
//  Created by think360 on 03/08/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import LCBannerView
import SDWebImage

class MyEventsDetailsViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,LCBannerViewDelegate {

    @IBOutlet var iconView: UIView!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    
    var locationManager = CLLocationManager()
    
    var selectImage = UIImage()
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapBackGrdVw: UIView!
    @IBOutlet weak var imageBanerView: UIView!
    
    @IBOutlet weak var mileLabel: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    
    @IBOutlet weak var txtStartDateTime: UILabel!
    @IBOutlet weak var txtEndDateTime: UILabel!
    
    
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var foodBankName: UILabel!
    @IBOutlet weak var foodBnkNameLbl: UILabel!
    
    @IBOutlet weak var mainScroolView: UIScrollView!
    @IBOutlet weak var shareView: UIView!
   
    @IBOutlet weak var identitylabel: UILabel!
    
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    var Uselocationbutt = UIButton()
    var alertCtrl2: UIAlertController?
    
    
    var foodid = String()
    var identityVal = NSString()
    
    var hiddenView = String()
    var foodbankID = String()
    var percentStr = String()
    var imagesArray = NSArray()
    var listDicFoodBank = NSDictionary()
    var chatlistDic = NSDictionary()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var UserID = NSString()
    var number=NSString()
    var posturl=NSString()
    
    var ZoomButton = UIButton()
    
    var strState = String()
    var checkString = String()
    
    var ShareUrl = String()
    
    @IBOutlet var MyShareView: UIView!
    // @IBOutlet weak var ShareView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconView.isHidden = true

        // Do any additional setup after loading the view.
        
       //  MyShareView.isHidden = true
        
         self.setupAlertCtrl2()
        
        posturl="2"
        
        if UserDefaults.standard.object(forKey: "EVState") != nil
        {
            strState=UserDefaults.standard.object(forKey: "EVState") as! String
        }
        else
        {
            strState = ""
        }
        
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
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
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
        
        self.FoodBankDetailAPImethod()

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

    
    @objc private  func showMapView()
    {
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapBackGrdVw.frame.size.width, height: self.mapBackGrdVw.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        self.mapView.isUserInteractionEnabled = true
        self.mapBackGrdVw.addSubview(mapView)
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.title = self.listDicFoodBank.value(forKey: "city") as? String
        // self.marker.icon = UIImage(named: "map_marker.png")!.withRenderingMode(.alwaysTemplate)
        let image: UIImage = UIImage(named: "map_marker.png")!
        self.marker.icon = self.image(withReduce: image, scaleTo: CGSize(width: CGFloat(40), height: CGFloat(40)))
        self.marker.map = self.mapView
        
        
        
        let DirectionImage = UIImageView()
        DirectionImage.frame = CGRect(x:self.mapBackGrdVw.frame.size.width-50, y:self.mapBackGrdVw.frame.size.height-50, width:40, height:40)
        DirectionImage.image = UIImage(named: "google-2.png")
        DirectionImage.contentMode = .scaleAspectFit
        self.mapBackGrdVw.addSubview(DirectionImage)
        
        Uselocationbutt.frame = CGRect(x:self.mapBackGrdVw.frame.size.width-50, y:self.mapBackGrdVw.frame.size.height-50, width:40, height:40)
        Uselocationbutt.addTarget(self, action: #selector(FoodBankDetailsVC.multipleParamSelector2), for: .touchUpInside)
        self.mapBackGrdVw.addSubview(Uselocationbutt)
        
    }
    
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
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

    
    
    
    
    @objc private  func showBannerView()
    {
        //        imagesArray = [ "http://think360.in/kindr/api/uploads/uploadedPic-956765420.79.jpeg",
        //                        "http://think360.in/kindr/api/uploads/uploadedPic-583508613.798.jpeg",
        //                        "http://think360.in/kindr/api/uploads/uploadedPic-747751351.679.jpeg"]
        
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
    
    
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankDetailAPImethod () -> Void
    {
        var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&event_id=\(foodbankID)&time_zone=\(localTimeZoneName)"
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
                    print(responceDic)
                    self.listDicFoodBank = (responceDic.object(forKey: "eventDetail") as? NSDictionary)!
                    
                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "long") as! String)!
                    
                    self.Directionlatitude = self.listDicFoodBank.value(forKey: "lat") as! String as NSString
                    self.Directionlongitude = self.listDicFoodBank.value(forKey: "long") as! String as NSString
                    
                    self.aboutLabel.text! = self.listDicFoodBank.value(forKey: "desc") as? String ?? ""
                    
                    
                    
                    let straddress = self.listDicFoodBank.value(forKey: "address") as? String ?? ""
                    let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                    self.addressLabel.text! = stradd
                    
                    
                    self.txtStartDateTime.text! = self.listDicFoodBank.object(forKey: "start_datetime") as? String ?? ""
                    
                    self.txtEndDateTime.text! = self.listDicFoodBank.object(forKey: "end_datetime") as? String ?? ""
                    
                    
                    self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "title") as! String)
                    
                  //  self.phoneNumLbl.text! = String(format:"%@",(self.listDicFoodBank .value(forKey: "phone_no") as? String ?? ""))
                  //  self.number = String(format:"%@",(self.listDicFoodBank .value(forKey: "phone_no") as? String ?? "")) as NSString
                    
                    self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
                    
                    if let quantity = (self.listDicFoodBank .value(forKey: "distance")) as? NSNumber
                    {
                        //let strval: String = (quantity: quantity.stringValue) as! String
                        let strval = String(describing: quantity)
                        let str1:String = "With in "
                        let str2:String = "Kms"
                        self.mileLabel.text! = str1 + (strval as String) + str2
                        
                    }
                    else if let quantity = (self.listDicFoodBank .value(forKey: "distance")) as? String
                    {
                        let str1:String = "With in "
                        let str2:String = " Kms"
                        self.mileLabel.text! = str1 + quantity + str2
                    }
                    
                    let stringUrl = self.listDicFoodBank.value(forKey: "user_image") as? NSString ?? ""
                    let url = URL.init(string:stringUrl as String)
                    if NSURL(string:stringUrl as String) != nil
                    {
                       // self.userPic.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "Logo"))
                      //  self.userPic.image = UIImage.init(named: "Logo")
                    }
                    else
                    {
                      //  self.userPic.image = UIImage.init(named: "Logo")
                    }
                    
                    
//                    let strname1 = self.listDicFoodBank.object(forKey: "first_name") as? String ?? ""
//                    let strname2 = self.listDicFoodBank.object(forKey: "last_name") as? String ?? ""
//                    self.userName.text! = strname1+" "+strname2
                    
                   
                    
//                    self.UserID = self.listDicFoodBank.value(forKey: "user_id") as! String as NSString
//
//                    if self.UserID == self.strUserID
//                    {
//                        self.chatButton.isHidden=true
//                        self.callButton.isHidden=true
//                    }
//                    else
//                    {
//                        self.chatButton.isHidden=false
//                        self.callButton.isHidden=false
//
//                        // self.reportView.isHidden = false
//                        // self.RequestView.isHidden = false
//                    }
//
                    
               
                    
                    
                    
//                    if self.identityVal == "1"
//                    {
//                        self.userPic.isHidden = false
//                        self.userName.isHidden = false
//                        self.phoneNumLbl.isHidden = false
//                        self.identitylabel.isHidden = true
//                    }
//                    else
//                    {
//                        self.userPic.isHidden = true
//                        self.userName.isHidden = true
//                        self.phoneNumLbl.isHidden = true
//                        self.identitylabel.isHidden = false
//                    }
                    
                    
                    
                     self.perform(#selector(self.showMapView), with: nil, afterDelay: 0.02)
                    
                    self.imagesArray = (self.listDicFoodBank.object(forKey: "images") as? NSArray)!
                    
                    if self.imagesArray.count == 0
                    {
                        self.imagesArray = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
                        self.perform(#selector(self.showBannerView), with: nil, afterDelay: 0.02)
                    }else{
                        self.perform(#selector(self.showBannerView), with: nil, afterDelay: 0.02)
                    }
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
//
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=eventDetail&event_id=\(foodbankID)&lat=\(currentLatitude)&lon=\(currentLongitude)"
//
//      //  print(params)
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
//
//                 //   print(responceDic)
//                    self.listDicFoodBank = (responceDic.object(forKey: "eventList") as? NSDictionary)!
//
//                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
//                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "longt") as! String)!
//
//                    self.Directionlatitude = self.listDicFoodBank.value(forKey: "lat") as! String as NSString
//                    self.Directionlongitude = self.listDicFoodBank.value(forKey: "longt") as! String as NSString
//
//                    self.aboutLabel.text! = (self.listDicFoodBank.value(forKey: "event_desc") as! String)
//                    self.addressLabel.text! = (self.listDicFoodBank.value(forKey: "address") as! String)
//                    self.txtStartDateTime.text! = String(format:"%@ | %@",(self.listDicFoodBank .value(forKey: "start_date") as! String),(self.listDicFoodBank .value(forKey: "start_time") as! String))
//
//                    self.txtEndDateTime.text! = String(format:"%@ | %@",(self.listDicFoodBank .value(forKey: "end_date") as! String),(self.listDicFoodBank .value(forKey: "end_time") as! String))
//
//                    self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "event_title") as! String)
//
//                     self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
//
//
//
//                    if let quantity = (self.listDicFoodBank .value(forKey: "distance")) as? NSNumber
//                    {
//                        //let strval: String = (quantity: quantity.stringValue) as! String
//                        let strval = String(describing: quantity)
//                        self.mileLabel.text! =  String(format:"%@ Kms Away",strval as String)
//
//
//                    }
//                    else if let quantity = (self.listDicFoodBank .value(forKey: "distance")) as? String
//                    {
//                        self.mileLabel.text! = String(format:"%@ Kms Away",quantity as String)
//                    }
//
//
//
//                    self.perform(#selector(MyFoodBankDetailsVC.showMapView), with: nil, afterDelay: 0.01)
//
//                    self.imagesArray = (self.listDicFoodBank.object(forKey: "image") as? NSArray)!
//
//                    if self.imagesArray.count == 0
//                    {
//                        self.imagesArray = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }else{
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }
//                }
//
//
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
    
    
    
    @IBAction func zoomImageBtnAction(_ sender: Any) {
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "BannerViewFullSizeVC") as? BannerViewFullSizeVC
        self.navigationController?.pushViewController(myVC!, animated: false)
        
        myVC?.imagesArrayFul = imagesArray
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
            Message = "Mobile Number Not Avalilable for this"
            
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
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            
            let baseURL: String  = String(format:"%@",Constants.mainURL)
            let params = "method=set_conversation&buyer_id=\(strUserID)&post_id=\(foodbankID)&selling_id=\(self.UserID)&post_url=\(posturl)"
            
         //   print(params)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                 //   print(responceDic)
                    if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController
                        // myVC?.strConversionId=String(format:"%@",(responceDic.object(forKey: "conversation_id") as! NSNumber)
                        
                        self.foodid = String(format : "%@", responceDic.object(forKey: "conversation_id") as! CVarArg)
                        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func ShareButtClicked(_ sender: UIButton)
    {
         let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
        
        //  let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
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
