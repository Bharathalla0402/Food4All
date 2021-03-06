//
//  SetupFoodBankVC.swift
//  FoodForAll
//
//  Created by amit on 5/5/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import Contacts



fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}






class SetupFoodBankVC: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,HMDiallingCodeDelegate,SecondDelegate
{
   
    var CategoryListArray = NSMutableArray()
    
    var camera = GMSCameraPosition()
    var lastCameraPosition = GMSCameraPosition()
    var mapView = GMSMapView()
    var mapView2 = GMSMapView()
    var marker = GMSMarker()
    var marker2 = GMSMarker()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    var searchViewController = ABCGooglePlacesSearchViewController()
    
    var CropperView = BABCropperView()
    var CroppedImageView = UIImageView()
    
    var SliderVal2 = WOWMarkSlider()
    
    var myArray = NSDictionary()
    var strUserID = String()
    var strManageUser = NSString()
    
    var classObject = ChatingDetailsViewController()
    
    
    @IBOutlet weak var HeaderImage: UIImageView!
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var HeaderImageButt: UIButton!
    @IBOutlet weak var LogoImageButt: UIButton!
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var nameTextFieds: ACFloatingTextfield!
    @IBOutlet weak var mapBkrndView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var SetUpFoodBankButt: UIButton!
    
    @IBOutlet var txtLabImage: UILabel!
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    var cropSelectedImage = UIImage()
    var imageTakeArray = NSMutableArray()
    var imagPathArray = NSMutableArray()
    var imgFolderAry = NSMutableArray()
    var HeaderimagPathArray = NSMutableArray()
    var logoimagPathArray = NSMutableArray()
    var logoimgFolderAry = NSMutableArray()
    var DeleteFolderAry = NSMutableArray()
    var responseString = String()
    var responseString2 = String()
     var HeaderresponseString = String()
    var logoresponseString = String()
    var logoresponseString2 = String()
    var deletePathStr = String()
    var foodBankIDStr = String()
    var locationlab = UILabel()
    var sliderString = String()
     var responseCatIdString = String()
    
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var txtlab = UILabel()
    var percentlab = UILabel()
    var switchlab = UISwitch()
    var txtemailfield = UITextField()
    var Headview2 = UIView()
    
    var popview3 = UIView()
    var footerView3 = UIView()
    
    var popview4 = UIView()
    var footerView4 = UIView()
    
    @IBOutlet weak var AddPhotosLab: UILabel!
    @IBOutlet weak var collectionViewSetUp: UICollectionView!
    var cell = SetupCVCell()
    
    @IBOutlet weak var cameraButton: UIButton!
    var scrollViewPopUp = UIView()
    @IBOutlet weak var backScrlView: UIScrollView!
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var txtSelectCategory: ACFloatingTextfield!
    
    @IBOutlet weak var CategoryButt: UIButton!
    
    var Fbcell: UITableViewCell?
    
     var arryCatDatalistids = NSMutableArray()
     var arryCatDatalistnames = NSMutableArray()
    
    var arryDatalistids = NSMutableArray()
    var arryDatalistids2 = NSMutableArray()
    var ContactId = NSMutableArray()
    var EmailId = NSMutableArray()
    var strCheck = NSString()
    
    var ContactList = NSMutableArray()
    var EmailList = NSMutableArray()
    var UserImage = UIImage()
    var popviewEmail = UIView()
    var footerViewEmail = UIView()
    
    @IBOutlet var volunterFbTblView: UITableView!
    @IBOutlet var volunterFbTblView2: UITableView!
    var emailcell: ContactTableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var searchResults2 = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    var strEmailId = NSString()
    var strMobileNumber = String()
    var strCountryCode = NSString()
    var strCCodeCheck = NSString()
    var diallingCode = HMDiallingCode()
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var CameraInt:Int = 0
    
    var imagesArray = NSArray()
    var listDetailBank = NSDictionary()
    var StrEditMode = String()
    var StrFoodbankId = String()
    
    @IBOutlet weak var SetupFoodbankLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         classObject.delegate = self
        
      //  AddPhotosLab.isHidden = true
      //  collectionViewSetUp.isHidden = true
      //  cameraButton.isHidden = true
        
        mapView2.delegate = self
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

        self.tabBarController?.tabBar.isHidden = true
        
         self.diallingCode.delegate=self;
        
        imagePicker.delegate = self
       // imagePicker.allowsEditing = true
        descriptionTextView.delegate = self
        descriptionTextView.text = "Enter your text here.."
        descriptionTextView.textColor = UIColor.lightGray
        
        searchViewController.delegate=self

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
        
      //  perform(#selector(SetupFoodBankVC.showMapView), with: nil, afterDelay: 0.02)
        
      
        if StrEditMode == "1"
        {
            SetupFoodbankLab.text = "UPDATE FOOD BANK"
            
            self.currentLatitude = Double(self.listDetailBank .value(forKey: "lat") as! String)!
            self.currentLongitude = Double(self.listDetailBank.value(forKey: "long") as! String)!
            self.nameTextFieds.text! = (self.listDetailBank.value(forKey: "title") as! String)
            self.descriptionTextView.text = self.listDetailBank.value(forKey: "desc") as? String ?? ""
            self.descriptionTextView.textColor = UIColor.black
            let straddress = self.listDetailBank.value(forKey: "address") as? String ?? ""
            let stradd = straddress.replacingOccurrences(of: "\n", with: "")
            self.locationTF.text! = stradd
            self.locationlab.text = stradd
            self.imagPathArray = (self.listDetailBank.value(forKey: "images") as? NSMutableArray)!
           
            
            if self.imagPathArray.count == 0
            {
                txtLabImage.isHidden = false
            }
            else
            {
                txtLabImage.isHidden = true
            }
            
            SetUpFoodBankButt.setTitle("UPDATE FOOD BANK", for: .normal)
            
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imagPathArray, options: [])
            self.responseString = String(data: jsonData!, encoding: .utf8)!
            self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
            
            if let quantity = self.listDetailBank.value(forKey: "id") as? NSNumber
            {
                StrFoodbankId = String(describing: quantity)
            }
            else if let quantity = self.listDetailBank.value(forKey: "id") as? String
            {
                StrFoodbankId = quantity
            }
            
            self.HeaderimagPathArray.removeAllObjects()
            self.HeaderresponseString = self.listDetailBank.value(forKey: "header_image") as? String ?? ""
            let strpath =  self.listDetailBank.value(forKey: "header_image") as? String ?? ""
            var arrUrl = [Any]()
            arrUrl.append(strpath)
            self.HeaderimagPathArray.addObjects(from: arrUrl)
            
            self.logoimagPathArray.removeAllObjects()
            self.logoresponseString = self.listDetailBank.value(forKey: "logo_image") as? String ?? ""
            let strpath2 =  self.listDetailBank.value(forKey: "logo_image") as? String ?? ""
            var arrUrl2 = [Any]()
            arrUrl2.append(strpath2)
            self.logoimagPathArray.addObjects(from: arrUrl2)
            
            if HeaderresponseString == ""
            {
               
            }
            else
            {
                let url = NSURL(string:HeaderresponseString)
                HeaderImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
            }
            
            if logoresponseString == ""
            {
                
            }
            else
            {
                let url = NSURL(string:logoresponseString)
                LogoImage.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
            }
            
            let arraylist: NSMutableArray = (self.listDetailBank.value(forKey: "food_categories") as? NSMutableArray)!
            for i in 0..<arraylist.count
            {
                let str = (arraylist.object(at: i) as! NSDictionary).value(forKey: "name") as? String ?? ""
                arryCatDatalistnames.add(str)
            }
            
            self.responseCatIdString = self.listDetailBank.value(forKey: "food_category") as? String ?? ""
            print(self.responseCatIdString)
            let str = self.listDetailBank.value(forKey: "food_category") as? String ?? ""
            let array: NSArray = str.components(separatedBy: ",") as NSArray
            
            print(array)
           
            for i in 0..<array.count
            {
                var strVal = String()
                
                if let quantity = array.object(at: i) as? NSNumber
                {
                    strVal = String(describing: quantity)
                }
                else if let quantity = array.object(at: i) as? String
                {
                    strVal = quantity
                }
                
                let strname: String = strVal.replacingOccurrences(of: " ", with: "")
                arryCatDatalistids.add(strname)
            }
            
            txtSelectCategory.text = arryCatDatalistnames.componentsJoined(by: ",")
        
            print(arryCatDatalistnames)
            print(arryCatDatalistids)
        }
        else
        {
            self.nameTextFieds.text = ""
            self.descriptionTextView.text = "Enter your text here.."

            self.setUsersClosestCity()
        }
        
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
        
        self.nameTextFieds.inputAccessoryView = doneToolbar
        self.descriptionTextView.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"foodCategories",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.CategoryListArray = ((responceDic.value(forKey: "foodCategories") as? NSDictionary)?.value(forKey: "get_category") as? NSMutableArray)!
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
        
//
//        let baseURL: String  = String(format:"%@",Constants.mainURL)
//        let params = "method=foodCategories"
//        print(params)
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
//                    self.CategoryListArray = ((responceDic.value(forKey: "foodCategories") as? NSDictionary)?.value(forKey: "get_category") as? NSMutableArray)!
//                }
//                else
//                {
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
    
    func showMapView()
    {
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapBkrndView.frame.size.width, height: self.mapBkrndView.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        self.mapBkrndView.addSubview(mapView)
        self.mapView.addSubview(locationTF)
        locationTF.addSubview(locationButton)
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.icon = UIImage(named: "Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.map = self.mapView
    }
    
    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
//        geoCoder.reverseGeocodeLocation(location)
//        {
//            (placemarks, error) -> Void in
//            if ((error) != nil)
//            {
//                self.locationTF.text! = ""
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
//                    self.locationTF.text! = locationNameFul
//                    self.locationlab.text=locationNameFul
//                }
//            }
//        }
//        
        
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
                
                self.locationTF.text! = formattedAddress.joined(separator: ", ")
                self.locationlab.text = formattedAddress.joined(separator: ", ")
            }
            
        })
    }

    
    func geoCodeUsingAddress(address: NSString) -> CLLocationCoordinate2D {
        var latitude: Double = 0
        var longitude: Double = 0
        let addressstr : NSString = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(address)" as NSString
        let urlStr  = addressstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let searchURL: NSURL = NSURL(string: urlStr! as String)!
        do {
            let newdata = try Data(contentsOf: searchURL as URL)
            if let responseDictionary = try JSONSerialization.jsonObject(with: newdata, options: []) as? NSDictionary {
              //  print(responseDictionary)
                let array = responseDictionary.object(forKey: "results") as! NSArray
                let dic = array[0] as! NSDictionary
                let locationDic = (dic.object(forKey: "geometry") as! NSDictionary).object(forKey: "location") as! NSDictionary
                latitude = locationDic.object(forKey: "lat") as! Double
                longitude = locationDic.object(forKey: "lng") as! Double
                
                currentLatitude = latitude
                currentLongitude = longitude
                
//                self.marker.map = nil
//                self.mapView.clear()
                //self.marker = GMSMarker()
                self.marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                 self.marker.icon = UIImage(named: " Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
                self.marker.map = self.mapView
                
                camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 8.0)
                self.mapView.animate(to: camera)
              
                
            }} catch {
        }
        var center = CLLocationCoordinate2D()
        center.latitude = latitude
        center.longitude = longitude
      //  print("\(currentLatitude) \n \(currentLongitude)")
        
        return center
    }
  
    
    @IBAction func locationBtnAction(_ sender: Any) {
        
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
        
//        let navigationController = UINavigationController(rootViewController: searchViewController)
//        present(navigationController, animated: true, completion: { _ in })
        
        popview.isHidden=false
        footerView.isHidden=false
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:0, y:0, width:popview.frame.size.width, height:popview.frame.size.height)
        footerView.backgroundColor = UIColor.white
        popview.addSubview(footerView)
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView.frame.size.width, height: footerView.frame.size.height), camera: camera)
        mapView2.delegate = self
        self.mapView2.settings.compassButton = true
        footerView.addSubview(mapView2)
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:60)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView.addSubview(Headview)
        
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
        crossbutt.addTarget(self, action: #selector(SetupFoodBankVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(SetupFoodBankVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x:self.view.frame.size.width/2-25, y:self.view.frame.size.height/2-25, width:50, height:50));
        imageView.image = UIImage(named:"map_pin96.png")
        imageView.contentMode = .scaleAspectFit
        footerView.addSubview(imageView)
        
        
        
        
        let locationView = UIView()
        locationView.frame = CGRect(x:20, y:75, width:footerView.frame.size.width-40, height:100)
        locationView.backgroundColor=#colorLiteral(red: 0.3215386271, green: 0.3215884566, blue: 0.3215229511, alpha: 1)
        locationView.layer.cornerRadius=8.0
        footerView.addSubview(locationView)
        
        
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
        locationlab.text = locationTF.text!
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(SetupFoodBankVC.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        locationView.addSubview(locationbutt)
        
        
        
        
        let uselocation = UIView()
        uselocation.frame = CGRect(x:5, y:footerView.frame.size.height-45, width:footerView.frame.size.width-10, height:40  )
        uselocation.backgroundColor=#colorLiteral(red: 0.9528647065, green: 0.009665175341, blue: 0.3223749697, alpha: 1)
        uselocation.layer.cornerRadius=4.0
        footerView.addSubview(uselocation)
        
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
        Uselocationbutt.addTarget(self, action: #selector(SetupFoodBankVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        uselocation.addSubview(Uselocationbutt)
        
        
        
        let NotifyMe = UIView()
        NotifyMe.frame = CGRect(x:footerView.frame.size.width/2-55  , y:footerView.frame.size.height-80, width:110, height:30  )
        NotifyMe.backgroundColor=#colorLiteral(red: 0.2156647146, green: 0.2157005072, blue: 0.2156534195, alpha: 1)
        NotifyMe.layer.cornerRadius=4.0
        footerView.addSubview(NotifyMe)
        
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
        locatemebutt.addTarget(self, action: #selector(SetupFoodBankVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        NotifyMe.addSubview(locatemebutt)
    }
    

    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    func locationButtonAction(_ sender: UIButton!)
    {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        present(navigationController, animated: true, completion: { _ in })
    }
    
    
    func UselocationButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
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
        
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.icon = UIImage(named: "Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.map = self.mapView
        mapView.reloadInputViews()
        
        mapView2.delegate = self
        mapView2.camera=camera
        
        self.setUsersClosestCity()
    }
    
    //MARK:  -> HeaderImage butt Clicked
    
    @IBAction func HeaderImageButtClicked(_ sender: UIButton)
    {
        CameraInt = 0
        self.CameraView()
    }
    
    //MARK:  -> LogoImage butt Clicked
    
    @IBAction func LogoImageButtClicked(_ sender: UIButton)
    {
        CameraInt = 1
        self.CameraView()
    }
    
    //MARK:  -> Select Category butt Clicked
    
    @IBAction func SelectCategoryButtClicked(_ sender: UIButton)
    {
        if CategoryListArray.count == 0
        {
            AFWrapperClass.alert(Constants.applicationName, message: "No Category Found", view: self)
        }
        else
        {
             self.CategorylistView()
        }
    }
    
    func CategorylistView ()
    {
        popview3.isHidden=false
        footerView3.isHidden=false
        
        popview3.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview3.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview3)
        
        footerView3.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-200, width:300, height:400)
        footerView3.backgroundColor = UIColor.white
         footerView3.layer.cornerRadius = 4.0
        footerView3.clipsToBounds = true
        popview3.addSubview(footerView3)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerView3.frame.size.width, height:60)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView3.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:10, y:10, width:footerView3.frame.size.width-60, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Accepted food categories"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .left
        footerView3.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerView3.frame.size.width-35, y:20, width:20, height:20)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(self.CloseBAction(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView3.frame.size.width-50, y:10, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(self.CloseBAction(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(crossbutt2)
        
        
//        let cancelbutt = UIButton()
//        Donebutt.frame = CGRect(x:footerView3.frame.size.width-70, y:15, width:65, height:30)
//        Donebutt.setTitle("Done", for: UIControlState.normal)
//        Donebutt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        Donebutt.setTitleColor(UIColor.black, for: UIControlState.normal)
//        Donebutt.layer.cornerRadius = 4.0
//        Donebutt.addTarget(self, action: #selector(self.DoneButtAction(_:)), for: UIControlEvents.touchUpInside)
//        footerView3.addSubview(Donebutt)
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerView3.frame.size.width, height: footerView3.frame.size.height-110)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.tag = 5
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        footerView3.addSubview(volunterFbTblView)
        
        let Donebutt = UIButton()
        Donebutt.frame = CGRect(x:10, y:volunterFbTblView.frame.origin.y+volunterFbTblView.frame.size.height+5, width:280, height:40)
        Donebutt.setTitle("Done", for: UIControlState.normal)
        Donebutt.backgroundColor = #colorLiteral(red: 0.186588645, green: 0.6638349891, blue: 0.8730256557, alpha: 1)
        Donebutt.setTitleColor(UIColor.white, for: UIControlState.normal)
        Donebutt.layer.cornerRadius = 4.0
        Donebutt.addTarget(self, action: #selector(self.DoneButtAction(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(Donebutt)
    }
    
    func CloseBAction(_ sender: UIButton!)
    {
//        if arryCatDatalistids.count == 0
//        {
//            AFWrapperClass.alert(Constants.applicationName, message: "Please select atleast one category.", view: self)
//        }
        popview3.isHidden=true
        footerView3.isHidden=true
        volunterFbTblView.removeFromSuperview()
    }
    func DoneButtAction(_ sender: UIButton!)
    {
        if arryCatDatalistids.count == 0
        {
            AFWrapperClass.alert(Constants.applicationName, message: "Please select atleast one category.", view: self)
        }
        else
        {
            popview3.isHidden=true
            footerView3.isHidden=true
            volunterFbTblView.removeFromSuperview()
            
         //   let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.arryCatDatalistids, options: [])
         //   self.responseCatIdString = String(data: jsonData!, encoding: .utf8)!
        //    self.responseCatIdString = self.responseCatIdString.replacingOccurrences(of: " ", with: "%20")
            
            self.responseCatIdString = self.arryCatDatalistids.componentsJoined(by: ",")
            print(self.responseCatIdString)
            txtSelectCategory.text = arryCatDatalistnames.componentsJoined(by: ",")
        }
    }
    

    
    //MARK:  -> ImagePicker Controller Delegates
    @IBAction func cameraButtonAction(_ sender: Any)
    {
       CameraInt = 2
        self.CameraView()
   }
    
    func CameraView ()
    {
        if self.imagPathArray.count == 5
        {
            AFWrapperClass.alert(Constants.applicationName, message: "You can add up to five images only.", view: self)
        }else{
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
            let pibraryAction = UIAlertAction(title: "From Photo Library", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            let cameraction = UIAlertAction(title: "Camera", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                    
                } else {
                    AFWrapperClass.alert(Constants.applicationName, message: "Sorry, this device has no camera", view: self)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
            })
           // self.imagePicker.allowsEditing = true
            optionMenu.addAction(pibraryAction)
            optionMenu.addAction(cameraction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
                if CameraInt == 2
                {
                    popOverPresentationController.sourceView = cameraButton
                    popOverPresentationController.sourceRect = cameraButton.bounds
                }
                else if  CameraInt == 1
                {
                    popOverPresentationController.sourceView = LogoImageButt
                    popOverPresentationController.sourceRect = LogoImageButt.bounds
                }
                else
                {
                    popOverPresentationController.sourceView = HeaderImageButt
                    popOverPresentationController.sourceRect = HeaderImageButt.bounds
                }
                popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
            }
        }
    }
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage
    {
        
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = newsize.width / currentSelectedImage.size.width;
        let aspectHeight:CGFloat = newsize.height / currentSelectedImage.size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = currentSelectedImage.size.width * aspectRatio;
        scaledImageRect.size.height = currentSelectedImage.size.height * aspectRatio;
        scaledImageRect.origin.x = (newsize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newsize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        
        imageName.draw(in: CGRect(x: scaledImageRect.origin.x, y: scaledImageRect.origin.y, width: scaledImageRect.size.width, height: scaledImageRect.size.height))
       
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage!
        
        
//        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
//        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        return newImage!
    }
    
    
    func compressImage(_ image: UIImage) -> UIImage
    {
        //  let imgData: NSData = UIImageJPEGRepresentation(image, 1)! as NSData
        
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 1200.0
        let maxWidth: Float = 600.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 1.0
        
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let Rwidth = CGFloat(actualWidth)
        let Rheight = CGFloat(actualHeight)
        let rect = CGRect(origin: CGPoint(x: 0.0,y :0.0), size: CGSize(width: Rwidth, height: Rheight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))! as NSData
     //   print("Size of Image(bytes):\(imageData.length)")
        UIGraphicsEndImageContext()
        return UIImage(data: imageData as Data)!
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //  currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: currentSelectedImage.size.width, height: currentSelectedImage.size.height))
        
      //  let imgData: NSData = UIImageJPEGRepresentation(currentSelectedImage, 1)! as NSData
    //    print("Size of Image(bytes):\(imgData.length)")
        
      //  currentSelectedImage = self.compressImage(currentSelectedImage)
        
        if CameraInt == 0
        {
          //  HeaderImage.image = currentSelectedImage
            
            self.ImageCropView()
        }
        else if CameraInt == 1
        {
           // LogoImage.image = currentSelectedImage
            
              self.ImageCropView()
            
           // self.uploadImageAPIMethod()
        }
        else
        {
             self.ImageCropView()
        }

        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func ImageCropView ()
    {
        popview4.isHidden=false
        footerView4.isHidden=false
        
        popview4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview4.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview4)
        
        footerView4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerView4.backgroundColor = UIColor.black
        popview4.addSubview(footerView4)
        
        CropperView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height-50)
        CropperView.backgroundColor = UIColor.white
        CropperView.image = currentSelectedImage
        footerView4.addSubview(CropperView)
        
        CroppedImageView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height-50)
        
        footerView4.addSubview(CroppedImageView)
        
        
        let Cancelbutt = UIButton()
        Cancelbutt.frame = CGRect(x:0, y:self.view.frame.size.height-50, width:self.view.frame.size.width/2-2, height:50)
        Cancelbutt.setTitle("Retake", for: UIControlState.normal)
        Cancelbutt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Cancelbutt.setTitleColor(UIColor.black, for: UIControlState.normal)
        Cancelbutt.addTarget(self, action: #selector(self.RetakeButtAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(Cancelbutt)
        
        let Donebutt = UIButton()
        Donebutt.frame = CGRect(x:self.view.frame.size.width/2+1, y:self.view.frame.size.height-50, width:self.view.frame.size.width/2-2, height:50)
        Donebutt.setTitle("Crop", for: UIControlState.normal)
        Donebutt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Donebutt.setTitleColor(UIColor.black, for: UIControlState.normal)
        Donebutt.addTarget(self, action: #selector(self.CropButtAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(Donebutt)
        
        if CameraInt == 1
        {
            CropperView.cropSize = CGSize(width: 300, height: 300)
        }
        else if CameraInt == 2
        {
            CropperView.cropSize = CGSize(width: 400, height: 300)
        }
        else
        {
             CropperView.cropSize = CGSize(width: 400, height: 200)
        }
       
    }
    
    func RetakeButtAction(_ sender: UIButton!)
    {
        popview4.isHidden=true
        footerView4.isHidden=true
        self.CameraView()
    }
    
    func CropButtAction(_ sender: UIButton!)
    {
        popview4.isHidden=true
        footerView4.isHidden=true
        
        CropperView.renderCroppedImage({(_ croppedImage: UIImage?, _ cropRect: CGRect) -> Void in
            
            if self.CameraInt == 0
            {
                 self.HeaderImage.image = croppedImage
                 self.cropSelectedImage = croppedImage!
                 self.classObject.next(croppedImage)
                 AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
               //  self.uploadImageAPIMethod()
            }
            else if self.CameraInt == 1
            {
                self.LogoImage.image = croppedImage
                self.cropSelectedImage = croppedImage!
                self.classObject.next(croppedImage)
                AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            }
            else
            {
                self.cropSelectedImage = croppedImage!
                self.classObject.next(croppedImage)
                AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
               //  self.uploadImageAPIMethod()
            }
        })
    }
    
    func responsewithToken(_ responseToken: NSMutableDictionary!)
    {
        print(responseToken)
        AFWrapperClass.svprogressHudDismiss(view: self)
        
        if responseToken == nil
        {
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: "Server is not responding.Please try again later", view: self)
        }
        else
        {
        
        if (responseToken.object(forKey: "status") as! NSNumber) == 1
        {
            if self.CameraInt == 0
            {
                self.HeaderimagPathArray.removeAllObjects()
                self.HeaderresponseString = responseToken.value(forKey: "path") as? String ?? ""
                let strpath =  responseToken.value(forKey: "path") as? String ?? ""
                
                var arrUrl = [Any]()
                arrUrl.append(strpath)
                self.HeaderimagPathArray.addObjects(from: arrUrl)
            }
             else if self.CameraInt == 1
            {
                self.logoimagPathArray.removeAllObjects()
                self.logoresponseString = responseToken.value(forKey: "path") as? String ?? ""
                let strpath =  responseToken.value(forKey: "path") as? String ?? ""
                
                var arrUrl = [Any]()
                arrUrl.append(strpath)
                self.logoimagPathArray.addObjects(from: arrUrl)
            }
            else
            {
                if StrEditMode == "1"
                {
                    var arrUrl = [Any]()
                    arrUrl.append(responseToken.value(forKey: "url") as? String ?? "")
                    self.imagPathArray.addObjects(from: arrUrl)
                    
                    print(self.imagPathArray)
                    self.collectionViewSetUp.reloadData()
                    
                    let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imagPathArray, options: [])
                    self.responseString = String(data: jsonData!, encoding: .utf8)!
                    self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
                    
                    if self.imagPathArray.count == 0
                    {
                        txtLabImage.isHidden = false
                    }
                    else
                    {
                        txtLabImage.isHidden = true
                    }
                }
                else
                {
                    let strurl =  responseToken.value(forKey: "url") as? String ?? ""
                    let strpath =  responseToken.value(forKey: "path") as? String ?? ""
                
                    var arrUrl = [Any]()
                    arrUrl.append(strurl)
                    self.imagPathArray.addObjects(from: arrUrl)
                
                    var arrPath = [Any]()
                    arrPath.append(strpath)
                    self.imgFolderAry.addObjects(from: arrPath)
                
                    var postDict = [AnyHashable: Any]()
                    postDict["locations"] = self.imgFolderAry
                
                    let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
                    self.responseString = String(data: jsonData!, encoding: .utf8)!
                    self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
                
                    if self.imagPathArray.count == 0
                    {
                        txtLabImage.isHidden = false
                    }
                    else
                    {
                        txtLabImage.isHidden = true
                    }
                
                    self.collectionViewSetUp.reloadData()
                }
            }
        }
        else
        {
            let strerror = responseToken.object(forKey: "error") as? String ?? "Server error"
            let Message = responseToken.object(forKey: "responseMessage") as? String ?? strerror
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        }
    }
    

    
 //MARK: Upload image Method API:
    
//    func uploadImageAPIMethod () -> Void
//    {
//        if self.CameraInt == 0
//        {
//            self.imagPathArray.removeAllObjects()
//            self.imgFolderAry.removeAllObjects()
//
//
//            var arrUrl = [Any]()
//            arrUrl.append("http://arghyathakur.in/assets/file-upload/No_Image.jpg")
//            self.imagPathArray.addObjects(from: arrUrl)
//
//            var arrPath = [Any]()
//            arrPath.append("http://arghyathakur.in/assets/file-upload/No_Image.jpg")
//            self.imgFolderAry.addObjects(from: arrPath)
//
//            var postDict = [AnyHashable: Any]()
//            postDict["locations"] = self.imgFolderAry
//
//            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
//            self.responseString = String(data: jsonData!, encoding: .utf8)!
//            self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
//        }
//        else
//        {
//            self.logoimagPathArray.removeAllObjects()
//            self.logoimgFolderAry.removeAllObjects()
//
//            var arrUrl = [Any]()
//            arrUrl.append("http://arghyathakur.in/assets/file-upload/No_Image.jpg")
//            self.logoimagPathArray.addObjects(from: arrUrl)
//
//            var arrPath = [Any]()
//            arrPath.append("http://arghyathakur.in/assets/file-upload/No_Image.jpg")
//            self.logoimgFolderAry.addObjects(from: arrPath)
//
//            var postDict = [AnyHashable: Any]()
//            postDict["locations"] = self.logoimgFolderAry
//
//            self.logoresponseString = self.logoimgFolderAry.componentsJoined(by: ",")
//
//            // let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.logoimgFolderAry, options: [])
//            // self.logoresponseString = String(data: jsonData!, encoding: .utf8)!
//            // self.logoresponseString = self.logoresponseString.replacingOccurrences(of: " ", with: "%20")
//        }
//
//
//    }
//
//
    
    
    
    

    func uploadImageAPIMethod () -> Void
    {

        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
       // let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
         let imageData: Data? = UIImageJPEGRepresentation(cropSelectedImage, 1)
        if imageData == nil {
//            let imgData: Data? = UIImageJPEGRepresentation(cell.imageViewColctn.image!, 1)
//            self.currentSelectedImage = UIImage(data: imgData! as Data)!

            AFWrapperClass.alert(Constants.applicationName, message: "Please choose images", view: self)
                    }
         let strkey = Constants.ApiKey
        let parameters = ["api_key":strkey] as [String : String]
        print(parameters)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
        let image = self.cropSelectedImage
        multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "img", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@%@&",Constants.mainURL,"imageUpload"))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    print(response)
                    if response.result.isSuccess
                    {
                    AFWrapperClass.svprogressHudDismiss(view: self)

                    let dataDic : NSDictionary = response.result.value as! NSDictionary
                        if (dataDic.object(forKey: "responseCode") as! NSNumber) == 200
                        {

                            if self.CameraInt == 0
                            {
                                self.imagPathArray.removeAllObjects()
                                self.imgFolderAry.removeAllObjects()


                                var arrUrl = [Any]()
                                arrUrl.append((dataDic.object(forKey: "imagepath") as? String)!)
                                self.imagPathArray.addObjects(from: arrUrl)

                                var arrPath = [Any]()
                                arrPath.append((dataDic.object(forKey: "imgfolderpath") as? String)!)
                                self.imgFolderAry.addObjects(from: arrPath)

                                var postDict = [AnyHashable: Any]()
                                postDict["locations"] = self.imgFolderAry

                                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
                                self.responseString = String(data: jsonData!, encoding: .utf8)!
                                self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
                            }
                            else
                            {
                                self.logoimagPathArray.removeAllObjects()
                                self.logoimgFolderAry.removeAllObjects()

                                var arrUrl = [Any]()
                                arrUrl.append((dataDic.object(forKey: "imagepath") as? String)!)
                                self.logoimagPathArray.addObjects(from: arrUrl)

                                var arrPath = [Any]()
                                arrPath.append((dataDic.object(forKey: "imgfolderpath") as? String)!)
                                self.logoimgFolderAry.addObjects(from: arrPath)

                                var postDict = [AnyHashable: Any]()
                                postDict["locations"] = self.logoimgFolderAry

                                self.logoresponseString = self.logoimgFolderAry.componentsJoined(by: ",")

                               // let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.logoimgFolderAry, options: [])
                               // self.logoresponseString = String(data: jsonData!, encoding: .utf8)!
                               // self.logoresponseString = self.logoresponseString.replacingOccurrences(of: " ", with: "%20")
                            }


//          print("Before JsonString: \(self.responseString)")
//          print("Before deleted Array \(self.imgFolderAry)")

       //     self.collectionViewSetUp.reloadData()
        //    AFWrapperClass.alert(Constants.applicationName, message: "Image Uplaod Successfully", view: self)
            }
            else
                {
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: "Image not Uploaded Please try again.", view: self)
                }
            }
            if response.result.isFailure
                    {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError

                    AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                     //   print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
              //  print(error.localizedDescription)
                break
            }
        }
}

    
//MARK: CollectionView Delegates
    
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imagPathArray.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetupCVCell", for: indexPath) as! SetupCVCell
        
//        let image:UIImage = self.imageTakeArray.object(at: indexPath.row) as! UIImage
//        cell.imageViewColctn.image = image
        
        
        let imageURL: String = self.imagPathArray.object(at: indexPath.row) as! String
     //   print(imageURL)
        let url = NSURL(string:imageURL)
        cell.imageViewColctn.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
       cell.deleteBtn.tag = indexPath.row
       cell.deleteBtn.addTarget(self, action: #selector(SetupFoodBankVC.deleteButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    // MARK: Delete Button Action:
    func deleteButtonAction(_ sender: UIButton!) {
   
        let myCell: SetupCVCell? = (sender.superview?.superview as? UICollectionViewCell as! SetupCVCell?)
        let indexPath: IndexPath? = self.collectionViewSetUp.indexPath(for: myCell!)
        if sender.tag == indexPath?.row
        {
            if StrEditMode == "1"
            {
               // deletePathStr = self.imgFolderAry.object(at: (indexPath?.row)!) as! String
                
                self.imagPathArray.removeObject(at: indexPath?.row ?? Int())
                
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imagPathArray, options: [])
                self.responseString = String(data: jsonData!, encoding: .utf8)!
                self.responseString = responseString.replacingOccurrences(of: " ", with: "%20")
            }
            else
            {
                deletePathStr = self.imgFolderAry.object(at: (indexPath?.row)!) as! String
            
                self.imagPathArray.removeObject(at: indexPath?.row ?? Int())
                self.imgFolderAry.removeObject(at: indexPath?.row ?? Int())
            
                if self.imagPathArray.count == 0
                {
                    txtLabImage.isHidden = false
                }
                else
                {
                    txtLabImage.isHidden = true
                }
            
                var postDict = [AnyHashable: Any]()
                postDict["locations"] = self.imgFolderAry
                let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
                self.responseString = String(data: jsonData!, encoding: .utf8)!
                self.responseString = responseString.replacingOccurrences(of: " ", with: "%20")
            }
            
          //  print("After JsonString: \(self.responseString)")
            //print("after deleted Array \(self.imagPathArray)")
            //print(self.imagPathArray.count)
            
          //  self.ImageDeleteAPImethod ()
            
           self.collectionViewSetUp.reloadData()
        }
        
    }
    
   
    
    // MARK:  DeleteImageAPImethod
    
    func ImageDeleteAPImethod () -> Void
    {
        var arrPath = [Any]()
        arrPath.append(deletePathStr)
        self.DeleteFolderAry.addObjects(from: arrPath)
        
        var postDict = [AnyHashable: Any]()
        postDict["locations"] = self.DeleteFolderAry
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.DeleteFolderAry, options: [])
        self.responseString2 = String(data: jsonData!, encoding: .utf8)!
        self.responseString2 = self.responseString.replacingOccurrences(of: " ", with: "%20")
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=deleteupload&imgfolderpath=\(self.responseString2)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                  //  print(responceDic)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Please try again", view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }

    
      // MARK:  SEt
    @IBAction func setUpFoodbankBtnAction(_ sender: Any)
    {
        var message = String()
        if (locationTF.text?.isEmpty)!
        {
            message = "Please select Location"
        }
        else if (nameTextFieds.text?.isEmpty)!
        {
            message = "Please enter FoodBank name"
        }
        else if ((descriptionTextView.text?.isEmpty)! || descriptionTextView.text! == "Enter your text here..")
        {
            message = "Please enter description"
        }
        else if (HeaderimagPathArray.count == 0)
        {
            message = "Please choose Foodbank Header image"
        }
        else if (logoimagPathArray.count == 0)
        {
            message = "Please choose Foodbank Logo image"
        }
        else if (imagPathArray.count == 0)
        {
            message = "Please choose Atleasst one Image"
        }
        else if (txtSelectCategory.text?.isEmpty)!
        {
            message = "Please choose Foodbank Category"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
            
        }else{
            self.saveFoodbankAPImethod()
        }
    }
    
    
    @objc private  func saveFoodbankAPImethod () -> Void
    {
        
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        
        var baseURL = String()
        if StrEditMode == "1"
        {
            baseURL = String(format:"%@%@",Constants.mainURL,"updateFoodbankDetail")
        }
        else
        {
            baseURL = String(format:"%@%@",Constants.mainURL,"addFoodbank")
        }
        
        
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        if StrEditMode == "1"
        {
            PostDataValus.setValue(StrFoodbankId, forKey: "foodbank_id")
        }
        else
        {
            PostDataValus.setValue(strUserID, forKey: "user_id")
        }
        PostDataValus.setValue(nameTextFieds.text!, forKey: "title")
        PostDataValus.setValue(descriptionTextView.text!, forKey: "desc")
        PostDataValus.setValue(locationTF.text!, forKey: "address")
        PostDataValus.setValue(strlat, forKey: "lat")
        PostDataValus.setValue(strlong, forKey: "long")
        PostDataValus.setValue(responseCatIdString, forKey: "food_category")
        PostDataValus.setValue(logoresponseString, forKey: "logo_image")
        PostDataValus.setValue(HeaderresponseString, forKey: "header_image")
        PostDataValus.setValue(responseString, forKey: "images")
        
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
        
        
        
        
        
      //  let latStr: String = String(currentLatitude)
      //  let longStr: String = String(currentLongitude)
     //   let baseURL: String  = String(format:"%@",Constants.mainURL)
     //   let params = "method=add_foodbanks&user_id=\(strUserID)&fbank_title=\(nameTextFieds.text!)&fbank_desc=\(descriptionTextView.text!)&images=\(responseString)&lat=\(latStr)&longt=\(longStr)&address=\(locationTF.text!)&logo_image=\(logoresponseString)&food_category=\(responseCatIdString)"
       // print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                 print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                   // let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CongratulationVC") as? CongratulationVC
                   // self.navigationController?.pushViewController(myVC!, animated: false)
                  //  let number = responceDic.object(forKey: "foodbankid") as! NSNumber
                  //  myVC?.foodBankIDStr  = String(describing: number)
                    
                    if self.StrEditMode == "1"
                    {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        let number = responceDic.object(forKey: "foodbank_id") as! NSNumber
                        self.foodBankIDStr = String(describing: number)
                        
                        self.UpdateFoodBank()
                    }
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "Please try again", view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    func UpdateFoodBank()
    {
        strManageUser = "1"
        
        sliderString = String(format:"0") 
        popview2.isHidden=false
        footerView2.isHidden=false
        
        popview2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview2.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview2)
        
        footerView2.frame = CGRect(x:10, y:popview2.frame.size.height/2-230, width:popview2.frame.size.width-20, height:460)
        footerView2.backgroundColor = UIColor.white
        popview2.addSubview(footerView2)
        
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:10, y:15, width:footerView2.frame.size.width-20, height:25)
        titlelab.text="Congratulations!!!!!"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        titlelab.textColor=#colorLiteral(red: 0.1807585061, green: 0.6442081332, blue: 0.8533658385, alpha: 1)
        titlelab.textAlignment = .center
        footerView2.addSubview(titlelab)
        
        
        
        txtlab.frame = CGRect(x:10, y:50, width:footerView2.frame.size.width-20, height:80)
        txtlab.numberOfLines=0
        
        let mutableAttributedString = NSMutableAttributedString()
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        
        let regularAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        
        
        let regularAttributedString = NSAttributedString(string: "Thanks for setting up ", attributes: regularAttribute)
        let boldAttributedString = NSAttributedString(string: nameTextFieds.text!, attributes: boldAttribute)
        let regularAttributedString2 = NSAttributedString(string: " on Food4All. Your Food Bank will be listed soon once our team review and activate it.", attributes: regularAttribute)
        
        mutableAttributedString.append(regularAttributedString)
        mutableAttributedString.append(boldAttributedString)
        mutableAttributedString.append(regularAttributedString2)
        
        txtlab.attributedText = mutableAttributedString
        txtlab.textAlignment = .left
        footerView2.addSubview(txtlab)
        
        
        
        let titlelab3 = UILabel()
        titlelab3.frame = CGRect(x:10, y:140, width:footerView2.frame.size.width-20, height:40)
        titlelab3.numberOfLines=0
        
        let mutableAttributedString2 = NSMutableAttributedString()
        
        let regularAttributedString3 = NSAttributedString(string: "Please Update initial ", attributes: regularAttribute)
        let boldAttributedString2 = NSAttributedString(string: "Load Status", attributes: boldAttribute)
        let regularAttributedString4 = NSAttributedString(string: " of your Food Bank.", attributes: regularAttribute)
        
        mutableAttributedString2.append(regularAttributedString3)
        mutableAttributedString2.append(boldAttributedString2)
        mutableAttributedString2.append(regularAttributedString4)
        
        titlelab3.attributedText = mutableAttributedString2
        titlelab3.textAlignment = .left
        footerView2.addSubview(titlelab3)
        
        
        
        percentlab.frame = CGRect(x:10, y:185, width:footerView2.frame.size.width-20, height:20)
        percentlab.text="Percent(%)"
        percentlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        percentlab.textColor=UIColor.black
        percentlab.textAlignment = .center
        footerView2.addSubview(percentlab)
        
        
        
        
        SliderVal2.frame = CGRect(x:25, y:250, width:footerView2.frame.size.width-50, height:31)
        SliderVal2.maximumValue=1
        SliderVal2.maximumValue=100
        SliderVal2.value=0
        SliderVal2.markWidth=0
        SliderVal2.height=6
        SliderVal2.handlerImage=UIImage(named:"Radio-clicked copy")
        SliderVal2.addTarget(self, action:  #selector(_sldComponentChangedValue),for: .valueChanged)
        footerView2.addSubview(SliderVal2)
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:15, y:SliderVal2.frame.size.height+SliderVal2.frame.origin.y+10, width:footerView2.frame.size.width-80, height:40)
        Headview.layer.borderWidth=1.0
        Headview.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
        footerView2.addSubview(Headview)
        
        
        let txtlab2 = UILabel()
        txtlab2.frame = CGRect(x:10, y:5, width:Headview.frame.size.width-20, height:30)
        txtlab2.text="Are you managing this food Bank?"
        txtlab2.font =  UIFont(name:"Helvetica", size: 13)
        txtlab2.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txtlab2.textAlignment = .left
        Headview.addSubview(txtlab2)
        
        
        switchlab.frame = CGRect(x:footerView2.frame.size.width-60, y:SliderVal2.frame.size.height+SliderVal2.frame.origin.y+15, width:40, height:30)
        switchlab.setOn(true, animated: false)
        switchlab.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        footerView2.addSubview(switchlab)
        
        
        
        
        
        
        
        
        
        
        
        Headview2.frame = CGRect(x:15, y:Headview.frame.size.height+Headview.frame.origin.y+15, width:footerView2.frame.size.width-35, height:40)
        Headview2.layer.borderWidth=1.0
        Headview2.layer.borderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(164 / 255.0), blue: CGFloat(154 / 255.0), alpha: CGFloat(1.0)).cgColor
        Headview2.isHidden=true
        footerView2.addSubview(Headview2)
        
        txtemailfield.frame = CGRect(x:5, y:5, width:Headview2.frame.size.width-45, height:30);
        txtemailfield.placeholder="Enter Email Id/Mobile Number"
        txtemailfield.font =  UIFont(name:"Helvetica", size: 14)
        Headview2.addSubview(txtemailfield)
        
        let addemailbutt = UIButton()
        addemailbutt.frame = CGRect(x:Headview2.frame.size.width-40, y:5, width:30, height:30)
        addemailbutt.setTitle("+", for: .normal)
        addemailbutt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addemailbutt.setTitleColor(UIColor.white, for: UIControlState.normal)
        addemailbutt.layer.cornerRadius = 15;
        addemailbutt.clipsToBounds = true;
        addemailbutt.addTarget(self, action: #selector(SetupFoodBankVC.addEmailbuttAction(_:)), for: UIControlEvents.touchUpInside)
        addemailbutt.backgroundColor=#colorLiteral(red: 0.1807585061, green: 0.6442081332, blue: 0.8533658385, alpha: 1)
        Headview2.addSubview(addemailbutt)
        
        
        
        
        
        let okbutt = UIButton()
        okbutt.frame = CGRect(x:15, y:Headview2.frame.size.height+Headview2.frame.origin.y+15, width:footerView2.frame.size.width-30, height:40)
        okbutt.setTitle("Ok", for: .normal)
        okbutt.addTarget(self, action: #selector(SetupFoodBankVC.okButtonAction(_:)), for: UIControlEvents.touchUpInside)
        okbutt.backgroundColor=#colorLiteral(red: 0.1807585061, green: 0.6442081332, blue: 0.8533658385, alpha: 1)
        footerView2.addSubview(okbutt)

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
        
        self.txtemailfield.inputAccessoryView = doneToolbar
       
    }
    
   
    
    func _sldComponentChangedValue(sender: UISlider!) {
        
        self.SliderVal2.setValue((round(sender.value / 5) * 5), animated: false)
        let integere: Int = Int((round(sender.value / 5) * 5))
      //  print(integere)
        
         percentlab.text = ""
        let aStr = String(format: "Percent(%d)", integere)
        percentlab.text=aStr
        
        sliderString = String(integere)
    }
    
    
    
   // MARK: add email action:
    func addEmailbuttAction(_ sender: UIButton!)
    {
        
        let alert = UIAlertController(title: "Food4All", message: "Add Email Id/Mobile number", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Email Id", style: UIAlertActionStyle.default,handler: { action in
            self.Emailmethod()
        })
        
        let alertOKAction2=UIAlertAction(title:"Mobile Number", style: UIAlertActionStyle.default,handler: { action in
            self.MobileNumbermethod()
        })
        
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertOKAction2)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
      
    }

    func CloseemButtonAction(_ sender: UIButton!)
    {
        popviewEmail.isHidden=true
        footerViewEmail.isHidden=true
        
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
    }
    
    func Emailmethod()
    {
        
        strCheck = "2"
        popviewEmail.isHidden=false
        footerViewEmail.isHidden=false
        
        arryDatalistids2.removeAllObjects()
        
        popviewEmail.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popviewEmail.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popviewEmail)
        
        footerViewEmail.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerViewEmail.backgroundColor = UIColor.white
        popviewEmail.addSubview(footerViewEmail)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerViewEmail.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerViewEmail.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerViewEmail.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Email Id"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerViewEmail.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerViewEmail.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(SetupFoodBankVC.CloseemButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerViewEmail.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(SetupFoodBankVC.CloseemButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerViewEmail.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerViewEmail.frame.size.width, height: footerViewEmail.frame.size.height-120)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.tag=2
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        volunterFbTblView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        footerViewEmail.addSubview(volunterFbTblView)
        
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search Email Id"
        theSearchBar?.showsCancelButton = false
        volunterFbTblView.tableHeaderView = theSearchBar
        theSearchBar?.tag=2
        theSearchBar?.isUserInteractionEnabled = true
        
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x:0, y:footerViewEmail.frame.size.height-50, width:footerViewEmail.frame.size.width, height:50  )
        bottomView.backgroundColor = #colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        footerViewEmail.addSubview(bottomView)
        
        let submitlab = UILabel()
        submitlab.frame = CGRect(x:0, y:10, width:bottomView.frame.size.width, height:30)
        submitlab.text="Done"
        submitlab.font =  UIFont(name:"Helvetica", size: 17)
        submitlab.textColor=UIColor.white
        submitlab.textAlignment = .center
        bottomView.addSubview(submitlab)
        
        let submitbutt = UIButton()
        submitbutt.frame = CGRect(x:0, y:0, width:bottomView.frame.size.width, height:bottomView.frame.size.height)
        submitbutt.addTarget(self, action: #selector(SetupFoodBankVC.SubmitButtonAction(_:)), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(submitbutt)
        
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
    
  


    
    func MobileNumbermethod()
    {
        strCheck = "1"
        popviewEmail.isHidden=false
        footerViewEmail.isHidden=false
        
        arryDatalistids.removeAllObjects()
        
        popviewEmail.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popviewEmail.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popviewEmail)
        
        footerViewEmail.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerViewEmail.backgroundColor = UIColor.white
        popviewEmail.addSubview(footerViewEmail)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerViewEmail.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerViewEmail.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerViewEmail.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Mobile Number"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerViewEmail.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerViewEmail.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(SetupFoodBankVC.CloseemButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerViewEmail.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(SetupFoodBankVC.CloseemButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerViewEmail.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerViewEmail.frame.size.width, height: footerViewEmail.frame.size.height-120)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.tag=4
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        volunterFbTblView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        footerViewEmail.addSubview(volunterFbTblView)
        
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search Mobile Number"
        theSearchBar?.showsCancelButton = false
        volunterFbTblView.tableHeaderView = theSearchBar
        theSearchBar?.tag=1
        theSearchBar?.isUserInteractionEnabled = true
        
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x:0, y:footerViewEmail.frame.size.height-50, width:footerViewEmail.frame.size.width, height:50  )
        bottomView.backgroundColor = #colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        footerViewEmail.addSubview(bottomView)
        
        let submitlab = UILabel()
        submitlab.frame = CGRect(x:0, y:10, width:bottomView.frame.size.width, height:30)
        submitlab.text="Done"
        submitlab.font =  UIFont(name:"Helvetica", size: 17)
        submitlab.textColor=UIColor.white
        submitlab.textAlignment = .center
        bottomView.addSubview(submitlab)
        
        let submitbutt = UIButton()
        submitbutt.frame = CGRect(x:0, y:0, width:bottomView.frame.size.width, height:bottomView.frame.size.height)
        submitbutt.addTarget(self, action: #selector(SetupFoodBankVC.SubmitButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(submitbutt)
        
        self.addDoneButtonOnKeyboard4()
    }
    
  
    func addDoneButtonOnKeyboard4()
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
    
    
    
    func SubmitButtonAction(_ sender: UIButton!)
    {
        if arryDatalistids2.count==0
        {
            var Message=String()
            Message = "Please Select Mobile Number"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
            // let jsonData2: Data? = try? JSONSerialization.data(withJSONObject: arryDatalistids, options: [])
            // let jsonObject : Any = try! JSONSerialization.jsonObject(with: jsonData2!, options: [])
            // let jsonString = String(data: jsonData2!, encoding: String.Encoding.utf8)! as String
            // let string = arryDatalistids.joined(separator: ",")
            
            let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Add this Email Id", preferredStyle: UIAlertControllerStyle.alert)
            
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
        txtemailfield.text = strEmailId as String
        
        popviewEmail.isHidden=true
        footerViewEmail.isHidden=true
        
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
    }
    
    
    func SubmitButtonAction2(_ sender: UIButton!)
    {
        if arryDatalistids.count==0
        {
            var Message=String()
            Message = "Please Select Mobile Number"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
            // let jsonData2: Data? = try? JSONSerialization.data(withJSONObject: arryDatalistids, options: [])
            // let jsonObject : Any = try! JSONSerialization.jsonObject(with: jsonData2!, options: [])
            // let jsonString = String(data: jsonData2!, encoding: String.Encoding.utf8)! as String
            // let string = arryDatalistids.joined(separator: ",")
            
            let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Add this Mobile Number", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Add", style: UIAlertActionStyle.default,handler: { action in
                self.Addmethod2()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func Addmethod2()
    {
        
        txtemailfield.text = strMobileNumber as String
        
        popviewEmail.isHidden=true
        footerViewEmail.isHidden=true
        
        self.searchResults2.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
        
        
//         let str = strMobileNumber as String
//        
//        let index = str.index(str.startIndex, offsetBy: 1)
//        let str1:String = str.substring(to: index)
//        
//        let index2 = str.index(str.startIndex, offsetBy: 2)
//        let str2:String = str.substring(to: index2)
//        
//        if str1 == "+" || str2 == "00"
//        {
//             txtemailfield.text = strMobileNumber as String
//            
//            popviewEmail.isHidden=true
//            footerViewEmail.isHidden=true
//            
//            self.searchResults2.removeAllObjects()
//            volunterFbTblView.removeFromSuperview()
//        }
//        else
//        {
//            strCCodeCheck = "1"
//            
//            let vc = SLCountryPickerViewController()
//            vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
//                self.diallingCode.getForCountry(code!)
//                
//            }
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }

    
    @IBAction func CountryPickerClicked(_ sender: Any)
    {
       
    }
    
    // MARK: Country picker Button Action :
    func CountryPickerButtonAction(_ sender: UIButton!)
    {
        
    }
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!)
    {
        
        if strCCodeCheck == "1"
        {
          //  print(diallingCode)
            let str1:String = "+"
            
            strCountryCode = String(format: "+%@",diallingCode) as NSString
            
            txtemailfield.text = str1+diallingCode+" "+(strMobileNumber as String) as String
            
            // txtemailfield.text = strMobileNumber as String
            
            popviewEmail.isHidden=true
            footerViewEmail.isHidden=true
            
            self.searchResults2.removeAllObjects()
            volunterFbTblView.removeFromSuperview()
        }
        else
        {
          //  print(diallingCode)
        
            strCountryCode = String(format: "+%@",diallingCode) as NSString
            strMobileNumber = (String(format: "%@",txtemailfield.text!) as NSString) as String
            
            self.UpdateFoodbankAPImethod2()
        }
        
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }


    
    
    
    
    func switchValueDidChange()
    {
        if switchlab.isOn
        {
             Headview2.isHidden=true
            strManageUser = "1"
        }
        else
        {
             Headview2.isHidden=false
            strManageUser = "0"
        }
    }

    class func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func okButtonAction(_ sender: UIButton!)
    {
        var message = String()
        
        if switchlab.isOn
        {
            if sliderString == "0"
            {
                var Message=String()
                Message = "Please Select Minimum Range"
                
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
            }
            else
            {
              self.UpdateFoodbankAPImethod()
            }
            
        }
        else
        {
            if (txtemailfield.text?.isEmpty)!
            {
                message = "Please Enter Email Id/Mobile Number"
                
                AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            }
            else if sliderString == "0"
            {
                var Message=String()
                Message = "Please Select Minimum Range"
                
                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
            }
            else
            {
                
                let str = txtemailfield.text! as String
                
                if str.range(of:"@") != nil
                {
                    if !AFWrapperClass.isValidEmail(txtemailfield.text!)
                    {
                        var Message=String()
                        Message = "Please Enter Proper Email Id"
                        
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                    }
                    else
                    {
                    self.UpdateFoodbankAPImethod1()
                    }
                }
                else
                {
            
//                let index = str.index(str.startIndex, offsetBy: 1)
//              _r1:String = str.substring(to: index)
//                
//                let index2 = str.index(str.startIndex, offsetBy: 2)
//              _r2:String = str.substring(to: index2)
                
               
                //let str1:String = String(format: "%@",str?.index((str?.startIndex)!, offsetBy: 0) as! CVarArg)
               // let str2:String = String(format: "%@%@",str?.index((str?.startIndex)!, offsetBy: 0) as! CVarArg,str?.index((str?.startIndex)!, offsetBy: 1) as! CVarArg)
                    
                
                    let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
                    if str.lowercased().rangeOfCharacter(from: charset) != nil
                    {
                        var Message=String()
                        Message = "Please Enter Proper Email Id/ Mobile Number"
                        
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                    }
                    else
                    {
                        strCCodeCheck = "2"
                        
                        let vc = SLCountryPickerViewController()
                        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
                            self.diallingCode.getForCountry(code!)
                            
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                    
//                if str1 == "+" || str2 == "00"
//                {
//                  self.UpdateFoodbankAPImethod2()
//                }
//                else
//                {
//                   
//                    
//                }
                    
                }
            }
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    
    @objc private  func UpdateFoodbankAPImethod () -> Void
    {
        if sliderString == "0"
        {
            var Message=String()
            Message = "Please Select Minimum Range"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
           // let baseURL: String  = String(format:"%@",Constants.mainURL)
           // let params = "method=update_FoodBanks&fbank_id=\(foodBankIDStr)&percentage=\(sliderString)&userid=\(strUserID)&manage_user=\(strManageUser)"
          //  print(params)
            
            
            let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbank")
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue(foodBankIDStr, forKey: "foodbank_id")
            PostDataValus.setValue(sliderString, forKey: "capacity_status")
            PostDataValus.setValue(strManageUser, forKey: "manage_user")
            PostDataValus.setValue("", forKey: "manage_other_contact")
          
            
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
                    if (responceDic.object(forKey: "status") as! NSNumber) == 1
                    {
                        self.popview2.isHidden=true
                        self.footerView2.isHidden=true
                        _ = self.navigationController?.popToRootViewController(animated: true)
                        
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

    }
    
    
    @objc private  func UpdateFoodbankAPImethod1 () -> Void
    {
        if sliderString == "0"
        {
            var Message=String()
            Message = "Please Select Minimum Range"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
          //  let baseURL: String  = String(format:"%@",Constants.mainURL)
          //  let params = "method=update_FoodBanks&fbank_id=\(foodBankIDStr)&percentage=\(sliderString)&userid=\(strUserID)&manage_user=\(strManageUser)&manage_otheremail=\(txtemailfield.text!)"
        //    print(params)
            
            
            let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbank")
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue(foodBankIDStr, forKey: "foodbank_id")
            PostDataValus.setValue(sliderString, forKey: "capacity_status")
            PostDataValus.setValue(strManageUser, forKey: "manage_user")
            PostDataValus.setValue("", forKey: "manage_other_contact")
            
            
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
                    
                //    print(responceDic)
                    if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                    {
                        self.popview2.isHidden=true
                        self.footerView2.isHidden=true
                        _ = self.navigationController?.popToRootViewController(animated: true)
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
    }
    
    @objc private  func UpdateFoodbankAPImethod2 () -> Void
    {
        if sliderString == "0"
        {
            var Message=String()
            Message = "Please Select Minimum Range"
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
        }
        else
        {
            // Ccode2 = strMobileNumber.replacingOccurrences(of: "+", with: "%2B")
            
            var Ccode=String()
            Ccode = strCountryCode.replacingOccurrences(of: "+", with: "+")
            
            var Ccode2=String()
            Ccode2 = strMobileNumber.replacingOccurrences(of: "+", with: "+")
            
            let strcode = (strCountryCode as String)+strMobileNumber
            
          //  let trimmedString = Ccode2.trimmingCharacters(in: .whitespaces)
            
        //    let baseURL: String  = String(format:"%@",Constants.mainURL)
        //    let params = "method=update_FoodBanks&fbank_id=\(foodBankIDStr)&percentage=\(sliderString)&userid=\(strUserID)&manage_user=\(strManageUser)&manage_otheremail=\(trimmedString)&country_code=\(Ccode)"
         //   print(params)
            
            
            let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateFoodbank")
            let strkey = Constants.ApiKey
            
            let PostDataValus = NSMutableDictionary()
            PostDataValus.setValue(strkey, forKey: "api_key")
            PostDataValus.setValue(strUserID, forKey: "user_id")
            PostDataValus.setValue(foodBankIDStr, forKey: "foodbank_id")
            PostDataValus.setValue(sliderString, forKey: "capacity_status")
            PostDataValus.setValue(strManageUser, forKey: "manage_user")
            PostDataValus.setValue(strcode, forKey: "manage_other_contact")
            
            
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
                    
                //    print(responceDic)
                    if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                    {
                        self.popview2.isHidden=true
                        self.footerView2.isHidden=true
                        _ = self.navigationController?.popToRootViewController(animated: true)
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
    }


    
    
    
  // MARK: TextView Delegates:   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter your text here.."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
        
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        _ = self.navigationController?.popViewController(animated: true)
 
    }
    
    
    
    
    
    
    //  MARK: searchbar Delegates and Datasource:
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.tag==2)
        {
            if searchResults.count != 0 {
                self.searchResults.removeAllObjects()
                volunterFbTblView.tag = 2
            }
            for i in 0..<EmailList.count {
                // [searchResults removeAllObjects];
                let string: String = (self.EmailList.object(at: i) as! NSDictionary).value(forKey: "email") as! String
                let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
                if rangeValue.length > 0
                {
                    volunterFbTblView.tag = 1
                    searchResults.add(EmailList[i])
                }
                else
                {
                    
                }
            }
            volunterFbTblView.reloadData()
        }
        else
        {
            if searchResults2.count != 0 {
                self.searchResults2.removeAllObjects()
                volunterFbTblView2.tag = 4
            }
            for i in 0..<ContactList.count {
                // [searchResults removeAllObjects];
                let string: String = (self.ContactList.object(at: i) as! NSDictionary).value(forKey: "phone") as! String
                let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
                if rangeValue.length > 0
                {
                    volunterFbTblView2.tag = 3
                    searchResults2.add(ContactList[i])
                }
                else
                {
                    
                }
            }
            volunterFbTblView2.reloadData()
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

    
    
    // UITableViewDataSource && Delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 5
        {
            return 50
        }
        else
        {
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 2
        {
            return EmailList.count
        }
        else if tableView.tag == 1
        {
             return searchResults.count
        }
        else if tableView.tag == 4
        {
            return ContactList.count
        }
        else if tableView.tag == 5
        {
            return CategoryListArray.count
        }
        else
        {
           return searchResults2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView.tag == 5
        {
            let cellIdetifier: String = "Cell"
            Fbcell = UITableViewCell(style: .default, reuseIdentifier: cellIdetifier)
            
            Fbcell?.selectionStyle = .none
            
            let userName = UILabel()
            userName.frame = CGRect(x:10, y:10, width:((Fbcell?.frame.size.width)!-120), height:30)
            userName.text=(self.CategoryListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
            userName.font =  UIFont(name:"Helvetica", size: 15)
            userName.textColor=UIColor.black
            userName.textAlignment = .left
            userName.numberOfLines = 0
            Fbcell?.addSubview(userName)
            
            
            let checkImage = UIImageView()
            checkImage.frame = CGRect(x:(Fbcell?.frame.size.width)!-65, y:10, width:30, height:30)
            if let quantity = (self.CategoryListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? NSNumber
            {
                let VolunteerID: String = (quantity: quantity.stringValue) as! String
                
                if arryCatDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }
            }
            else if let VolunteerID = (self.CategoryListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? String
            {
                if arryCatDatalistids.contains(VolunteerID)
                {
                    checkImage.image = UIImage(named: "ck2.png")
                }
                else
                {
                    checkImage.image = UIImage(named: "checkbox.png")
                }
                
            }
            Fbcell?.addSubview(checkImage)
            
            
             return Fbcell!
        }
        else
        {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        // let entry = contacts[(indexPath as NSIndexPath).row]
        // cell.configureWithContactEntry(entry)
        // cell.layoutIfNeeded()
        
    
        if tableView.tag == 2
        {
            cell.contactNameLabel.text = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            let ima: UIImage = (self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            if arryDatalistids2.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }

        }
        else if tableView.tag == 1
        {
            cell.contactNameLabel.text = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            let ima: UIImage = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            if arryDatalistids2.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }

        }
        else if tableView.tag == 4
        {
            cell.contactNameLabel.text = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            let ima: UIImage = (self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            if arryDatalistids.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }
        }
        else
        {
            cell.contactNameLabel.text = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            let ima: UIImage = (self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            
            let VolunteerID:String = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            if arryDatalistids.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }

        }

        

        cell.SelectButt.tag = indexPath.row
        cell.SelectButt.addTarget(self, action: #selector(self.favoritelistClicked), for: .touchUpInside)
        
        cell.SelectButt2.tag = indexPath.row
        cell.SelectButt2.addTarget(self, action: #selector(self.favoritelistClicked), for: .touchUpInside)
        
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 5
        {
            let VolunteerID:String = (self.CategoryListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            let Volunteername:String = (self.CategoryListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String
            
            if arryCatDatalistids.contains(VolunteerID)
            {
                arryCatDatalistids.remove(VolunteerID)
            }
            else
            {
                arryCatDatalistids.add(VolunteerID)
            }
            
            if arryCatDatalistnames.contains(Volunteername)
            {
                arryCatDatalistnames.remove(Volunteername)
            }
            else
            {
                arryCatDatalistnames.add(Volunteername)
            }
            
            volunterFbTblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func favoritelistClicked(_ sender: UIButton!)
    {
       
        if strCheck == "2"
        {
            let buttonPosition = sender.convert(CGPoint.zero, to: volunterFbTblView)
            let tappedIP: IndexPath? = volunterFbTblView.indexPathForRow(at: buttonPosition)
            
            if volunterFbTblView.tag == 2
            {
                arryDatalistids2.removeAllObjects()
                let VolunteerID:String = ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                if arryDatalistids2.contains(VolunteerID)
                {
                    arryDatalistids2.remove(VolunteerID)
                    
                    let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids2.add(VolunteerID)
                    
                    strEmailId =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String as NSString)
                }
 
            }
            else
            {
                arryDatalistids2.removeAllObjects()
                let VolunteerID:String = ((self.searchResults.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                if arryDatalistids2.contains(VolunteerID)
                {
                    arryDatalistids2.remove(VolunteerID)
                    
                    let str: String =  ((self.searchResults.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids2.add(VolunteerID)
                    
                   strEmailId =  ((self.searchResults.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String as NSString)
                }
            }
            
             volunterFbTblView.reloadData()
        }
        else
        {
            let buttonPosition = sender.convert(CGPoint.zero, to: volunterFbTblView)
            let tappedIP: IndexPath? = volunterFbTblView.indexPathForRow(at: buttonPosition)
            
            if volunterFbTblView.tag == 4
            {
                arryDatalistids.removeAllObjects()
                let VolunteerID:String = ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                if arryDatalistids.contains(VolunteerID)
                {
                    arryDatalistids.remove(VolunteerID)
                    
                    let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids.add(VolunteerID)
                    
                    strMobileNumber =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String as NSString) as String
                }
                
            }
            else
            {
                arryDatalistids.removeAllObjects()
                let VolunteerID:String = ((self.searchResults2.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                if arryDatalistids.contains(VolunteerID)
                {
                    arryDatalistids.remove(VolunteerID)
                    
                    let str: String =  ((self.searchResults2.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids.add(VolunteerID)
                    
                    strMobileNumber =  ((self.searchResults2.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String as NSString) as String
                }
            }
                volunterFbTblView.reloadData()
        }
        
       
    }

    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    if success && contacts?.count > 0 {
                        
                        self.contacts = contacts!
                        
                        self.ContactList.removeAllObjects()
                        self.EmailList.removeAllObjects()
                        
                        for i in 0..<self.contacts.count
                        {
                            let entry = contacts?[i]
                            let strname: String = entry!.name
                            let strphone: String = entry!.phone ?? ""
                            
                            self.UserImage = entry?.image ?? UIImage(named: "defaultUser")!
                            
                            if strphone == ""
                            {
                                
                            }
                            else
                            {
                                let arrDic = NSMutableDictionary()
                                let strna: String = strname
                                arrDic["name"] = strna
                                let strph: String = strphone
                                arrDic["phone"] = strph
                                let strpic: UIImage = self.UserImage
                                arrDic["pic"] = strpic
                                
                                self.ContactList.add(arrDic)
                            }
                            
                        }
                        
                        
                        for i in 0..<self.contacts.count
                        {
                            let entry = contacts?[i]
                            let strname: String = entry!.name
                            let stremail: String = entry!.email ?? ""
                            
                            self.UserImage = entry?.image ?? UIImage(named: "defaultUser")!
                            
                            if stremail == ""
                            {
                                
                            }
                            else
                            {
                                let arrDic = NSMutableDictionary()
                                let strna: String = strname
                                arrDic["name"] = strna
                                let strem: String = stremail
                                arrDic["email"] = strem
                                let strpic: UIImage = self.UserImage
                                arrDic["pic"] = strpic
                                
                                self.EmailList.add(arrDic)
                            }
                            
                        }
                        
                    } else {
                        //self.noContactsLabel.text = "Unable to get contacts..."
                    }
                })
            }
        }
    }
    
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SetupFoodBankVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
     //   print("Place name: \(place.name)")
     //   print("Place address: \(String(describing: place.formattedAddress))")
     //   print("Place attributions: \(String(describing: place.attributions))")
        
        locationTF.text! = place.name as String
        geoCodeUsingAddress(address: place.name as NSString)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
     //   print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension SetupFoodBankVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
       mapView2.delegate = self;
        
        currentLatitude=position.target.latitude
        currentLongitude=position.target.longitude
        
        self.locationTF.text! = "Featching Address..."
        locationlab.text = "Featching Address..."
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        self.mapView.animate(to: camera)
        
       
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        
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
       
        if let error = error {
          //  print("Unable to Reverse Geocode Location (\(error))")
            self.locationTF.text! = "Unable to Find Address for Location"
            locationlab.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.locationTF.text! = placemark.compactAddress!
                locationlab.text = placemark.compactAddress!
              //  print(self.locationTF.text!)
            } else {
                self.locationTF.text! = "No Matching Addresses Found"
                locationlab.text = "No Matching Addresses Found"
            }
        }
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
          
            if let street = locality {
                result += ", \(street)"
            }
            
            if let city = subLocality {
                result += ", \(city)"
            }
            
            if let admin = administrativeArea {
                result += ", \(admin)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}


extension SetupFoodBankVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        locationTF.text!=place.name
        locationlab.text = place.name
        currentLatitude=place.location.coordinate.latitude
        currentLongitude=place.location.coordinate.longitude
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        self.marker.title = place.formatted_address
        mapView.reloadInputViews()
        
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView2.delegate = self
        mapView2.camera=camera
        
    }
}

