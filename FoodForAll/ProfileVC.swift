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

class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,HMDiallingCodeDelegate,UITextFieldDelegate
{

    
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


    lazy var geocoder = CLGeocoder()
    
    
    var userData = NSDictionary()
    
    @IBOutlet weak var profileBackgrndView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var UserName: ACFloatingTextfield!
    @IBOutlet weak var userEmail: ACFloatingTextfield!
    @IBOutlet weak var userMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var userAddress: ACFloatingTextfield!
    @IBOutlet weak var countryCode: ACFloatingTextfield!
    var myArray = NSDictionary()
    var strUserID = NSString()
    var imgFolderAry = NSMutableArray()
    var responseString = String()
    
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         searchViewController.delegate=self
        
        imagePicker.delegate = self
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        print(myArray)
        UserName.text=myArray.value(forKey: "first_name") as! String?
        userEmail.text=myArray.value(forKey: "email") as! String?
        strUserID=myArray.value(forKey: "id") as! NSString
        let string1 = myArray.value(forKey: "country_code") as! NSString
        countryCode.text = string1 as String
        let string3 = myArray.value(forKey: "phone_no") as! NSString
        userMobileNumber.text = string3 as String
        let stringUrl = myArray.value(forKey: "image") as! NSString
        let url = URL.init(string:stringUrl as String)
        profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
        userAddress.text=myArray.value(forKey: "address") as! String?
       //profileBackgrndView.backgroundColor = UIColor(patternImage: UIImage(named: "profile-bg")!)
        
        // Do any additional setup after loading the view.
        
        myString = "0"
        self.diallingCode.delegate=self;
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
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
        
       // self.setUsersClosestCity2()
        
        self.getProfileAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getProfile&user_id=\(strUserID)")
    }

    
    
    @objc private  func getProfileAPIMethod (baseURL:String , params: String)
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
                    self.userData = (responceDic.object(forKey: "profileDetail") as? NSDictionary)!
                   
                    
                   self.userAddress.text = self.userData.object(forKey: "address") as! String?
                    
                    let stringUrl = self.userData.object(forKey: "image") as! String?
                    let url = URL.init(string:stringUrl! as String)
                    self.profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
                    
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
    
    

    
    
    
    
    
    
    
    @IBAction func ProfileImageClicked(_ sender: Any)
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
        profileImage.image=currentSelectedImage
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Upload image Method API:
    
    func uploadImageAPIMethod () -> Void
    {
        
        var message = String()
        
        if (UserName.text?.isEmpty)!
        {
            message = "Please enter name"
        }
        else if !AFWrapperClass.isValidEmail(userEmail.text!)
        {
            message = "Please enter valid Email"
        }
        else if (countryCode.text?.isEmpty)!
        {
            message = "Please choose country code"
        }
        else if (userMobileNumber.text?.isEmpty)!
        {
            message = "Please enter Phone number"
        }
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }else
        {
            let alert = UIAlertController(title: "Food4All", message: "Are You Sure Want to Update Profile", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Update", style: UIAlertActionStyle.default,handler: { action in
                self.Updatemethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func Updatemethod()
    {
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
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
            
            print(params)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                
                DispatchQueue.main.async {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let responceDic:NSDictionary = jsonDic as NSDictionary
                    print(responceDic)
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
                let image = self.currentSelectedImage
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
                        print(Progress())
                        if response.result.isSuccess
                            //print(response.result.value as! NSDictionary)
                        {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            
                            let dataDic : NSDictionary = response.result.value as! NSDictionary
                            if (dataDic.object(forKey: "responseCode") as! NSNumber) == 200
                            {
                                
                                let UserResponse:NSDictionary = dataDic.object(forKey: "profileDetail")  as! NSDictionary
                                UserDefaults.standard.set(UserResponse, forKey: "UserId")
                                
                                let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                                self.navigationController?.pushViewController(foodVC!, animated: true)
                                
                                
                                
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
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                    print(error.localizedDescription)
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
        print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
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
        
        print(params);
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    UserDefaults.standard.set(self.dataDic, forKey: "UserId")
                    
                    self.popview2.isHidden=true
                    self.footerView2.isHidden=true
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(foodVC!, animated: true)
                    
                
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
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
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
        locationManager.requestAlwaysAuthorization()
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
                    print(placeMark.isoCountryCode! as String)
                    
                    let iosCode = placeMark.isoCountryCode! as String
                    
                    print(iosCode)
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
        
        print(diallingCode)
        self.countryCode.text! = String(format: "+%@",diallingCode)
        
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
        print(position)
        
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

