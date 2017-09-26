//
//  ChatListVC.swift
//  FoodForAll
//
//  Created by amit on 5/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//


import UIKit

class ChatListVC: UIViewController,UITableViewDelegate,UITableViewDataSource
 {

    
    var cell: ChatTVCell!
    @IBOutlet weak var ChatTblView: UITableView!
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var listArrayChat : NSMutableArray = []
    var Stringlab = UILabel()
    
    
    
    var strpage = String()
    var footerview2: UIView!
    var loadLbl: UILabel!
    var locationNamelabel: UILabel!
    var actInd: UIActivityIndicatorView!
    var scrool = 1
    var count = 1
    var lastCount = 1
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatTblView.tableFooterView = UIView(frame: .zero)

        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            strUserID=myArray.value(forKey: "id") as! NSString
        }
        else
        {
            
        }
        
        Stringlab.frame = CGRect(x:self.view.frame.size.width/2-100, y:self.view.frame.size.height/2-10, width:200, height:20)
        Stringlab.backgroundColor = UIColor.clear
        Stringlab.text="No Chat List"
        Stringlab.font =  UIFont(name:"Helvetica-Bold", size: 16)
        Stringlab.textColor=UIColor.black
        Stringlab.textAlignment = .center
        Stringlab.isHidden=true;
        self.view.addSubview(Stringlab)
        
        var localTimeZoneName: String { return TimeZone.current.identifier }
        
        self.ChatlistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=get_conversation_list&user_id=\(strUserID)&time_zone=\(localTimeZoneName)")

    }
    
    
    @objc private  func ChatlistAPIMethod (baseURL:String , params: String)
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
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.listArrayChat = (responceDic.object(forKey: "List") as? NSMutableArray)!
                    self.ChatTblView.reloadData()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if Message == "No DATA_FOUND."
                    {
                        self.Stringlab.isHidden=false
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


    
    
    //MARK: TableView Delegates and Datasource:
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 91
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listArrayChat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "ChatTVCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatTVCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "ChatTVCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatTVCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: String = ((self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "user") as! NSDictionary).object(forKey: "profile_pic") as! String
        let url = NSURL(string:imageURL)
        cell.userPic.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        cell.userName.text! = ((self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "user") as! NSDictionary).object(forKey: "name") as! String
        cell.Datetime.text! = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "dateTime") as! String
        cell.module.text! = String(format:"%@",(self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "function_title") as! String)

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         UserDefaults.standard.set("2", forKey: "CState")
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController
        myVC?.strConversionId=(self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "conversation_id") as! String
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath)
    {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) {
            if (strpage == "0") {
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else if (strpage == "") {
                //    loadLbl.text = "No More List"
                //   actInd.stopAnimating()
            }
            else
            {
                var localTimeZoneName: String { return TimeZone.current.identifier }
                let baseURL: String  = String(format:"%@",Constants.mainURL)
                let params = "method=get_conversation_list&user_id=\(strUserID)&time_zone=\(localTimeZoneName)"
                
              
                
                // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        print(responceDic)
                        
                        
                        
                        if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                        {
                            self.responsewithToken6(responceDic)
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
            
        }
        
    }
    
    func responsewithToken6(_ responseDict: NSDictionary) {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        if count == 1 {
            count = 2
            if (strpage == "2") {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayChat.addObjects(from: arr as [AnyObject])
                self.ChatTblView.reloadData()
            }
            else
            {
                
            }
            let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
            self.strpage = String(describing: number)
        }
        else {
            let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
            self.strpage = String(describing: number)
            
            if (strpage == "0") {
                if lastCount == 1 {
                    var arr = NSMutableArray()
                    arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayChat.addObjects(from: arr as [AnyObject])

                    lastCount = 2
                     self.ChatTblView.reloadData()
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "List") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayChat.addObjects(from: arr as [AnyObject])
                self.ChatTblView.reloadData()
            }
        }
    }
    
    
    
    func initFooterView() {
        footerview2 = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(view.frame.size.width), height: CGFloat(50.0)))
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: CGFloat(view.frame.size.width / 2 - 10), y: CGFloat(5.0), width: CGFloat(20.0), height: CGFloat(20.0))
        actInd.isHidden = true
        //actInd.performSelector(#selector(removeFromSuperview), withObject: nil, afterDelay: 30.0)
        footerview2.addSubview(actInd)
        loadLbl = UILabel(frame: CGRect(x: CGFloat(view.frame.size.width / 2 - 100), y: CGFloat(25), width: CGFloat(200), height: CGFloat(20)))
        loadLbl.textAlignment = .center
        loadLbl.textColor = UIColor.lightGray
        // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
        loadLbl.font = UIFont.systemFont(ofSize: CGFloat(12))
        footerview2.addSubview(loadLbl)
        actInd = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrool == 1 {
            let endOfTable: Bool = (scrollView.contentOffset.y >= 0)
            if endOfTable && !scrollView.isDragging && !scrollView.isDecelerating {
                if (strpage == "0") {
                    ChatTblView.tableFooterView = footerview2
                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
                    // loadLbl.text = "No More List"
                    //  actInd.stopAnimating()
                }
                else {
                    //  FoodShareTableView.tableFooterView = footerview2
                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.startAnimating()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrool == 1 {
            footerview2.isHidden = true
            // loadLbl.isHidden = true
        }
    }
    
    
    

    
    
    
    
    
    @IBAction func backButttonAction(_ sender: Any) {
        
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
