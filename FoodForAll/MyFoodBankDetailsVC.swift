//
//  MyFoodBankDetailsVC.swift
//  FoodForAll
//
//  Created by amit on 5/9/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import LCBannerView
import SDWebImage


class VolunteersCollectionCell2: UICollectionViewCell {
    
    @IBOutlet weak var VolunteerlistImage: UIImageView!
    @IBOutlet weak var volunteername: UILabel!
    @IBOutlet weak var volunteerRemoveButt: UIButton!
    
}

class VoluntRequestCell: UICollectionViewCell {
    
    @IBOutlet weak var VolReqImage: UIImageView!
    @IBOutlet weak var VolReqName: UILabel!
    @IBOutlet weak var ReqAcceptButt: UIButton!
    @IBOutlet weak var ReqRejectbutt: UIButton!
   
    
}


class MyFoodBankDetailsVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,LCBannerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
     @IBOutlet var iconView: UIView!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var foodBankName: UILabel!
    @IBOutlet weak var imagesBanerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var aboutDiscLabel: UILabel!
    @IBOutlet weak var mapBackGrndView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sliderOutlet: WOWMarkSlider!
    @IBOutlet weak var foodBnNameLbl: UILabel!
    @IBOutlet weak var percentLab: UILabel!
    @IBOutlet weak var mainScroolView: UIScrollView!
    @IBOutlet weak var AddVolunteersButt: UIButton!
    
     @IBOutlet weak var mileLabel: UILabel!
    
    var ZoomButton = UIButton()
    
    var listDicFoodBank = NSDictionary()
    
    var foodbankID = String()
    var percentStr = String()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var UserID = NSString()
    
    
    var  imagesArray = NSArray()
    var checkString = String()
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    var Uselocationbutt = UIButton()
    var alertCtrl2: UIAlertController?

    var VolunteerId = NSString()
    var RequestId = NSString()
    var typeId = NSString()
    var cell: VolunteersCollectionCell2!
    var cell2: VoluntRequestCell!
    
    var listArrayFoodBankManagerlist = NSDictionary()
    var listArrayFoodVolunteerlist = NSMutableArray()
    var listArrayFoodVolunteerRequestlist = NSMutableArray()
    var listArrayFoodVolunteerGrouplist = NSMutableArray()
    @IBOutlet weak var foodbankManagerView: UIView!
    @IBOutlet weak var foodbankManagerheight: NSLayoutConstraint!
    @IBOutlet weak var foodbankvolunteerlistView: UIView!
    @IBOutlet weak var foodbankvolunteerlistheight: NSLayoutConstraint!
    @IBOutlet weak var VolunteerCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var VolunteerListCollectionView: UICollectionView!

    
    @IBOutlet weak var VolunteersRequestView: UIView!
    @IBOutlet weak var volunteersReqLab: UILabel!
    @IBOutlet weak var VolunteersReqCollectview: UICollectionView!
    @IBOutlet weak var VolReqViewHeight: NSLayoutConstraint!
    @IBOutlet weak var VolReqCollectionviewHeight: NSLayoutConstraint!
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    
    var popview2 = UIView()
    var footerView2 = UIView()
    var arryDatalistids = NSMutableArray()
    var arryDatalistids2 = NSMutableArray()
    var countLab = UILabel()
    
    
    var layout = UICollectionViewFlowLayout()
    var collectionLayout =  UICollectionViewFlowLayout()
    
     var ShareUrl = String()
     var strpage = String()
     var strpage2 = String()
     var strpage3 = String()
    
     var imgFolderAry = NSMutableArray()
    
     @IBOutlet weak var ShareView: UIView!
    
      @IBOutlet var FoodCategoryCollectionViewCell: UICollectionView!
     var cell3: FoodCategoriesCell!
    var FoodCategoriesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //  ShareView.isHidden = true
        
         iconView.isHidden = true
        
       // AddVolunteersButt.isHidden = true
        
         self.setupAlertCtrl2()
        
        
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
            myLatitude = (locationManager.location?.coordinate.latitude)!
            myLongitude = (locationManager.location?.coordinate.longitude)!
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
        
        
        if percentStr == "0"
        {
            percentStr = "1"
        }
        if percentStr == "0.0"
        {
            percentStr = "1"
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
    

    
    
    func showMapView()
    {
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapBackGrndView.frame.size.width, height: self.mapBackGrndView.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        self.mapView.isUserInteractionEnabled = true
        self.mapBackGrndView.addSubview(mapView)
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.title = self.listDicFoodBank.value(forKey: "address") as? String
        self.marker.icon = UIImage(named: "Fmap_pin36.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.map = self.mapView
        
        let DirectionImage = UIImageView()
        DirectionImage.frame = CGRect(x:self.mapBackGrndView.frame.size.width-50, y:self.mapBackGrndView.frame.size.height-50, width:40, height:40)
        DirectionImage.image = UIImage(named: "google-2.png")
        DirectionImage.contentMode = .scaleAspectFit
        self.mapBackGrndView.addSubview(DirectionImage)
        
        Uselocationbutt.frame = CGRect(x:self.mapBackGrndView.frame.size.width-50, y:self.mapBackGrndView.frame.size.height-50, width:40, height:40)
        Uselocationbutt.addTarget(self, action: #selector(MyFoodBankDetailsVC.multipleParamSelector2), for: .touchUpInside)
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


    
    func showBannerView()
    {
               // imagesArray = [ "http://think360.in/kindr/api/uploads/uploadedPic-956765420.79.jpeg",
                  //              "http://think360.in/kindr/api/uploads/uploadedPic-583508613.798.jpeg",
                 //               "http://think360.in/kindr/api/uploads/uploadedPic-747751351.679.jpeg"]
        
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
            let bannerview = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imagesBanerView.frame.size.width, height: self.imagesBanerView.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 500, currentPageIndicatorTintColor: UIColor.clear, pageIndicatorTintColor: UIColor.clear)
            bannerview?.clipsToBounds = true
            bannerview?.notScrolling = true
            bannerview?.contentMode = .scaleAspectFill
            imagesBanerView.addSubview(bannerview!)
        }
        else
        {
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imagesBanerView.frame.size.width, height: self.imagesBanerView.frame.size.height), delegate: self, imageURLs: (imagesArray as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        banner?.clipsToBounds = true
         banner?.contentMode = .scaleAspectFill
        imagesBanerView.addSubview(banner!)
        }
        
        
    }
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankDetailAPImethod () -> Void
    {
         
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankDetail",params)
        
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
                    let strCategory: String = (self.listDicFoodBank.value(forKey: "categorytype") as! String)
                    
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
                    self.foodBankName.attributedText = mutableAttributedString
                    
                    let stringUrl2 = self.listDicFoodBank.value(forKey: "logo_image") as? NSString ?? ""
                    let url2 = URL.init(string:stringUrl2 as String)
                    self.logoImageView.sd_setImage(with: url2 , placeholderImage: UIImage(named: "applogo.png"))
                    
                    
                    self.aboutDiscLabel.text! = (self.listDicFoodBank.value(forKey: "desc") as! String)
                  
                    
                    
                    let straddress = self.listDicFoodBank.value(forKey: "address") as? String ?? ""
                    let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                    self.addressLabel.text! = stradd
                    
                    
                    
                    self.foodBnNameLbl.text! = self.listDicFoodBank.value(forKey: "title") as? String ?? ""
                    //  self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
                   
                    self.foodBankName.text = strname
                    
                    
                   
                    
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
                    
                    
                    
                    self.percentLab.text=String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "capacity_status") as! String),"%")
                    
                    self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
                    
                  
                    
                    
                    
                    self.UserID = self.listDicFoodBank.value(forKey: "user_id") as! String as NSString
                    
                   
                    
                    let sValue:String = (self.listDicFoodBank.value(forKey: "capacity_status") as! String)
                    if sValue == "" {
                        self.sliderOutlet.value = 0
                        
                    }else{
                        self.sliderOutlet.value = Float(sValue)!
                        
                    }
                    
                    self.perform(#selector(self.showMapView), with: nil, afterDelay: 0.01)
                    
                    self.imagesArray = self.listDicFoodBank.value(forKey: "images") as! NSArray
                    
                    if self.imagesArray.count == 0
                    {
                        self.imagesArray = [ "http://arghyathakur.in/assets/file-upload/No_Image.jpg"]
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
//        let params = "method=get_FoodBanks&fbank_id=\(foodbankID)&lat=\(currentLatitude)&longt=\(currentLongitude)&userid=\(strUserID)"
//
//       // print(params)
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
//                   print(responceDic)
//                     self.listDicFoodBank = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
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
//
//                    self.currentLatitude = Double(self.listDicFoodBank .value(forKey: "lat") as! String)!
//                    self.currentLongitude = Double(self.listDicFoodBank.value(forKey: "longt") as! String)!
//
//                    self.aboutDiscLabel.text! = (self.listDicFoodBank.value(forKey: "fbank_desc") as! String)
//                    self.addressLabel.text! = (self.listDicFoodBank.value(forKey: "address") as! String)
//                    self.foodBnNameLbl.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
//                   // self.foodBankName.text! = (self.listDicFoodBank.value(forKey: "fbank_title") as! String)
//
//                     self.ShareUrl = self.listDicFoodBank.value(forKey: "short_code") as? String ?? ""
//
//
//                    let stringUrl = self.listDicFoodBank.value(forKey: "logo_image") as! NSString
//                    let url = URL.init(string:stringUrl as String)
//                    self.logoImageView.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
//
//
//                    self.percentLab.text=String(format:"%@ %@",(self.listDicFoodBank .value(forKey: "percentage") as! String),"%")
//                    self.mileLabel.text! = String(format:"%@ Kms Away",(self.listDicFoodBank .value(forKey: "distance") as! String))
//
//                    let sValue:String = (self.listDicFoodBank.value(forKey: "percentage") as! String)
//                    if sValue == "" {
//                        self.sliderOutlet.value = 0
//
//                    }else{
//                        self.sliderOutlet.value = Float(sValue)!
//                    }
//
//
//                    self.imagesArray = (self.listDicFoodBank.object(forKey: "Foodbank_image") as? NSArray)!.value(forKey: "images") as! NSArray
//
//                    self.perform(#selector(MyFoodBankDetailsVC.showMapView), with: nil, afterDelay: 0.01)
//
//
//                    if self.imagesArray.count == 0
//                   {
//                        self.imagesArray = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }else{
//                        self.perform(#selector(MyFoodBankDetailsVC.showBannerView), with: nil, afterDelay: 0.02)
//                    }
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
        
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
       
        self.sliderOutlet.setValue(round(sender.value / 5) * 5, animated: false)
        
       // let integere: Int = Int((round(sender.value / 5) * 5))
        //kmLabel.text! = String(integere)

        
        percentStr = String(Int(round(sender.value / 5) * 5))
        self.percentLab.text=String(format:"%@ %@",percentStr,"%")
    }
    
    
    @IBAction func updateFoodBankBtnAction(_ sender: Any) {
        self.saveFoodbankAPImethod()
        
    }
    // MARK:  Save FppdBank API Method:
    
    @objc private  func saveFoodbankAPImethod () -> Void
    {
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbank")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserID, forKey: "user_id")
        PostDataValus.setValue(foodbankID, forKey: "foodbank_id")
        PostDataValus.setValue(percentStr, forKey: "capacity_status")
      //  PostDataValus.setValue(strManageUser, forKey: "manage_user")
      //  PostDataValus.setValue(strcode, forKey: "manage_other_contact")
        
        
        var jsonStringValues = String()
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        if jsonData == nil {
            
        }
        else {
            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
            print("jsonString: \(jsonStringValues)")
        }
        
        
        
     //   let baseURL: String  = String(format:"%@",Constants.mainURL)
     //   let params = "method=update_FoodBanks&fbank_id=\(foodbankID)&percentage=\(percentStr)&userid=\(strUserID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                  //  print(responceDic)
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "", view: self)
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
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
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
    
    
    @IBAction func ShareButtClicked(_ sender: UIButton)
    {
      //  let text = "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8"
        let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
        
        //  let text = self.ShareUrl + "\n\n" + "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    // MARK:  FoodBank Volunteers
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.volunteersReqLab.isHidden = true
        VolReqViewHeight.constant = 0
        
        self.FoodBankManagerAPImethod()
        self.FoodBankManagerVolunteerRequestAPImethod()
        
      
    }
    
    
    
    // MARK:  FoodBanks Details API method
    
    func FoodBankManagerAPImethod () -> Void
    {
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankVolunteers",params)
        
        print(baseURL)
        
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
                        self.foodbankManagerheight.constant = 40
                       // self.volunteersReqLab.isHidden = true
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
                    self.foodbankManagerheight.constant = 40
                    self.foodbankvolunteerlistheight.constant = 40
                    self.VolunteerCollectionHeight.constant = 0
                     self.listArrayFoodVolunteerlist.removeAllObjects()
                     self.VolunteerListCollectionView .reloadData()
                    //self.volunteersReqLab.isHidden = true
                    
                   // self.foodbankManagerheight.constant = 0
                   // self.foodbankvolunteerlistheight.constant = 0
                   // self.VolunteerCollectionHeight.constant = 0
                  //  self.volunteersReqLab.isHidden = true
                    
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
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
        
        
        
        
        
        
//        
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=foodBank_volunteer&foodbankid=\(foodbankID)&userid=\(strUserID)"
//        
//     //   print(params)
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
//                   // print(responceDic)
//                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//                    
//                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
//                    
//                    self.VolunteerListCollectionView .reloadData()
//                     self.VolunteersReqCollectview .reloadData()
//                    
//                    
//                   
//                    
//                    if self.listArrayFoodVolunteerRequestlist.count == 0
//                    {
//                        self.VolReqViewHeight.constant = 0
//                        self.volunteersReqLab.isHidden = true
//                    }
//                    else
//                    {
//                        self.VolReqViewHeight.constant = CGFloat(65+(73*self.listArrayFoodVolunteerRequestlist.count))
//                        self.volunteersReqLab.isHidden = false
//                    }
//                    
//                    if self.listArrayFoodVolunteerlist.count == 0
//                    {
//                        self.foodbankManagerheight.constant = 50
//                         self.foodbankvolunteerlistheight.constant = 0
//                    }
//                    else
//                    {
//                      //  self.foodbankManagerheight.constant = 200
//                      //  self.foodbankvolunteerlistheight.constant = 200
//                        
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
//                        
//                    }
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
//        }) { (error) in
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
    }
    
    
    
    func FoodBankManagerVolunteerRequestAPImethod () -> Void
    {
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankVolunteerRequests",params)
        
        print(baseURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                     self.listArrayFoodVolunteerRequestlist.removeAllObjects()
                    
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage3 = String(describing: number)
                    
                
                   self.listArrayFoodVolunteerRequestlist = (responceDic.object(forKey: "volunteerList") as? NSMutableArray)!
                    
                    
                    self.VolunteersReqCollectview .reloadData()
                    
                    if self.listArrayFoodVolunteerRequestlist.count == 0
                    {
                        self.VolReqViewHeight.constant = 0
                        self.volunteersReqLab.isHidden = true
                    }
                    else
                    {
                        self.VolReqViewHeight.constant = CGFloat(65+(73*self.listArrayFoodVolunteerRequestlist.count))
                        self.volunteersReqLab.isHidden = false
                    }
                }
                else
                {
                    self.VolReqViewHeight.constant = 0
                    self.volunteersReqLab.isHidden = true
                    self.listArrayFoodVolunteerRequestlist.removeAllObjects()
                    self.VolunteersReqCollectview .reloadData()
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
     // MARK:  Add Volunteers API method
    
    @IBAction func AddVolunteersClicked(_ sender: UIButton)
    {
       // PostDataValus.setValue(foodbankID, forKey: "foodbank_id")
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=&lat=\(currentLatitude)&long=\(currentLongitude)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchVolunteer",params)
        
        print(baseURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                     self.arrChildCategory.removeAllObjects()
                    self.arrChildCategory = (responceDic.object(forKey: "volunteerList") as? NSArray)! as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage2 = String(describing: number)
                    
                    self.foodbankVolunteerslistView()
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
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=Searchvolunteer&foodbank_id=\(foodbankID)&text="
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
//
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    self.arrChildCategory = (responceDic.object(forKey: "VolunteerList") as? NSArray)! as! NSMutableArray
//
//                    self.foodbankVolunteerslistView()
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
    
    
    
    func foodbankVolunteerslistView ()
    {
        popview2.isHidden=false
        footerView2.isHidden=false
        
        arryDatalistids.removeAllObjects()
        
        popview2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview2.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview2)
        
        footerView2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerView2.backgroundColor = UIColor.white
        popview2.addSubview(footerView2)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerView2.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView2.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerView2.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Volunteers"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView2.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerView2.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(MyFoodBankDetailsVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(MyFoodBankDetailsVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerView2.frame.size.width, height: footerView2.frame.size.height-120)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        footerView2.addSubview(volunterFbTblView)
        
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search Volunteers"
        theSearchBar?.showsCancelButton = false
        volunterFbTblView.tableHeaderView = theSearchBar
        theSearchBar?.isUserInteractionEnabled = true
        
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x:0, y:footerView2.frame.size.height-50, width:footerView2.frame.size.width, height:50  )
        bottomView.backgroundColor = #colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        footerView2.addSubview(bottomView)
        
        
        countLab.frame = CGRect(x:10, y:10, width:30, height:30)
        countLab.layer.cornerRadius = 15
        countLab.layer.masksToBounds = true
        countLab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        countLab.text = "0"
        countLab.font =  UIFont(name:"Helvetica", size: 15)
        countLab.textColor=UIColor.white
        countLab.textAlignment = .center
        bottomView.addSubview(countLab)
        
        let textlab = UILabel()
        textlab.frame = CGRect(x:45, y:10, width:150, height:30)
        textlab.text="Volunteers(s) Added"
        textlab.font =  UIFont(name:"Helvetica", size: 15)
        textlab.textColor=UIColor.white
        textlab.textAlignment = .left
        bottomView.addSubview(textlab)
        
        
        let submitlab = UILabel()
        submitlab.frame = CGRect(x:bottomView.frame.size.width-120, y:10, width:110, height:30)
        submitlab.text="Submit >>  "
        submitlab.font =  UIFont(name:"Helvetica", size: 17)
        submitlab.textColor=UIColor.white
        submitlab.textAlignment = .right
        bottomView.addSubview(submitlab)
        
        let submitbutt = UIButton()
        submitbutt.frame = CGRect(x:bottomView.frame.size.width-120, y:10, width:110, height:30)
        submitbutt.addTarget(self, action: #selector(MyFoodBankDetailsVC.SubmitButtonAction(_:)), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(submitbutt)
        
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
        
        self.theSearchBar?.inputAccessoryView = doneToolbar
        
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
        
        self.arrChildCategory.removeAllObjects()
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
    }
    
    
    func SubmitButtonAction(_ sender: UIButton!)
    {
        if arryDatalistids.count==0
        {
            var Message=String()
            Message = "Please Select Atleast One Volunteer"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
           // let jsonData2: Data? = try? JSONSerialization.data(withJSONObject: arryDatalistids, options: [])
           // let jsonObject : Any = try! JSONSerialization.jsonObject(with: jsonData2!, options: [])
           // let jsonString = String(data: jsonData2!, encoding: String.Encoding.utf8)! as String
           // let string = arryDatalistids.joined(separator: ",")
            
            let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Add these Volunteers", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Add", style: UIAlertActionStyle.default,handler: { action in
                self.Addmethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func Addmethod()
    {
        let newArray = arryDatalistids as Array
        print(newArray)
        
        var responseString = String()
        let jsonDatav: Data? = try? JSONSerialization.data(withJSONObject: self.arryDatalistids, options: [])
        responseString = String(data: jsonDatav!, encoding: .utf8)!
        responseString = responseString.replacingOccurrences(of: " ", with: "%20")
        
      //  let baseURL: String  = String(format:"%@",Constants.mainURL)
      //  let params = "method=manage_foodBank_volunteer&user_id=\(newArray)&foodbankid=\(foodbankID)&type=2"
        
      //  print(params)
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbankVolunteers")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(foodbankID, forKey: "foodbank_id")
        PostDataValus.setValue(responseString, forKey: "user_ids")
        PostDataValus.setValue("3", forKey: "type")
        
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
                    
                    self.popview2.isHidden=true
                    self.footerView2.isHidden=true
                    
                    self.arrChildCategory.removeAllObjects()
                    self.searchResults.removeAllObjects()
                    self.volunterFbTblView.removeFromSuperview()
                    
                     self.FoodBankManagerAPImethod()
                    
                    
//                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//
//                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
//
//                    self.VolunteerListCollectionView .reloadData()
//                    self.VolunteersReqCollectview.reloadData()
//
//                    if self.listArrayFoodVolunteerRequestlist.count == 0
//                    {
//                        self.VolReqViewHeight.constant = 0
//                        self.volunteersReqLab.isHidden = true
//                    }
//                    else
//                    {
//                        self.VolReqViewHeight.constant = CGFloat(65+(73*self.listArrayFoodVolunteerRequestlist.count))
//                        self.volunteersReqLab.isHidden = false
//                    }
//
//                    if self.listArrayFoodVolunteerlist.count == 0
//                    {
//                        self.foodbankManagerheight.constant = 50
//                        self.foodbankvolunteerlistheight.constant = 0
//                    }
//                    else
//                    {
//                       // self.foodbankManagerheight.constant = 200
//                       // self.foodbankvolunteerlistheight.constant = 200
//
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
    
    

    
    
   // MARK:  Collection view list
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            return CGSize(width: 80 , height: 80)
        }
        else if collectionView == VolunteerListCollectionView
        {
            
            let userInterface = UIDevice.current.userInterfaceIdiom
            
            if(userInterface == .pad)
            {
                return CGSize(width: (self.view.frame.size.width-40) / 4 , height: 163)
                
            }
            return CGSize(width: (self.view.frame.size.width-32) / 3  , height: 163)
            
           // return CGSize(width: 142, height: 163)
        }
        else
        {
            return CGSize(width: self.view.frame.size.width, height: 73)
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            return self.FoodCategoriesArray.count
        }
        else if collectionView == VolunteerListCollectionView
        {
           return self.listArrayFoodVolunteerlist.count
        }
        else if (collectionView == VolunteersReqCollectview)
        {
           return self.listArrayFoodVolunteerRequestlist.count
        }
        else
        {
            return self.listArrayFoodVolunteerGrouplist.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoriesCell", for: indexPath) as! FoodCategoriesCell
            
            let imageURL: String = (self.FoodCategoriesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            cell3.FoodTypeImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            
            cell3.FoodtypeName.text = (self.FoodCategoriesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String ?? ""
            
            return cell3
        }
        else if collectionView == VolunteerListCollectionView
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolunteersCollectionCell2", for: indexPath) as! VolunteersCollectionCell2
            
            
            let strname1 = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
            let strname2 = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
             cell.volunteername.text! = strname1+" "+strname2
            
          //  cell.volunteername.text! = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as! String
            
            let imageURL: String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            cell.VolunteerlistImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            
            cell.volunteerRemoveButt.tag = indexPath.row
            cell.volunteerRemoveButt.addTarget(self, action: #selector(MyFoodBankDetailsVC.RemoveVolunteerButtonAction(_:)), for: UIControlEvents.touchUpInside)
          //  cell.volunteerRemoveButt.isHidden = true
            
            return cell
        }
        else if (collectionView == VolunteersReqCollectview)
        {
            cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "VoluntRequestCell", for: indexPath) as! VoluntRequestCell
            
            
            let strname1 = (self.listArrayFoodVolunteerRequestlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
            let strname2 = (self.listArrayFoodVolunteerRequestlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
            cell2.VolReqName.text! = strname1+" "+strname2
            
       
            
            let imageURL: String = (self.listArrayFoodVolunteerRequestlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            cell2.VolReqImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            
            cell2.ReqAcceptButt.tag = indexPath.row
            cell2.ReqAcceptButt.addTarget(self, action: #selector(MyFoodBankDetailsVC.RequestAcceptButtonAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell2.ReqRejectbutt.tag = indexPath.row
            cell2.ReqRejectbutt.addTarget(self, action: #selector(MyFoodBankDetailsVC.RequestRejectButtonAction(_:)), for: UIControlEvents.touchUpInside)
            
            
            return cell2
        }
        else
        {
            
        }
        
        return cell
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
                else if collectionView == VolunteerListCollectionView
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
                else if (collectionView == VolunteersReqCollectview)
                {
                    let strkey = Constants.ApiKey
                    let params = "api_key=\(strkey)&lat=\(currentLatitude)&long=\(currentLongitude)&user_id=\(strUserID)&foodbank_id=\(foodbankID)&page=\(self.strpage3)"
                    let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodbankVolunteerRequests",params)
                    
                    AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                        
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
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
            self.foodbankManagerheight.constant = 40
            self.foodbankvolunteerlistheight.constant = 40
            self.VolunteerCollectionHeight.constant = 0
            self.listArrayFoodVolunteerlist.removeAllObjects()
            self.VolunteerListCollectionView .reloadData()
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
    
    
    func responsewithToken8(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "volunteerList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayFoodVolunteerRequestlist.addObjects(from: arr as [AnyObject])
        
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage3 = String(describing: number)
        
        
     
        
        if self.listArrayFoodVolunteerRequestlist.count == 0
        {
            self.VolReqViewHeight.constant = 0
            self.volunteersReqLab.isHidden = true
        }
        else
        {
            self.VolReqViewHeight.constant = CGFloat(65+(73*self.listArrayFoodVolunteerRequestlist.count))
            self.volunteersReqLab.isHidden = false
            
        }
        
           self.VolunteersReqCollectview .reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: Remove Volunteer Button Action :
    func RemoveVolunteerButtonAction(_ sender: UIButton!)
    {
        VolunteerId = (self.listArrayFoodVolunteerlist.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String as NSString
        
     //   print(VolunteerId)
        
        
        let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Delete this Volunteer", preferredStyle: UIAlertControllerStyle.alert)
        
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
        
        
       
      
       // let baseURL: String  = String(format:"%@",Constants.mainURL)
       // let params = "method=manage_foodBank_volunteer&user_id=\(VolunteerId)&foodbankid=\(foodbankID)&type=1"
        
       // print(params)
        
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//              //  print(responceDic)
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//
//                  //  print(responceDic)
//                    self.listArrayFoodBankManagerlist = (responceDic.object(forKey: "FoodbankList") as? NSDictionary)!
//
//                    self.listArrayFoodVolunteerlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunter") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerRequestlist = (self.listArrayFoodBankManagerlist.object(forKey: "volunterRequest") as? NSMutableArray)!
//                    self.listArrayFoodVolunteerGrouplist = (self.listArrayFoodBankManagerlist.object(forKey: "group") as? NSMutableArray)!
//
//                    self.VolunteerListCollectionView .reloadData()
//                    self.VolunteersReqCollectview.reloadData()
//
//                    if self.listArrayFoodVolunteerRequestlist.count == 0
//                    {
//                        self.VolReqViewHeight.constant = 0
//                        self.volunteersReqLab.isHidden = true
//                    }
//                    else
//                    {
//                        self.VolReqViewHeight.constant = CGFloat(65+(73*self.listArrayFoodVolunteerRequestlist.count))
//                        self.volunteersReqLab.isHidden = false
//                    }
//
//
//                    if self.listArrayFoodVolunteerlist.count == 0
//                    {
//                        self.foodbankManagerheight.constant = 50
//                        self.foodbankvolunteerlistheight.constant = 0
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
//
//        }) { (error) in
//
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
    }
    
    
    
    
    // MARK: Request Accept Button Action :
    func RequestAcceptButtonAction(_ sender: UIButton!)
    {
        typeId = "2"
        RequestId = (self.listArrayFoodVolunteerRequestlist.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String as NSString
        
       // print(RequestId)
        
        
        let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Accept this Request", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Accept", style: UIAlertActionStyle.default,handler: { action in
            self.Requestmethod()
        })
        
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: Request Reject Button Action :
    func RequestRejectButtonAction(_ sender: UIButton!)
    {
        typeId = "1"
        RequestId = (self.listArrayFoodVolunteerRequestlist.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String as NSString
        
      //  print(RequestId)
        
        
        let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Reject this Request", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Reject", style: UIAlertActionStyle.default,handler: { action in
            self.Requestmethod()
        })
        
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }


    func Requestmethod()
    {
       // let baseURL: String  = String(format:"%@",Constants.mainURL)
      //  let params = "method=manage_volunteer_request&user_id=\(RequestId)&foodbankid=\(foodbankID)&type=\(typeId)"
        
     //   print(params)
        
        
        
        var arrPath = [Any]()
        arrPath.append(RequestId)
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
        PostDataValus.setValue(typeId, forKey: "type")
        
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
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.FoodBankManagerAPImethod()
                    self.FoodBankManagerVolunteerRequestAPImethod()
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

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == FoodCategoryCollectionViewCell
        {
            
        }
        else if collectionView == VolunteerListCollectionView
        {
            let VolunteerID:String = (self.listArrayFoodVolunteerlist.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
            
             var localTimeZoneName: String { return TimeZone.current.identifier }
            let strkey = Constants.ApiKey
            let params = "api_key=\(strkey)&lat=\(myLatitude)&long=\(myLongitude)&user_id=\(VolunteerID)&time_zone=\(localTimeZoneName)"
            let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"volunteerDetail",params)
            
            self.VolunteerDetailAPIMethod(baseURL: String(format:"%@",baseURL))
            
            //  self.GetVolunteerDetailslistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=volunteerDetail&user_id=\(VolunteerID)&lat=\(firstLatitude)&lon=\(firstLongitude)")
        }
        else if (collectionView == VolunteersReqCollectview)
        {
            
        }
        else
        {
            
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
    
    
    
    @objc private  func GetVolunteerDetailslistAPIMethod (baseURL:String , params: String)
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

    
    
    //  MARK: searchbar Delegates and Datasource:
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let str = searchText
        var encodeUrl = String()
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let escapedString = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            encodeUrl = escapedString
        }
        
        //foodbankID
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(currentLatitude)&long=\(currentLongitude)&foodbank_id=\(foodbankID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchVolunteer",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.arrChildCategory.removeAllObjects()
                    self.arrChildCategory = (responceDic.object(forKey: "volunteerList") as? NSArray)! as! NSMutableArray
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage2 = String(describing: number)
                    
                    self.volunterFbTblView.reloadData()
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
            let UserImage = UIImageView()
            UserImage.frame = CGRect(x:15, y:10, width:50, height:50)
            UserImage.layer.cornerRadius = 25
            UserImage.layer.masksToBounds = true
            UserImage.contentMode = .scaleAspectFill
            let imageURL: String = (self.searchResults.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            UserImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            Fbcell?.addSubview(UserImage)
            
            
            let userName = UILabel()
            userName.frame = CGRect(x:75, y:10, width:(self.view.frame.size.width-120), height:50)
            userName.text=(self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "first_name") as? String
            userName.font =  UIFont(name:"Helvetica", size: 15)
            userName.textColor=UIColor.black
            userName.textAlignment = .left
            userName.numberOfLines = 0
            Fbcell?.addSubview(userName)
            
            
            let checkImage = UIImageView()
            checkImage.frame = CGRect(x:self.view.frame.size.width-40, y:20, width:30, height:30)
            if let quantity = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? NSNumber
            {
                let VolunteerID: String = (quantity: quantity.stringValue) as! String

                if arryDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }
            }
            else if let VolunteerID = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? String
            {
                if arryDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }

            }
            Fbcell?.addSubview(checkImage)
        }
        else
        {
            let UserImage = UIImageView()
            UserImage.frame = CGRect(x:15, y:10, width:50, height:50)
            UserImage.layer.cornerRadius = 25
            UserImage.layer.masksToBounds = true
            UserImage.contentMode = .scaleAspectFill
            let imageURL: String = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
            let url = NSURL(string:imageURL)
            UserImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
            Fbcell?.addSubview(UserImage)
            
            
            let userName = UILabel()
            userName.frame = CGRect(x:75, y:10, width:(self.view.frame.size.width-120), height:50)
            let strname1 = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
            let strname2 = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
            userName.text = strname1+" "+strname2
            userName.font =  UIFont(name:"Helvetica", size: 15)
            userName.textColor=UIColor.black
            userName.textAlignment = .left
            userName.numberOfLines = 0
            Fbcell?.addSubview(userName)
            
            
            let checkImage = UIImageView()
            checkImage.frame = CGRect(x:self.view.frame.size.width-40, y:20, width:30, height:30)
            if let quantity = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? NSNumber
            {
                let VolunteerID: String = (quantity: quantity.stringValue) as! String
                
                if arryDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }
            }
            else if let VolunteerID = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? String
            {
                if arryDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }
                
            }
            Fbcell?.addSubview(checkImage)
        }
        return Fbcell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if volunterFbTblView.tag == 2
        {
            let VolunteerID:String = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            if arryDatalistids.contains(VolunteerID)
            {
                arryDatalistids.remove(VolunteerID)
            }
            else
            {
                arryDatalistids.add(VolunteerID)
            }
            volunterFbTblView.reloadData()
        }
        else
        {
            
            let VolunteerID:String = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            if arryDatalistids.contains(VolunteerID)
            {
                arryDatalistids.remove(VolunteerID)
            }
            else
            {
                arryDatalistids.add(VolunteerID)
            }
             volunterFbTblView.reloadData()
        }
        
        countLab.text = String(arryDatalistids.count)
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
                
                let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(currentLatitude)&long=\(currentLongitude)&page=\(self.strpage2)&foodbank_id=\(foodbankID)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchVolunteer",params)
                
                print(baseURL)
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                          print(responceDic)
                        if (responceDic.object(forKey: "status") as! NSNumber) == 1
                        {
                            self.responsewithToken9(responceDic)
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
    
    func responsewithToken9(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "volunteerList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.arrChildCategory.addObjects(from: arr as [AnyObject])
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage2 = String(describing: number)
        
        self.volunterFbTblView.reloadData()
        
    }
    
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
