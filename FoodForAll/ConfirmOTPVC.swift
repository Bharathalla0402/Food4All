//
//  ConfirmOTPVC.swift
//  FoodForAll
//
//  Created by amit on 4/24/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ConfirmOTPVC: UIViewController,UITextFieldDelegate
{

    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sisthTF: UITextField!
    
    var UsearID = String()
    var otpStr = String()
    
    
    
    @IBOutlet weak var redLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTF.delegate = self
        secondTF.delegate = self
        thirdTF.delegate = self
        fourthTF.delegate = self
        fifthTF.delegate = self
        sisthTF.delegate = self
        
        firstTF.becomeFirstResponder()
        
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
        
        self.firstTF.inputAccessoryView = doneToolbar
        self.secondTF.inputAccessoryView = doneToolbar
        self.thirdTF.inputAccessoryView = doneToolbar
        self.fourthTF.inputAccessoryView = doneToolbar
        self.fifthTF.inputAccessoryView = doneToolbar
        self.sisthTF.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
 // MARK: TextField Delegates:
    
func textField(_ textField: UITextField, shouldChangeCharactersIn shouldChangeCharactersInRangerange: NSRange, replacementString string: String)-> Bool

    {
        let newString = ((textField.text)! as NSString).replacingCharacters(in: shouldChangeCharactersInRangerange, with: string)
        
      let newLength = newString.characters.count
        
        if (textField == firstTF)
        {
            if (newLength == 1)
            {
                firstTF.text = newString
                secondTF.becomeFirstResponder()
                return false
            }
        }
        if (textField == secondTF)
        {
            if (newLength == 1)
            {
                secondTF.text = newString
                thirdTF.becomeFirstResponder()
                return false
            }
        }
        if (textField == thirdTF)
        {
            if (newLength == 1)
            {
                thirdTF.text = newString
                fourthTF.becomeFirstResponder()
                return false
            }
        }
        if (textField == fourthTF)
        {
            if (newLength == 1)
            {
                fourthTF.text = newString
                fifthTF.becomeFirstResponder()
                return false
            }
        }
        if (textField == fifthTF)
        {
            if (newLength == 1)
            {
                fifthTF.text = newString
                sisthTF.becomeFirstResponder()
                return false
            }
        }
        if (textField == sisthTF)
        {
            if (newLength == 1)
            {
                sisthTF.text = newString
                sisthTF.resignFirstResponder()
                return true
            }
        }
        return newLength <= 1
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == firstTF {
            redLabel.frame = CGRect(x:firstTF.frame.origin.x, y:37, width:30, height:2)
        }
        else if  textField == secondTF {
            redLabel.frame = CGRect(x:secondTF.frame.origin.x, y:37, width:30, height:2)
        }
        else if  textField == thirdTF {
            redLabel.frame = CGRect(x:thirdTF.frame.origin.x, y:37, width:30, height:2)
        }
        else if  textField == fourthTF {
            redLabel.frame = CGRect(x:fourthTF.frame.origin.x, y:37, width:30, height:2)
        }
        else if  textField == fifthTF {
            redLabel.frame = CGRect(x:fifthTF.frame.origin.x, y:37, width:30, height:2)
        }
        else if  textField == sisthTF {
            redLabel.frame = CGRect(x:sisthTF.frame.origin.x, y:37, width:30, height:2)
        }
        
    }
    
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        otpStr = String(format:"%@%@%@%@%@%@",firstTF.text!,secondTF.text!,thirdTF.text!,fourthTF.text!,fifthTF.text!,sisthTF.text!)
        
        self.otpAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=verifyotp&id=\(UsearID)&otp=\(otpStr)")
    }
    
    
    
    
    
    
    @objc private   func otpAPIMethod (baseURL:String , params: String)
    {
     //   print(params);
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"verifyOtp")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(UsearID, forKey: "user_id")
        PostDataValus.setValue(otpStr, forKey: "otp")
        
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
                   // let UserResponse:NSDictionary = responceDic.object(forKey: "userDetails")  as! NSDictionary
                   // UserDefaults.standard.set(UserResponse, forKey: "UserId")
                    
                     let dataDic:NSDictionary = (responceDic.object(forKey: "userDetails") as? NSDictionary)!
                    
                    let currentDefaults: UserDefaults? = UserDefaults.standard
                    let data = NSKeyedArchiver.archivedData(withRootObject: dataDic)
                    currentDefaults?.set(data, forKey: "UserId")
                    
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(foodVC!, animated: true)
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

    @IBAction func ResendButtonAction(_ sender: Any)
    {
         self.ReverifyotpAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=resendotp&user_id=\(UsearID)")
    }
    
    
    @objc private   func ReverifyotpAPIMethod (baseURL:String , params: String)
    {
      //  print(params);
        
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"resendotp")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(UsearID, forKey: "user_id")
        
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

    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
