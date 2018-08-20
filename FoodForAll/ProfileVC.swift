//
//  ProfileVC.swift
//  FoodForAll
//
//  Created by amit on 4/26/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import GoogleMaps
import GooglePlaces
import CoreLocation

class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,HMDiallingCodeDelegate,UITextFieldDelegate,SecondDelegate
{

      var classObject = ChatingDetailsViewController()
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
    
    var popview = UIView()
    var footerView = UIView()
    var locationlab = UILabel()
    
    var dataDic = NSDictionary()
    var popview2 = UIView()
    var footerView2 = UIView()
    var CancelButton = UIButton()
    var DoneButton = UIButton()
    var ResendButton = UIButton()
    var forgotPassWordTF = ACFloatingTextfield()
    
    var myString = String()
    var diallingCode = HMDiallingCode()
    var strApiCheck = String()

    lazy var geocoder = CLGeocoder()
    
    
    var userData = NSDictionary()
    
    @IBOutlet weak var profileBackgrndView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var UserName: ACFloatingTextfield!
    @IBOutlet weak var LastName: ACFloatingTextfield!
    @IBOutlet weak var userEmail: ACFloatingTextfield!
    @IBOutlet weak var userMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var userAddress: ACFloatingTextfield!
    @IBOutlet weak var countryCode: ACFloatingTextfield!
    var myArray = NSDictionary()
    var strUserID = NSString()
    var imgFolderAry = NSMutableArray()
    var responseString = String()
    var StrImageUrl = String()
    
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var popview4 = UIView()
    var footerView4 = UIView()
    var CropperView = BABCropperView()
    var CroppedImageView = UIImageView()
    var cropSelectedImage = UIImage()
    
    var popview5 = UIView()
    var footerView5 = UIView()
    var CancelButton5 = UIButton()
    var DoneButton5 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classObject.delegate = self
        let data2 = UserDefaults.standard.object(forKey: "UserId") as? Data
        self.myArray = (NSKeyedUnarchiver.unarchiveObject(with: data2!) as? NSDictionary)!
        self.strUserID=self.myArray.value(forKey: "id") as! NSString
        
         self.getProfileAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getProfile&user_id=\(strUserID)")
        
        self.UserName.text = ""
        self.userEmail.text = ""
        self.LastName.text = ""
        self.userAddress.text = ""
        self.countryCode.text = ""
        self.userMobileNumber.text = ""
        countryCode.isHidden = true
        
         searchViewController.delegate=self
        
        imagePicker.delegate = self
      
        // Do any additional setup after loading the view.
        
        myString = "0"
        self.diallingCode.delegate=self;
        
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
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
                firstLongitude = long
            }else {
                
            }
           // currentLatitude = (locationManager.location?.coordinate.latitude)!
           // currentLongitude = (locationManager.location?.coordinate.longitude)!
          //  firstLatitude = (locationManager.location?.coordinate.latitude)!
          //  firstLongitude = (locationManager.location?.coordinate.longitude)!
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
        
       // self.setUsersClosestCity2()
        
       
        
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
        
        self.UserName.inputAccessoryView = doneToolbar
        self.userEmail.inputAccessoryView = doneToolbar
        self.userAddress.inputAccessoryView = doneToolbar
        self.countryCode.inputAccessoryView = doneToolbar
        self.userMobileNumber.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }

    
    
    @objc private  func getProfileAPIMethod (baseURL:String , params: String)
    {
      //  print(params);
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(strUserID)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"userProfile",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    let UserResponse:NSDictionary = responceDic.object(forKey: "profileDetail")  as! NSDictionary
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: UserResponse)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    
                    
                    
                    let data2 = UserDefaults.standard.object(forKey: "UserId") as? Data
                    self.myArray = (NSKeyedUnarchiver.unarchiveObject(with: data2!) as? NSDictionary)!
                    
                    self.UserName.text=self.myArray.value(forKey: "first_name") as? String ?? ""
                    self.LastName.text=self.myArray.value(forKey: "last_name") as? String ?? ""
                    self.userEmail.text=self.myArray.value(forKey: "email") as? String ?? ""
                    self.strUserID=self.myArray.value(forKey: "id") as! NSString
                    // let string1 = myArray.value(forKey: "country_code") as! NSString
                    //  countryCode.text = string1 as String
                    let string3 = self.myArray.value(forKey: "phone_no") as? NSString ?? ""
                    self.userMobileNumber.text = string3 as String
                  //  self.StrImageUrl = self.myArray.value(forKey: "image") as? String ?? ""
                    let stringUrl = self.myArray.value(forKey: "image") as! NSString
                    let url = URL.init(string:stringUrl as String)
                    print(url ?? "")
                    self.profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
                    self.userAddress.text=self.myArray.value(forKey: "address") as! String?
                    //profileBackgrndView.backgroundColor = UIColor(patternImage: UIImage(named: "profile-bg")!)
                    
                    let str1 = self.myArray.value(forKey: "lat") as? String ?? ""
                    let str2 = self.myArray.value(forKey: "long") as? String ?? ""
                    
                    if str1 == "" || str2 == ""
                    {
                        
                    }
                    else
                    {
                      //  self.currentLatitude = Double(self.myArray.value(forKey: "lat") as? String ?? "")!
                      //  self.currentLongitude = Double(self.myArray.value(forKey: "long") as? String ?? "")!
                    }
                   // print(self.currentLatitude)
                   // print(self.currentLongitude)
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
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
        //
        
        
        
        
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//             //   print(responceDic)
//                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
//                {
//                    self.userData = (responceDic.object(forKey: "profileDetail") as? NSDictionary)!
//
//                   self.userAddress.text = self.userData.object(forKey: "address") as! String?
//
//                    let stringUrl = self.userData.object(forKey: "image") as! String?
//                    let url = URL.init(string:stringUrl! as String)
//                    self.profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
//
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
    
    

    
    
    
    
    
    
    
    @IBAction func ProfileImageClicked(_ sender: Any)
    {
        self.CameraView()
    }
    
    func CameraView ()
    {
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
    
    
//    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
//        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        return newImage!
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      //  currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: CGFloat(40), height: CGFloat(40)))
        
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
        
        CropperView.cropSize = CGSize(width: 300, height: 300)
        
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
            self.profileImage.image = croppedImage!
            
            self.classObject.next2(croppedImage)
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
            
            self.StrImageUrl = responseToken.value(forKey: "path") as? String ?? ""
          
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
    
    
    
     //MARK: Add Mobile Number
    
    @IBAction func AddMobileClicked(_ sender: UIButton)
    {
        self.AddMobileNumber()
    }
    
    
    func AddMobileNumber()
    {
        
        popview5.isHidden=false
        footerView5.isHidden=false
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
        
        popview5.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview5.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview5)
        
        footerView5.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView5.backgroundColor = UIColor.white
        popview5.addSubview(footerView5)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView5.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Mobile Number"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView5.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView5.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView5.addSubview(labUnderline)
        
        
        
        forgotPassWordTF = ACFloatingTextfield()
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:250, height:45)
        forgotPassWordTF.delegate = self
        forgotPassWordTF.placeholder = "Mobile Number"
        forgotPassWordTF.placeHolderColor=UIColor.lightGray
        forgotPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.lineColor=UIColor.lightGray
        forgotPassWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.keyboardType=UIKeyboardType.emailAddress
        forgotPassWordTF.autocorrectionType = .no
        forgotPassWordTF.autocapitalizationType = .none
        forgotPassWordTF.spellCheckingType = .no
        footerView5.addSubview(forgotPassWordTF)
        
        
        CancelButton5.frame = CGRect(x:10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView5.frame.size.width/2-15, height:40)
        CancelButton5.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton5.setTitle("Cancel", for: .normal)
        CancelButton5.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton5.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton5.titleLabel?.textAlignment = .center
        CancelButton5.addTarget(self, action: #selector(self.cancelButtonAction4(_:)), for: UIControlEvents.touchUpInside)
        footerView5.addSubview(CancelButton5)
        
        
        DoneButton5.frame = CGRect(x:CancelButton5.frame.size.width+CancelButton5.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView5.frame.size.width/2-15, height:40)
        DoneButton5.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton5.setTitle("Done", for: .normal)
        DoneButton5.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton5.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton5.titleLabel?.textAlignment = .center
        DoneButton5.addTarget(self, action: #selector(self.AddMobileDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView5.addSubview(DoneButton5)
        
        self.forgotPassWordTF.text = ""
        
        self.addDoneButtonOnKeyboard6()
    }
    
    func addDoneButtonOnKeyboard6()
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
    func cancelButtonAction4(_ sender: UIButton!)
    {
        popview5.isHidden=true
        footerView5.isHidden=true
    }
    
    
    // MARK: Done Button Action :
    func AddMobileDoneButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (forgotPassWordTF.text?.isEmpty)!
        {
            message = "Please enter Mobile Number"
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            
            let str: String = forgotPassWordTF.text!
            if str.isNumber == true
            {
                strApiCheck = "3"
                let vc = SLCountryPickerViewController()
                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
                    self.diallingCode.getForCountry(code!)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Mobile Number", view: self)
            }
        }
        
    }
    
    
    func AddMobileapi()
    {
        
        let str1 = countryCode.text
        let str2 = forgotPassWordTF.text
        let usermobile = str1!+str2!
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"addPhoneNo")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(self.strUserID, forKey: "user_id")
        PostDataValus.setValue(usermobile, forKey: "phone_no")
        
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
        
        
        //  print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    // self.strUserId = responceDic.object(forKey: "user_id")  as! String
                    
                    self.popview5.isHidden=true
                    self.footerView5.isHidden=true
                    
                    let str1 = self.countryCode.text
                    let str2 = self.forgotPassWordTF.text
                    let str = str1!+str2!
                    self.userMobileNumber.text = str
                    
                  //  self.VerifyView()
                    
                   // let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                   // foodVC?.UsearID = String(describing: self.strUserID)
                   // self.navigationController?.pushViewController(foodVC!, animated: true)
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
    

    
    
    //MARK: Upload image Method API:
    
    func uploadImageAPIMethod () -> Void
    {
        
        var message = String()
        
        if (UserName.text?.isEmpty)!
        {
            message = "Please enter first name"
        }
        else if (LastName.text?.isEmpty)!
        {
            message = "Please enter last name"
        }
        else if (userEmail.text?.isEmpty)!
        {
            message = "Please enter email id"
        }
        else if !AFWrapperClass.isValidEmail(userEmail.text!)
        {
            message = "Please enter valid Email"
        }
       
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }else
        {
            let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Update Profile", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Update", style: UIAlertActionStyle.default,handler: { action in
//                self.strApiCheck = "1"
//                let vc = SLCountryPickerViewController()
//                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
//                    self.diallingCode.getForCountry(code!)
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
                self.Updatemethod2()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func Updatemethod2()
    {
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"updateProfile")
        let strkey = Constants.ApiKey
      //  let str1 = ""
       // let str2 = userMobileNumber.text
      //  let usermobile = str1!+str2!
        
        let strlat = "\(currentLatitude)"
        let strlong = "\(currentLongitude)"
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserID, forKey: "user_id")
        PostDataValus.setValue(UserName.text!, forKey: "first_name")
        PostDataValus.setValue(LastName.text!, forKey: "last_name")
        PostDataValus.setValue(userAddress.text!, forKey: "address")
        PostDataValus.setValue(strlat, forKey: "lat")
        PostDataValus.setValue(strlong, forKey: "long")
        PostDataValus.setValue(self.StrImageUrl, forKey: "image")
        PostDataValus.setValue(userEmail.text!, forKey: "email")
        PostDataValus.setValue(userMobileNumber.text, forKey: "phone_no")
        
        
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
                let responceDics:NSDictionary = jsonDic as NSDictionary
                print(responceDics)
                if (responceDics.object(forKey: "status") as! NSNumber) == 1
                {
                    let UserResponse:NSDictionary = responceDics.object(forKey: "profileDetail")  as! NSDictionary
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: UserResponse)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    let alert = UIAlertController(title: Constants.applicationName, message: responceDics.object(forKey: "responseMessage") as? String ?? "Profile has been updated", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertOKAction=UIAlertAction(title:"Ok", style: UIAlertActionStyle.default,handler: { action in
                                 _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    alert.addAction(alertOKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    
    
    func Updatemethod()
    {
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(self.cropSelectedImage, 1)
        if imageData == nil
        {
            var address=String()
            address = userAddress.text!
            address = address.replacingOccurrences(of: "+", with: "%2B")
            address = address.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            var StrName=String()
            StrName = (UserName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            
            
            let baseURL: String  = String(format:"%@",Constants.mainURL)
            let params = "method=updateProfile&id=\(strUserID)&first_name=\(StrName)&address=\(address)&lat=\(currentLatitude)&lon=\(currentLongitude)&email=\(userEmail.text!)&country_code=\(countryCode.text!)&phone=\(userMobileNumber.text!)"
            
           // print(params)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                   // print(responceDic)
                    if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                    {
                        _ = self.navigationController?.popViewController(animated: true)
                        
                        let UserResponse:NSDictionary = responceDic.object(forKey: "profileDetail")  as! NSDictionary
                        UserDefaults.standard.set(UserResponse, forKey: "UserId")
                        
                        var Message=String()
                        Message = responceDic.object(forKey: "responseMessage") as! String
                        
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                        
                    }
                    else if (responceDic.object(forKey: "responseCode") as! NSNumber) == 201
                    {
                        self.VerifyView()
                        
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
            
            var address=String()
            address = userAddress.text!
            address = address.replacingOccurrences(of: "+", with: "%2B")
            address = address.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            var StrName=String()
            StrName = (UserName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            
            let strlat = "\(currentLatitude)"
            let strlong = "\(currentLongitude)"
            
            let emailadd = userEmail.text!
            let counCode = countryCode.text!
            let PhoneNum = userMobileNumber.text!
            
            
            let parameters = ["method":"updateProfile","id":strUserID as String,"first_name":StrName as String,"address":address as String,"lat":strlat as String,"lon":strlong as String,"email":emailadd as String,"country_code":counCode as String,"phone":PhoneNum as String] as [String : String]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                let image = self.cropSelectedImage
                multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "image", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to:String(format: "%@",Constants.mainURL))
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                    })
                    upload.responseJSON { response in
                     //   print(Progress())
                        if response.result.isSuccess
                            //print(response.result.value as! NSDictionary)
                        {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            
                            let dataDic : NSDictionary = response.result.value as! NSDictionary
                            if (dataDic.object(forKey: "responseCode") as! NSNumber) == 200
                            {
                                
                                let UserResponse:NSDictionary = dataDic.object(forKey: "profileDetail")  as! NSDictionary
                                UserDefaults.standard.set(UserResponse, forKey: "UserId")
                                
                            //    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                          //      self.navigationController?.pushViewController(foodVC!, animated: true)
                                
                                self.navigationController?.popViewController(animated: true)
                                
                                var Message=String()
                                Message = dataDic.object(forKey: "responseMessage") as! String
                                
                                AFWrapperClass.svprogressHudDismiss(view: self)
                                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                                
                                
                            }
                            else if (dataDic.object(forKey: "responseCode") as! NSNumber) == 201
                            {
                                
                                self.VerifyView()
                            }
                            else
                            {
                                var Message=String()
                                Message = dataDic.object(forKey: "responseMessage") as! String
                                
                                AFWrapperClass.svprogressHudDismiss(view: self)
                                AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
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

    }
    
    
    // MARK: verify :
    func VerifyView ()
    {
        popview2.isHidden=false
        footerView2.isHidden=false
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
        
        popview2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview2.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview2)
        
        footerView2.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView2.backgroundColor = UIColor.white
        popview2.addSubview(footerView2)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView2.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="VERIFY ACCOUNT"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView2.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView2.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView2.addSubview(labUnderline)
        
        
        
        forgotPassWordTF = ACFloatingTextfield()
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:250, height:45)
        forgotPassWordTF.delegate = self
        forgotPassWordTF.placeholder = "Enter Your Verification Code"
        forgotPassWordTF.placeHolderColor=UIColor.lightGray
        forgotPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotPassWordTF.lineColor=UIColor.lightGray
        forgotPassWordTF.selectedLineColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotPassWordTF.autocorrectionType = UITextAutocorrectionType.no
        forgotPassWordTF.keyboardType=UIKeyboardType.numberPad
        footerView2.addSubview(forgotPassWordTF)
        
        
        CancelButton.frame = CGRect(x:6, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView2.frame.size.width/3-8, height:40)
        CancelButton.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton.titleLabel?.textAlignment = .center
        CancelButton.addTarget(self, action: #selector(ProfileVC.VerifycancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(CancelButton)
        
        
        DoneButton.frame = CGRect(x:CancelButton.frame.size.width+CancelButton.frame.origin.x+6, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView2.frame.size.width/3-8, height:40)
        DoneButton.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton.titleLabel?.textAlignment = .center
        DoneButton.addTarget(self, action: #selector(ProfileVC.VerifyDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(DoneButton)
        
        
        
        ResendButton.frame = CGRect(x:DoneButton.frame.size.width+DoneButton.frame.origin.x+6, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView2.frame.size.width/3-8, height:40)
        ResendButton.backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        ResendButton.setTitle("Resend", for: .normal)
        ResendButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        ResendButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ResendButton.titleLabel?.textAlignment = .center
        ResendButton.addTarget(self, action: #selector(ProfileVC.ResendButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(ResendButton)
        
        self.forgotPassWordTF.text = ""
        
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
    
    
   
    
    // MARK: Verify Cancel Button Action :
    func VerifycancelButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
    }
    
    @IBAction func ResendButtonAction(_ sender: Any)
    {
        self.ReverifyotpAPIMethod2(baseURL: String(format:"%@",Constants.mainURL) , params: "method=resendotp&user_id=\(strUserID)")
    }
    
    
    @objc private   func ReverifyotpAPIMethod2 (baseURL:String , params: String)
    {
     //   print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
              //  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
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

    // MARK: Done Button Action :
    func VerifyDoneButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (forgotPassWordTF.text?.isEmpty)!
        {
            message = "Please enter Verification Code"
        }
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }
        else
        {
            self.Veify2APIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=verifyotpUpdateProfile&otp=\(forgotPassWordTF.text!)&id=\(strUserID)")
        }
        
    }
    
    
    @objc private  func Veify2APIMethod (baseURL:String , params: String)
    {
        
       // print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
              //  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    UserDefaults.standard.set(self.dataDic, forKey: "UserId")
                    
                    self.popview2.isHidden=true
                    self.footerView2.isHidden=true
                    
                    //    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    //      self.navigationController?.pushViewController(foodVC!, animated: true)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                
                    var Message=String()
                    Message = "profile Updated Successfully"
                    
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


    
    
   
    @IBAction func UpdateProfileButtonClicked(_ sender: Any)
    {
        self.uploadImageAPIMethod()
    }
    
   
    
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        //    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        //      self.navigationController?.pushViewController(foodVC!, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddressButtClicked(_ sender: UIButton)
    {
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
        crossbutt.addTarget(self, action: #selector(ProfileVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(ProfileVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
       // locationlab.text = locationlab.text!
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(ProfileVC.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        Uselocationbutt.addTarget(self, action: #selector(ProfileVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        locatemebutt.addTarget(self, action: #selector(ProfileVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
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
        
        
        userAddress.text = locationlab.text
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
           // currentLatitude = (locationManager.location?.coordinate.latitude)!
          //  currentLongitude = (locationManager.location?.coordinate.longitude)!
          //  firstLatitude = (locationManager.location?.coordinate.latitude)!
          //  firstLongitude = (locationManager.location?.coordinate.longitude)!
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
    
    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity2()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            if ((error) != nil)
            {
                
            }
            else{
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.isoCountryCode != nil
                {
                  //  print(placeMark.isoCountryCode! as String)
                    
                    let iosCode = placeMark.isoCountryCode! as String
                    
                   // print(iosCode)
                    self.diallingCode.getForCountry(iosCode)
                }
            }
        }
    }

    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
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
                
                self.locationlab.text! = formattedAddress.joined(separator: ", ")
                
            }
            
        })
    }
    
    @IBAction func CountryCodeClicked(_ sender: UIButton)
    {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.diallingCode.getForCountry(code!)
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        
      //  print(diallingCode)
        self.countryCode.text! = String(format: "+%@",diallingCode)
        
        if strApiCheck == "1"
        {
            self.Updatemethod2()
        }
        else
        {
            self.AddMobileapi()
        }
        
        myString = "1"
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden=true
        
        
        if myString == "0" {
          //  self.setUsersClosestCity2()
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension ProfileVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView2.delegate = self;
        
        currentLatitude=position.target.latitude
        currentLongitude=position.target.longitude
        
       // self.locationTF.text! = "Featching Address..."
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
            print("Unable to Reverse Geocode Location (\(error))")
           // self.locationTF.text! = "Unable to Find Address for Location"
            locationlab.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
               // self.locationTF.text! = placemark.compactAddress!
                locationlab.text = placemark.compactAddress!
               // print(self.locationTF.text!)
            } else {
               // self.locationTF.text! = "No Matching Addresses Found"
                locationlab.text = "No Matching Addresses Found"
            }
        }
    }
}



extension ProfileVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
       // userAddress.text!=place.name
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

