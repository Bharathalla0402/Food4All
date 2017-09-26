//
//  RearViewController.swift
//  FoodForAll
//
//  Created by amit on 4/26/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI

class RearViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var profileBackView: UIView!
    @IBOutlet weak var BackGroundView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var myArray = NSDictionary()
    
    @IBOutlet weak var logoutView: UIView!
    var strUserID = NSString()
    var bgLabel = UILabel()
    
    @IBOutlet weak var CategroScrool: UIScrollView!
    @IBOutlet weak var tabl: UITableView!
    var cell: Customcell1!
    
    var arrtitle : NSMutableArray = []
    var arrimage : NSMutableArray  = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        bgLabel.frame = CGRect(x:0, y:305, width:245, height:2)
        bgLabel.backgroundColor = UIColor.white
        bgLabel.isHidden=true
        
        CategroScrool.contentSize = CGSize(width: CGFloat(view.frame.size.width), height: CGFloat(780))
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            userName.text=myArray.value(forKey: "first_name") as! String?
            strUserID=myArray.value(forKey: "id") as! NSString
            
            let stringUrl = myArray.value(forKey: "image") as! NSString
            let url = URL.init(string:stringUrl as String)
            profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
        }
        else
        {
            
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
      //  self.tabBarController?.tabBar.isHidden = false
        
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            CategroScrool.isScrollEnabled=true
            CategroScrool.contentSize = CGSize(width: CGFloat(view.frame.size.width), height: CGFloat(780))
            
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            userName.text=myArray.value(forKey: "first_name") as! String?
            strUserID=myArray.value(forKey: "id") as! NSString
            
            let stringUrl = myArray.value(forKey: "image") as! NSString
            let url = URL.init(string:stringUrl as String)
            profileImage.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
            
            
            arrtitle = ["My Profile", "My Settings", "My Chats", "My Food Sharing", "My Food Bank", "My Events", "Send FeedBack" ,"Contact Us", "Logout"]
            arrimage = ["profile", "settings", "chats", "foodShareProfile", "My_foodbank", "event.png", "send_feedback.png","phone-call-2.png", "logout"]
            
            tabl.reloadData()
        }
        else
        {
            CategroScrool.isScrollEnabled=false
            CategroScrool.contentSize = CGSize(width: CGFloat(view.frame.size.width), height: CGFloat(400))
            
            userName.text="Guest User"
           
            arrtitle = ["Login", "Contact Us"]
            arrimage = ["profile", "phone-call-2.png"]
            
            tabl.reloadData()
        }
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    @IBAction func mySettingsBtnAction(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    
    
    @IBAction func ContactClicked(_ sender: Any)
    {
        let url = URL(string: "https://www.food4all.org/#contact")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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
                    let proVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                    proVC.listArraySettings = (responceDic.object(forKey: "settingDetail") as? NSDictionary)!
                    self.navigationController?.pushViewController(proVC, animated: true)
                    self.revealViewController().revealToggle(animated: true)
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
    

    
    

    @IBAction func chatButtonAction(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    @IBAction func myFoodSharigBtnAction(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareVC") as! MyFoodShareVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    
    
    @IBAction func myFoodbankButtonAction(_ sender: Any)
    {
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankVC") as! MyFoodBankVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    
    @IBAction func LogoutButtonAction(_ sender: Any)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
        self.revealViewController().revealToggle(animated: true)
        
        UserDefaults.standard.removeObject(forKey: "UserId")
        AFWrapperClass.svprogressHudDismiss(view: self)
        AFWrapperClass.alert(Constants.applicationName, message: "Logout Successfully", view: self)
    }
   
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Customcell1"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Customcell1
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "Customcell1", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Customcell1
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        let lblName: UILabel? = (cell?.viewWithTag(2) as? UILabel)
        let image: UIImageView? = (cell?.viewWithTag(1) as? UIImageView)
        lblName?.text = (arrtitle[indexPath.row] as? String)
        let imageName: String? = (arrimage[indexPath.row] as? String)
        image?.image = UIImage(named: imageName!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            if UserDefaults.standard.object(forKey: "UserId") != nil
            {
                let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                self.navigationController?.pushViewController(proVC, animated: true)
                self.revealViewController().revealToggle(animated: true)
            }
            else
            {
                let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(proVC, animated: true)
                self.revealViewController().revealToggle(animated: true)
            }
        }
        else if indexPath.row == 1
        {
            if UserDefaults.standard.object(forKey: "UserId") != nil
            {
                let proVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                self.navigationController?.pushViewController(proVC, animated: true)
                self.revealViewController().revealToggle(animated: true)
            }
            else
            {
                let url = URL(string: "https://www.food4all.org/#contact")!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else if indexPath.row == 2
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else if indexPath.row == 3
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareVC") as! MyFoodShareVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else if indexPath.row == 4
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankVC") as! MyFoodBankVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else if indexPath.row == 5
        {
            let proVC = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsVC") as! MyEventsVC
            self.navigationController?.pushViewController(proVC, animated: true)
            self.revealViewController().revealToggle(animated: true)
        }
        else if indexPath.row == 6
        {
            //            let composer = MFMailComposeViewController()
            //
            //            if MFMailComposeViewController.canSendMail() {
            //                composer.mailComposeDelegate = self
            //                composer.setToRecipients(["bharath0402@gmail.com"])
            //                composer.setSubject("iOS User App feedback  ")
            //                composer.setMessageBody("Sending From My Phone", isHTML: false)
            //                present(composer, animated: true, completion: nil)
            //
            //                }
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }

        }
        else if indexPath.row == 7
        {
            let url = URL(string: "https://www.food4all.org/#contact")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else if indexPath.row == 8
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
            self.navigationController?.pushViewController(myVC!, animated: true)
            self.revealViewController().revealToggle(animated: true)
            
            UserDefaults.standard.removeObject(forKey: "UserId")
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: "Logout Successfully", view: self)
        }
        else
        {
            cell.selectionStyle = .none
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@food4all.org"])
        mailComposerVC.setSubject("IOS User App feedback")
        mailComposerVC.setMessageBody("Sending e-mail from the app", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
       
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


