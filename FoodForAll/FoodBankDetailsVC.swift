//
//  FoodBankDetailsVC.swift
//  FoodForAll
//
//  Created by amit on 5/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import LCBannerView
import SDWebImage


class VolunteersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var VolunteerlistImage: UIImageView!
    @IBOutlet weak var volunteername: UILabel!
    @IBOutlet weak var volunteerRemoveButt: UIButton!
   
}


class FoodBankDetailsVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,LCBannerViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate
{
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()

    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    
    var locationManager = CLLocationManager()
    
   
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapBackGrdVw: UIView!
    @IBOutlet weak var imageBanerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mileLabel: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var sliderOutlet: WOWMarkSlider!
   
    
    @IBOutlet weak var percentlab: UILabel!
    
    
    @IBOutlet weak var foodBankName: UILabel!
    @IBOutlet weak var foodBnkNameLbl: UILabel!
    
    @IBOutlet weak var mainScroolView: UIScrollView!
    
    @IBOutlet weak var foodbankMangView: UIView!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
   
    @IBOutlet weak var userIdentity: UILabel!
    var identityVal = NSString()
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    var Uselocationbutt = UIButton()
     var alertCtrl2: UIAlertController?
    
    var foodid = String()
    var checkString = String()
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
    
    
    var CheckCondition=String()
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var forgotPassWordTF = ACFloatingTextfield()
    var CancelButton2 = UIButton()
    var DoneButton2 = UIButton()
    
    var VolunteerId = NSString()
    var cell: VolunteersCollectionCell!
    
    var listArrayFoodBankManagerlist = NSDictionary()
    var listArrayFoodVolunteerlist = NSMutableArray()
    var listArrayFoodVolunteerRequestlist = NSMutableArray()
    var listArrayFoodVolunteerGrouplist = NSMutableArray()
    @IBOutlet weak var foodbankManagerView: UIView!
    @IBOutlet weak var foodbankManagerheight: NSLayoutConstraint!
    @IBOutlet weak var foodbankvolunteerlistView: UIView!
    @IBOutlet weak var foodbankvolunteerlistheight: NSLayoutConstraint!
    
    @IBOutlet weak var VolunteerListCollectionView: UICollectionView!
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?

    @IBOutlet weak var volunteerslabel: UILabel!
    
    var VolunteerStatus = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlertCtrl2()
        
        callButton.isHidden=true
        chatButton.isHidden=true
        
        posturl="0"
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            strUserID=myArray.value(forKey: "id") as! NSString
        }
        else
        {
            strUserID = ""
        }
       
        print(percentStr)
        
        if percentStr == "0"
        {
            percentStr = "1"
        }
        if percentStr == "0.0"
        {
            percentStr = "1"
        }
                
        
        ZoomButton.frame = CGRect(x:self.view.frame.size.width-50, y:130, width:40, height:40)
        ZoomButton.setImage(UIImage(named: "ic_aspect_ratio_white_3x.png"), for: .normal)
        ZoomButton.addTarget(self, action: #selector(self.zoomImageBtnAction(_:)), for: UIControlEvents.touchUpInside)
        self.mainScroolView.addSubview(ZoomButton)
        
      self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
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
        //self.mapView.isUserInteractionEnabled = false
        self.mapBackGrdVw.addSubview(mapView)
       
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.title = self.listDicFoodBank.value(forKey: "address") as? String
        self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
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
        titlelabtext.text = String(format: ": %@", self.listDicFoodBank.object(forKey: "fbank_title") as! CVarArg)
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
        Distancelabtext.text = String(format: ": %@ kms", self.listDicFoodBank.object(forKey: "distance") as! CVarArg)
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
        Directionlongitude = self.listDicFoodBank.object(forKey: "longt") as! String as NSString
        
     
        
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
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageBanerView.frame.size.width, height: self.imageBanerView.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        banner?.clipsToBounds = true
        banner?.contentMode = .scaleAspectFill
        imageBanerView.addSubview(banner!)
    }
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankDetailAPImethod () -> Void
    {
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=get_FoodBanks&fbank_id=\(foodbankID)&lat=\(currentLatitude)&longt=\(currentLongitude)&userid=\(strUserID)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    print(responceDic)
                    self.listDicFoodBank = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
                    
                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "longt") as! String)!
                    
                    self.Directionlatitude = self.listDicFoodBank.value(forKey: "lat") as! String as NSString
                    self.Directionlongitude = self.listDicFoodBank.value(forKey: "longt") as! String as NSString
                    
                    self.aboutLabel.text! = (self.listDicFoodBank.value(forKey: "fbank_desc") as! String)
                    self.addressLabel.text! = (self.listDicFoodBank.value(forKey: "address") as! String)
                    self.foodBnkNameLbl.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
                    self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
                    self.userName.text! = (self.listDicFoodBank.value(forKey: "first_name") as! String)
                    let stringUrl = self.listDicFoodBank.value(forKey: "user_pic") as! NSString
                    let url = URL.init(string:stringUrl as String)
                    self.userPic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
                    self.phoneNumLbl.text! = String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String))
                    self.number = String(format:"%@%@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String)) as NSString
                    self.mileLabel.text! = String(format:"%@ Kms Away",(self.listDicFoodBank .value(forKey: "distance") as! String))
                    self.percentlab.text=String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "percentage") as! String),"%")
                    
                    
                    
                    self.identityVal=(self.listDicFoodBank.value(forKey: "identity_hidden") as! String as NSString)
                    
                    if self.identityVal == "1"
                    {
                        self.userPic.isHidden = false
                        self.userName.isHidden = false
                        self.phoneNumLbl.isHidden = false
                        self.userIdentity.isHidden = true
                    }
                    else
                    {
                        self.userPic.isHidden = true
                        self.userName.isHidden = true
                        self.phoneNumLbl.isHidden = true
                        self.userIdentity.isHidden = false
                    }
                    
                    
                    
                    self.UserID=(self.listDicFoodBank.value(forKey: "user_id") as! String as NSString)
                    
                    if self.UserID == self.strUserID
                    {
                        self.chatButton.isHidden=true
                        self.callButton.isHidden=true
                    }
                    else
                    {
                        self.chatButton.isHidden=false
                        self.callButton.isHidden=false
                    }
                    
                    let sValue:String = (self.listDicFoodBank.value(forKey: "percentage") as! String)
                    if sValue == "" {
                        self.sliderOutlet.value = 0
                        
                    }else{
                        self.sliderOutlet.value = Float(sValue)!
                         
                    }
                    
                    self.perform(#selector(MyFoodBankDetailsVC.showMapView), with: nil, afterDelay: 0.01)
                    
                    self.imagesArray = (self.listDicFoodBank.object(forKey: "Foodbank_image") as? NSArray)!.value(forKey: "images") as! NSArray
                    
                    if self.imagesArray.count == 0
                    {
                        self.imagesArray = [ "  "]
                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
                    }else{
                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
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
            
            print(params)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                    print(responceDic)
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
    
    @IBAction func DirectionMapClicked(_ sender: UIButton)
    {
        
    }
    
    
    @IBAction func ShareButtClicked(_ sender: UIButton)
    {
        let text = "https://itunes.apple.com/tw/app/id1242021232"
        
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
            let alert = UIAlertController(title: "Food4All", message: "Please login to Report this foodbank", preferredStyle: UIAlertControllerStyle.alert)
            
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
            self.CheckCondition = "1"
            ReportRequestMethod()
        }
    }
    
    @IBAction func RequestButtClicked(_ sender: UIButton)
    {
        if self.strUserID == ""
        {
            let alert = UIAlertController(title: "Food4All", message: "Please login to Connect this foodbank", preferredStyle: UIAlertControllerStyle.alert)
            
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
            
            if UserDefaults.standard.object(forKey: "volunteerstatus") != nil
            {
                VolunteerStatus = UserDefaults.standard.object(forKey: "volunteerstatus") as! NSString
                
                if VolunteerStatus == "1"
                {
                    self.CheckCondition = "2"
                    ReportRequestMethod()
                }
                else
                {
                    var Message=String()
                    Message = "Please Become a Volunteer to Connect this foodbank"
            
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
            }
            else
            {
            
            
            }
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
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView.backgroundColor = UIColor.white
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
            forgotlab.text="Connect"
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
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:250, height:45)
        forgotPassWordTF.delegate = self
        if self.CheckCondition == "1"
        {
            forgotPassWordTF.placeholder = "Type Here"
        }
        else
        {
            forgotPassWordTF.text = "I wish to serve as a volunteer for this foodbank"
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
        CancelButton2.addTarget(self, action: #selector(FoodBankDetailsVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(CancelButton2)
        
        
        DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton2.setTitle("Done", for: .normal)
        DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton2.titleLabel?.textAlignment = .center
        DoneButton2.addTarget(self, action: #selector(FoodBankDetailsVC.forgotDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(DoneButton2)
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
                self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=report_issue&message=\(forgotPassWordTF.text!)&type_id=\(foodbankID)&user_id=\(strUserID)&type=1")
            }
            else
            {
                self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=request&message=\(forgotPassWordTF.text!)&type_id=\(foodbankID)&user_id=\(strUserID)&type=1")
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

    
    // MARK:  FoodBank Volunteers
    
    override func viewWillAppear(_ animated: Bool) {
       
         self.navigationController?.isNavigationBarHidden = true
        
         self.FoodBankManagerAPImethod()

    }
    
    
    
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankManagerAPImethod () -> Void
    {
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=foodBank_volunteer&foodbankid=\(foodbankID)&userid=\(strUserID)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    print(responceDic)
                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
                    
                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
                    
                    self.VolunteerListCollectionView .reloadData()
                    
                    if self.listArrayFoodVolunteerlist.count == 0
                    {
                        self.foodbankManagerheight.constant = 0
                        self.volunteerslabel.isHidden = true
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
    }
    
    
   // MARK:  Collection View Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.listArrayFoodVolunteerlist.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolunteersCollectionCell", for: indexPath) as! VolunteersCollectionCell
        

        cell.volunteername.text! = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as! String
        
        let imageURL: String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
        let url = NSURL(string:imageURL)
        cell.VolunteerlistImage.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        let userID:String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        if userID == strUserID as String
        {
            cell.volunteerRemoveButt.isHidden = false
            cell.volunteerRemoveButt.tag = indexPath.row
            cell.volunteerRemoveButt.addTarget(self, action: #selector(FoodBankDetailsVC.RemoveVolunteerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        }
        else
        {
            cell.volunteerRemoveButt.isHidden = true
        }

        
        
        return cell
    }
    
    
    // MARK: Remove Volunteer Button Action :
    func RemoveVolunteerButtonAction(_ sender: UIButton!)
    {
        VolunteerId = (self.listArrayFoodVolunteerlist.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String as NSString
        
        print(VolunteerId)
        
        
        let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Exit from this foodbank", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
            self.deletemethod()
        })
        
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func deletemethod()
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=manage_foodBank_volunteer&user_id=\(VolunteerId)&foodbankid=\(foodbankID)&type=1"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                    print(responceDic)
                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
                    
                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
                    
                    self.VolunteerListCollectionView .reloadData()
                    
                    
                    if self.listArrayFoodVolunteerlist.count == 0
                    {
                        self.foodbankManagerheight.constant = 0
                        self.volunteerslabel.isHidden = true
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
        
        
    }
    

    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let VolunteerID:String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
       
        self.GetVolunteerDetailslistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=volunteerDetail&user_id=\(VolunteerID)&lat=\(firstLatitude)&lon=\(firstLongitude)")
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
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}