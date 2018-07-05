//
//  ChatListVC.swift
//  FoodForAll
//
//  Created by amit on 5/3/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//


import UIKit

class ChatListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
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
    
    var theSearchBar: UISearchBar?
    var countCheck = 1
    
    var strChatId = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatTblView.tableFooterView = UIView(frame: .zero)
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search Chat"
        theSearchBar?.showsCancelButton = false
        ChatTblView.tableHeaderView = theSearchBar
        

        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            let data = UserDefaults.standard.object(forKey: "UserId") as? Data
            myArray = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary)!
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
         var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&user_id=\(strUserID)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchChat",params)
        
        print(baseURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                  print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.countCheck = 1
                    self.listArrayChat.removeAllObjects()
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.listArrayChat = (responceDic.object(forKey: "chatList") as? NSMutableArray)!
                    self.ChatTblView.reloadData()
                }
                else
                {
                    self.Stringlab.isHidden=false
                    self.listArrayChat.removeAllObjects()
                     self.ChatTblView.reloadData()
                    
                    let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
                    let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
                }
            }
            
        }) { (error) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
        
        
//
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
//        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
//
//            DispatchQueue.main.async {
//                AFWrapperClass.svprogressHudDismiss(view: self)
//                let responceDic:NSDictionary = jsonDic as NSDictionary
//                print(responceDic)
//                if (responceDic.object(forKey: "status") as! NSNumber) == 1
//                {
//
//                }
//                else
//                {
//                    var Message=String()
//                    Message = responceDic.object(forKey: "responseMessage") as! String
//
//                    if Message == "No DATA_FOUND."
//                    {
//                        self.Stringlab.isHidden=false
//                    }
//                    else
//                    {
//                        AFWrapperClass.svprogressHudDismiss(view: self)
//                        AFWrapperClass.alert(Constants.applicationName, message: Message, view: self)
//                    }
//
//                }
//            }
//
//        }) { (error) in
//
//            AFWrapperClass.svprogressHudDismiss(view: self)
//            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
//            //print(error.localizedDescription)
//        }
    }

    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let str = searchText
        var encodeUrl = String()
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let escapedString = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            encodeUrl = escapedString
        }
        
        var localTimeZoneName: String { return TimeZone.current.identifier }
        let strkey = Constants.ApiKey
        let params = "api_key=\(strkey)&search=\(encodeUrl)&user_id=\(strUserID)&time_zone=\(localTimeZoneName)"
        let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchChat",params)
        
        AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "status") as! NSNumber) == 1
                {
                    self.countCheck = 2
                    self.listArrayChat.removeAllObjects()
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.listArrayChat = (responceDic.object(forKey: "chatList") as? NSMutableArray)!
                    self.ChatTblView.reloadData()
                }
                else
                {
                    self.listArrayChat.removeAllObjects()
                    self.ChatTblView.reloadData()
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        theSearchBar?.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
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
        
        
        let imageURL: String = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as? String ?? ""
        let url = NSURL(string:imageURL)
        cell.userPic.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        let str1 = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String ?? ""
        let str2 = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "last_name") as? String ?? ""
        let strname = str1+" "+str2
        cell.userName.text! = strname
        cell.Datetime.text! = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "updated") as? String ?? ""
        cell.module.text! = String(format:"%@",(self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String ?? "")

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         UserDefaults.standard.set("2", forKey: "CState")
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatingDetailsViewController") as? ChatingDetailsViewController
        if let quantity = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
        {
            myVC?.strConversionId =  String(describing: quantity)
        }
        else if let quantity = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
        {
            myVC?.strConversionId = quantity
        }
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
                
                
                let str: String = theSearchBar?.text ?? ""
            
               var localTimeZoneName: String { return TimeZone.current.identifier }
                let strkey = Constants.ApiKey
                let params = "api_key=\(strkey)&user_id=\(strUserID)&page=\(self.strpage)&time_zone=\(localTimeZoneName)&search=\(str)"
                let baseURL: String  = String(format:"%@%@?%@",Constants.mainURL,"searchChat",params)
                
                print(baseURL)
                
                AFWrapperClass.requestGETURLWithUrlsession(baseURL, success: { (jsonDic) in
                    
                    DispatchQueue.main.async {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let responceDic:NSDictionary = jsonDic as NSDictionary
                        print(responceDic)
                        if (responceDic.object(forKey: "status") as! NSNumber) == 1
                        {
                            self.responsewithToken7(responceDic)
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
    
    
    func responsewithToken7(_ responseDict: NSDictionary)
    {
        var responseDictionary : NSDictionary = [:]
        responseDictionary = responseDict
        
        var arr = NSMutableArray()
        arr = (responseDictionary.value(forKey: "chatList") as? NSMutableArray)!
        arr=arr as AnyObject as! NSMutableArray
        self.listArrayChat.addObjects(from: arr as [AnyObject])
        
        let number = responseDictionary.object(forKey: "nextPage") as! NSNumber
        self.strpage = String(describing: number)
        
        self.ChatTblView.reloadData()
        
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
    
    
    
//    func initFooterView() {
//        footerview2 = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(view.frame.size.width), height: CGFloat(50.0)))
//        actInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        actInd.tag = 10
//        actInd.frame = CGRect(x: CGFloat(view.frame.size.width / 2 - 10), y: CGFloat(5.0), width: CGFloat(20.0), height: CGFloat(20.0))
//        actInd.isHidden = true
//        //actInd.performSelector(#selector(removeFromSuperview), withObject: nil, afterDelay: 30.0)
//        footerview2.addSubview(actInd)
//        loadLbl = UILabel(frame: CGRect(x: CGFloat(view.frame.size.width / 2 - 100), y: CGFloat(25), width: CGFloat(200), height: CGFloat(20)))
//        loadLbl.textAlignment = .center
//        loadLbl.textColor = UIColor.lightGray
//        // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
//        loadLbl.font = UIFont.systemFont(ofSize: CGFloat(12))
//        footerview2.addSubview(loadLbl)
//        actInd = nil
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrool == 1 {
//            let endOfTable: Bool = (scrollView.contentOffset.y >= 0)
//            if endOfTable && !scrollView.isDragging && !scrollView.isDecelerating {
//                if (strpage == "0") {
//                    ChatTblView.tableFooterView = footerview2
//                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
//                    // loadLbl.text = "No More List"
//                    //  actInd.stopAnimating()
//                }
//                else {
//                    //  FoodShareTableView.tableFooterView = footerview2
//                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.startAnimating()
//                }
//            }
//        }
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if scrool == 1 {
//           // footerview2.isHidden = true
//            // loadLbl.isHidden = true
//        }
//    }
//    
    
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            
            
            
            if let quantity = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? NSNumber
            {
                strChatId =  String(describing: quantity)
            }
            else if let quantity = (self.listArrayChat.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                strChatId = quantity
            }
            
            
            
           // strChatId=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String as NSString
            
            
            
            let alert = UIAlertController(title: "Food Bank", message: "Are You Sure Want to Delete this Conversion", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
                self.deletemethod()
            })
            
            let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.destructive,handler: { action in
                
            })
            
            alert.addAction(alertOKAction)
            alert.addAction(alertCancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    func deletemethod()
    {
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,"deleteChat")
        let strkey = Constants.ApiKey
        
        let PostDataValus = NSMutableDictionary()
        PostDataValus.setValue(strkey, forKey: "api_key")
        PostDataValus.setValue(strUserID, forKey: "user_id")
        PostDataValus.setValue(strChatId, forKey: "chat_id")
        
        var jsonStringValues = String()
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: PostDataValus, options: .prettyPrinted)
        if jsonData == nil {
            
        }
        else
        {
            jsonStringValues = String(data: jsonData!, encoding: String.Encoding.utf8)!
            print("jsonString: \(jsonStringValues)")
        }
        
        // let baseURL: String  = String(format:"%@",Constants.mainURL)
        //  let params = "method=deletefoodbank&user_id=\(strUserID)&fbank_id=\(strfoodbankid)"
        
        //  print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: jsonStringValues, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                   print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.ChatlistAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=get_conversation_list&user_id=\(self.strUserID)")
                }
                else
                {
                    let strerror = responceDic.object(forKey: "error") as? String ?? "Server error"
                    let Message = responceDic.object(forKey: "responseMessage") as? String ?? strerror
                    
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
    
    
    
    
    
    
    
    
    @IBAction func backButttonAction(_ sender: Any) {
        
        //    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        //      self.navigationController?.pushViewController(foodVC!, animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
