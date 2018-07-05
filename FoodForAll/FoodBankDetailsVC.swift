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
    @IBOutlet weak var volunteerRemoveButt2: UIButton!
    @IBOutlet weak var volunteerRemoveButt: UIButton!
   
}

class FoodCategoriesCell: UICollectionViewCell
{
    @IBOutlet var FoodTypeImage: UIImageView!
    @IBOutlet var FoodtypeName: UILabel!
    
}



class FoodBankDetailsVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,LCBannerViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate
{
     @IBOutlet var iconView: UIView!
    @IBOutlet weak var ShareView: UIView!
    
    var camera2 = GMSCameraPosition()
    var mapView2 = GMSMapView()
    var marker2 = GMSMarker()
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
     lazy var geocoder = CLGeocoder()

    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
      var locationlab = UILabel()
    
    var locationManager = CLLocationManager()
   
   // var myLatitude = Double()
   // var myLongitude = Double()
    var searchViewController = ABCGooglePlacesSearchViewController()
    
    
    
    @IBOutlet var FoodCategoryCollectionViewCell: UICollectionView!
    
   
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapBackGrdVw: UIView!
    @IBOutlet weak var imageBanerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
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
    var identityVal = String()
    
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
    var strUserID = String()
    var UserID = String()
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
    
    var popview4 = UIView()
    var footerView4 = UIView()
    var popview3 = UIView()
    var footerView3 = UIView()
     var citylab = UILabel()
    var CancelButton4 = UIButton()
    var DoneButton4 = UIButton()
    var CancelButton3 = UIButton()
    var DoneButton3 = UIButton()
    var locationButt = UIButton()
    
    var VolunteerId = NSString()
    var cell: VolunteersCollectionCell!
     var cell2: FoodCategoriesCell!
    
    var listArrayFoodBankManagerlist = NSDictionary()
    var listArrayFoodVolunteerlist = NSMutableArray()
    var listArrayFoodVolunteerRequestlist = NSMutableArray()
    var listArrayFoodVolunteerGrouplist = NSMutableArray()
    @IBOutlet weak var foodbankManagerView: UIView!
    @IBOutlet weak var foodbankManagerheight: NSLayoutConstraint!
    @IBOutlet weak var foodbankvolunteerlistView: UIView!
     @IBOutlet weak var VolunteerCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var foodbankvolunteerlistheight: NSLayoutConstraint!
    
    @IBOutlet weak var VolunteerListCollectionView: UICollectionView!
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    var FoodCategoriesArray = NSMutableArray()

    @IBOutlet weak var volunteerslabel: UILabel!
    
    var VolunteerStatus = NSString()
    
     var ShareUrl = String()
    var strpage = String()
    var imgFolderAry = NSMutableArray()
    var TextDescription = UITextView()
    
    var strmapcheck = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  ShareView.isHidden = true
        iconView.isHidden = true
        self.setupAlertCtrl2()
          searchViewController.delegate=self
        
        callButton.isHidden=true
        chatButton.isHidden=true
        
        posturl="0"
        
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
       
      //  print(percentStr)
        
        if percentStr == "0"
        {
            percentStr = "1"
        }
        if percentStr == "0.0"
        {
            percentStr = "1"
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
        strmapcheck = "1"
        camera2 = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapBackGrdVw.frame.size.width, height: self.mapBackGrdVw.frame.size.height), camera: camera2)
       // mapView2.delegate = self
        self.mapView2.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        //self.mapView.isUserInteractionEnabled = false
        self.mapBackGrdVw.addSubview(mapView2)
       
        self.marker2.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker2.title = self.listDicFoodBank.value(forKey: "address") as? String
        self.marker2.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
        self.marker2.map = self.mapView2
        
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
        else if let quantity = self.listDicFoodBank.object(forKey: "distance") as? String
        {
            Distancelabtext.text = String(format: ": %@ Kms",quantity)
        }
       // Distancelabtext.text = String(format: ": %@ kms", self.listDicFoodBank.object(forKey: "distance") as! CVarArg)
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
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankDetail",params)
        
        print(baseURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.listDicFoodBank = (responceDic.object(forKey: "foodbankDetail") as? NSDictionary)!
                    
                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "long") as! String)!
                    
                    self.Directionlatitude = self.listDicFoodBank.value(forKey: "lat") as! String as NSString
                    self.Directionlongitude = self.listDicFoodBank.value(forKey: "long") as! String as NSString
                    
                    
                    
                    let strname: String = self.listDicFoodBank.value(forKey: "title") as? String ?? ""
                    let strCategory: String = self.listDicFoodBank.value(forKey: "categorytype") as? String ?? ""
                    
                    self.FoodCategoriesArray = (self.listDicFoodBank.value(forKey: "food_categories") as? NSMutableArray)!
                    self.FoodCategoryCollectionViewCell.reloadData()
                    
                    let mutableAttributedString = NSMutableAttributedString()
                    let regularAttribute = [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                        NSForegroundColorAttributeName: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                        ] as [String : Any]
                    let boldAttribute = [
                        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                        NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                        ] as [String : Any]
                    
                    let boldAttributedString = NSAttributedString(string: strname, attributes: boldAttribute)
                    let regularAttributedString = NSAttributedString(string: "\n", attributes: regularAttribute)
                    let regularAttributedString2 = NSAttributedString(string: strCategory, attributes: regularAttribute)
                    
                    mutableAttributedString.append(boldAttributedString)
                    mutableAttributedString.append(regularAttributedString)
                    mutableAttributedString.append(regularAttributedString2)
                  //  self.foodBankName.attributedText = mutableAttributedString
                     self.foodBankName.text = strname
                    
                    let stringUrl2 = self.listDicFoodBank.value(forKey: "logo_image") as? NSString ?? ""
                    let url2 = URL.init(string:stringUrl2 as String)
                    self.logoImageView.sd_setImage(with: url2 , placeholderImage: UIImage(named: "applogo.png"))
                    
                    
                    self.aboutLabel.text! = (self.listDicFoodBank.value(forKey: "desc") as! String)
                    let straddress =  self.listDicFoodBank.value(forKey: "address") as? String ?? ""
                    let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                    self.addressLabel.text! = stradd
                    self.foodBnkNameLbl.text! = (self.listDicFoodBank.value(forKey: "title") as! String)
                    //  self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
                    let strname1 = self.listDicFoodBank.value(forKey: "first_name") as? String ?? ""
                    let strname2 = self.listDicFoodBank.value(forKey: "last_name") as? String ?? ""
                    self.userName.text! = strname1+" "+strname2
                    
                    
                    let stringUrl = self.listDicFoodBank.value(forKey: "user_image") as? NSString ?? ""
                    let url = URL.init(string:stringUrl as String)
                    self.userPic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
                    
                    self.phoneNumLbl.text! = String(format:"%@",self.listDicFoodBank .value(forKey: "phone_no") as? String ?? "")
                    self.number = String(format:"%@",(self.listDicFoodBank .value(forKey: "phone_no") as? String ?? "")) as NSString
                   // self.mileLabel.text! = String(format:"%@ Kms Away",(self.listDicFoodBank .value(forKey: "distance") as! String))
                    
                    
                    if let quantity = self.listDicFoodBank .value(forKey: "distance") as? NSNumber
                    {
                        //   let strval: String = (quantity: quantity.stringValue) as! String
                        let strval = String(describing: quantity)
                        self.mileLabel.text! = strval as String + " kms Away"
                        
                    }
                    else if let quantity = self.listDicFoodBank .value(forKey: "distance") as? String
                    {
                        self.mileLabel.text! = quantity+" Kms Away"
                    }
                    
                    
                    
                    self.percentlab.text=String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "capacity_status") as! String),"%")
                    
                    self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
                    
                    self.identityVal = self.listDicFoodBank.value(forKey: "identity_hidden") as? String ?? ""
                    
                    if self.identityVal == "0"
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
                    
                    
                    
                    self.UserID = self.listDicFoodBank.value(forKey: "user_id") as! String
                    
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
                    
                    let sValue:String = (self.listDicFoodBank.value(forKey: "capacity_status") as! String)
                    if sValue == "" {
                        self.sliderOutlet.value = 0
                        
                    }else{
                        self.sliderOutlet.value = Float(sValue)!
                        
                    }
                    
                    self.perform(#selector(MyFoodBankDetailsVC.showMapView), with: nil, afterDelay: 0.01)
                    
                    self.imagesArray = self.listDicFoodBank.value(forKey: "images") as! NSArray
                    
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
        
        
        
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=get_FoodBanks&fbank_id=\(foodbankID)&lat=\(currentLatitude)&longt=\(currentLongitude)&userid=\(strUserID)"
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
//                 //   print(responceDic)
//                    self.listDicFoodBank = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//
//                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
//                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "longt") as! String)!
//
//                    self.Directionlatitude = self.listDicFoodBank.value(forKey: "lat") as! String as NSString
//                    self.Directionlongitude = self.listDicFoodBank.value(forKey: "longt") as! String as NSString
//
//
//
//                    let strname: String = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
//                    let strCategory: String = (self.listDicFoodBank.value(forKey: "categorytype") as! String)
//                    let mutableAttributedString = NSMutableAttributedString()
//                    let regularAttribute = [
//                        NSFontAttributeName: UIFont.systemFont(ofSize: 15),
//                        NSForegroundColorAttributeName: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//                        ] as [String : Any]
//                    let boldAttribute = [
//                        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
//                        NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
//                        ] as [String : Any]
//
//                    let boldAttributedString = NSAttributedString(string: strname, attributes: boldAttribute)
//                    let regularAttributedString = NSAttributedString(string: "\n", attributes: regularAttribute)
//                    let regularAttributedString2 = NSAttributedString(string: strCategory, attributes: regularAttribute)
//
//                    mutableAttributedString.append(boldAttributedString)
//                    mutableAttributedString.append(regularAttributedString)
//                    mutableAttributedString.append(regularAttributedString2)
//                    self.foodBankName.attributedText = mutableAttributedString
//
//                    let stringUrl2 = self.listDicFoodBank.value(forKey: "logo_image") as! NSString
//                    let url2 = URL.init(string:stringUrl2 as String)
//                    self.logoImageView.sd_setImage(with: url2 , placeholderImage: UIImage(named: "applogo.png"))
//
//
//                    self.aboutLabel.text! = (self.listDicFoodBank.value(forKey: "fbank_desc") as! String)
//                    self.addressLabel.text! = (self.listDicFoodBank.value(forKey: "address") as! String)
//                    self.foodBnkNameLbl.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
//                  //  self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
//                    self.userName.text! = (self.listDicFoodBank.value(forKey: "first_name") as! String)
//                    let stringUrl = self.listDicFoodBank.value(forKey: "user_pic") as? NSString ?? ""
//                    let url = URL.init(string:stringUrl as String)
//                    self.userPic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
//                    self.phoneNumLbl.text! = String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String))
//                    self.number = String(format:"%@%@",(self.listDicFoodBank .value(forKey: "country_code") as! String),(self.listDicFoodBank .value(forKey: "phone_no") as! String)) as NSString
//                    self.mileLabel.text! = String(format:"%@ Kms Away",(self.listDicFoodBank .value(forKey: "distance") as! String))
//                    self.percentlab.text=String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "percentage") as! String),"%")
//
//                     self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
//
//                    self.identityVal=(self.listDicFoodBank.value(forKey: "identity_hidden") as! String as NSString)
//
//                    if self.identityVal == "1"
//                    {
//                        self.userPic.isHidden = false
//                        self.userName.isHidden = false
//                        self.phoneNumLbl.isHidden = false
//                        self.userIdentity.isHidden = true
//                    }
//                    else
//                    {
//                        self.userPic.isHidden = true
//                        self.userName.isHidden = true
//                        self.phoneNumLbl.isHidden = true
//                        self.userIdentity.isHidden = false
//                    }
//
//
//
//                    self.UserID = self.listDicFoodBank.value(forKey: "user_id") as! String
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
//                    }
//
//                    let sValue:String = (self.listDicFoodBank.value(forKey: "percentage") as! String)
//                    if sValue == "" {
//                        self.sliderOutlet.value = 0
//
//                    }else{
//                        self.sliderOutlet.value = Float(sValue)!
//
//                    }
//
//                    self.perform(#selector(MyFoodBankDetailsVC.showMapView), with: nil, afterDelay: 0.01)
//
//                    self.imagesArray = (self.listDicFoodBank.object(forKey: "Foodbank_image") as? NSArray)!.value(forKey: "images") as! NSArray
//
//                    if self.imagesArray.count == 0
//                    {
//                        self.imagesArray = [ "  "]
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }else{
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }
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


    
    
    @IBAction func zoomImageBtnAction(_ sender: Any)
    {
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
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            
            let baseURL: String  = String(format:"%@%@",Constants.mainURL,"addChat")
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(self.UserID, forKey: "sender_id")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue("foodbanks", forKey: "entity")
            PostDataValus.setValue(foodbankID, forKey: "entity_id")
            
           
            
            
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
            //let params = "method=set_conversation&buyer_id=\(strUserID)&post_id=\(foodbankID)&selling_id=\(self.UserID)&post_url=\(posturl)"
            
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
                        // myVC?.strConversionId=String(format:"%@",(responceDic.object(forKey: "conversation_id") as! NSNumber)
                        
                        if let quantity = responceDic.object(forKey: "chat_id") as? NSNumber
                        {
                            self.foodid =  String(describing: quantity)
                        }
                        else if let quantity = responceDic.object(forKey: "chat_id") as? String
                        {
                            self.foodid = quantity
                        }
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
        let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
        
      //   let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
        
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
            let alert = UIAlertController(title: "Food4All", message: "Are you sure want to Report this FoodBank", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Yes", style: UIAlertActionStyle.default,handler: { action in
                 self.CheckCondition = "1"
                self.ReportRequestMethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"No", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
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
                   // self.CheckCondition = "2"
                  //  ReportRequestMethod()
                    
                    
                    let alert = UIAlertController(title: "Food4All", message: "Are you sure want to connect this foodbank", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertOKAction=UIAlertAction(title:"Yes", style: UIAlertActionStyle.default,handler: { action in
                        
                        let strkey = Constants.ApiKey
                        
                        let PostDataValus = NSMutableDictionary()
                        PostDataValus.setValue(strkey, forKey: "api_key")
                        PostDataValus.setValue(self.strUserID, forKey: "user_id")
                        PostDataValus.setValue("1", forKey: "connect_foodbank")
                        PostDataValus.setValue(self.foodbankID, forKey: "foodbank_id")
                        
                        
                        
                        
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
                    })
                    
                    let alertCancelAction=UIAlertAction(title:"No", style: UIAlertActionStyle.destructive,handler: { action in
                        
                    })
                    
                    alert.addAction(alertOKAction)
                    alert.addAction(alertCancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                  //  var Message=String()
                 //   Message = "Please Become a Volunteer to Connect this foodbank"
            
                 //   AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                    
                    
                    let alert = UIAlertController(title: "Food4All", message: "If you want to connect the Foodbanks Please become a volunteer first", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertOKAction=UIAlertAction(title:"Become Volunteer", style: UIAlertActionStyle.default,handler: { action in
                        
                       self.becomeVolunteer()
                    })
                    
                    let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                        
                    })
                    
                    alert.addAction(alertOKAction)
                    alert.addAction(alertCancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
            
            
            }
        }
    }
    
    
    func becomeVolunteer()
    {
        popview4.isHidden=false
        footerView4.isHidden=false
       
        
        
        popview4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview4.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview4)
        
        footerView4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height-50)
        footerView4.backgroundColor = UIColor.white
        popview4.addSubview(footerView4)
        
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerView4.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView4.addSubview(bglab)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerView4.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Want To Become Volunteer?"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView4.addSubview(forgotlab)
        
        
        
        
        let userProfile = UIView()
        userProfile.frame = CGRect(x:0, y:forgotlab.frame.size.height+forgotlab.frame.origin.y, width:footerView4.frame.size.width, height:150  )
        userProfile.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        footerView4.addSubview(userProfile)
        
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
        labUnderline.frame = CGRect(x:0, y:userProfile.frame.origin.y+userProfile.frame.size.height+1, width:footerView4.frame.size.width, height:2)
        // labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.backgroundColor = UIColor.clear
        footerView4.addSubview(labUnderline)
        
        
        
        let Descriptionlab = UILabel()
        Descriptionlab.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:footerView4.frame.size.width-20, height:15)
        Descriptionlab.text = "About Me"
        Descriptionlab.textColor = UIColor.lightGray
        footerView4.addSubview(Descriptionlab)
        
        TextDescription.frame = CGRect(x:10, y:Descriptionlab.frame.size.height+Descriptionlab.frame.origin.y+5, width:footerView4.frame.size.width-20, height:50)
        TextDescription.delegate = self
        TextDescription.textAlignment = .left
        TextDescription.text = "Enter your text here.."
        TextDescription.textColor = UIColor.lightGray
        TextDescription.layer.borderColor = UIColor.lightGray.cgColor
        footerView4.addSubview(TextDescription)
        
        
        let linelab = UILabel()
        linelab.frame = CGRect(x:10, y:TextDescription.frame.size.height+TextDescription.frame.origin.y, width:footerView4.frame.size.width-20, height:1)
        linelab.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        footerView4.addSubview(linelab)
        
        
        let locationlab = UILabel()
        locationlab.frame = CGRect(x:10, y:linelab.frame.size.height+linelab.frame.origin.y+15, width:footerView4.frame.size.width-20, height:15)
        locationlab.text = "Address"
        locationlab.textColor = UIColor.lightGray
        footerView4.addSubview(locationlab)
        
        
        
        let Cityview = UIView()
        Cityview.frame = CGRect(x:10, y:locationlab.frame.size.height+locationlab.frame.origin.y+5, width:footerView4.frame.size.width-20, height:50)
        Cityview.layer.borderWidth=1.0
        Cityview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
        footerView4.addSubview(Cityview)
        
        
        
        citylab.frame = CGRect(x:5, y:5, width:Cityview.frame.size.width-10, height:40)
        citylab.text = " Select Location"
        citylab.textAlignment = .center
        citylab.font =  UIFont(name:"Helvetica", size: 15)
        citylab.numberOfLines = 2
        Cityview.addSubview(citylab)
        
        locationButt.frame = CGRect(x:0, y:0, width:Cityview.frame.size.width, height:Cityview.frame.size.height)
        locationButt.backgroundColor=UIColor.clear
        locationButt.addTarget(self, action: #selector(self.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Cityview.addSubview(locationButt)
        
        
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:10, y:Cityview.frame.size.height+Cityview.frame.origin.y+15, width:footerView4.frame.size.width-80, height:50)
        Headview.layer.borderWidth=0.0
        Headview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
        footerView4.addSubview(Headview)
        
    
        let mutableAttributedString = NSMutableAttributedString()
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        let regularAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        let regularAttributedString = NSAttributedString(string: "Connect FoodBank: ", attributes: regularAttribute)
        let boldAttributedString = NSAttributedString(string: self.listDicFoodBank.value(forKey: "title") as? String ?? "", attributes: boldAttribute)
        mutableAttributedString.append(regularAttributedString)
        mutableAttributedString.append(boldAttributedString)
        
    
        let foodbankNamelab = UILabel()
        foodbankNamelab.frame = CGRect(x:5, y:5, width:Headview.frame.size.width-10, height:40)
        foodbankNamelab.attributedText = mutableAttributedString
        foodbankNamelab.font =  UIFont(name:"Helvetica", size: 15)
        foodbankNamelab.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        foodbankNamelab.numberOfLines = 0
        foodbankNamelab.textAlignment = .left
        Headview.addSubview(foodbankNamelab)
        
        
        CancelButton4.frame = CGRect(x:10, y:footerView4.frame.size.height-50, width:footerView4.frame.size.width/2-15, height:40)
        CancelButton4.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton4.setTitle("Cancel", for: .normal)
        CancelButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        CancelButton4.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton4.titleLabel?.textAlignment = .center
        CancelButton4.addTarget(self, action: #selector(self.cancelButtonActionmet(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(CancelButton4)
        
        
        DoneButton4.frame = CGRect(x:CancelButton4.frame.size.width+CancelButton4.frame.origin.x+10, y:footerView4.frame.size.height-50, width:footerView4.frame.size.width/2-15, height:40)
        DoneButton4.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton4.setTitle("Become Volunteer", for: .normal)
        DoneButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 15)
        DoneButton4.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton4.titleLabel?.textAlignment = .center
        DoneButton4.addTarget(self, action: #selector(self.VolunteerDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(DoneButton4)
        
        self.setUsersClosestCity()
        
        self.addDoneButtonOnKeyboard3()
    }
    
    func cancelButtonActionmet(_ sender: UIButton!)
    {
        popview4.isHidden=true
        footerView4.isHidden=true
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
        
        self.TextDescription.inputAccessoryView = doneToolbar
        
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
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
        
        footerView3.frame = CGRect(x:0, y:0, width:popview3.frame.size.width, height:popview3.frame.size.height-50)
        footerView3.backgroundColor = UIColor.white
        popview3.addSubview(footerView3)
        
        strmapcheck = "2"
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView3.frame.size.width, height: footerView3.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        footerView3.addSubview(mapView)
        
        
        
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
        locationlab.text = self.citylab.text!
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
      //  tabBarController?.tabBar.isHidden=false
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
       // tabBarController?.tabBar.isHidden=false
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
        
        firstLatitude = (locationManager.location?.coordinate.latitude)!
        firstLatitude = (locationManager.location?.coordinate.longitude)!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
        
        camera = GMSCameraPosition.camera(withLatitude: firstLatitude, longitude: firstLatitude, zoom: 8.0)
        self.mapView2.animate(to: camera)
        
        self.setUsersClosestCity()
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
                //  print(formattedAddress.joined(separator: ", "))
                
                self.citylab.text! = formattedAddress.joined(separator: ", ")
                self.locationlab.text = formattedAddress.joined(separator: ", ")
            }
            
        })
        
    }
    
    
    
    // MARK: Done Button Action :
    func VolunteerDoneButtonAction(_ sender: UIButton!)
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
            //                self.BecomeVolunteerAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=Becomevolenteer&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&description=\(TextDescription.text!)&address=\(citylab.text!)&foodbankid=\(strFoodbankId)&is_foodbank=1")
            
            // let strkey = Constants.ApiKey
            
            let strlat = "\(firstLatitude)"
            let strlong = "\(firstLongitude)"
            
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue("1", forKey: "connect_foodbank")
            PostDataValus.setValue(foodbankID, forKey: "foodbank_id")
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
    
    
    
    
    
    @objc private  func BecomeVolunteerAPIMethod (baseURL:String , params: String)
    {
      print(baseURL)
       print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.popview4.isHidden=true
                    self.footerView4.isHidden=true
                    
                     UserDefaults.standard.set("1", forKey: "volunteerstatus")
                    
                    let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
                    let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
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
        CancelButton2.layer.cornerRadius = 4.0
        CancelButton2.clipsToBounds = true
        CancelButton2.addTarget(self, action: #selector(FoodBankDetailsVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(CancelButton2)
        
        
        DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton2.setTitle("Done", for: .normal)
        DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton2.titleLabel?.textAlignment = .center
        DoneButton2.layer.cornerRadius = 4.0
        DoneButton2.clipsToBounds = true
        DoneButton2.addTarget(self, action: #selector(FoodBankDetailsVC.forgotDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
                PostDataValus.setValue("foodbanks", forKey: "entity")
                PostDataValus.setValue(foodbankID, forKey: "entity_id")
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
                
    
               // self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=report_issue&message=\(forgotPassWordTF.text!)&type_id=\(foodbankID)&user_id=\(strUserID)&type=1")
                
            }
            else
            {
                self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=request&message=\(forgotPassWordTF.text!)&type_id=\(foodbankID)&user_id=\(strUserID)&type=1")
            }
        }
        
    }
    
    
    @objc private  func ForgotAPIMethod (baseURL:String , params: String)
    {
      //  print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
              //  print(responceDic)
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
    
    override func viewWillAppear(_ animated: Bool)
    {
         self.navigationController?.isNavigationBarHidden = true
         self.FoodBankManagerAPImethod()
    }
    
    
    
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankManagerAPImethod () -> Void
    {
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankVolunteers",params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    //  print(responceDic)
                    
                    self.listArrayFoodVolunteerlist.removeAllObjects()
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                     self.listArrayFoodVolunteerlist = (responceDic.object(forKey: "volunteerList") as? NSMutableArray)!
                    
                   // self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
                    
                  //  self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
                  //  self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
                  //  self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
                    
                    self.VolunteerListCollectionView .reloadData()
                    
                    if self.listArrayFoodVolunteerlist.count == 0
                    {
                        self.foodbankManagerheight.constant = 0
                        self.volunteerslabel.isHidden = true
                    }
                    else
                    {
                        var a = Int()
                        
                        let userInterface = UIDevice.current.userInterfaceIdiom
                        
                        if(userInterface == .pad)
                        {
                            a = 4
                        }
                        else
                        {
                            a = 3
                        }
                        
                        let b: Int = self.listArrayFoodVolunteerlist.count%a
                        
                        var val = Int()
                        
                        if b==0
                        {
                            val = 0
                        }
                        else
                        {
                            val = 1
                        }
                        
                        self.foodbankManagerheight.constant =  (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*164)+50
                        self.foodbankvolunteerlistheight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*164)+50
                        self.VolunteerCollectionHeight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*174)
                    }
                }
                else
                {
                    self.foodbankManagerheight.constant = 0
                    self.volunteerslabel.isHidden = true
                    self.listArrayFoodVolunteerlist.removeAllObjects()
                    self.VolunteerListCollectionView .reloadData()
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
        
        
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=foodBank_volunteer&foodbankid=\(foodbankID)&userid=\(strUserID)"
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
//                  //  print(responceDic)
//                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//
//                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
//
//                    self.VolunteerListCollectionView .reloadData()
//
//                    if self.listArrayFoodVolunteerlist.count == 0
//                    {
//                        self.foodbankManagerheight.constant = 0
//                        self.volunteerslabel.isHidden = true
//                    }
//                    else
//                    {
//                        var a = Int()
//
//                        let userInterface = UIDevice.current.userInterfaceIdiom
//
//                        if(userInterface == .pad)
//                        {
//                            a = 5
//                        }
//                        else
//                        {
//                            a = 3
//                        }
//
//                        let b: Int = self.listArrayFoodVolunteerlist.count%a
//
//                        var val = Int()
//
//                        if b==0
//                        {
//                            val = 0
//                        }
//                        else
//                        {
//                            val = 1
//                        }
//
//                        self.foodbankManagerheight.constant =  (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*163)+50
//                        self.foodbankvolunteerlistheight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*163)+50
//                        self.VolunteerCollectionHeight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*173)
//                    }
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
    
    
   // MARK:  Collection View Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            return self.FoodCategoriesArray.count
        }
        else
        {
            return self.listArrayFoodVolunteerlist.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            return CGSize(width: 80 , height: 80)
        }
        else
        {
            let userInterface = UIDevice.current.userInterfaceIdiom
            
            if(userInterface == .pad)
            {
                return CGSize(width: (self.view.frame.size.width-40) / 4 , height: 163)
                
            }
            return CGSize(width: (self.view.frame.size.width-32) / 3  , height: 163)
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == FoodCategoryCollectionViewCell
        {
           cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoriesCell", for: indexPath) as! FoodCategoriesCell
            
            let imageURL: String = (self.FoodCategoriesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            cell2.FoodTypeImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            
            cell2.FoodtypeName.text = (self.FoodCategoriesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
             return cell2
        }
        else
        {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolunteersCollectionCell", for: indexPath) as! VolunteersCollectionCell
        

       // cell.volunteername.text! = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as! String
        
        let strname1 = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
        let strname2 = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
         cell.volunteername.text! = strname1+" "+strname2
        
        let imageURL: String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
        let url = NSURL(string:imageURL)
        cell.VolunteerlistImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        let userID:String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        if userID == strUserID as String
        {
            
            cell.volunteerRemoveButt2.isHidden = false
            cell.volunteerRemoveButt2.tag = indexPath.row
            cell.volunteerRemoveButt2.addTarget(self, action: #selector(FoodBankDetailsVC.RemoveVolunteerButtonAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell.volunteerRemoveButt.isHidden = false
            cell.volunteerRemoveButt.tag = indexPath.row
            cell.volunteerRemoveButt.addTarget(self, action: #selector(FoodBankDetailsVC.RemoveVolunteerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        }
        else
        {
            cell.volunteerRemoveButt2.isHidden = true
            cell.volunteerRemoveButt.isHidden = true
        }

      //  cell.volunteerRemoveButt.isHidden = true
        
        return cell
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
                if collectionView == FoodCategoryCollectionViewCell
                {
                    
                }
                else
                {
                
                let strkey = Constants.ApiKey
                let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)&page=\(self.strpage)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankVolunteers",params)
                
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
    }
    
    
    func responsewithToken7(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "volunteerList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayFoodVolunteerlist.addObjects(from: arr as [AnyObject])
        
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
        
        self.VolunteerListCollectionView .reloadData()
        
        if self.listArrayFoodVolunteerlist.count == 0
        {
            self.foodbankManagerheight.constant = 0
            self.volunteerslabel.isHidden = true
        }
        else
        {
            var a = Int()
            
            let userInterface = UIDevice.current.userInterfaceIdiom
            
            if(userInterface == .pad)
            {
                a = 4
            }
            else
            {
                a = 3
            }
            
            let b: Int = self.listArrayFoodVolunteerlist.count%a
            
            var val = Int()
            
            if b==0
            {
                val = 0
            }
            else
            {
                val = 1
            }
            
            self.foodbankManagerheight.constant =  (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*164)+50
            self.foodbankvolunteerlistheight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*164)+50
            self.VolunteerCollectionHeight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*174)
        }
    }
    
    
    
    // MARK: Remove Volunteer Button Action :
    func RemoveVolunteerButtonAction(_ sender: UIButton!)
    {
        VolunteerId = (self.listArrayFoodVolunteerlist.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String as NSString
        
     //   print(VolunteerId)
        
        
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
        
        self.imgFolderAry.removeAllObjects()
        
        var arrPath = [Any]()
        arrPath.append(VolunteerId)
        self.imgFolderAry.addObjects(from: arrPath)
        
        var responseString = String()
        let jsonData2: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
        responseString = String(data: jsonData2!, encoding: .utf8)!
        responseString = responseString.replacingOccurrences(of: " ", with: "%20")
        
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbankVolunteers")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(foodbankID, forKey: "foodbank_id")
        PostDataValus.setValue(responseString, forKey: "user_ids")
        PostDataValus.setValue("1", forKey: "type")
        
        var jsonStringValues = String()
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        if jsonData == nil {
            
        }
        else {
            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
            print("jsonString: \(jsonStringValues)")
        }
        
        
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                    self.FoodBankManagerAPImethod()
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
        
        
        
        
        
//        
//        
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=manage_foodBank_volunteer&user_id=\(VolunteerId)&foodbankid=\(foodbankID)&type=1"
//        
//       // print(params)
//        
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//            
//            DispatchQueue.main.async {
//                //AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//             //   print(responceDic)
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    
//                 //   print(responceDic)
//                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//                    
//                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
//                    
//                    self.VolunteerListCollectionView .reloadData()
//                    
//                    
//                    if self.listArrayFoodVolunteerlist.count == 0
//                    {
//                        self.foodbankManagerheight.constant = 0
//                        self.volunteerslabel.isHidden = true
//                    }
//                    else
//                    {
//                        var a = Int()
//                        
//                        let userInterface = UIDevice.current.userInterfaceIdiom
//                        
//                        if(userInterface == .pad)
//                        {
//                            a = 5
//                        }
//                        else
//                        {
//                            a = 3
//                        }
//                        
//                        let b: Int = self.listArrayFoodVolunteerlist.count%a
//                        
//                        var val = Int()
//                        
//                        if b==0
//                        {
//                            val = 0
//                        }
//                        else
//                        {
//                            val = 1
//                        }
//                        
//                        self.foodbankManagerheight.constant =  (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*163)+50
//                        self.foodbankvolunteerlistheight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*163)+50
//                        self.VolunteerCollectionHeight.constant = (CGFloat((self.listArrayFoodVolunteerlist.count/a)+(val))*173)
//                    }
//
//                    
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
//            
//        }) { (error) in
//            
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
//        
        
    }
    

    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            
        }
        else
        {
            let VolunteerID:String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
       
            var localTimeZoneName: String { return TimeZone.current.identifier }
            let strkey = Constants.ApiKey
            let params = "api_key=\(strkey)&lat=\(myLatitude)&long=\(myLongitude)&user_id=\(VolunteerID)&time_zone=\(localTimeZoneName)"
            let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"volunteerDetail",params)
            print(baseURL)
            self.VolunteerDetailAPIMethod(baseURL: String(format:"%@",baseURL))
        }
        
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
        
      //  print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
            //    print(responceDic)
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
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        if strmapcheck == "1"
        {
        }
        else
        {
        mapView.delegate = self;
        
        firstLatitude=position.target.latitude
        firstLongitude=position.target.longitude
        
        
        self.citylab.text! = "Featching Address..."
        locationlab.text = "Featching Address..."
        
      //  self.marker.position = CLLocationCoordinate2D(latitude: firstLatitude, longitude: firstLongitude)
      //  self.marker.map = self.mapView
        
     //   camera = GMSCameraPosition.camera(withLatitude: firstLatitude, longitude: firstLongitude, zoom: 8.0)
     //   self.mapView.animate(to: camera)
        
        
        let location = CLLocation(latitude: firstLatitude, longitude: firstLongitude)
        
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        }
        
    }
    
    
    private func mapView(mapView:GMSMapView!,idleAtCameraPosition position:GMSCameraPosition!)
    {
        // print(position)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
            //   print("Unable to Reverse Geocode Location (\(error))")
            self.citylab.text! = "Unable to Find Address for Location"
            locationlab.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.citylab.text! = placemark.compactAddress!
                locationlab.text = placemark.compactAddress!
                //  print( self.citylab.text!)
            } else {
                self.citylab.text! = "No Matching Addresses Found"
                locationlab.text = "No Matching Addresses Found"
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}






extension FoodBankDetailsVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        citylab.text=place.formatted_address
        locationlab.text = place.formatted_address
        firstLatitude=place.location.coordinate.latitude
        firstLongitude=place.location.coordinate.longitude
        
        camera = GMSCameraPosition.camera(withLatitude: firstLatitude, longitude: firstLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
    }
}

