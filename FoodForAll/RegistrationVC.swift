//
//  RegistrationVC.swift
//  FoodForAll
//
//  Created by amit on 4/24/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Fabric
import TwitterKit
import CoreLocation
import PinterestSDK
import SwiftyJSON


class RegistrationVC: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate,HMDiallingCodeDelegate,CLLocationManagerDelegate,UIWebViewDelegate
{

    
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var registerSgmntBtn: UISegmentedControl!
    
    @IBOutlet weak var scrollviewRgstr: UIScrollView!
    var userNameTF = ACFloatingTextfield()
    var emailTF = ACFloatingTextfield()
    var phoneTF = ACFloatingTextfield()
    var passWordTF = ACFloatingTextfield()
    var reEnterPWTF = ACFloatingTextfield()
    var plusLabel = ACFloatingTextfield()
    var countryCodeTF = ACFloatingTextfield()
    var lastNameTF = ACFloatingTextfield()
    
    var registerButton = UIButton()
    var facebookLoginbtn = UIButton()
    var googleSigninButton = UIButton()
    var twitterLoginbtn = UIButton()
    var InstagramLoginbtn = UIButton()
    var pinterestLoginbtn = UIButton()
    var pLoginButton = UIButton()
    var instagramLoginButton = UIButton()
    var acceptBtn = UIButton()
    var CountryPicker = UIButton()
    var termscondition = UIButton()
    var acceptLbl = UILabel()
    var StrName = String()
    var acceptString = String()
    
    var dataDic = NSDictionary()
    
    var  faceBookDic = NSDictionary()
    
    var diallingCode = HMDiallingCode()
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var myString = String()
    var DeviceToken=String()
    
    var popview = UIView()
    var footerView = UIView()
    var termsView = UIWebView()
    var htmlstring=String()
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var user = PDKUser()
    var accessToken = ""
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    var pinterestName=String()
    var imageURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = ""
        }
        
        acceptString = "1"
        myString = "0"
        
        let attr = NSDictionary(object: UIFont(name: "Helvetica-Bold", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        self.registerSgmntBtn.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
        
        self.diallingCode.delegate=self;
        
        self.registerView()
        
       
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
        
         self.termsmethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=termsandcondition")
    }
    
    
    @objc private  func termsmethod (baseURL:String , params: String)
    {
        print(params)
        
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
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
        
        self.view.isUserInteractionEnabled = true
        
        
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

    
    
    
    func registerView() -> Void
    {
      //self.scrollviewRgstr.contentSize = CGSize(width:self.view.frame.size.width, height:750)
        
        
        userNameTF = ACFloatingTextfield()
        userNameTF.frame = CGRect(x:15, y:registerSgmntBtn.frame.origin.y+55, width:self.view.frame.size.width-55, height:45)
        userNameTF.delegate = self
        userNameTF.placeholder = "Your Name"
        userNameTF.placeHolderColor=UIColor.lightGray
        userNameTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        userNameTF.lineColor=UIColor.lightGray
        userNameTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        userNameTF.autocorrectionType = UITextAutocorrectionType.no
        self.scrollviewRgstr.addSubview(userNameTF)
        
//        lastNameTF = ACFloatingTextfield()
//        lastNameTF.frame = CGRect(x:self.view.frame.size.width/2+10, y:registerSgmntBtn.frame.origin.y+55, width:self.view.frame.size.width/2-50, height:45)
//        lastNameTF.delegate = self
//        lastNameTF.placeholder = "Last Name"
//        lastNameTF.placeHolderColor=UIColor.lightGray
//        lastNameTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
//        lastNameTF.lineColor=UIColor.lightGray
//        lastNameTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
//        lastNameTF.autocorrectionType = UITextAutocorrectionType.no
//        self.scrollviewRgstr.addSubview(lastNameTF)

        emailTF = ACFloatingTextfield()
        emailTF.frame = CGRect(x:15, y:userNameTF.frame.origin.y+70, width:self.view.frame.size.width-55, height:45)
        emailTF.delegate = self
        emailTF.placeholder = "Email address"
        emailTF.placeHolderColor=UIColor.lightGray
        emailTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        emailTF.lineColor=UIColor.lightGray
        emailTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        emailTF.keyboardType=UIKeyboardType.emailAddress
        emailTF.autocorrectionType = .no
        emailTF.autocapitalizationType = .none
        emailTF.spellCheckingType = .no
        self.scrollviewRgstr.addSubview(emailTF)
        
//        plusLabel = ACFloatingTextfield()
//        plusLabel.frame = CGRect(x:15, y:emailTF.frame.origin.y+70, width:10, height:45)
//        plusLabel.text="+"
//        plusLabel.delegate = self
//        plusLabel.placeholder = ""
//        plusLabel.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
//        plusLabel.lineColor=UIColor.lightGray
//        plusLabel.keyboardType=UIKeyboardType.numberPad
//        plusLabel.autocorrectionType = UITextAutocorrectionType.no
//        plusLabel.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
//        self.scrollviewRgstr.addSubview(plusLabel)
        
        countryCodeTF = ACFloatingTextfield()
        countryCodeTF.frame = CGRect(x:15, y:emailTF.frame.origin.y+70, width:60, height:45)
        countryCodeTF.delegate = self
        countryCodeTF.placeholder = "CCode"
        countryCodeTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        countryCodeTF.lineColor=UIColor.lightGray
        countryCodeTF.keyboardType=UIKeyboardType.numberPad
        countryCodeTF.autocorrectionType = UITextAutocorrectionType.no
        countryCodeTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        countryCodeTF.isUserInteractionEnabled=false
        self.scrollviewRgstr.addSubview(countryCodeTF)
        
        CountryPicker.frame = CGRect(x:15, y:emailTF.frame.origin.y+70, width:65, height:45)
        CountryPicker.addTarget(self, action: #selector(RegistrationVC.CountryPickerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollviewRgstr.addSubview(CountryPicker)
        
        
        phoneTF = ACFloatingTextfield()
        phoneTF.frame = CGRect(x:120, y:emailTF.frame.origin.y+70, width:self.view.frame.size.width-160, height:45)
        phoneTF.delegate = self
        phoneTF.placeholder = "Phone Number"
        phoneTF.placeHolderColor=UIColor.lightGray
        phoneTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        phoneTF.lineColor=UIColor.lightGray
        phoneTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        phoneTF.keyboardType=UIKeyboardType.numberPad
        phoneTF.autocorrectionType = UITextAutocorrectionType.no
        phoneTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        self.scrollviewRgstr.addSubview(phoneTF)
        
        passWordTF = ACFloatingTextfield()
        passWordTF.frame = CGRect(x:15, y:phoneTF.frame.origin.y+70, width:self.view.frame.size.width-55, height:45)
        passWordTF.delegate = self
        passWordTF.placeholder = "Password"
        passWordTF.placeHolderColor=UIColor.lightGray
        passWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        passWordTF.lineColor=UIColor.lightGray
        passWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        passWordTF.autocorrectionType = UITextAutocorrectionType.no
        passWordTF.isSecureTextEntry=true
        self.scrollviewRgstr.addSubview(passWordTF)
                
        reEnterPWTF = ACFloatingTextfield()
        reEnterPWTF.frame = CGRect(x:15, y:passWordTF.frame.origin.y+70, width:self.view.frame.size.width-55, height:45)
        reEnterPWTF.delegate = self
        reEnterPWTF.placeholder = "Re-enter Password"
        reEnterPWTF.placeHolderColor=UIColor.lightGray
        reEnterPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        reEnterPWTF.lineColor=UIColor.lightGray
        reEnterPWTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        reEnterPWTF.autocorrectionType = UITextAutocorrectionType.no
        reEnterPWTF.isSecureTextEntry=true
        self.scrollviewRgstr.addSubview(reEnterPWTF)
        
        acceptBtn.frame = CGRect(x:7, y:reEnterPWTF.frame.origin.y+60, width:30, height:30)
        acceptBtn.backgroundColor = UIColor.clear
        acceptBtn.setImage(#imageLiteral(resourceName: "UncheckBox"), for: UIControlState.normal)
        acceptBtn.addTarget(self, action: #selector(RegistrationVC.acceptButtonAction(_:)), for: UIControlEvents.touchUpInside)
        acceptBtn.isSelected = false
        acceptBtn.setImage(UIImage(named: "CheckRightbox"), for: .normal)
        self.scrollviewRgstr.addSubview(acceptBtn)
        
        acceptLbl.frame = CGRect(x:acceptBtn.frame.origin.x+30, y:acceptBtn.frame.origin.y, width:95, height:30)
        acceptLbl.backgroundColor = UIColor.clear
        acceptLbl.text="I accept all the"
        acceptLbl.font =  UIFont(name:"Helvetica", size: 14)
        acceptLbl.textAlignment = .left
        acceptLbl.textColor=UIColor.darkGray
        scrollviewRgstr.addSubview(acceptLbl)
        
        let acccptLblOne = UILabel()
        acccptLblOne.frame = CGRect(x:acceptLbl.frame.origin.x+95, y:acceptBtn.frame.origin.y, width:140, height:30)
        acccptLblOne.backgroundColor = UIColor.clear
        acccptLblOne.text="terms and conditions"
        acccptLblOne.font =  UIFont(name:"Helvetica", size: 14)
        acccptLblOne.textAlignment = .left
        acccptLblOne.textColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        scrollviewRgstr.addSubview(acccptLblOne)
        
        termscondition.frame = CGRect(x:acceptLbl.frame.origin.x+95, y:acceptBtn.frame.origin.y, width:140, height:30)
        termscondition.addTarget(self, action: #selector(RegistrationVC.termsButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollviewRgstr.addSubview(termscondition)

        registerButton.frame = CGRect(x:15, y:reEnterPWTF.frame.origin.y+120, width:self.view.frame.size.width-30, height:45)
        registerButton.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        registerButton.setTitle("SEND OTP", for: .normal)
        registerButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.titleLabel?.textAlignment = .left
        registerButton.addTarget(self, action: #selector(RegistrationVC.registaerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        registerButton.layer.cornerRadius = 4
        self.scrollviewRgstr.addSubview(registerButton)
        
        let orLabe = UILabel()
        orLabe.frame = CGRect(x:self.view.frame.size.width/2-15, y:registerButton.frame.origin.y+70, width:30, height:30)
        orLabe.backgroundColor = UIColor.lightGray
        orLabe.text="OR"
        orLabe.font =  UIFont(name:"Helvetica-Bold", size: 12)
        orLabe.textAlignment = .center
        orLabe.textColor=UIColor.white
        orLabe.layer.cornerRadius = 15
        orLabe.clipsToBounds = true
        scrollviewRgstr.addSubview(orLabe)
        
        
        twitterLoginbtn.frame = CGRect(x:self.view.frame.width/2-20, y:orLabe.frame.origin.y+50, width:40, height:40)
        twitterLoginbtn.setImage(#imageLiteral(resourceName: "Twitter"), for: UIControlState.normal)
        twitterLoginbtn.addTarget(self, action: #selector(RegistrationVC.twitterLoginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        twitterLoginbtn.layer.cornerRadius = 4
        self.scrollviewRgstr.addSubview(twitterLoginbtn)
        
        googleSigninButton.frame = CGRect(x:twitterLoginbtn.frame.origin.x+50, y:orLabe.frame.origin.y+50, width:40, height:40)
        googleSigninButton.setImage(#imageLiteral(resourceName: "GoogleSignIn icon"), for: UIControlState.normal)
        googleSigninButton.addTarget(self, action: #selector(RegistrationVC.googleloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        googleSigninButton.layer.cornerRadius = 4
        self.scrollviewRgstr.addSubview(googleSigninButton)
       
        
        facebookLoginbtn.frame = CGRect(x:twitterLoginbtn.frame.origin.x-50, y:twitterLoginbtn.frame.origin.y, width:40, height:40)
        facebookLoginbtn.setImage(#imageLiteral(resourceName: "FaceBook"), for: UIControlState.normal)
        facebookLoginbtn.addTarget(self, action: #selector(RegistrationVC.faceBookloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        facebookLoginbtn.layer.cornerRadius = 4
        self.scrollviewRgstr.addSubview(facebookLoginbtn)
        
//        InstagramLoginbtn.frame = CGRect(x:googleSigninButton.frame.origin.x+50, y:twitterLoginbtn.frame.origin.y+2, width:35, height:35)
//        InstagramLoginbtn.setImage(UIImage(named: "instagram.png"), for: .normal)
//        InstagramLoginbtn.addTarget(self, action: #selector(RegistrationVC.InstagramloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
//        InstagramLoginbtn.layer.cornerRadius = 4
//        self.scrollviewRgstr.addSubview(InstagramLoginbtn)
        
        
        pLoginButton.frame = CGRect(x:googleSigninButton.frame.origin.x+50, y:googleSigninButton.frame.origin.y, width:40, height:40)
       // pLoginButton.backgroundColor=#colorLiteral(red: 0.7894110084, green: 0.2063373625, blue: 0.2409539223, alpha: 1)
        pLoginButton.setImage(UIImage(named: "pinterest.png"), for: .normal)
        pLoginButton.addTarget(self, action: #selector(RegistrationVC.pinterestloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        pLoginButton.layer.cornerRadius = 4
        pLoginButton.isHidden = true
        self.scrollviewRgstr.addSubview(pLoginButton)
        
        instagramLoginButton.frame = CGRect(x:pLoginButton.frame.origin.x+50, y:googleSigninButton.frame.origin.y, width:40, height:40)
        instagramLoginButton.backgroundColor=#colorLiteral(red: 0.2456161082, green: 0.4461238384, blue: 0.6086036563, alpha: 1)
        instagramLoginButton.setImage(#imageLiteral(resourceName: "Instagram"), for: UIControlState.normal)
        instagramLoginButton.addTarget(self, action: #selector(RegistrationVC.InstagramloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        instagramLoginButton.layer.cornerRadius = 20
        instagramLoginButton.isHidden = true
        self.scrollviewRgstr.addSubview(instagramLoginButton)
        
        
    }
    
    
    
    func termsButtonAction(_ sender: UIButton!)
    {
       self.TermsConditions()
    }
    
    
    func TermsConditions() -> Void
    {
        popview.isHidden=false
        footerView.isHidden=false
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:10, y:40, width:popview.frame.size.width-20, height:popview.frame.size.height-80)
        footerView.backgroundColor = UIColor.white
        popview.addSubview(footerView)
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:50)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView.addSubview(Headview)
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:Headview.frame.size.width/2-100, y:5, width:200, height:40)
        titlelab.text="Terms and Conditions"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        titlelab.textColor=UIColor.white
        titlelab.textAlignment = .center
        Headview.addSubview(titlelab)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:Headview.frame.size.width-35, y:15, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(RegistrationVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:50)
        crossbutt2.addTarget(self, action: #selector(RegistrationVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        termsView.frame = CGRect(x:0, y:50, width:footerView.frame.size.width, height:footerView.frame.size.height-50)
        termsView.delegate = self
        termsView.backgroundColor=UIColor.white
        footerView.addSubview(termsView)
        //let htmlString: String = "<font face='Times New Roman' size='3'>\(htmlstring)"
        termsView.loadHTMLString(htmlstring, baseURL: nil)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system\"")
    }
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    
    // MARK: Country picker Button Action :
    func CountryPickerButtonAction(_ sender: UIButton!)
    {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.diallingCode.getForCountry(code!)
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        
        print(diallingCode)
        self.countryCodeTF.text! = String(format: "+%@",diallingCode)
        
         myString = "1"
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    

    
    
     // MARK: Register Segment Button Action :
    @IBAction func segmentButtonAction(_ sender: Any) {
        if registerSgmntBtn.selectedSegmentIndex == 0
        {
            let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController?.pushViewController(foodVC!, animated: false)
           // present(myVC!, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Accept  Button Action :
    func acceptButtonAction(_ sender: UIButton!) {
        
        if sender.isSelected {
            
            acceptBtn.setImage(UIImage(named: "CheckRightbox"), for: .normal)
            sender.isSelected = false
            acceptString = "1"
            
            print("select 1")
        } else {
            
            print("Un select 0")
            acceptBtn.setImage(UIImage(named: "UncheckBox"), for: .normal)
            sender.isSelected = true
            acceptString = "0"
        }

    }
    
    // MARK: Register Button Action :
    func registaerButtonAction(_ sender: UIButton!) {
        
        
        var message = String()
        
        if (userNameTF.text?.isEmpty)!
        {
            message = "Please enter Your Name"
        }
//        else if (lastNameTF.text?.isEmpty)!
//        {
//            message = "Please enter LastName"
//        }
        else if !AFWrapperClass.isValidEmail(emailTF.text!)
        {
            message = "Please enter valid Email"
        }
        else if (countryCodeTF.text?.isEmpty)!
        {
            message = "Please choose country code"
        }
        else if (phoneTF.text?.isEmpty)!
        {
            message = "Please enter Phone number"
        }
        else if (passWordTF.text?.characters.count)! < 6
        {
            message = "Password sould be minimum six characters"
        }
        else if !(passWordTF.text == reEnterPWTF.text)
        {
            message = "Password doesn't match please try again"
        }
        
        else if acceptString == "0"
        {
            message = "Please accept all the terms & conditions"
        }
        
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }else{
            
            self.simpleRegistarationMethod()
        }
    }
        func simpleRegistarationMethod () -> Void
        {
            var Ccode=String()
            Ccode = countryCodeTF.text!
            Ccode = Ccode.replacingOccurrences(of: "+", with: "%2B")
            
    
            StrName = (userNameTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            
            let baseURL: String  = String(format:"%@",Constants.mainURL)
            let params = "method=signup&first_name=\(StrName)&email=\(emailTF.text!)&phone_no=\(phoneTF.text!)&pwd=\(passWordTF.text!)&country_code=\(Ccode)&gcm_id=\(DeviceToken)&device_type=ios"
            
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
            
            
            
            // self.performSegue(withIdentifier: "navv", sender: self)

        }
    
    
    
    
    // MARK: Instagram  Button Action :
      func InstagramloginButtonAction(_ sender: UIButton!)
      {
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "InstagramLoginVC") as? InstagramLoginVC
        self.navigationController?.pushViewController(foodVC!, animated: true)
      }
    
    
    // MARK: Pinterest  Button Action :
    func pinterestloginButtonAction(_ sender: UIButton!)
    {
        
        self.view.isUserInteractionEnabled = false
        //MARK: - Authenticating user, this will get the auth token... but to get the user profile, see MARK: Getting User Profile
        
        PDKClient.sharedInstance().authenticate(withPermissions: [PDKClientReadPublicPermissions,PDKClientWritePublicPermissions,PDKClientReadRelationshipsPermissions,PDKClientWriteRelationshipsPermissions], withSuccess: { (PDKResponseObject) in
            
            
            self.accessToken = PDKClient.sharedInstance().oauthToken
            
            //MARK: - Getting User Profile, use "/v1/me" to get user data in the Response object -
            
            let parameters : [String:String] =
                [
                    
                    "fields":  "first_name,id,last_name,url,image,username,bio,counts,created_at,account_type" //these fields will be fetched for the loggd in user
            ]
            
            PDKClient.sharedInstance().getPath("/v1/me/", parameters: parameters, withSuccess: {
                
                (PDKResponseObject) in
                self.view.isUserInteractionEnabled = true
                
                
                print((PDKResponseObject?.user().identifier)!)
                
                self.user = (PDKResponseObject?.user())!
                self.pinterestName = (PDKResponseObject?.user().firstName)! + " " + (PDKResponseObject?.user().lastName != nil ? (PDKResponseObject?.user().lastName)! : "")
                
                
                if let url = JSON(PDKResponseObject?.user().images["60x60"] as Any)["url"].string
                {
                    print(url)
                    self.imageURL = NSURL(string: url)!
                }
                
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                self.navigationController?.pushViewController(myVC!, animated: true)
                
                let number = (PDKResponseObject?.user().identifier)!
                myVC?.nameGet = self.pinterestName
                myVC?.socialID = String(describing: number)
                myVC?.emailChkStr = "NO"
                myVC?.imgURL = self.imageURL
                myVC?.socialRegistaerStr = "Pinterest"
                
               
                
            }) {
                (Error) in
                if let error = Error
                {
                    print(error)
                }
                self.view.isUserInteractionEnabled = true
            }
            
        }) {
            (Error) in
            self.view.isUserInteractionEnabled = true
            
        }

    }
    
    
    
    // MARK: FaceBook  Button Action :
    func faceBookloginButtonAction(_ sender: UIButton!) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                    
                }
            }
        }

    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    self.faceBookDic = result as! [String : AnyObject] as NSDictionary
                    
                    print( self.faceBookDic)
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.emailGet = self.faceBookDic.object(forKey: "email") as! String
                    myVC?.nameGet = self.faceBookDic.object(forKey: "name") as! String
                    myVC?.socialID = self.faceBookDic.object(forKey: "id") as! String
                    let info : NSDictionary =  self.faceBookDic.object(forKey: "picture") as! NSDictionary
                    let info2 : NSDictionary =  info.object(forKey: "data") as! NSDictionary
                    let url: NSString = (info2.object(forKey: "url") as? NSString)!
                    print(url)
                    myVC?.imgURL = NSURL(string: url as String)!
                    myVC?.emailChkStr = "YES"
                    myVC?.socialRegistaerStr = "FaceBook"
                    
                }
            })
        }
    }

    
    // MARK: Google SignIn Button Action :
    func twitterLoginButtonAction(_ sender: UIButton!) {
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
//        let client = TWTRAPIClient.withCurrentUser()
//        let request = client.urlRequest(withMethod: "GET",
//                                        url: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                                        parameters: ["include_email": "true", "skip_status": "true"],
//                                        error: nil)
//        client.sendTwitterRequest(request, completion: { response, data, connectionError in
//            if (connectionError == nil) {
//                do {
//                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                        print(convertedJsonIntoDict)
//                    }
//                    else{
//                        print("here")
//                    }
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
//        })
        
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                AFWrapperClass.svprogressHudDismiss(view: self)
                print("signed in as \(session?.userName)")
                print("signed in as \(session?.userID)")
              
                
//                let userID = Twitter.sharedInstance().sessionStore.session()!.userID
//                let twitterClient = TWTRAPIClient(userID: userID)
//                twitterClient.loadUserWithID(userID) { (user:TWTRUser?, error:NSError?) in
//                    print(user?.profileImageURL ?? <#default value#>)
//                }
                
                
                let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
                client.loadUser(withID: Twitter.sharedInstance().sessionStore.session()!.userID, completion: {(_ user: TWTRUser?, _ error: Error?) -> Void in
                    print("\(user?.profileImageURL)")
                    
                    self.imageURL = NSURL(string:  (user?.profileImageURL)!)!
                    
                    print(self.imageURL)
                    
                    
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.emailChkStr = "NO"
                    myVC?.nameGet = (session?.userName)!
                    myVC?.socialID = (session?.userID)!
                    myVC?.imgURL = self.imageURL
                    myVC?.socialRegistaerStr = "Twitter"
                })
                
                
              
                
                
                let stores = Twitter.sharedInstance().sessionStore
                if let userID = stores.session()?.userID {
                    stores.logOutUserID(userID)
                    Twitter.sharedInstance().sessionStore.logOutUserID(userID)
                }
            } else {
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: (error?.localizedDescription)!, view: self)
                print("error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        
        
    }
    
    // MARK: Google SignIn Button Action :
    func googleloginButtonAction(_ sender: UIButton!) {
        GIDSignIn.sharedInstance().signOut()
        
        let sighIn:GIDSignIn = GIDSignIn.sharedInstance()
        sighIn.delegate = self;
        sighIn.uiDelegate = self;
        sighIn.shouldFetchBasicProfile = true
        sighIn.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile","https://www.googleapis.com/auth/plus.me"];
        sighIn.clientID = "808187279005-m8e939c0lb7ll4e03lv2qofrrabv8arm.apps.googleusercontent.com"
        sighIn.signIn()
        GIDSignIn.sharedInstance().signOut()
        
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        AFWrapperClass.svprogressHudDismiss(view: self);
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            return
        }
        reportAuthStatus()
        
        //print("\(user.profile.name) \n \(user.profile.email) \n \(user.authentication.idToken) \n \(user.userID)")
        
        if GIDSignIn.sharedInstance().currentUser.profile.hasImage
        {
            imageURL = user.profile.imageURL(withDimension: UInt(120)) as NSURL
            print("Image Url : \(imageURL)")
        }

    
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        
        myVC?.emailGet = user.profile.email
        myVC?.nameGet = user.profile.name
        myVC?.socialID = user.userID
        myVC?.emailChkStr = "YES"
        myVC?.imgURL = imageURL
        myVC?.socialRegistaerStr = "Google"
        
        
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            
        }else
        {
            
        }
    }
    func reportAuthStatus() -> Void {
        let googleUser:GIDGoogleUser = GIDSignIn.sharedInstance().currentUser
        if (googleUser.authentication != nil)
        {
            print("Status: Authenticated")
        }else
        {
            print("Status: Not authenticated")
        }
        
    }
    func refreshUserInfo() -> Void {
        if GIDSignIn.sharedInstance().currentUser.authentication == nil {
            return
        }
        if !GIDSignIn.sharedInstance().currentUser.profile.hasImage {
            return
        }
    }
    
    
    @IBAction func bavkButtonAction(_ sender: Any) {
        
        
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
        
        
    }
    
    
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
