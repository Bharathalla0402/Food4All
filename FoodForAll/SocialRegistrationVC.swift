//
//  SocialRegistrationVC.swift
//  FoodForAll
//
//  Created by amit on 5/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class SocialRegistrationVC: UIViewController,UITextFieldDelegate,HMDiallingCodeDelegate,CLLocationManagerDelegate
{

    
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var phoneTF: ACFloatingTextfield!
    @IBOutlet weak var countryCodeTF: ACFloatingTextfield!
    @IBOutlet weak var titleLab: UILabel!
    
    var plusLabel = ACFloatingTextfield()
    
    
    var emailChkStr = String()
    var socialID = String()
    var emailGet = String()
    var nameGet = String()
    var socialRegistaerStr = String()
    var method = String()
    var StrName = String()
    var StrName2 = String()
    var socialApi = String()
    var CountryPicker = UIButton()
    
    var dataDic = NSDictionary()
    
    var diallingCode = HMDiallingCode()
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var myString = String()
    var DeviceToken=String()
    var imgURL = NSURL()
    
    var popview = UIView()
    var footerView = UIView()
    var termsView = UIWebView()
    var htmlstring=String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(nameGet)
        print(socialID)
        print(imgURL)
        
//        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
//        for cookie in cookieJar.cookies! as [HTTPCookie]{
//            NSLog("cookie.domain = %@", cookie.domain)
//            
//            if cookie.domain == "www.instagram.com" ||
//                cookie.domain == "api.instagram.com"{
//                
//                cookieJar.deleteCookie(cookie)
//            }
//        }

        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = ""
        }
        
        myString = "0"
        StrName2=""
        emailTF.text! = emailGet
        nameTF.text! = nameGet
        if emailChkStr == "YES" {
            emailTF.isEnabled = false
        }else{
            emailTF.isEnabled = true
        }
        if socialRegistaerStr == "FaceBook"
        {
            titleLab.text="Facebook Registration"
            method = "facebook"
            socialApi = "facebook_id"
        }
        else if socialRegistaerStr == "Twitter"
        {
             titleLab.text="Twitter Registration"
             method = "twitter"
             socialApi = "twitter_id"
        }
        else if socialRegistaerStr == "Google"
        {
             titleLab.text="Google Registration"
             method = "google_plus"
             socialApi = "google_id"
        }
        else if socialRegistaerStr == "Instagram"
        {
            titleLab.text="Instagram Registration"
            method = "instagram"
            socialApi = "instagram_id"
        }
        else if socialRegistaerStr == "Pinterest"
        {
            titleLab.text="Pinterest Registration"
            method = "pinterest"
            socialApi = "pinterest_id"
        }
        
        countryCodeTF.isUserInteractionEnabled=false
        
        self.diallingCode.delegate=self;
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
//        self.termsmethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=termsandcondition")
    }
    
    @objc private  func termsmethod (baseURL:String , params: String)
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
                    
                    self.htmlstring = (responceDic.object(forKey: "terms") as? NSString)! as String
                    
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

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden=true
        
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            
            locationManager.requestWhenInUseAuthorization()
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            
        }else{
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        if myString == "0" {
            self.setUsersClosestCity()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations.last!
        currentLatitude = (userLocation.coordinate.latitude)
        currentLongitude = (userLocation.coordinate.longitude)
        //  print(currentLatitude,currentLongitude)
        //locationManager.stopUpdatingHeading()
    }
    
    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            if ((error) != nil)
            {
                self.countryCodeTF.text! = ""
                print("Locarion Error :\((error?.localizedDescription)! as String)")
                //     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
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
    


 
   // MARK: Send OTP Button Action :
    @IBAction func sendOTPbtnAction(_ sender: Any) {
        
        var message = String()
        
        if (emailTF.text?.isEmpty)!
        {
            message = "Please enter email"
        }
        else if (countryCodeTF.text?.isEmpty)!
        {
            message = "Please choose country code"
        }
        else if (phoneTF.text?.isEmpty)!
        {
            message = "Please enter Phone number"
        }
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
            
        }else{
            self.socialRegistarationMethod()
        }

        
    }
    
    
    func socialRegistarationMethod () -> Void
    {
        var Ccode=String()
        Ccode = countryCodeTF.text!
        Ccode = Ccode.replacingOccurrences(of: "+", with: "%2B")
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        StrName = (nameTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        
        //url to string
        var string = "\(imgURL)"
        string = string.replacingOccurrences(of: "&", with: "%26")
        string = string.replacingOccurrences(of: "+", with: "%2B")
        
        let params = "method=\(method)&\(socialApi)=\(socialID)&first_name=\(StrName)&email=\(emailTF.text!)&phone_no=\(phoneTF.text!)&gcm_id=\(DeviceToken)&country_code=\(Ccode)&device_type=ios&image=\(string)"

        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                    self.navigationController?.pushViewController(foodVC!, animated: true)
                    
                    
                    let id: NSNumber   = (self.dataDic.value(forKey: "id") as? NSNumber!)!
                    
                    foodVC?.UsearID = String(describing: id)
                    
                    print(id )

                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "User already exists", view: self)
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
        
    }
    

    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func bavkButtonAction(_ sender: Any)
    {
       // _ = self.navigationController?.popViewController(animated: true)
        
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC
        self.navigationController?.pushViewController(foodVC!, animated: true)
    }
    
    @IBAction func CountryPickerClicked(_ sender: Any)
    {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.diallingCode.getForCountry(code!)
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Country picker Button Action :
    func CountryPickerButtonAction(_ sender: UIButton!)
    {
       
    }
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        
        print(diallingCode)
        self.countryCodeTF.text! = String(format: "+%@",diallingCode)
        
        myString = "1"
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
