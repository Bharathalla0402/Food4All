//
//  ViewController.swift
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
import InstagramKit
import Alamofire
import PinterestSDK
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate,UIWebViewDelegate,HMDiallingCodeDelegate,CLLocationManagerDelegate
{

    
    
    @IBOutlet weak var scrollViewLogin: UIScrollView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var loginSegmentBtn: UISegmentedControl!
    
    
    var dataDic2 = NSDictionary()
    var loginWebView = UIWebView()
    var loginIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var userNameTF = ACFloatingTextfield()
    var passWordTF = ACFloatingTextfield()
    var forgotPassWordTF = ACFloatingTextfield()
    var NewPassWordTF = ACFloatingTextfield()
    var ConfirmPassWordTF = ACFloatingTextfield()
     var countryCodeTF = ACFloatingTextfield()
     var CountryPicker = UIButton()
    
    var userNMimg = UIImageView()
    var passwordNMimg = UIImageView()
    var ResponseMessage=String()
    var CheckCondition=String()
    var TwitterCheckId=String()
    var popviewTwit = UIView()
    var footerViewTwit = UIView()
    var CheckEmail = ACFloatingTextfield()
    
    var rememberButton = UIButton()
    var forgotPWbtn = UIButton()
    var loginButton = UIButton()
    var facebookLoginbtn = UIButton()
    var googleSigninButton = UIButton()
    var twitterLoginbtn = UIButton()
    var pLoginButton = UIButton()
    var instagramLoginButton = UIButton()
    var dataDic = NSDictionary()
    var faceBookDic = NSDictionary()
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var popview3 = UIView()
    var footerView3 = UIView()
    var CancelButton2 = UIButton()
    var DoneButton2 = UIButton()
    var CancelButton = UIButton()
    var DoneButton = UIButton()
    var ResendButton = UIButton()
    var CancelButton3 = UIButton()
    var DoneButton3 = UIButton()
    var strMessage = String()
    var strUserId = String()
    var DeviceToken=String()
    
    var popview4 = UIView()
    var footerView4 = UIView()
    var CancelButton4 = UIButton()
    var DoneButton4 = UIButton()
    
    var Inpopview = UIView()
    var InfooterView = UIView()
    
    var InstagramLoginbtn = UIButton()
    
    var imageURL = NSURL()
    var emailChkStr = String()
    var socialID = String()
    var emailGet = String()
    var nameGet = String()
    var socialRegistaerStr = String()
    var imgURL = NSURL()
    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var user = PDKUser()
    var accessToken = ""
    let story = UIStoryboard(name: "Main", bundle: nil)
    
     var strApiCheck = String()
    var name1Get = String()
    var name2Get = String()
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       self.diallingCode.delegate = self
        
        if UserDefaults.standard.object(forKey: "DeviceToken") != nil
        {
            DeviceToken=UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        else
        {
            DeviceToken = "bnhj"
        }
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //  locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if let lat = self.locationManager.location?.coordinate.latitude {
                currentLatitude = lat
            }else {
                
            }
            
            if let long = self.locationManager.location?.coordinate.longitude {
                currentLongitude = long
            }else {
                
            }
            
            
        }
        
        
        
        
//        
//        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
//        self.navigationController?.pushViewController(myVC!, animated: true)
//
       
        
        let attr = NSDictionary(object: UIFont(name: "Helvetica-Bold", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        self.loginSegmentBtn.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
        
//        let font = UIFont.systemFont(ofSize: 16)
//        loginSegmentBtn.setTitleTextAttributes([NSFontAttributeName: font],
//                                                for: .normal)
        
        AFWrapperClass.shadowEffect(view: self.view)
        // Login View Method:
        self.LOGINView()
        
        
        let userID = UserDefaults.standard.object(forKey: "userIDsave")
        let pw = UserDefaults.standard.object(forKey: "passWrdsave")
        if userID == nil && pw == nil {
            rememberButton.isSelected = true
            rememberButton.setImage(UIImage(named: "UncheckBox"), for: .normal)
            UserDefaults.standard.set("notSaved", forKey: "userIDsave")
            UserDefaults.standard.set("notSaved", forKey: "passWrdsave")
        }
        else{
          //  print("User ID PW :\(userID) \n \(pw)")
            if UserDefaults.standard.object(forKey: "userIDsave") as! String == "notSaved" && UserDefaults.standard.object(forKey: "passWrdsave") as! String == "notSaved"
            {
                rememberButton.isSelected = true
                rememberButton.setImage(UIImage(named: "UncheckBox"), for: .normal)
                
                
            }else{
                userNameTF.text! =  UserDefaults.standard.object(forKey: "userIDsave") as! String
                passWordTF.text! = UserDefaults.standard.object(forKey: "passWrdsave") as! String
                rememberButton.isSelected = false
                rememberButton.setImage(UIImage(named: "CheckRightbox"), for: .normal)
            }
        }
    }
    
    
    
    // MARK: Login View
    
    func LOGINView ()
    {
        userNameTF = ACFloatingTextfield()
        userNameTF.frame = CGRect(x:15, y:loginSegmentBtn.frame.origin.y+55, width:self.view.frame.size.width-30, height:45)
        userNameTF.delegate = self
        //userNameTF.text!="chunchuswamy80@gmail.com"
        userNameTF.placeholder = "Email/Mobile number with Country code(e.g: +971)"
        userNameTF.placeHolderColor=UIColor.lightGray
        userNameTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        userNameTF.lineColor=UIColor.lightGray
        userNameTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        userNameTF.keyboardType=UIKeyboardType.emailAddress
        userNameTF.autocorrectionType = .no
        userNameTF.autocapitalizationType = .none
        userNameTF.spellCheckingType = .no
        self.scrollViewLogin.addSubview(userNameTF)
        
        passWordTF = ACFloatingTextfield()
        passWordTF.frame = CGRect(x:15, y:userNameTF.frame.origin.y+70, width:self.view.frame.size.width-30, height:45)
        passWordTF.delegate = self
        //passWordTF.text!="123456"
        passWordTF.placeholder = "Password"
        passWordTF.placeHolderColor=UIColor.lightGray
        passWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        passWordTF.lineColor=UIColor.lightGray
        passWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        passWordTF.isSecureTextEntry=true
        self.scrollViewLogin.addSubview(passWordTF)
        
        rememberButton.frame = CGRect(x:7, y:passWordTF.frame.origin.y+60, width:30, height:30)
        rememberButton.backgroundColor = UIColor.clear
        rememberButton.setImage(#imageLiteral(resourceName: "CheckRightbox"), for: UIControlState.normal)
        rememberButton.addTarget(self, action: #selector(ViewController.rememberButtonAction(_:)), for: UIControlEvents.touchUpInside)
        rememberButton.isSelected = false
        self.scrollViewLogin.addSubview(rememberButton)
        
        let rememberLabel = UILabel()
        rememberLabel.frame = CGRect(x:rememberButton.frame.origin.x+30, y:rememberButton.frame.origin.y, width:100, height:30)
        rememberLabel.backgroundColor = UIColor.clear
        rememberLabel.text="Remember me"
        rememberLabel.font =  UIFont(name:"Helvetica", size: 14)
        rememberLabel.textAlignment = .left
        rememberLabel.textColor=UIColor.darkGray
        scrollViewLogin.addSubview(rememberLabel)
        
        forgotPWbtn.frame = CGRect(x:self.view.frame.size.width-155, y:passWordTF.frame.origin.y+60, width:147, height:30)
        forgotPWbtn.backgroundColor=UIColor.clear
        forgotPWbtn.setTitle("Forget Password?", for: .normal)
        forgotPWbtn.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        forgotPWbtn.setTitleColor(#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1), for: .normal)
        forgotPWbtn.titleLabel?.textAlignment = .right
        forgotPWbtn.addTarget(self, action: #selector(ViewController.forgotButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.scrollViewLogin.addSubview(forgotPWbtn)
        
        loginButton.frame = CGRect(x:15, y:passWordTF.frame.origin.y+130, width:self.view.frame.size.width-30, height:45)
        loginButton.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.textAlignment = .left
        loginButton.addTarget(self, action: #selector(ViewController.loginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        loginButton.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(loginButton)
        
       
        let orLabe = UILabel()
        orLabe.frame = CGRect(x:self.view.frame.size.width/2-15, y:loginButton.frame.origin.y+70, width:30, height:30)
        orLabe.backgroundColor = UIColor.lightGray
        orLabe.text="OR"
        orLabe.font =  UIFont(name:"Helvetica-Bold", size: 12)
        orLabe.textColor=UIColor.white
        orLabe.textAlignment = .center
        orLabe.layer.cornerRadius = 15
        orLabe.clipsToBounds = true
        scrollViewLogin.addSubview(orLabe)
        
        twitterLoginbtn.frame = CGRect(x:self.view.frame.width/2+5, y:orLabe.frame.origin.y+50, width:40, height:40)
        twitterLoginbtn.setImage(#imageLiteral(resourceName: "Twitter"), for: UIControlState.normal)
        twitterLoginbtn.addTarget(self, action: #selector(self.twitterloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        twitterLoginbtn.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(twitterLoginbtn)
        
       // twitterLoginbtn.isHidden = true
        
        
        googleSigninButton.frame =  CGRect(x:twitterLoginbtn.frame.origin.x-50, y:orLabe.frame.origin.y+50, width:40, height:40)
        googleSigninButton.setImage(#imageLiteral(resourceName: "GoogleSignIn icon"), for: UIControlState.normal)
        googleSigninButton.addTarget(self, action: #selector(self.googleloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        googleSigninButton.layer.cornerRadius = 4
        googleSigninButton.clipsToBounds = true
        self.scrollViewLogin.addSubview(googleSigninButton)
        
        
        
        facebookLoginbtn.frame = CGRect(x:twitterLoginbtn.frame.origin.x-100, y:twitterLoginbtn.frame.origin.y, width:40, height:40)
        facebookLoginbtn.setImage(#imageLiteral(resourceName: "FaceBook"), for: UIControlState.normal)
        facebookLoginbtn.addTarget(self, action: #selector(self.faceBookloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        facebookLoginbtn.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(facebookLoginbtn)
        
        
        InstagramLoginbtn.frame = CGRect(x:twitterLoginbtn.frame.origin.x+50, y:twitterLoginbtn.frame.origin.y+2, width:40, height:40)
        InstagramLoginbtn.setImage(UIImage(named: "instagram.png"), for: .normal)
        InstagramLoginbtn.addTarget(self, action: #selector(self.InstagramloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        InstagramLoginbtn.layer.cornerRadius = 4
        self.scrollViewLogin.addSubview(InstagramLoginbtn)
        
        
        
        pLoginButton.frame = CGRect(x:googleSigninButton.frame.origin.x+50, y:googleSigninButton.frame.origin.y, width:40, height:40)
        //pLoginButton.backgroundColor=#colorLiteral(red: 0.7894110084, green: 0.2063373625, blue: 0.2409539223, alpha: 1)
        pLoginButton.setImage(UIImage(named: "pinterest.png"), for: .normal)
        pLoginButton.addTarget(self, action: #selector(ViewController.pinterestloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        pLoginButton.isHidden = true
        self.scrollViewLogin.addSubview(pLoginButton)
        
        instagramLoginButton.frame = CGRect(x:pLoginButton.frame.origin.x+50, y:googleSigninButton.frame.origin.y, width:40, height:40)
        instagramLoginButton.backgroundColor=#colorLiteral(red: 0.2456161082, green: 0.4461238384, blue: 0.6086036563, alpha: 1)
        instagramLoginButton.setImage(#imageLiteral(resourceName: "Instagram"), for: UIControlState.normal)
        instagramLoginButton.addTarget(self, action: #selector(ViewController.InstagramloginButtonAction(_:)), for: UIControlEvents.touchUpInside)
        instagramLoginButton.layer.cornerRadius = 20
        instagramLoginButton.isHidden = true
        self.scrollViewLogin.addSubview(instagramLoginButton)

        
        self.scrollViewLogin.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        
        self.userNameTF.text = ""
        self.passWordTF.text = ""
       
        
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
        
        self.userNameTF.inputAccessoryView = doneToolbar
        self.passWordTF.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }

    
    
    
    @IBAction func loginSegmwntBtnAction(_ sender: Any) {
        if loginSegmentBtn.selectedSegmentIndex == 1
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC
            self.navigationController?.pushViewController(myVC!, animated: false)
            //present(myVC!, animated: true, completion: nil)
        }
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
                
                
                 let pinterestId:String = (PDKResponseObject?.user().identifier)!
                 self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=pinterestlogin&pinterest_id=\(pinterestId)&gcm_id=\(self.DeviceToken)&device_type=ios")
                
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

    
    
    // MARK: Instagram  Button Action :
    func InstagramloginButtonAction(_ sender: UIButton!)
    {
        Inpopview.isHidden=false
        InfooterView.isHidden=false
        
        
        Inpopview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        Inpopview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(Inpopview)
        
        InfooterView.frame = CGRect(x:0, y:0, width:Inpopview.frame.size.width, height:Inpopview.frame.size.height)
        InfooterView.backgroundColor = UIColor.white
        Inpopview.addSubview(InfooterView)
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:InfooterView.frame.size.width, height:60)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        InfooterView.addSubview(Headview)
        
        
        let Instagramlab = UILabel()
        Instagramlab.frame = CGRect(x:60, y:25, width:InfooterView.frame.size.width-120, height:25)
        Instagramlab.text="Instagram"
        Instagramlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        Instagramlab.textColor=UIColor.white
        Instagramlab.textAlignment = .center
        Headview.addSubview(Instagramlab)
        
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x:10, y:25, width:25, height:25));
        imageView.image = UIImage(named:"backButton")
        imageView.contentMode = .scaleAspectFit
        Headview.addSubview(imageView)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:0, y:10, width:40, height:50)
        crossbutt.addTarget(self, action: #selector(ViewController.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        
        loginWebView.frame = CGRect(x:0, y:60, width:InfooterView.frame.size.width, height:InfooterView.frame.size.height-60)
        loginWebView.backgroundColor=UIColor.lightGray
        loginWebView.delegate=self
        InfooterView.addSubview(loginWebView)
        
        loginIndicator.frame = CGRect(x:InfooterView.frame.size.width/2-20, y:InfooterView.frame.size.height/2-20, width:20, height:20)
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loginIndicator.center = Inpopview.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.tintColor = .blue
        loginIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.white
        InfooterView.addSubview(loginIndicator)
        loginIndicator.startAnimating()
        
       // appInstance.showLoader()
        
      AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        unSignedRequest()
    }
    
    
    
    func unSignedRequest ()
    {
        let authURL = InstagramEngine.shared().authorizationURL()
        loginWebView.loadRequest(URLRequest.init(url: authURL))
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        do {
            if let url = request.url {
                
              //  print(url)
                
                if String(describing: url).range(of: "#access_token") != nil {
                    
                    try InstagramEngine.shared().receivedValidAccessToken(from: url)
                    
                    if let accessToken = InstagramEngine.shared().accessToken {
                       // print("accessToken: \(accessToken)")
                        //start
                        
                        let URl =  "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)"
                        
                        let parameter = [ "access_token" : accessToken ]
                        
                        //    let URl = "https://api.instagram.com/v1/users/self/"
                        
                        appInstance.showLoader()
                        Alamofire.request(URl, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                            .responseJSON { response in
                                appInstance.hideLoader()
                              //  print(response.result.value!)
                                
                                if response.result.isSuccess {
                                    
                                    let dict = response.result.value!
                                    
                                    do {
                                        
                                        var result : [String : AnyObject] = [String : AnyObject]()
                                        
                                        let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                                        
                                        if let json = NSString(data: data, encoding:  String.Encoding.utf8.rawValue){
                                            
                                            print(json)
                                            result["result"] = json
                                            
                                            let responceDic:NSDictionary = ((dict as AnyObject).object(forKey: "meta") as? NSDictionary)!
                                            
                                            
                                            if (((responceDic as AnyObject).object(forKey: "code")) as! NSNumber) == 200
                                            {
                                                self.dataDic2 = ((dict as AnyObject).object(forKey: "data") as? NSDictionary)!
                                                print(self.dataDic2)
                                                let instagramId:String = (self.dataDic2 as AnyObject).object(forKey: "id") as? String ?? ""
                                                let instagramname:String = (self.dataDic2 as AnyObject).object(forKey: "full_name") as? String ?? ""
                                                
                                                let url: String = (self.dataDic2 as AnyObject).object(forKey: "profile_picture") as? String ?? ""
                                                self.imgURL = NSURL(string: url as String)!
                                                
                                        
                                                self.emailChkStr = "NO"
                                                self.nameGet = instagramname
                                                self.name1Get = instagramname
                                                self.name2Get = ""
                                                self.socialID = instagramId
                                               
                                                self.socialRegistaerStr = "instagram"
                                                
                                                self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=twitterlogin&twitter_id=\(self.socialID)&gcm_id=\(self.DeviceToken)&device_type=ios")
                                                
                                                
                                                
//                                                  self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=instagramlogin&instagram_id=\(instagramId)&gcm_id=\(self.DeviceToken)&device_type=ios")
                                                
                                                self.Inpopview.isHidden=true
                                                self.InfooterView.isHidden=true
                                                
//                                                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
//                                                self.navigationController?.pushViewController(myVC!, animated: true)
//                                                
//                                                // let number = (self.dataDic2 as AnyObject).object(forKey: "id") as! NSNumber
//                                                
//                                                
//                                                myVC?.nameGet = self.dataDic2.object(forKey: "full_name") as! String
//                                                myVC?.socialID = (self.dataDic2 as AnyObject).object(forKey: "id") as! String
//                                                myVC?.emailChkStr = "NO"
//                                                myVC?.socialRegistaerStr = "Instagram"
                                                
                                                
//                                                let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
//                                                for cookie in cookieJar.cookies! as [HTTPCookie]{
//                                                    NSLog("cookie.domain = %@", cookie.domain)
//                                                    
//                                                    if cookie.domain == "www.instagram.com" ||
//                                                        cookie.domain == "api.instagram.com"{
//                                                        
//                                                        cookieJar.deleteCookie(cookie)
//                                                    }
//                                                }
                                                
                                            }
                                            else
                                            {
                                                _ =   self.navigationController?.popViewController(animated: true)
                                            }
                                            
                                            
                                            if pbSocialDelegate != nil{
                                                
                                                pbSocialDelegate.getInstagramLoginResponse(userData : result)
                                                _ =   self.navigationController?.popViewController(animated: true)
                                                
                                            }
                                        }
                                        
                                    }catch let err as NSError{
                                        print(err.debugDescription)
                                        _ =   self.navigationController?.popViewController(animated: true)
                                    }
                                }
                        }
                    }
                }
            }
        } catch let err as NSError {
            print(err.debugDescription)
            _ =   self.navigationController?.popViewController(animated: true)
        }
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
       //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
      //  appInstance.showLoader()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
        AFWrapperClass.svprogressHudDismiss(view: self)
       //  appInstance.hideLoader()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }


    
    func CloseButtonAction(_ sender: UIButton!)
    {
        self.view.endEditing(true)
        Inpopview.isHidden=true
        InfooterView.isHidden=true
    }
    
    
    
    // MARK: remember Button Action :
    func rememberButtonAction(_ sender: UIButton!) {
        
        if (userNameTF.text?.isEmpty)! && (passWordTF.text?.isEmpty)!
        {
            AFWrapperClass.alert(Constants.applicationName, message: "Enter userID/Password", view: self)
        }
        
        else{
            if sender.isSelected {
                
                rememberButton.setImage(UIImage(named: "CheckRightbox"), for: .normal)
                sender.isSelected = false
                UserDefaults.standard.set(userNameTF.text!, forKey: "userIDsave")
                UserDefaults.standard.set(passWordTF.text!, forKey: "passWrdsave")
          
            } else {

                rememberButton.setImage(UIImage(named: "UncheckBox"), for: .normal)
                sender.isSelected = true
                UserDefaults.standard.set("notSaved", forKey: "userIDsave")
                UserDefaults.standard.set("notSaved", forKey: "passWrdsave")
            }
        }
    }
    
    
    // MARK: Forgot Button Action :
    func forgotButtonAction(_ sender: UIButton!) {
        
        CheckCondition = "1"
        
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
        popview.addSubview(footerView)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="FORGET PASSWORD?"
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
        forgotPassWordTF.placeholder = "Email/Mobile number with Country code(e.g: +971)"
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
        CancelButton2.addTarget(self, action: #selector(ViewController.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(CancelButton2)
        
        
        DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton2.setTitle("Done", for: .normal)
        DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton2.titleLabel?.textAlignment = .center
        DoneButton2.addTarget(self, action: #selector(ViewController.forgotDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(DoneButton2)
        
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
            message = "Please enter Registered Email Id/ Mobile Number"
        }
            
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            let str2 = forgotPassWordTF.text!
            var trimmedString = str2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let firstCharacter = trimmedString.characters.first
            
            
            if str2.isNumber == true
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid mobile number with country code (e.g: +971)", view: self)
                
//                strApiCheck = "2"
//                let vc = SLCountryPickerViewController()
//                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
//                    self.diallingCode.getForCountry(code!)
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if firstCharacter == "+"
            {
                let strnumber = str2.replacingOccurrences(of: "+", with: "")
                
                if strnumber.isNumber == true
                {
                    mobileFullString = forgotPassWordTF.text!
                    self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=forgetPassword&email=\(forgotPassWordTF.text!)")
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid Email/mobile number with country code (e.g: +971)", view: self)
                }
            }
            else if str2.isNumber == false
            {
                if !AFWrapperClass.isValidEmail(userNameTF.text!)
                {
                    AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid Email", view: self)
                }
                else
                {
                    mobileFullString = forgotPassWordTF.text!
                    self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=forgetPassword&email=\(forgotPassWordTF.text!)")
                }
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }

    }
    
    
    @objc private  func ForgotAPIMethod (baseURL:String , params: String)
    {
      //  print(params);
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"forgetPassword")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(mobileFullString, forKey: "login_key")
       
        
        
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
             //   print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.popview.isHidden=true
                    self.footerView.isHidden=true
                    
                    self.popviewTwit.isHidden=true
                    self.footerViewTwit.isHidden=true
                    
                    
                    if self.CheckCondition == "1"
                    {
                        let responceDic2:NSDictionary=responceDic.object(forKey: "userDetails") as! NSDictionary
                        
                        self.strUserId = responceDic2.object(forKey: "id")  as! String
                    }
                    else
                    {
                        self.strUserId = responceDic.object(forKey: "id")  as! String
                    }
                    
                  
                    
                    self.VerifyView()
                    
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if (Message.isEqual("User not verified."))
                    {
                        self.popview.isHidden=true
                        self.footerView.isHidden=true
                        
                        self.strUserId = responceDic.object(forKey: "user_id")  as! String
                        
                        self.VerifyView()
                    }
                    else if (Message.isEqual("Oops! Your account does not exist. Kindly register first!"))
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                        self.navigationController?.pushViewController(myVC!, animated: true)
                        
                        myVC?.emailGet = self.emailGet
                        myVC?.nameGet = self.nameGet
                        myVC?.socialID = self.socialID
                        myVC?.emailChkStr = self.emailChkStr
                        myVC?.imgURL = self.imgURL
                        myVC?.socialRegistaerStr = self.socialRegistaerStr
                        
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                    }
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }

    
    // MARK: verify :
    func VerifyView ()
    {
        popview2.isHidden=false
        footerView2.isHidden=false
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
          forgotPassWordTF.removeFromSuperview()
        
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
        forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
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
        CancelButton.addTarget(self, action: #selector(ViewController.VerifycancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(CancelButton)
        
        
        DoneButton.frame = CGRect(x:CancelButton.frame.size.width+CancelButton.frame.origin.x+6, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView2.frame.size.width/3-8, height:40)
        DoneButton.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton.titleLabel?.textAlignment = .center
        DoneButton.addTarget(self, action: #selector(ViewController.VerifyDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(DoneButton)
        
        
        
        ResendButton.frame = CGRect(x:DoneButton.frame.size.width+DoneButton.frame.origin.x+6, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView2.frame.size.width/3-8, height:40)
        ResendButton.backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        ResendButton.setTitle("Resend", for: .normal)
        ResendButton.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        ResendButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ResendButton.titleLabel?.textAlignment = .center
        ResendButton.addTarget(self, action: #selector(ViewController.ResendButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(ResendButton)
        
        self.forgotPassWordTF.text = ""

        self.addDoneButtonOnKeyboard2()
    }
    
    // MARK: Verify Cancel Button Action :
    func VerifycancelButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
    }
    
    @IBAction func ResendButtonAction(_ sender: Any)
    {
        self.ReverifyotpAPIMethod2(baseURL: String(format:"%@",Constants.mainURL) , params: "method=resendotp&user_id=\(strUserId)")
    }
    
    
    @objc private   func ReverifyotpAPIMethod2 (baseURL:String , params: String)
    {
      //  print(params);
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"resendotp")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserId, forKey: "user_id")
        
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
            message = "Please Enter Valid OTP"
        }
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
            
        }
        else
        {
            
            if self.CheckCondition == "1"
            {
                self.Veify2APIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=verifyotp&otp=\(forgotPassWordTF.text!)&id=\(strUserId)")
            }
            else
            {
                self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=verifyotpSocial&social_id=\(TwitterCheckId)&otp=\(forgotPassWordTF.text!)&id=\(strUserId)")
            }
        }
        
    }
    
    
    @objc private  func Veify2APIMethod (baseURL:String , params: String)
    {
      //  print(params);
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"verifyOtp")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserId, forKey: "user_id")
        PostDataValus.setValue(forgotPassWordTF.text!, forKey: "otp")
        
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
              //  print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.popview2.isHidden=true
                    self.footerView2.isHidden=true
                    
                    self.ResetPasswordView()
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

    
    
   
    // MARK: Reset Password :
    func ResetPasswordView ()
    {
        popview3.isHidden=false
        footerView3.isHidden=false
        NewPassWordTF.text=""
        NewPassWordTF.placeholder=""
        ConfirmPassWordTF.text=""
        ConfirmPassWordTF.placeholder=""
        ConfirmPassWordTF.removeFromSuperview()
        NewPassWordTF.removeFromSuperview()
        
        popview3.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview3.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview3)
        
        footerView3.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-130, width:300, height:260)
        footerView3.backgroundColor = UIColor.white
        popview3.addSubview(footerView3)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="CHANGE PASSWORD"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView3.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView3.addSubview(labUnderline)
        
        
        
        NewPassWordTF = ACFloatingTextfield()
        NewPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:280, height:45)
        NewPassWordTF.delegate = self
        NewPassWordTF.placeholder = "New Password"
        NewPassWordTF.placeHolderColor=UIColor.lightGray
        NewPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        NewPassWordTF.lineColor=UIColor.lightGray
        NewPassWordTF.selectedLineColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        NewPassWordTF.autocorrectionType = UITextAutocorrectionType.no
        //forgotPassWordTF.setKeyboardType=UIKeyboardTypeNumberPad
        footerView3.addSubview(NewPassWordTF)
        
        
        ConfirmPassWordTF = ACFloatingTextfield()
        ConfirmPassWordTF.frame = CGRect(x:10, y:NewPassWordTF.frame.size.height+NewPassWordTF.frame.origin.y+15, width:280, height:45)
        ConfirmPassWordTF.delegate = self
        ConfirmPassWordTF.placeholder = "Confirm New Password"
        ConfirmPassWordTF.placeHolderColor=UIColor.lightGray
        ConfirmPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        ConfirmPassWordTF.lineColor=UIColor.lightGray
        ConfirmPassWordTF.selectedLineColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        ConfirmPassWordTF.autocorrectionType = UITextAutocorrectionType.no
        //forgotPassWordTF.setKeyboardType=UIKeyboardTypeNumberPad
        footerView3.addSubview(ConfirmPassWordTF)
        
        
        CancelButton3.frame = CGRect(x:10, y:ConfirmPassWordTF.frame.size.height+ConfirmPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        CancelButton3.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton3.setTitle("Cancel", for: .normal)
        CancelButton3.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton3.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton3.titleLabel?.textAlignment = .center
        CancelButton3.addTarget(self, action: #selector(ViewController.ResetcancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(CancelButton3)
        
        
        DoneButton3.frame = CGRect(x:CancelButton3.frame.size.width+CancelButton3.frame.origin.x+10, y:ConfirmPassWordTF.frame.size.height+ConfirmPassWordTF.frame.origin.y+35, width:footerView.frame.size.width/2-15, height:40)
        DoneButton3.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton3.setTitle("Done", for: .normal)
        DoneButton3.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton3.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton3.titleLabel?.textAlignment = .center
        DoneButton3.addTarget(self, action: #selector(ViewController.ResetButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView3.addSubview(DoneButton3)
        
        self.NewPassWordTF.text = ""
        self.ConfirmPassWordTF.text = ""
        
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
        
        self.NewPassWordTF.inputAccessoryView = doneToolbar
        self.ConfirmPassWordTF.inputAccessoryView = doneToolbar
    }
    
    // MARK: Resset Cancel Button Action :
    func ResetcancelButtonAction(_ sender: UIButton!)
    {
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    
    // MARK: Reset Password Button Action :
    func ResetButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (NewPassWordTF.text?.isEmpty)!
        {
             message = "Please Enter New Password"
        }
        else if !(NewPassWordTF.text == ConfirmPassWordTF.text)
        {
            message = "Password doesn't match please try again"
        }

        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            self.ResetPasswordAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=forget_reset_password&new_pwd=\(NewPassWordTF.text!)&user_id=\(strUserId)")
        }
        
    }
    
    
    @objc private  func ResetPasswordAPIMethod (baseURL:String , params: String)
    {
        
      //  print(params);
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"changePassword")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserId, forKey: "user_id")
        PostDataValus.setValue(NewPassWordTF.text!, forKey: "new_pwd")
        
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
             //   print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.popview3.isHidden=true
                    self.footerView3.isHidden=true
                    
                  
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
    

    
    // MARK: DialingCodeDelegates:
    
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
        
        
        if strApiCheck == "1"
        {
            mobileFullString = String(format: "%@%@",countryCode,userNameTF.text!)
          //  mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
            
            self.simpleLoginMethod()
        }
        else if strApiCheck == "3"
        {
            mobileFullString = String(format: "%@%@",countryCode,forgotPassWordTF.text!)
           // mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
            
           self.AddMobileapi()
        }
        else if strApiCheck == "4"
        {
            self.countryCodeTF.text!  = countryCode
        }
        else
        {
            mobileFullString = String(format: "%@%@",countryCode,forgotPassWordTF.text!)
          //  mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
            
             self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=forgetPassword&email=\(forgotPassWordTF.text!)")
        }
        
        
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
    func validatePhone(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    
    // MARK: Login Button Action :
    func loginButtonAction(_ sender: UIButton!)
    {
        var message = String()
         if (userNameTF.text?.isEmpty)!
        {
            message = "Please enter Email Id/Mobile Number"
        }
        else if (passWordTF.text?.isEmpty)!
        {
            message = "Please enter password"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
           // let str: String = userNameTF.text!
            
            let str2 = userNameTF.text!
            var trimmedString = str2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let firstCharacter = trimmedString.characters.first
            
            
            if str2.isNumber == true
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid mobile number with country code (e.g: +971)", view: self)
                
//                strApiCheck = "1"
//                let vc = SLCountryPickerViewController()
//                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
//                    self.diallingCode.getForCountry(code!)
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if firstCharacter == "+"
            {
                let strnumber = str2.replacingOccurrences(of: "+", with: "")
                
                if strnumber.isNumber == true
                {
                    mobileFullString = userNameTF.text!
                    self.simpleLoginMethod()
                }
                else
                {
                     AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid Email/mobile number with country code (e.g: +971)", view: self)
                }
               
            }
            else if str2.isNumber == false
            {
                if !AFWrapperClass.isValidEmail(userNameTF.text!)
                {
                     AFWrapperClass.alert(Constants.applicationName, message: "Please enter valid Email", view: self)
                }
                else
                {
                    mobileFullString = userNameTF.text!
                    self.simpleLoginMethod()
                }
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func simpleLoginMethod () -> Void
    {
        
       // let baseURL: String  = String(format:"%@",Constants.mainURL)
      //  let params = "method=login&email=\(userNameTF.text!)&pwd=\(passWordTF.text!)&gcm_id=\(DeviceToken)&device_type=ios"
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"login")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(DeviceToken, forKey: "gcm_id")
        PostDataValus.setValue("ios", forKey: "device_type")
        PostDataValus.setValue(mobileFullString, forKey: "login_key")
        PostDataValus.setValue(passWordTF.text!, forKey: "pwd")
       
        
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
                
                var strcode = String()
                if let quantity = responceDic.object(forKey: "code") as? NSNumber
                {
                    strcode =  String(describing: quantity)
                }
                else if let quantity = responceDic.object(forKey: "code") as? String
                {
                    strcode = quantity
                }
                
                if strcode == "0"
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.dataDic)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    // UserDefaults.standard.set(self.dataDic, forKey: "UserId")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else if strcode == "1"
                {
                    if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        self.strUserId =  String(describing: quantity)
                    }
                    else if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        self.strUserId = String(describing: quantity)
                    }
                    
                    self.AddMobileNumber()
                }
                else if strcode == "2"
                {
                    if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        self.strUserId =  String(describing: quantity)
                    }
                    else if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        self.strUserId = String(describing: quantity)
                    }
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                    foodVC?.UsearID = String(describing: self.strUserId)
                    self.navigationController?.pushViewController(foodVC!, animated: true)
                }
                else if strcode == "3"
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
                else
                {
                
                
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.dataDic)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if (Message.isEqual("Your Account is not verified."))
                    {
                    
                        self.strUserId = responceDic.object(forKey: "user_id")  as! String
                        
                        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                        foodVC?.UsearID = String(describing: self.strUserId)
                        self.navigationController?.pushViewController(foodVC!, animated: true)
                        
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                        
                    }
                    }

                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    // MARK: faceBook Login Button Action :
    func faceBookloginButtonAction(_ sender: UIButton!) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
       // fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
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
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, first_name, last_name, picture.type(large), id"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    self.faceBookDic = result as! [String : AnyObject] as NSDictionary
                    
                    print( self.faceBookDic)
                    
                    
                    var email=String()
                    email = self.faceBookDic.object(forKey: "email") as? String ?? ""
                    
                    var fbid=String()
                    fbid = self.faceBookDic.object(forKey: "id") as? String ?? ""
                    
                    self.emailGet = self.faceBookDic.object(forKey: "email") as? String ?? ""
                    self.nameGet = self.faceBookDic.object(forKey: "name") as? String ?? ""
                    self.name1Get = self.faceBookDic.object(forKey: "first_name") as? String ?? ""
                    self.name2Get = self.faceBookDic.object(forKey: "last_name") as? String ?? ""
                    self.socialID = self.faceBookDic.object(forKey: "id") as? String ?? ""
                    let info : NSDictionary =  self.faceBookDic.object(forKey: "picture") as! NSDictionary
                    let info2 : NSDictionary =  info.object(forKey: "data") as! NSDictionary
                    let url: NSString = (info2.object(forKey: "url") as? NSString)!
                    //  print(url)
                    self.imgURL = NSURL(string: url as String)!
                    self.emailChkStr = "YES"
                    self.socialRegistaerStr = "facebook"
                    
                    
                    self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=fblogin&email=\(email)&fb_id=\(fbid)&gcm_id=\(self.DeviceToken)&device_type=ios")
                    
                }
            })
        }
    }

    
    @objc private   func FbLoginAPIMethod (baseURL:String , params: String)
    {
        
      //  print(params);
       
        
        var strSocialParameter = String()
        if socialRegistaerStr == "facebook"
        {
            strSocialParameter = "facebook_id"
        }
        else if socialRegistaerStr == "google"
        {
             strSocialParameter = "google_id"
        }
        else if socialRegistaerStr == "twitter"
        {
            strSocialParameter = "twitter_id"
        }
        else if socialRegistaerStr == "instagram"
        {
            strSocialParameter = "instagram_id"
        }
        
       
        let urlString: String = self.imgURL.absoluteString!
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"socialLogin")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(socialRegistaerStr, forKey: "social_entity")
        PostDataValus.setValue(self.nameGet, forKey: "username")
        PostDataValus.setValue(self.emailGet, forKey: "email")
        PostDataValus.setValue(self.name1Get, forKey: "first_name")
        PostDataValus.setValue(self.name2Get, forKey: "last_name")
        PostDataValus.setValue(self.socialID, forKey: strSocialParameter)
        PostDataValus.setValue(DeviceToken, forKey: "gcm_id")
        PostDataValus.setValue("ios", forKey: "device_type")
        PostDataValus.setValue("1", forKey: "is_social")
        PostDataValus.setValue(urlString, forKey: "image")
        
        
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
                var strcode = String()
                if let quantity = responceDic.object(forKey: "code") as? NSNumber
                {
                    strcode =  String(describing: quantity)
                }
                else if let quantity = responceDic.object(forKey: "code") as? String
                {
                    strcode = quantity
                }
                
                if strcode == "0"
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.dataDic)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    
                     self.getProfileAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getProfile")
                    
                    // UserDefaults.standard.set(self.dataDic, forKey: "UserId")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else if strcode == "1"
                {
                    
                    if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        self.strUserId =  String(describing: quantity)
                    }
                    else if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? String
                    {
                       self.strUserId = String(describing: quantity)
                    }
                    
                    self.AddMobileNumber()
                }
                else if strcode == "2"
                {
                    if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? NSNumber
                    {
                        self.strUserId =  String(describing: quantity)
                    }
                    else if let quantity =  (responceDic.object(forKey: "userDetails") as? NSDictionary)?.value(forKey: "id") as? String
                    {
                        self.strUserId = String(describing: quantity)
                    }
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                    foodVC?.UsearID = String(describing: self.strUserId)
                    self.navigationController?.pushViewController(foodVC!, animated: true)
                }
                else if strcode == "3"
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
                else
                {
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.dataDic = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.dataDic)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    self.getProfileAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getProfile")
                    
                   // UserDefaults.standard.set(self.dataDic, forKey: "UserId")
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)

                }
                else if (responceDic.object(forKey: "responseCode") as! NSNumber) == 404
                {
                    self.ResponseMessage = responceDic.object(forKey: "responseMessage")  as! String
                    self.TwitterCheckAction()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if (Message.isEqual("Your Account is not verified."))
                    {
                        self.strUserId = responceDic.object(forKey: "user_id")  as! String
                        
                        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                        foodVC?.UsearID = String(describing: self.strUserId)
                        self.navigationController?.pushViewController(foodVC!, animated: true)
                    }
                    else if (Message.isEqual("Oops! Your account does not exist. Kindly register first!"))
                    {
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                        self.navigationController?.pushViewController(myVC!, animated: true)
                        
                        myVC?.emailGet = self.emailGet
                        myVC?.nameGet = self.nameGet
                        myVC?.socialID = self.socialID
                        myVC?.emailChkStr = self.emailChkStr
                        myVC?.imgURL = self.imgURL
                        myVC?.socialRegistaerStr = self.socialRegistaerStr
                        
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                        
                    }
                    }
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    
    @objc private  func getProfileAPIMethod (baseURL:String , params: String)
    {
        
        let data2 = UserDefaults.standard.object(forKey: "UserId") as? Data
        let myArray: NSDictionary = (NSKeyedUnarchiver.unarchiveObject(with: data2!) as? NSDictionary)!
        let strUserID: String = myArray.value(forKey: "id") as! String
        
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
                }
                else
                {
                  
                }
            }
        }) { (error) in
          //  AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    
    func AddMobileNumber()
    {
        popview4.isHidden=false
        footerView4.isHidden=false
        countryCodeTF.text = ""
        countryCodeTF.placeholder = ""
        forgotPassWordTF.text=""
        forgotPassWordTF.placeholder=""
        countryCodeTF.removeFromSuperview()
        forgotPassWordTF.removeFromSuperview()
        
        popview4.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview4.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview4)
        
        footerView4.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-100, width:300, height:200)
        footerView4.backgroundColor = UIColor.white
        popview4.addSubview(footerView4)
        
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:0, width:footerView4.frame.size.width, height:40)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Add Mobile Number"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 15)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView4.addSubview(forgotlab)
        
        
        let labUnderline = UILabel()
        labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerView4.frame.size.width, height:2)
        labUnderline.backgroundColor = UIColor.darkGray
        labUnderline.isHidden=true
        footerView4.addSubview(labUnderline)
        
        
        
        
        
        countryCodeTF = ACFloatingTextfield()
        countryCodeTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:60, height:45)
        countryCodeTF.delegate = self
        countryCodeTF.placeholder = "CCode"
        countryCodeTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        countryCodeTF.lineColor=UIColor.lightGray
        countryCodeTF.keyboardType=UIKeyboardType.numberPad
        countryCodeTF.autocorrectionType = UITextAutocorrectionType.no
        countryCodeTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        countryCodeTF.isUserInteractionEnabled=false
        self.footerView4.addSubview(countryCodeTF)
        
        CountryPicker.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:65, height:45)
        CountryPicker.addTarget(self, action: #selector(self.CountryPickerButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.footerView4.addSubview(CountryPicker)
        
      
        
        

        forgotPassWordTF = ACFloatingTextfield()
      //  forgotPassWordTF.frame = CGRect(x:10, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:250, height:45)
        forgotPassWordTF.frame = CGRect(x:75, y:labUnderline.frame.size.height+labUnderline.frame.origin.y+15, width:215, height:45)
        forgotPassWordTF.delegate = self
        forgotPassWordTF.placeholder = "Mobile Number"
        forgotPassWordTF.placeHolderColor=UIColor.lightGray
        forgotPassWordTF.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.lineColor=UIColor.lightGray
        forgotPassWordTF.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        forgotPassWordTF.keyboardType=UIKeyboardType.numberPad
        forgotPassWordTF.autocorrectionType = .no
        forgotPassWordTF.autocapitalizationType = .none
        forgotPassWordTF.spellCheckingType = .no
        footerView4.addSubview(forgotPassWordTF)
        
        
        CancelButton4.frame = CGRect(x:10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView4.frame.size.width/2-15, height:40)
        CancelButton4.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        CancelButton4.setTitle("Cancel", for: .normal)
        CancelButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        CancelButton4.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
        CancelButton4.titleLabel?.textAlignment = .center
        CancelButton4.addTarget(self, action: #selector(ViewController.cancelButtonAction4(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(CancelButton4)
        
        
        DoneButton4.frame = CGRect(x:CancelButton4.frame.size.width+CancelButton4.frame.origin.x+10, y:forgotPassWordTF.frame.size.height+forgotPassWordTF.frame.origin.y+35, width:footerView4.frame.size.width/2-15, height:40)
        DoneButton4.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
        DoneButton4.setTitle("Done", for: .normal)
        DoneButton4.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
        DoneButton4.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        DoneButton4.titleLabel?.textAlignment = .center
        DoneButton4.addTarget(self, action: #selector(self.AddMobileDoneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView4.addSubview(DoneButton4)
        
        
        
        self.forgotPassWordTF.text = ""
        self.countryCodeTF.text = ""
        
        self.setUsersClosestCity()
        
        self.addDoneButtonOnKeyboard6()
    }
    
    
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
                // print("Locarion Error :\((error?.localizedDescription)! as String)")
                //     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
            }
            else{
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.isoCountryCode != nil
                {
                    //  print(placeMark.isoCountryCode! as String)
                    
                    self.strApiCheck = "4"
                    let iosCode = placeMark.isoCountryCode! as String
                    self.diallingCode.getForCountry(iosCode)
                }
            }
        }
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
    
    // MARK: Country picker Button Action :
    func CountryPickerButtonAction(_ sender: UIButton!)
    {
        let vc = SLCountryPickerViewController()
        vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
            self.strApiCheck = "4"
            self.diallingCode.getForCountry(code!)
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: Cancel Button Action :
    func cancelButtonAction4(_ sender: UIButton!)
    {
        popview4.isHidden=true
        footerView4.isHidden=true
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
                self.AddMobileapi()
                
//                strApiCheck = "3"
//                let vc = SLCountryPickerViewController()
//                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
//                    self.diallingCode.getForCountry(code!)
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Mobile Number", view: self)
            }
        }
        
    }
    
    func AddMobileapi()
    {
        
        var Ccode=String()
        Ccode = countryCodeTF.text!
        var mobileString = String()
        mobileString = String(format: "%@%@",Ccode,forgotPassWordTF.text!)
        
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"addPhoneNo")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(self.strUserId, forKey: "user_id")
        PostDataValus.setValue(mobileString, forKey: "phone_no")
   
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
                    
                    self.popview4.isHidden=true
                    self.footerView4.isHidden=true
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOTPVC") as? ConfirmOTPVC
                    foodVC?.UsearID = String(describing: self.strUserId)
                    self.navigationController?.pushViewController(foodVC!, animated: true)
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
    
    
    
    // MARK: Twitter Check one  Action :
    
    func TwitterCheckAction()
    {
        CheckCondition = "2"
    popviewTwit.isHidden=false
    footerViewTwit.isHidden=false
    CheckEmail.text=""
    CheckEmail.placeholder=""
        CheckEmail.removeFromSuperview()
    
    popviewTwit.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
    popviewTwit.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
    self.view.addSubview(popviewTwit)
    
    footerViewTwit.frame = CGRect(x:self.view.frame.size.width/2-150, y:self.view.frame.size.height/2-130, width:300, height:260)
    footerViewTwit.backgroundColor = UIColor.white
    popviewTwit.addSubview(footerViewTwit)
    
    
    let forgotlab = UILabel()
    forgotlab.frame = CGRect(x:10, y:0, width:footerViewTwit.frame.size.width-20, height:100)
    forgotlab.text=ResponseMessage
    forgotlab.textColor=UIColor.black
    forgotlab.numberOfLines = 0
    forgotlab.textAlignment = .center
    footerViewTwit.addSubview(forgotlab)
    
    
    let labUnderline = UILabel()
    labUnderline.frame = CGRect(x:0, y:forgotlab.frame.origin.y+forgotlab.frame.size.height+1, width:footerViewTwit.frame.size.width, height:2)
    labUnderline.backgroundColor = UIColor.darkGray
    labUnderline.isHidden=true
    footerViewTwit.addSubview(labUnderline)
    
    
    
    CheckEmail = ACFloatingTextfield()
    CheckEmail.frame = CGRect(x:10, y:forgotlab.frame.size.height+forgotlab.frame.origin.y+15, width:250, height:45)
    CheckEmail.delegate = self
    CheckEmail.placeholder = "Email Id"
    CheckEmail.placeHolderColor=UIColor.lightGray
    CheckEmail.selectedPlaceHolderColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
    CheckEmail.lineColor=UIColor.lightGray
    CheckEmail.selectedLineColor=#colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
    CheckEmail.keyboardType=UIKeyboardType.emailAddress
    CheckEmail.autocorrectionType = .no
    CheckEmail.autocapitalizationType = .none
    CheckEmail.spellCheckingType = .no
    footerViewTwit.addSubview(CheckEmail)
    
    
    CancelButton2.frame = CGRect(x:10, y:CheckEmail.frame.size.height+CheckEmail.frame.origin.y+35, width:footerViewTwit.frame.size.width/2-15, height:40)
    CancelButton2.backgroundColor=#colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
    CancelButton2.setTitle("Cancel", for: .normal)
    CancelButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
    CancelButton2.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), for: .normal)
    CancelButton2.titleLabel?.textAlignment = .center
    CancelButton2.addTarget(self, action: #selector(ViewController.TwittercancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
    footerViewTwit.addSubview(CancelButton2)
    
    
    DoneButton2.frame = CGRect(x:CancelButton2.frame.size.width+CancelButton2.frame.origin.x+10, y:CheckEmail.frame.size.height+CheckEmail.frame.origin.y+35, width:footerViewTwit.frame.size.width/2-15, height:40)
    DoneButton2.backgroundColor=#colorLiteral(red: 0.1097696498, green: 0.6676027775, blue: 0.8812960982, alpha: 1)
    DoneButton2.setTitle("Done", for: .normal)
    DoneButton2.titleLabel!.font =  UIFont(name:"Helvetica", size: 16)
    DoneButton2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    DoneButton2.titleLabel?.textAlignment = .center
    DoneButton2.addTarget(self, action: #selector(ViewController.TwitterCheckButtonAction(_:)), for: UIControlEvents.touchUpInside)
    footerViewTwit.addSubview(DoneButton2)
        
        CheckEmail.text = ""
        self.addDoneButtonOnKeyboard5()
    }
    
    func addDoneButtonOnKeyboard5()
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
        
        self.CheckEmail.inputAccessoryView = doneToolbar
    }
    
    
    func TwittercancelButtonAction(_ sender: UIButton!)
    {
        self.popviewTwit.isHidden=true
        self.footerViewTwit.isHidden=true
    }
    
    
    // MARK: Done Button Action :
    func TwitterCheckButtonAction(_ sender: UIButton!)
    {
        var message = String()
        if (CheckEmail.text?.isEmpty)!
        {
            message = "Please enter Email Id"
        }
        else if !AFWrapperClass.isValidEmail(CheckEmail.text!)
        {
            message = "Please enter valid Email"
        }
        
        if message.characters.count > 1
        {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            self.ForgotAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=accountSearch&email=\(CheckEmail.text!)")
        }
        
    }

    

    
    // MARK: Google Login Button Action :
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
        
       //  print(user.profile.givenName)
       //  print(user.profile.familyName)
       //  print(user.profile.name)
        
        print(user.profile)
        var email=String()
        email = user.profile.email
        
        var fbid=String()
        fbid = user.userID
        
        if GIDSignIn.sharedInstance().currentUser.profile.hasImage
        {
            imageURL = user.profile.imageURL(withDimension: UInt(120)) as NSURL
            //  print("Image Url : \(imageURL)")
        }
    
        emailGet = user.profile.email
        name1Get = user.profile.givenName
        name2Get = user.profile.familyName
        nameGet = user.profile.name
        socialID = user.userID
        emailChkStr = "YES"
        imgURL = imageURL
        socialRegistaerStr = "google"
        print(name1Get)
        print(name2Get)
        
        self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=googlelogin&email=\(email)&google_id=\(fbid)&gcm_id=\(self.DeviceToken)&device_type=ios")
        
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

    
    
     // MARK: Twitter Login Button Action :
    
    
    func twitterloginButtonAction(_ sender: UIButton!)
    {
    
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                let twUsername = session?.userName
                print( twUsername!)

//                let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
//                    client.loadUser(withID: Twitter.sharedInstance().sessionStore.session()!.userID, completion: {(_, user: TWTRUser?, _, error: Error?) ->
//                            self.imageURL = NSURL(string:  (user?.profileImageURL)!)!
//                         print(self.imageURL)
//                })
//
                self.TwitterCheckId = (session?.userID)!

                //   self.imageURL = NSURL(string:  (session?.profileImageURL)!)!
                self.emailChkStr = "NO"
                self.nameGet = (session?.userName)!
                self.name1Get = (session?.userName)!
                self.name2Get = ""
                self.socialID = (session?.userID)!
                self.imgURL = self.imageURL
                self.socialRegistaerStr = "twitter"

                  self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=twitterlogin&twitter_id=\(self.socialID)&gcm_id=\(self.DeviceToken)&device_type=ios")

                let stores = Twitter.sharedInstance().sessionStore
                if let userID = stores.session()?.userID {
                    stores.logOutUserID(userID)
                    Twitter.sharedInstance().sessionStore.logOutUserID(userID)
                }

            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
    }
    
    

//     func twitterloginButtonAction(_ sender: UIButton!)
//     {
//       //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//
//
//
//
//        Twitter.sharedInstance().logIn { session, error in
//            if (session != nil) {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//
//                let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
//                client.loadUser(withID: Twitter.sharedInstance().sessionStore.session()!.userID, completion: {(_ user: TWTRUser?, _ error: Error?) -> Void in
//                    //    print("\(user?.profileImageURL)")
//
//                    self.imageURL = NSURL(string:  (user?.profileImageURL)!)!
//
//                    //  print(self.imageURL)
//
//
//
//                })
//
//
//
//
//
//                let stores = Twitter.sharedInstance().sessionStore
//                if let userID = stores.session()?.userID {
//                    stores.logOutUserID(userID)
//                    Twitter.sharedInstance().sessionStore.logOutUserID(userID)
//                }
//            } else {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                AFWrapperClass.alert(Constants.applicationName, message: (error?.localizedDescription)!, view: self)
//                //   print("error: \(String(describing: error?.localizedDescription))")
//            }
//        }
//
//
//        Twitter.sharedInstance().logIn { session, error in
//            if (session != nil) {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//              //  print("signed in as \(session?.)")
//              //  print("signed in as \(session?.userID)")
//
//                var fbid=String()
//                fbid = (session?.userID)!
//
//                self.TwitterCheckId = (session?.userID)!
//
//             //   self.imageURL = NSURL(string:  (session?.profileImageURL)!)!
//                self.emailChkStr = "NO"
//                self.nameGet = (session?.userName)!
//                 self.name1Get = (session?.userName)!
//                self.name2Get = ""
//                self.socialID = (session?.userID)!
//                self.imgURL = self.imageURL
//                self.socialRegistaerStr = "twitter"
//
//
//                print(self.nameGet)
//                print(self.socialID)
//                print(self.imgURL)
//
//
//
////                let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
////                client.loadUser(withID: Twitter.sharedInstance().sessionStore.session()!.userID, completion: {(_, user: TWTRUser?, _, error: Error?) ->
////                    self.imageURL = NSURL(string:  (user?.profileImageURL)!)!
////                    emailChkStr = "NO"
////                    nameGet = (session?.userName)!
////                    socialID = (session?.userID)!
////                    imgURL = self.imageURL
////                    socialRegistaerStr = "Twitter"
////                })
//
//               // var email=String()
//              //  email = "Bharath@hmail.com"
//
//                self.FbLoginAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=twitterlogin&twitter_id=\(fbid)&gcm_id=\(self.DeviceToken)&device_type=ios")
//
//
//                let stores = Twitter.sharedInstance().sessionStore
//                if let userID = stores.session()?.userID {
//                    stores.logOutUserID(userID)
//                    Twitter.sharedInstance().sessionStore.logOutUserID(userID)
//                }
//            } else {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                AFWrapperClass.alert(Constants.applicationName, message: (error?.localizedDescription)!, view: self)
//              //  print("error: \(String(describing: error?.localizedDescription))")
//            }
//        }
//
//     }
//
//
    
    
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
        
    }


}

