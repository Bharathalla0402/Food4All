//
//  StepThreeShareFoodVC.swift
//  FoodForAll
//
//  Created by amit on 5/11/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import CoreLocation
import GooglePlaces

class StepThreeShareFoodVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,GMSIndoorDisplayDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SecondDelegate {
    
      var classObject = ChatingDetailsViewController()
    @IBOutlet weak var mainScroolView: UIScrollView!
    @IBOutlet weak var nameTextFieds: ACFloatingTextfield!
    @IBOutlet weak var timeExprTF: ACFloatingTextfield!
    @IBOutlet weak var quantityTF: ACFloatingTextfield!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var UpdateLab: UILabel!
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    var imageTakeArray = NSMutableArray()
    var imagPathArray = NSMutableArray()
    var imgFolderAry = NSMutableArray()
    var DeleteFolderAry = NSMutableArray()
    var responseString = String()
    var responseString2 = String()
    var deletePathStr = String()
    
    @IBOutlet weak var collectionViewSetUp: UICollectionView!
    var cell = SetupCVCell()
    @IBOutlet weak var cameraButton: UIButton!
    
    var categoryStr = String()
    var subCategoryStr = String()
    
    
    
    
    
    
    @IBOutlet var txtLabImage: UILabel!
    
    var foodBankCamera = GMSCameraPosition()
    var foodBankMapView = GMSMapView()
    var foodBankMarker = GMSMarker()
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var mapView2 = GMSMapView()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var checklat = Double()
    var checklong = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var InitialLatitude = Double()
    var InitialLongitude = Double()
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
    
    
    
    
    
    
    @IBOutlet weak var fdBnkNearHightConstrnt: NSLayoutConstraint!
    @IBOutlet weak var searchFoodbankHeightconstrnt: NSLayoutConstraint!
    @IBOutlet weak var volunteersConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectfrommylocconstrain: NSLayoutConstraint!
    
    
    
    
    
    
    @IBOutlet weak var foodBankBrn: UIButton!
    @IBOutlet weak var foodbanksubbutt: UIButton!
    @IBOutlet weak var foodbanksubbutt2: UIButton!
    @IBOutlet weak var myLoctnBtn: UIButton!
    
    
    @IBOutlet weak var foodBankView: UIView!
    @IBOutlet weak var myLoctnView: UIView!
    
    
    @IBOutlet weak var searchFDBnkTF: UITextField!
    @IBOutlet weak var searchVolunteerTF: UITextField!
    @IBOutlet weak var searchLoctnTF: UITextField!
    
    var listArrayFoodBank = NSArray()
    
    var mapSrt = String()
    var radioBtnStringChk = String()
    var straddress = NSString()
    var straddress2 = NSString()
    
    
    
    
    var mainArray = NSArray()
    var searchTableView = UITableView()
    var searchCell: StepFourTableCell!
    
    var  cityNameSelected = String()
    
    
    var mealtitle = String()
    var mealDescription = String()
    var mealQuantity = String()
    var hoursHidden = String()
    var imageString = String()
    var strStatus = String()
    var foodbankiID = String()
    
    var myArray = NSDictionary()
    var strUserID = String()


    var popview4 = UIView()
    var footerView4 = UIView()
    var CropperView = BABCropperView()
    var CroppedImageView = UIImageView()
    var cropSelectedImage = UIImage()
     var strpage = String()
    var StrEditMode = String()
    var StrFoodShareId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        classObject.delegate = self
        imagePicker.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.text = "Enter your text here.."
        descriptionTextView.textColor = UIColor.lightGray
        
        if UserDefaults.standard.object(forKey: "cat1") != nil
        {
            categoryStr = (UserDefaults.standard.object(forKey: "cat1") as! NSString) as String
        }
        
        if UserDefaults.standard.object(forKey: "cat2") != nil
        {
            subCategoryStr = (UserDefaults.standard.object(forKey: "cat2") as! NSString) as String
        }
        else
        {
            subCategoryStr = ""
        }
        
        
        
        
        
        searchFDBnkTF.delegate=self
        
        //strStatus="0"
        
        
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
        
        foodBankBrn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fdBnkNearHightConstrnt.constant = 0
        foodBankView.isHidden=true
        myLoctnView.isHidden=true
        collectfrommylocconstrain.constant = 0
        
        radioBtnStringChk = "nocheck"
        
        
        searchViewController.delegate=self
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
            InitialLatitude = (locationManager.location?.coordinate.latitude)!
            InitialLongitude = (locationManager.location?.coordinate.longitude)!
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
        //self.getAllFoodBanksAPImethod ()
        
        
        
       // scrollheightconst.constant = 260
        
        
       // mainScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: 500)
        
        
        
        if UserDefaults.standard.object(forKey: "EditFoodShare") != nil
        {
            UpdateLab.text = "UPDATE FOOD SHARE"
            
            StrEditMode = "1"
            let outData = UserDefaults.standard.object(forKey: "EditFoodShare")
            let listDetailBank: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData as! Data) as! NSDictionary
            
            self.nameTextFieds.text! = (listDetailBank.value(forKey: "title") as! String)
            self.descriptionTextView.text = listDetailBank.value(forKey: "desc") as? String ?? ""
            self.descriptionTextView.textColor = UIColor.black
            let straddress = listDetailBank.value(forKey: "address") as? String ?? ""
            let stradd = straddress.replacingOccurrences(of: "\n", with: "")
            self.searchLoctnTF.text! = stradd
            self.searchVolunteerTF.text! =  stradd
            self.straddress = stradd as NSString
           
           
            self.imagPathArray = (listDetailBank.value(forKey: "images") as? NSMutableArray)!
            self.imgFolderAry = (listDetailBank.value(forKey: "images") as? NSMutableArray)!
            
            if self.imagPathArray.count == 0
            {
                txtLabImage.isHidden = false
            }
            else
            {
                txtLabImage.isHidden = true
            }
            
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imagPathArray, options: [])
            self.responseString = String(data: jsonData!, encoding: .utf8)!
            self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
            
            if let quantity = listDetailBank.object(forKey: "quantity") as? NSNumber
            {
                self.quantityTF.text =  String(describing: quantity)
            }
            else if let quantity = listDetailBank.object(forKey: "quantity")  as? String
            {
                self.quantityTF.text = quantity
            }
            
            if let quantity = listDetailBank.object(forKey: "id") as? NSNumber
            {
                StrFoodShareId =  String(describing: quantity)
            }
            else if let quantity = listDetailBank.object(forKey: "id")  as? String
            {
                StrFoodShareId = quantity
            }
            
            if let quantity = listDetailBank.object(forKey: "remaining_time") as? NSNumber
            {
                let Val = quantity.intValue/3600
                self.timeExprTF.text = String(Val)
            }
            else if let quantity = listDetailBank.object(forKey: "remaining_time")  as? String
            {
                let Val = Int(quantity)!/3600
                self.timeExprTF.text = String(Val)
            }
            
            var strDeliveryMode = String()
            if let quantity = listDetailBank.object(forKey: "delivery_mode") as? NSNumber
            {
                strDeliveryMode =  String(describing: quantity)
            }
            else if let quantity = listDetailBank.object(forKey: "delivery_mode")  as? String
            {
                strDeliveryMode = quantity
            }
            
            if let quantity = listDetailBank.object(forKey: "food_bank_id") as? NSNumber
            {
                strFoodbankId = String(describing: quantity) as NSString
            }
            else if let quantity = listDetailBank.object(forKey: "food_bank_id")  as? String
            {
                strFoodbankId = quantity as NSString
            }
          
            if strDeliveryMode == "collection"
            {
                let straddress = listDetailBank.value(forKey: "address") as? String ?? ""
                let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                self.straddress2 = stradd as NSString
                
                self.currentLatitude = Double(listDetailBank .value(forKey: "lat") as! String)!
                self.currentLongitude = Double(listDetailBank.value(forKey: "long") as! String)!
                
                if strFoodbankId == "0"
                {
                    strStatus="2"
                    radioBtnStringChk = "FromMyLocation2"
                    
                    foodBankView.isHidden=true
                    myLoctnView.isHidden=false
                    
                    fdBnkNearHightConstrnt.constant = 0
                    searchFoodbankHeightconstrnt.constant  = 0
                    volunteersConstraint.constant = 0
                    collectfrommylocconstrain.constant = 30
                    
                    
                    foodBankBrn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                    foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                    foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                    myLoctnBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
                }
                else
                {
                    strStatus="1"
                    radioBtnStringChk = "FromMyLocation"
                    
                    searchFDBnkTF.text = listDetailBank.value(forKey: "foodbank_title") as? String ?? ""
                    strfoodbankname = listDetailBank.value(forKey: "foodbank_title") as? NSString ?? ""
                    
                    foodBankView.isHidden=false
                    myLoctnView.isHidden=true
                    
                    fdBnkNearHightConstrnt.constant = 172
                    searchFoodbankHeightconstrnt.constant  = 30
                    volunteersConstraint.constant = 30
                    collectfrommylocconstrain.constant = 0
                    
                    
                    foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
                    foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                    foodbanksubbutt2.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
                    myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                    
                   //  self.setUsersClosestCity2()
                }
            }
            else
            {
                let straddress = listDetailBank.value(forKey: "address") as? String ?? ""
                let stradd = straddress.replacingOccurrences(of: "\n", with: "")
                self.straddress = stradd as NSString
                
                checklat = Double(listDetailBank.value(forKey: "lat") as! String)!
                checklong = Double(listDetailBank.value(forKey: "long") as! String)!
                
                strStatus="0"
                radioBtnStringChk = "FoodBankNearBy"
                
                foodBankView.isHidden=false
                myLoctnView.isHidden=true
                
                fdBnkNearHightConstrnt.constant = 142
                searchFoodbankHeightconstrnt.constant  = 30
                volunteersConstraint.constant = 0
                collectfrommylocconstrain.constant = 0
                
                searchFDBnkTF.text = listDetailBank.value(forKey: "foodbank_title") as? String ?? ""
                strfoodbankname = listDetailBank.value(forKey: "foodbank_title") as? NSString ?? ""
                
                foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
                foodbanksubbutt.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
                foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
                
                 self.setUsersClosestCity2()
            }
            
            UserDefaults.standard.removeObject(forKey: "EditFoodShare")
        }
        else
        {
            self.nameTextFieds.text = ""
            self.timeExprTF.text = ""
            self.quantityTF.text = ""
            self.descriptionTextView.text = "Enter your text here.."
            
            self.setUsersClosestCity()
        }
        
        self.addDoneButtonOnKeyboard()
    }
    
    
    func setUsersClosestCity2()
    {
        currentLatitude = InitialLatitude
        currentLongitude = InitialLongitude
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: InitialLatitude, longitude: InitialLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
                
                self.straddress2 = formattedAddress.joined(separator: ", ") as NSString
                self.searchLoctnTF.text! = formattedAddress.joined(separator: ", ")
                self.searchVolunteerTF.text! =  formattedAddress.joined(separator: ", ")
            }
            
        })
        
    }
    
    
    
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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
        self.quantityTF.inputAccessoryView = doneToolbar
        self.timeExprTF.inputAccessoryView = doneToolbar
        self.descriptionTextView.inputAccessoryView = doneToolbar
        self.searchFDBnkTF.inputAccessoryView = doneToolbar
        self.searchVolunteerTF.inputAccessoryView = doneToolbar
        self.searchLoctnTF.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }

    
     //MARK:  -> ImagePicker Controller Delegates
    
    @IBAction func cameraButtonAction(_ sender: Any)
    {
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
            optionMenu.addAction(pibraryAction)
            optionMenu.addAction(cameraction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
                popOverPresentationController.sourceView                = cameraButton
                popOverPresentationController.sourceRect                = cameraButton.bounds
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
        print("Size of Image(bytes):\(imageData.length)")
        UIGraphicsEndImageContext()
        return UIImage(data: imageData as Data)!
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      //  currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: currentSelectedImage.size.width, height: currentSelectedImage.size.height))
        
     //   let imgData: NSData = UIImageJPEGRepresentation(currentSelectedImage, 1)! as NSData
     //   print("Size of Image(bytes):\(imgData.length)")
        
      //  currentSelectedImage = self.compressImage(currentSelectedImage)
        
       // self.uploadImageAPIMethod()
        
          self.ImageCropView()
        
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
        
         CropperView.cropSize = CGSize(width: 400, height: 300)
        
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
            
            self.cropSelectedImage = croppedImage!
          //  self.uploadImageAPIMethod()
            
            self.classObject.next(croppedImage)
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
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
            var arrUrl = [Any]()
            arrUrl.append(responseToken.value(forKey: "url") as? String ?? "")
            self.imagPathArray.addObjects(from: arrUrl)
            
            var arrPath = [Any]()
            arrPath.append(responseToken.value(forKey: "path") as? String ?? "")
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
            }
            
            self.collectionViewSetUp.reloadData()
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
    
    
    func uploadImageAPIMethod () -> Void
    {
        self.imagPathArray.removeAllObjects()
        self.imgFolderAry.removeAllObjects()
        
        
        var arrUrl = [Any]()
        arrUrl.append("No_Image.jpg")
        self.imagPathArray.addObjects(from: arrUrl)
        
        var arrPath = [Any]()
        arrPath.append("No_Image.jpg")
        self.imgFolderAry.addObjects(from: arrPath)
        
        var postDict = [AnyHashable: Any]()
        postDict["locations"] = self.imgFolderAry
        
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
        self.responseString = String(data: jsonData!, encoding: .utf8)!
        self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
        
         self.collectionViewSetUp.reloadData()
    }
    
    
    
//
//    func uploadImageAPIMethod () -> Void
//    {
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        // let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
//        let imageData: Data? = UIImageJPEGRepresentation(cropSelectedImage, 1)
//        if imageData == nil {
//            //            let imgData: Data? = UIImageJPEGRepresentation(cell.imageViewColctn.image!, 1)
//            //            self.currentSelectedImage = UIImage(data: imgData! as Data)!
//
//            AFWrapperClass.alert(Constants.applicationName, message: "Please choose images", view: self)
//        }
//
//        let parameters = ["method":"imageupload"] as [String : String]
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            let image = self.currentSelectedImage
//            multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "img", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to:String(format: "%@",Constants.mainURL))
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                upload.uploadProgress(closure: { (progress) in
//                })
//                upload.responseJSON { response in
//                    print(Progress())
//                    if response.result.isSuccess
//                        //print(response.result.value as! NSDictionary)
//                    {
//                        AFWrapperClass.svprogressHudDismiss(view: self)
//
//                        let dataDic : NSDictionary = response.result.value as! NSDictionary
//                        if (dataDic.object(forKey: "responseCode") as! NSNumber) == 200
//                        {
//
//                            var arrUrl = [Any]()
//                            arrUrl.append((dataDic.object(forKey: "imagepath") as? String)!)
//                            self.imagPathArray.addObjects(from: arrUrl)
//
//                            var arrPath = [Any]()
//                            arrPath.append((dataDic.object(forKey: "imgfolderpath") as? String)!)
//                            self.imgFolderAry.addObjects(from: arrPath)
//
//                            var postDict = [AnyHashable: Any]()
//                            postDict["locations"] = self.imgFolderAry
//                            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
//                            self.responseString = String(data: jsonData!, encoding: .utf8)!
//                            self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
//
//                            print("Before JsonString: \(self.responseString)")
//                            print("Before deleted Array \(self.imgFolderAry)")
//
//                            self.collectionViewSetUp.reloadData()
//                          //  AFWrapperClass.alert(Constants.applicationName, message: "Image Uplaod Successfully", view: self)
//                        }
//                        else
//                        {
//                            AFWrapperClass.svprogressHudDismiss(view: self)
//                            AFWrapperClass.alert(Constants.applicationName, message: "Image not Uploaded Please try again.", view: self)
//                        }
//                    }
//                    if response.result.isFailure
//                    {
//                        AFWrapperClass.svprogressHudDismiss(view: self)
//                        let error : NSError = response.result.error! as NSError
//
//                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//                print(error.localizedDescription)
//                break
//            }
//        }
//    }
//
    
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
        print(imageURL)
        let url = NSURL(string:imageURL)
        cell.imageViewColctn.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        cell.imageViewColctn.contentMode = .scaleAspectFill
        cell.imageViewColctn.clipsToBounds = true
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(StepThreeShareFoodVC.deleteButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    // MARK: Delete Button Action:
    func deleteButtonAction(_ sender: UIButton!)
    {
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
            
                print("After JsonString: \(self.responseString)")
                //print("after deleted Array \(self.imagPathArray)")
                //print(self.imagPathArray.count)
            
                // self.ImageDeleteAPImethod ()
            }
            
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
                    print(responceDic)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //AFWrapperClass.alert(Constants.applicationName, message: "", view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        var message = String()
         if (nameTextFieds.text?.isEmpty)!
        {
            message = "Please enter FoodShare name"
        }
        else if ((descriptionTextView.text?.isEmpty)! || descriptionTextView.text! == "Enter your text here..")
        {
            message = "Please enter description"
        }
        else if (quantityTF.text?.isEmpty)!
        {
            message = "Please enter quantity"
        }
         else if (timeExprTF.text?.isEmpty)!
         {
            message = "Please enter expire time"
         }
        else if (imagPathArray.count == 0)
        {
            message = "Please choose FoodShare images"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
            
        }else{
            
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "StepFourFoodShareVC") as? StepFourFoodShareVC
            self.navigationController?.pushViewController(myVC!, animated: false)
           
            myVC?.mealtitle = nameTextFieds.text!
            myVC?.categoryStr = categoryStr
            myVC?.subCategoryStr = subCategoryStr
            myVC?.mealDescription = descriptionTextView.text!
            myVC?.mealQuantity = quantityTF.text!
            myVC?.hoursHidden = timeExprTF.text!
            myVC?.imageString = self.responseString

        }
    }
    
    
    
    
    
    // MARK: TextView Delegates:
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
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
        
        
        _ = self.navigationController?.popViewController(animated: false)
        
    }

    
    
    
    
    
    
    
    @IBAction func nearFoodbankClicked(_ sender: UIButton)
    {
        foodBankView.isHidden=false
        myLoctnView.isHidden=true
        
        fdBnkNearHightConstrnt.constant = 112
        searchFoodbankHeightconstrnt.constant  = 0
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 0
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
    // MARK: I am deliver to foodbank:
    
    
    @IBAction func IamDeliverFoodbankClicked(_ sender: UIButton)
    {
        if StrEditMode == "1"
        {
            self.straddress = ""
            
            checklat = 0.0
            checklong = 0.0
            
            searchFDBnkTF.text = ""
            strfoodbankname = ""
        }
        
        strStatus="0"
        radioBtnStringChk = "FoodBankNearBy"
        
        foodBankView.isHidden=false
        myLoctnView.isHidden=true
        
        fdBnkNearHightConstrnt.constant = 142
        searchFoodbankHeightconstrnt.constant  = 30
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 0
        
        
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
     // MARK: Volunteers butt action:
    
    @IBAction func VolunteerneedbuttAction(_ sender: Any)
    {
        strStatus="1"
        radioBtnStringChk = "FromMyLocation"
        
        foodBankView.isHidden=false
        myLoctnView.isHidden=true
        
        fdBnkNearHightConstrnt.constant = 172
        searchFoodbankHeightconstrnt.constant  = 30
        volunteersConstraint.constant = 30
        collectfrommylocconstrain.constant = 0
        
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
    
    @IBAction func VolunteerneedButtClicked(_ sender: Any)
    {
        strStatus="1"
        radioBtnStringChk = "FromMyLocation"
        
        foodBankView.isHidden=false
        myLoctnView.isHidden=true
        
        fdBnkNearHightConstrnt.constant = 172
        searchFoodbankHeightconstrnt.constant  = 30
        volunteersConstraint.constant = 30
        collectfrommylocconstrain.constant = 0
        
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
    @IBAction func CollectMylocationClicked(_ sender: UIButton)
    {
        strStatus="2"
        radioBtnStringChk = "FromMyLocation2"
        
        foodBankView.isHidden=true
        myLoctnView.isHidden=false
        
        fdBnkNearHightConstrnt.constant = 0
        searchFoodbankHeightconstrnt.constant  = 0
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 30
        
        
        foodBankBrn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    
    
    
    
    @IBAction func foodbanklistClicked(_ sender: UIButton)
    {
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=&lat=\(InitialLatitude)&long=\(InitialLongitude)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchFoodbank",params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
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
        forgotlab.text="Select FoodBank"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView2.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerView2.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(StepThreeShareFoodVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(StepThreeShareFoodVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
    
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
        
        self.arrChildCategory.removeAllObjects()
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
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
        let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(InitialLatitude)&long=\(InitialLongitude)"
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
        
        
        
        
        
//        if searchResults.count != 0 {
//            self.searchResults.removeAllObjects()
//            volunterFbTblView.tag = 1
//        }
//        for i in 0..<arrChildCategory.count {
//            // [searchResults removeAllObjects];
//            let string: String = (self.arrChildCategory.object(at: i) as! NSDictionary).value(forKey: "title") as! String
//            let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
//            if rangeValue.length > 0
//            {
//                volunterFbTblView.tag = 2
//                searchResults.add(arrChildCategory[i])
//            }
//            else
//            {
//                
//            }
//        }
//        volunterFbTblView.reloadData()
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
        //    Distancelab.text =  String(format: "%@ Kms ",((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? NSNumber)!)
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
            searchFDBnkTF.text = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            strfoodbankname = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString
            strFoodbankId = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! NSString
            straddress = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as! NSString
            
          //  currentLatitude = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
          //  currentLongitude = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "long") as! String)!
            
            checklat = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            checklong = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "long") as! String)!
            
            popview2.isHidden=true
            footerView2.isHidden=true
            
            self.arrChildCategory.removeAllObjects()
            self.searchResults.removeAllObjects()
            volunterFbTblView.removeFromSuperview()
        }
        else
        {
            searchFDBnkTF.text = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            strfoodbankname = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! NSString
            strFoodbankId = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! NSString
            straddress = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as! NSString
            
         //   currentLatitude = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
        //    currentLongitude = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "long") as! String)!
            
            checklat = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            checklong = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "long") as! String)!
            
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
                let params = "api_key=\(strkey)&search=\(encodeUrl)&lat=\(InitialLatitude)&long=\(InitialLongitude)&page=\(self.strpage)"
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
    
    
    
    @IBAction func VolunteersaddressACTION(_ sender: Any)
    {
         locationView()
    }
    
    
    @IBAction func VolunteersaddressClicked(_ sender: Any)
    {
        
        locationView()
    }
    
    
    
    @IBAction func MylocationClicked(_ sender: UIButton)
    {
        
        locationView()
    }
    
    
    
    
    func locationView()
    {
        // tabBarController?.tabBar.isHidden=true
        
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
        crossbutt.addTarget(self, action: #selector(StepThreeShareFoodVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(StepThreeShareFoodVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
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
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.text = self.searchLoctnTF.text!
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(StepThreeShareFoodVC.locationButtonAction2(_:)), for: UIControlEvents.touchUpInside)
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
        Uselocationbutt.addTarget(self, action: #selector(StepThreeShareFoodVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        locatemebutt.addTarget(self, action: #selector(StepThreeShareFoodVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        NotifyMe.addSubview(locatemebutt)
    }
    
    
    
    func CloseButtonAction2(_ sender: UIButton!)
    {
        //tabBarController?.tabBar.isHidden=false
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
    
    
    // MARK: Finish Button Action:
    
    @IBAction func finishbuttAction(_ sender: UIButton)
    {
        
        var message = String()
        if (nameTextFieds.text?.isEmpty)!
        {
            message = "Please enter FoodShare name"
        }
        else if ((descriptionTextView.text?.isEmpty)! || descriptionTextView.text! == "Enter your text here..")
        {
            message = "Please enter description"
        }
        else if (quantityTF.text?.isEmpty)!
        {
            message = "Please enter quantity"
        }
        else if (timeExprTF.text?.isEmpty)!
        {
            message = "Please enter expire time"
        }
        else if (imagPathArray.count == 0)
        {
            message = "Please choose atleast one food share Image"
        }
        else if (radioBtnStringChk == "nocheck")
        {
            message = "Please select any one to share your food"
        }
        else if (radioBtnStringChk == "FoodBankNearBy")
        {
            if (searchFDBnkTF.text?.isEmpty)!
            {
                message = "Please Select Foodbank"
            }
        }
        else if (radioBtnStringChk == "FromMyLocation")
        {
            if (searchFDBnkTF.text?.isEmpty)!
            {
                message = "Please Select Foodbank"
            }
            else if (searchVolunteerTF.text?.isEmpty)!
            {
                message = "Please Select location Volunteers need to collect it"
            }
        }
        else if (radioBtnStringChk == "FromMyLocation2")
        {
            if (searchLoctnTF.text?.isEmpty)!
            {
                message = "Please Select location to contact"
            }
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
            if strStatus == "0"
            {
              //  self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(nameTextFieds.text!)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(descriptionTextView.text!)&no_of_meal_hidden=\(quantityTF.text!)&hours_hidden=\(timeExprTF.text!)&share_meal_image=\(self.responseString)&lat=\(checklat)&longt=\(checklong)&share_with=\(strStatus)&food_bankid=\(strFoodbankId)&address=\(straddress)")
                
                let strlat = "\(checklat)"
                let strlong = "\(checklong)"
                
                
                var baseURL = String()
                if StrEditMode == "1"
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"updateFoodsharing")
                }
                else
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"addFoodsharing")
                }
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                if StrEditMode == "1"
                {
                    PostDataValus.setValue(StrFoodShareId, forKey: "foodsharing_id")
                }
                else
                {
                    PostDataValus.setValue(strUserID, forKey: "user_id")
                }
                PostDataValus.setValue(nameTextFieds.text!, forKey: "title")
                PostDataValus.setValue(descriptionTextView.text!, forKey: "desc")
                PostDataValus.setValue(categoryStr, forKey: "food_category_id")
                PostDataValus.setValue(subCategoryStr, forKey: "food_type_id")
                PostDataValus.setValue(quantityTF.text!, forKey: "quantity")
                PostDataValus.setValue(timeExprTF.text!, forKey: "expiration_time")
                PostDataValus.setValue(straddress, forKey: "address")
                PostDataValus.setValue(strlat, forKey: "lat")
                PostDataValus.setValue(strlong, forKey: "long")
                PostDataValus.setValue(strFoodbankId, forKey: "food_bank_id")
                PostDataValus.setValue("delivery", forKey: "delivery_mode")
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
                
                self.fodbankshareMealMethod(baseURL: baseURL , params: jsonStringValues )
                
            }
            else if strStatus == "1"
            {
               // self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(nameTextFieds.text!)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(descriptionTextView.text!)&no_of_meal_hidden=\(quantityTF.text!)&hours_hidden=\(timeExprTF.text!)&share_meal_image=\(self.responseString)&lat=\(currentLatitude)&longt=\(currentLongitude)&share_with=\(strStatus)&food_bankid=\(strFoodbankId)&address=\(straddress2)")
                
                let strlat = "\(currentLatitude)"
                let strlong = "\(currentLongitude)"
                
                var baseURL = String()
                if StrEditMode == "1"
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"updateFoodsharing")
                }
                else
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"addFoodsharing")
                }
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                if StrEditMode == "1"
                {
                    PostDataValus.setValue(StrFoodShareId, forKey: "foodsharing_id")
                }
                else
                {
                    PostDataValus.setValue(strUserID, forKey: "user_id")
                }
                PostDataValus.setValue(nameTextFieds.text!, forKey: "title")
                PostDataValus.setValue(descriptionTextView.text!, forKey: "desc")
                PostDataValus.setValue(categoryStr, forKey: "food_category_id")
                PostDataValus.setValue(subCategoryStr, forKey: "food_type_id")
                PostDataValus.setValue(quantityTF.text!, forKey: "quantity")
                PostDataValus.setValue(timeExprTF.text!, forKey: "expiration_time")
                PostDataValus.setValue(straddress2, forKey: "address")
                PostDataValus.setValue(strlat, forKey: "lat")
                PostDataValus.setValue(strlong, forKey: "long")
                PostDataValus.setValue(strFoodbankId, forKey: "food_bank_id")
                PostDataValus.setValue("collection", forKey: "delivery_mode")
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
                
                self.fodbankshareMealMethod(baseURL: baseURL , params: jsonStringValues )
                
                
            }
            else
            {
              //  self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(nameTextFieds.text!)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(descriptionTextView.text!)&no_of_meal_hidden=\(quantityTF.text!)&hours_hidden=\(timeExprTF.text!)&share_meal_image=\(self.responseString)&lat=\(currentLatitude)&longt=\(currentLongitude)&share_with=\(strStatus)&address=\(straddress2)")
                
                let strlat = "\(currentLatitude)"
                let strlong = "\(currentLongitude)"
                
                var baseURL = String()
                if StrEditMode == "1"
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"updateFoodsharing")
                }
                else
                {
                    baseURL = String(format:"%@%@",Constants.mainURL,"addFoodsharing")
                }
                let strkey = Constants.ApiKey
                
                let PostDataValus = NSMutableDictionary()
                PostDataValus.setValue(strkey, forKey: "api_key")
                if StrEditMode == "1"
                {
                    PostDataValus.setValue(StrFoodShareId, forKey: "foodsharing_id")
                }
                else
                {
                    PostDataValus.setValue(strUserID, forKey: "user_id")
                }
                PostDataValus.setValue(nameTextFieds.text!, forKey: "title")
                PostDataValus.setValue(descriptionTextView.text!, forKey: "desc")
                PostDataValus.setValue(categoryStr, forKey: "food_category_id")
                PostDataValus.setValue(subCategoryStr, forKey: "food_type_id")
                PostDataValus.setValue(quantityTF.text!, forKey: "quantity")
                PostDataValus.setValue(timeExprTF.text!, forKey: "expiration_time")
                PostDataValus.setValue(straddress2, forKey: "address")
                PostDataValus.setValue(strlat, forKey: "lat")
                PostDataValus.setValue(strlong, forKey: "long")
                PostDataValus.setValue("", forKey: "food_bank_id")
                PostDataValus.setValue("collection", forKey: "delivery_mode")
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
                
                self.fodbankshareMealMethod(baseURL: baseURL , params: jsonStringValues )
                
            }
        }
 
    }
    
    
    
    // MARK: Finish Button Action:
    @IBAction func finishButtonAction(_ sender: Any)
    {
        
    }
    
    
    
    
    @objc private   func fodbankshareMealMethod (baseURL:String , params: String)
    {
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                    //                    let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareFoodVC") as! ShareFoodVC
                    //                    self.navigationController?.pushViewController(proVC, animated: true)
                    
                    if self.StrEditMode == "1"
                    {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
                        for aViewController in viewControllers {
                            if(aViewController is MyFoodShareVC){
                                self.navigationController!.popToViewController(aViewController, animated: true);
                            }
                        }
                    }
                    else
                    {
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                   
                    
                    //                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController
                    //                    self.navigationController?.pushViewController(myVC!, animated: true)
                    //
                    //                    myVC?.selectedIndex=2
                    
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP not verify.", view: self)
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func previousbuttAction(_ sender: UIButton)
    {
          _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func previousButtonAction(_ sender: Any)
    {
      
    }
    
    
    
    
    // MARK: Get Current location Name And Lat, Long Delegates
    func setUsersClosestCity()
    {
        //        let geoCoder = CLGeocoder()
        //        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        //        geoCoder.reverseGeocodeLocation(location)
        //        {
        //            (placemarks, error) -> Void in
        //            if ((error) != nil)
        //            {
        //                self.searchLoctnTF.text! = ""
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
        //                    self.searchLoctnTF.text! = locationNameFul
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
                
                self.straddress2 = formattedAddress.joined(separator: ", ") as NSString
                self.searchLoctnTF.text! = formattedAddress.joined(separator: ", ")
                self.searchVolunteerTF.text! =  formattedAddress.joined(separator: ", ")
            }
            
        })
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension StepThreeShareFoodVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        searchLoctnTF.text! = place.name as String
        //  geoCodeUsingAddress(address: place.name as NSString)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
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


extension StepThreeShareFoodVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView.delegate = self;
        
        currentLatitude=position.target.latitude
        currentLongitude=position.target.longitude
        
        
        self.locationlab.text! = "Featching Address..."
        self.searchLoctnTF.text! = "Featching Address..."
        self.searchVolunteerTF.text! = "Featching Address..."
        
        
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
        print(position)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            self.locationlab.text! = "Unable to Find Address for Location"
            self.searchLoctnTF.text! = "Unable to Find Address for Location"
            self.searchVolunteerTF.text! = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.locationlab.text! = placemark.compactAddress!
                self.searchLoctnTF.text! = placemark.compactAddress!
                self.searchVolunteerTF.text! = placemark.compactAddress!
                straddress2 = placemark.compactAddress! as NSString
                
            } else {
                self.locationlab.text! = "No Matching Addresses Found"
                self.searchLoctnTF.text! = "No Matching Addresses Found"
                self.searchVolunteerTF.text! = "No Matching Addresses Found"
            }
        }
    }
}



extension StepThreeShareFoodVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        
        locationlab.text = place.formatted_address
        self.searchLoctnTF.text! = place.formatted_address
        self.searchVolunteerTF.text! = place.formatted_address
        straddress2 = place.formatted_address as NSString
        currentLatitude=place.location.coordinate.latitude
        currentLongitude=place.location.coordinate.longitude
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        mapView2.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        self.marker.icon = UIImage(named: "Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.title = place.formatted_address
        mapView.reloadInputViews()
        
    }
}



