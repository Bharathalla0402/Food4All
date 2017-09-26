//
//  SettingsVC.swift
//  FoodForAll
//
//  Created by amit on 4/26/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit


class SettingsVC: UIViewController {

   
    @IBOutlet weak var FoodbankSlider: WOWMarkSlider!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var eventsSlider: WOWMarkSlider!
    @IBOutlet weak var eventsLabelSlid: UILabel!
    
    @IBOutlet weak var facebookSwitch: UISwitch!
    @IBOutlet weak var twitterSwitch: UISwitch!
    @IBOutlet weak var googleSwitch: UISwitch!
    @IBOutlet weak var foodBankSwitch: UISwitch!
    @IBOutlet weak var foodShareSwitch: UISwitch!
    @IBOutlet weak var EventsSwitch: UISwitch!
    @IBOutlet weak var identitySwitch: UISwitch!
   
    @IBOutlet weak var identitylabel: UILabel!
     var alertCtrl2: UIAlertController?
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var strFacebook = NSString()
    var strTwitter = NSString()
    var strGoogle = NSString()
    var strfoodBank = NSString()
    var strfoodShare = NSString()
    var strEvents = NSString()
    var strIdentity = NSString()
    var straddress = String()
    
    
    var postsee = NSString()
    var postsee2 = NSString()
    var postgoogle = NSString()
    var posttwitter = NSString()
    var postfacebook = NSString()
    var postfoodbank = NSString()
    var postfoodshare = NSString()
    var postEvent = NSString()
    var postsetting = NSString()
     var userData = NSDictionary()

    var listArraySettings = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlertCtrl2()

    //  identitylabel.isHidden = true
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        strUserID=myArray.value(forKey: "id") as! NSString
        straddress=myArray.value(forKey: "address") as! String

        self.getProfileAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getProfile&user_id=\(strUserID)")
        
        if UserDefaults.standard.object(forKey: "Value") != nil
        {
            postsee = UserDefaults.standard.object(forKey: "Value") as! NSString
            
            print(postsee)
            
           
            
            if postsee == ""
            {
                self.FoodbankSlider.value = Float(5000)
                
                let attrString = NSMutableAttributedString(string: "5000",
                                                           attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
                
                attrString.append(NSMutableAttributedString(string: "Kms",
                                                            attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
                self.kmLabel.attributedText! = attrString
            }
            else
            {
                self.FoodbankSlider.value = Float(postsee as String)!
                
                let attrString = NSMutableAttributedString(string: postsee as String,
                                                           attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
                
                attrString.append(NSMutableAttributedString(string: "Kms",
                                                            attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
                self.kmLabel.attributedText! = attrString
            }
            
            
          
        }
        else
        {
            self.FoodbankSlider.value = Float(100)
            
            let attrString = NSMutableAttributedString(string: "100",
                                                       attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
            
            attrString.append(NSMutableAttributedString(string: "Kms",
                                                        attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
            self.kmLabel.attributedText! = attrString
            
        }
        
         self.ProfileSettinglistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=getSetting&userId=\(strUserID)")
        
    }
    
    
    func setupAlertCtrl2() {
        
        alertCtrl2 = UIAlertController(title: "Please Update Your Location to get the Notifications", message: nil, preferredStyle: .actionSheet)
        //Create an action
        let Report = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.locationUpdate()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: { _ in })
        })
        alertCtrl2?.addAction(Report)
        alertCtrl2?.addAction(cancel)
    }
    
    @objc private  func getProfileAPIMethod (baseURL:String , params: String)
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.userData = (responceDic.object(forKey: "profileDetail") as? NSDictionary)!
                    self.straddress = (self.userData.object(forKey: "address") as! String?)!
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

    
    
    
    @objc private  func ProfileSettinglistAPIMethod (baseURL:String , params: String)
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
                    self.listArraySettings = (responceDic.object(forKey: "settingDetail") as? NSDictionary)!
                    
                    let sValue:String = (self.listArraySettings.value(forKey: "range_foodbank") as! String)
                    
                    UserDefaults.standard.set(sValue, forKey: "Value")
                    
                    
                    if sValue == ""
                    {
                        self.FoodbankSlider.value = Float(5000)
                        
                        let attrString = NSMutableAttributedString(string: "5000",
                                                                   attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
                        
                        attrString.append(NSMutableAttributedString(string: "Kms",
                                                                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
                        self.kmLabel.attributedText! = attrString
                    }
                    else
                    {
                        self.FoodbankSlider.value = Float(sValue as String)!
                        
                        let attrString = NSMutableAttributedString(string: sValue as String,
                                                                   attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
                        
                        attrString.append(NSMutableAttributedString(string: "Kms",
                                                                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
                        self.kmLabel.attributedText! = attrString
                    }

                    
//                    self.postsee2=(self.listArraySettings.object(forKey: "range_foodshare") as? String)! as NSString
                    
//                    let sValue2:String = (self.listArraySettings.value(forKey: "range_foodshare") as! String)
//                    if sValue2 == "" {
//                        self.eventsSlider.value = 5000
//                        
//                        let attrString2 = NSMutableAttributedString(string: "5000",
//                                                                    attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
//                        
//                        attrString2.append(NSMutableAttributedString(string: "Kms",
//                                                                     attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
//                        
//                        self.eventsLabelSlid.attributedText! = attrString2
//                        
//                    }
//                    else{
//                        self.eventsSlider.value = Float(sValue2)!
//                        
//                        let attrString2 = NSMutableAttributedString(string: self.postsee2 as String,
//                                                                    attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
//                        
//                        attrString2.append(NSMutableAttributedString(string: "Kms",
//                                                                     attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
//                        
//                        self.eventsLabelSlid.attributedText! = attrString2
                        
 //                   }
                    
                    
                                      
                    
                    self.postfoodbank=(self.listArraySettings.object(forKey: "notification_foodbank") as? String)! as NSString
                    if self.postfoodbank == "2"
                    {
                        self.foodBankSwitch.setOn(true, animated: false)
                        self.strfoodBank="2"
                    }
                    else
                    {
                        self.foodBankSwitch.setOn(false, animated: false)
                        self.strfoodBank="1"
                    }
                    
                    self.postfoodshare=(self.listArraySettings.object(forKey: "notification_foodshare") as? String)! as NSString
                    if self.postfoodshare == "2"
                    {
                        self.foodShareSwitch.setOn(true, animated: false)
                        self.strfoodShare="2"
                    }
                    else
                    {
                        self.foodShareSwitch.setOn(false, animated: false)
                        self.strfoodShare="1"
                    }
                    
                    
                    self.postEvent=(self.listArraySettings.object(forKey: "notification_event") as? String)! as NSString
                    if self.postEvent == "2"
                    {
                        self.EventsSwitch.setOn(true, animated: false)
                        self.strEvents="2"
                    }
                    else
                    {
                        self.EventsSwitch.setOn(false, animated: false)
                        self.strEvents="1"
                    }
                    
                    
                    self.postsetting=(self.listArraySettings.object(forKey: "identity_hidden") as? String)! as NSString
                    if self.postsetting == "2"
                    {
                        self.identitySwitch.setOn(true, animated: false)
                        self.strIdentity="2"
                        
                        self.identitylabel.isHidden = false
                        
                    }
                    else
                    {
                        self.identitySwitch.setOn(false, animated: false)
                        self.strIdentity="1"
                        
                        self.identitylabel.isHidden = true
                    }
                    
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

    

    
    @IBAction func kmSliderValueChanged(_ sender: UISlider)
    {
        self.FoodbankSlider.setValue(round(sender.value / 5) * 5, animated: false)
        
        let integere: Int = Int((round(sender.value / 5) * 5))
        //kmLabel.text! = String(integere)
        
        let attrString = NSMutableAttributedString(string: String(integere) as String,
                                                   attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
        
        attrString.append(NSMutableAttributedString(string: "Kms",
                                                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
        self.kmLabel.attributedText! = attrString
        
        self.postsee = String(integere) as NSString
        
        UserDefaults.standard.set(self.postsee, forKey: "Value")
    }
    
    @IBAction func eventsSliderValueChanged(_ sender: UISlider) {
        let integere: Int = Int(sender.value as Float)
       // eventsLabelSlid.text! = String(integere)
        
        let attrString = NSMutableAttributedString(string: String(integere) as String,
                                                   attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 15) ])
        
        attrString.append(NSMutableAttributedString(string: "Kms",
                                                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11) ]))
        self.eventsLabelSlid.attributedText! = attrString
        
        self.postsee2 = String(integere) as NSString
    }
    
    
    @IBAction func FacebookValueChanged(_ sender: UISwitch)
    {
        if facebookSwitch.isOn
        {
          strFacebook="2"
        }
        else
        {
          strFacebook="1"
        }
    }
    
    @IBAction func TwitterSwitchChanged(_ sender: UISwitch)
    {
        if twitterSwitch.isOn
        {
           strTwitter="2"
        }
        else
        {
          strTwitter="1"
        }
    }
    
    @IBAction func GoogleSwitchChnaged(_ sender: UISwitch)
    {
        if googleSwitch.isOn
        {
          strGoogle="2"
        }
        else
        {
           strGoogle="1"
        }
    }
    @IBAction func FoodBankSwithchChanged(_ sender: UISwitch)
    {
        
        if !foodBankSwitch.isOn
        {
            strfoodBank="1"
            self.foodBankSwitch.setOn(false, animated: false)
        }
        else
        {
            if straddress.isEmpty
            {
                alertCtrl2?.popoverPresentationController?.sourceView = view
                present(alertCtrl2!, animated: true, completion: {() -> Void in
                })
                self.foodBankSwitch.setOn(false, animated: false)
                strfoodBank="1"
            }
            else
            {
                strfoodBank="2"
                self.foodBankSwitch.setOn(true, animated: false)
            }

        }
        
//        if foodBankSwitch.isOn
//        {
//             strfoodBank="on"
//        }
//        else
//        {
//           strfoodBank="off"
//        }
    }
    
    
    func locationUpdate()
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
        myVC?.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    @IBAction func FoodShareSwitchChanged(_ sender: UISwitch)
    {
        if !foodShareSwitch.isOn
        {
            strfoodShare="1"
            self.foodShareSwitch.setOn(false, animated: false)
        }
        else
        {
            if straddress.isEmpty
            {
                alertCtrl2?.popoverPresentationController?.sourceView = view
                present(alertCtrl2!, animated: true, completion: {() -> Void in
                })
                self.foodShareSwitch.setOn(false, animated: false)
                strfoodShare="1"
            }
            else
            {
                strfoodShare="2"
                self.foodShareSwitch.setOn(true, animated: false)
            }
            
        }
        
//        if foodShareSwitch.isOn
//        {
//            strfoodShare="on"
//        }
//        else
//        {
//            strfoodShare="off"
//        }
    }
  
    @IBAction func EventsSwitchChanged(_ sender: UISwitch)
    {
        if !EventsSwitch.isOn
        {
            strEvents="1"
            self.EventsSwitch.setOn(false, animated: false)
        }
        else
        {
            if straddress.isEmpty
            {
                alertCtrl2?.popoverPresentationController?.sourceView = view
                present(alertCtrl2!, animated: true, completion: {() -> Void in
                })
                self.EventsSwitch.setOn(false, animated: false)
                strEvents="1"
            }
            else
            {
                strEvents="2"
                self.EventsSwitch.setOn(true, animated: false)
            }
            
        }
        
//        if EventsSwitch.isOn
//        {
//            strEvents="on"
//        }
//        else
//        {
//            strEvents="off"
//        }
    }
    
    
    @IBAction func IdentityValueChanged(_ sender: UISwitch)
    {
        if identitySwitch.isOn
        {
           strIdentity="2"
            
            self.identitylabel.isHidden = false
        }
        else
        {
           strIdentity="1"
            
            self.identitylabel.isHidden = true
        }
    }
    
  
    @IBAction func SaveSettingsClicked(_ sender: Any)
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=updateSetting&userId=\(strUserID)&range_foodbank=\(self.postsee)&range_foodshare=\(self.postsee2)&facebook=\(strFacebook)&twitter=\(strTwitter)&google_plus=\(strGoogle)&identity_hidden=\(strIdentity)&notification_foodbank=\(strfoodBank)&notification_foodshare=\(strfoodShare)&notification_event=\(strEvents)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
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
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
