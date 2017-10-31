//
//  AppDelegate.swift
//  FoodForAll
//
//  Created by amit on 4/24/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import Fabric
import TwitterKit
import UserNotifications
import InstagramKit
import PinterestSDK

var appInstance : AppDelegate!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate
{

    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var instagram = Instagram()
    var myArray = NSDictionary()
    var strUserID = NSString()
     var DeviceToken=String()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            strUserID=myArray.value(forKey: "id") as! NSString
        }
        else
        {
            strUserID = ""
        }
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            
        }

        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        
       // GMSServices.provideAPIKey("AIzaSyBTSfCwuVANo-W_O3PfncD4MS4ehXFZJH4")
       // GMSPlacesClient.provideAPIKey("AIzaSyBTSfCwuVANo-W_O3PfncD4MS4ehXFZJH4")
        
        GMSServices.provideAPIKey("AIzaSyAFhk1Wyc6H_13J-e2JxhTH26vb9ivVj7U")
        GMSPlacesClient.provideAPIKey("AIzaSyAFhk1Wyc6H_13J-e2JxhTH26vb9ivVj7U")
        
        // Initialize sign-in
        //        var configureError: NSError?
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        //        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        Fabric.with([Twitter.self])
        
        appInstance = self
        
        //MARK: Pinterest
        PDKClient.configureSharedInstance(withAppId: "4911060408302846769")
        
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        let center = UNUserNotificationCenter.current()
        center.delegate=self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        registerForPushNotifications(application: application)
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "NCount")
        
       // self.getDashBoardAPImethod()

        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mvc: TabViewController? = (storyboard.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController)
//        
//        let rearVC: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
//        
//        let nav = UINavigationController(rootViewController: mvc!)
//        let smVC = UINavigationController(rootViewController: rearVC!)
//        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
//        
//        window?.rootViewController = revealController
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    
    func getDashBoardAPImethod () -> Void
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=get_sliderDashboard&gcm_id=\(DeviceToken)&device_type=ios&user_id=\(strUserID)&lat=\(currentLatitude)&lon=\(currentLongitude)"
        print(params)
      
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                }
                else
                {
                    
                }
            }
        }) { (error) in
            
        
        }
    }
    

    
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        if Twitter.sharedInstance().application(app, open:url, options: options) {
            return true
        }
        
        
        
        if PDKClient.sharedInstance().handleCallbackURL(url)
        {
            return true
        }
        
        
        
        
        
        if !url.absoluteString.contains("160743847789712")
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        }else{
            if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            {
            return true
            }
           return false
        }
        
       
    }

    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
           
            
        }
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        DeviceToken = deviceTokenString
        
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
        
      //  self.getDashBoardAPImethod()
        
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.post(name: notificationName, object: nil)
       
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       print(response.notification.request.content.userInfo)
        
        let dic = response.notification.request.content.userInfo as NSDictionary
        
        if let aps = dic["aps"] as? [String: Any] {
            
            if let alert = aps["type"] as? String
            {
                print(alert) // Achievement Completed
                
                if alert == "1"
                {
                    let userID:String = (aps["user_id"] as? String)!
                    if userID == strUserID as String
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: MyFoodBankDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                        // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                      //  home?.foodbankID = NSString(format: "%@", useID) as String
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: FoodBankDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                     //   let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                     //   home?.foodbankID = NSString(format: "%@", useID) as String
                       // home?.foodbankID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                    }
                    
                    UserDefaults.standard.set("1", forKey: "fbState")
                }
                else if alert == "2"
                {
                    let userID:String = (aps["user_id"] as? String)!
                    if userID == strUserID as String
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: MyFoodShareDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.SharedMealID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.SharedMealID = quantity
                        }
                       // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                       // home?.SharedMealID = NSString(format: "%@", useID) as String
                        // home?.SharedMealID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                        
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: EventsDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                           let strval: String = (quantity: quantity.stringValue) as! String
                            home?.SharedMealID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.SharedMealID = quantity
                        }
                      //  let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                       // home?.SharedMealID = NSString(format: "%@", useID) as String
                        // home?.SharedMealID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                        
                    }
                    
                    UserDefaults.standard.set("1", forKey: "fsState")
                }
                else if alert == "3"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: ChatingDetailsViewController? = (storyboard.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.strConversionId = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.strConversionId = quantity
                    }
                   // home?.strConversionId = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController
                    
                    UserDefaults.standard.set("1", forKey: "CState")
                }
                else if alert == "4"
                {
                    let userID:String = (aps["user_id"] as? String)!
                    if userID == strUserID as String
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: MyEventsDetailsViewController? = (storyboard.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                       // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                       // home?.foodbankID = NSString(format: "%@", useID) as String
                        // home?.foodbankID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                        
                    }
                    else
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: EventsDetailsViewController? = (storyboard.instantiateViewController(withIdentifier: "EventsDetailsViewController") as? EventsDetailsViewController)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                       // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                       // home?.foodbankID = NSString(format: "%@", useID) as String
                        // home?.foodbankID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                        
                    }
                    
                    UserDefaults.standard.set("1", forKey: "EVState")
                }
                else if alert == "5"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: MyEventsDetailsViewController? = (storyboard.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.foodbankID = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.foodbankID = quantity
                    }
                   // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                   // home?.foodbankID = NSString(format: "%@", useID) as String
                    // home?.foodbankID = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController
 
                }
                else if alert == "6"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: MyFoodShareDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.SharedMealID = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.SharedMealID = quantity
                    }
                   // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                   // home?.SharedMealID = NSString(format: "%@", useID) as String
                  //  home?.SharedMealID = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController
 
                }
                else if alert == "7"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: MyFoodBankDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.foodbankID = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.foodbankID = quantity
                    }
                    // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                    //  home?.foodbankID = NSString(format: "%@", useID) as String
                   // home?.foodbankID = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController
                }
                else if alert == "8"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: MyFoodShareDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.SharedMealID = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.SharedMealID = quantity
                    }
                  //  let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                  //  home?.SharedMealID = NSString(format: "%@", useID) as String
                  //  home?.SharedMealID = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController

                }
                else if alert == "9"
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home: MyEventsDetailsViewController? = (storyboard.instantiateViewController(withIdentifier: "MyEventsDetailsViewController") as? MyEventsDetailsViewController)
                    let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                    if let quantity = aps["type_id"] as? NSNumber
                    {
                        let strval: String = (quantity: quantity.stringValue) as! String
                        home?.foodbankID = strval as String
                    }
                    else if let quantity = aps["type_id"] as? String
                    {
                        home?.foodbankID = quantity
                    }
                   // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                   // home?.foodbankID = NSString(format: "%@", useID) as String
                  //  home?.foodbankID = (aps["type_id"] as? String)!
                    home?.checkString = "1"
                    let nav = UINavigationController(rootViewController: home!)
                    let smVC = UINavigationController(rootViewController: slidemenu!)
                    let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                    window?.rootViewController = revealController
                }
                else if alert == "10"
                {
                    let userID:String = (aps["user_id"] as? String)!
                    if userID == strUserID as String
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: MyFoodBankDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                            let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                        // let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                        //  home?.foodbankID = NSString(format: "%@", useID) as String
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let home: FoodBankDetailsVC? = (storyboard.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC)
                        let slidemenu: RearViewController? = (storyboard.instantiateViewController(withIdentifier: "RearViewController") as? RearViewController)
                        
                        if let quantity = aps["type_id"] as? NSNumber
                        {
                           let strval: String = (quantity: quantity.stringValue) as! String
                            home?.foodbankID = strval as String
                        }
                        else if let quantity = aps["type_id"] as? String
                        {
                            home?.foodbankID = quantity
                        }
                        //   let useID:NSNumber=(aps["type_id"] as? CVarArg)! as! NSNumber
                        //   home?.foodbankID = NSString(format: "%@", useID) as String
                        // home?.foodbankID = (aps["type_id"] as? String)!
                        home?.checkString = "1"
                        let nav = UINavigationController(rootViewController: home!)
                        let smVC = UINavigationController(rootViewController: slidemenu!)
                        let revealController = SWRevealViewController(rearViewController: smVC, frontViewController: nav)
                        window?.rootViewController = revealController
                    }
                    
                    UserDefaults.standard.set("1", forKey: "fbState")
                }
                else
                {
                
                
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
         print(notification.request.content.userInfo)
        let dic = notification.request.content.userInfo as NSDictionary
        
        if let aps = dic["aps"] as? [String: Any] {
            
            if let alert = aps["foodshare"] as? String {
                print(alert) // Achievement Completed
            }
            
        }
    }
    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
//        print(deviceTokenString)
//        
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        
//        print("i am not available in simulator \(error)")
//        
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    //MARK: ----LOADER----
    
    func hideLoader()
    {
        self.window?.isUserInteractionEnabled = true
        GMDCircleLoader.hide(from: self.window, animated: true)
    }
    
    func showLoader()
    {
        self.window?.isUserInteractionEnabled = false
        GMDCircleLoader.setOn(self.window, withTitle: "", animated: true)
    }

}

