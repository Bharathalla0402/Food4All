//
//  CongratulationVC.swift
//  FoodForAll
//
//  Created by amit on 5/8/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class CongratulationVC: UIViewController {

    
    var userIDStr = String()
    var titleFBstr = String()
    var discriptionStr = String()
    var imageStr = String()
    var latitudeStr = String()
    var longitudeStr = String()
    var cityStr = String()
    var sliderString = String()
    
    var foodBankIDStr = String()
    
   
    @IBOutlet weak var SliderVal: WOWMarkSlider!
    var myArray = NSDictionary()
    var strUserID = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderString = String(format:"0")
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        strUserID=myArray.value(forKey: "id") as! NSString
        
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.SliderVal.setValue((round(sender.value / 5) * 5), animated: false)
       // print("\(sender.value)")
        let integere: Int = Int((round(sender.value / 5) * 5))
        sliderString = String(integere)
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        
        self.saveFoodbankAPImethod()
    }
    
    // MARK:  Save FppdBank API Method:
    
    @objc private  func saveFoodbankAPImethod () -> Void
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
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=get_FoodBanks&fbank_id=\(foodBankIDStr)&percentage=\(sliderString)&userid=\(strUserID)"
      //  print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
             //   print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
//                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBanksVc") as? FoodBanksVc
//                    self.navigationController?.pushViewController(myVC!, animated: false)
                    
                     _ = self.navigationController?.popToRootViewController(animated: true)
                    
//                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController
//                    self.navigationController?.pushViewController(myVC!, animated: true)
//                    
//                    myVC?.selectedIndex=1
                    
                  //  _ = self.navigationController?.popViewController(animated: true)
                    
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
    

    
    @IBAction func backButtonAction(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
