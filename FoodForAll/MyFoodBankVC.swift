//
//  MyFoodBankVC.swift
//  FoodForAll
//
//  Created by amit on 5/8/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MyFoodBankVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate
{

    @IBOutlet weak var foodBnkBackView: UIView!
    var cell: MyFoodBnkCell!
    var FoodBankTableView = UITableView()
   
    var myArray = NSDictionary()
    var strUserID = NSString()
    var strfoodbankid = NSString()
    var listArrayFoodBank : NSMutableArray  = []
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var locationManager = CLLocationManager()
    
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
        
        
        
        Stringlab.frame = CGRect(x:self.view.frame.size.width/2-100, y:self.view.frame.size.height/2-10, width:200, height:20)
        Stringlab.backgroundColor = UIColor.clear
        Stringlab.text="No List"
        Stringlab.font =  UIFont(name:"Helvetica-Bold", size: 16)
        Stringlab.textColor=UIColor.black
        Stringlab.textAlignment = .center
        Stringlab.isHidden=true;
        self.view.addSubview(Stringlab)
        
        
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
        }
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
        }else{
            let alertController = UIAlertController(title: "Food4All", message: "Location services are disabled in your App settings Please enable the Location Settings. Click Ok to go to Location Settings.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
               // UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
                  UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                alertController.dismiss(animated: true, completion: nil)
            })
            // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            // alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        
       

        
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        print(myArray)
        strUserID=myArray.value(forKey: "id") as! NSString
        
        perform(#selector(MyFoodBankVC.showTableView), with: nil, afterDelay: 0.02)
        self.getAllFoodBanksAPImethod()
        
        
       //  FoodBankTableView.allowsMultipleSelectionDuringEditing = false

    }
    override func viewWillAppear(_ animated: Bool) {
       self.getAllFoodBanksAPImethod()
    }

    func showTableView()
    {
        FoodBankTableView.frame = CGRect(x:0, y:0, width:foodBnkBackView.frame.size.width, height:foodBnkBackView.frame.size.height)
        FoodBankTableView.delegate=self
        FoodBankTableView.dataSource=self
        FoodBankTableView.estimatedRowHeight = 112
        self.FoodBankTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        foodBnkBackView.addSubview(FoodBankTableView)
    }

    
       // MARK:  getAllFoodBanksAPImethod
    
    func getAllFoodBanksAPImethod () -> Void
    {
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=get_FoodBanksuser&user_id=\(strUserID)&lat=\(currentLatitude)&longt=\(currentLongitude)"
        
        print(params)
        
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
                    
                    self.listArrayFoodBank = (responceDic.object(forKey: "FoodbankList") as? NSMutableArray)!
                    
                    print(self.listArrayFoodBank)
                    
                    self.FoodBankTableView.reloadData()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if Message == "Foodbank list not found."
                    {
                        self.Stringlab.isHidden=false;
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
        return 140
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listArrayFoodBank.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "MyFoodBnkCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyFoodBnkCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "MyFoodBnkCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyFoodBnkCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: String = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "Foodbank_image") as! String
        let url = NSURL(string:imageURL)
        cell.imageViewUser.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        let foodbankManage = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_user") as! String
        if foodbankManage == "2"
        {
            cell.foodbankUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "username") as! String
        }
        else
        {
            cell.foodbankUserName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "manage_otheremail") as! String
        }
        
        cell.foodBankName.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_title") as! String
     
        cell.locationLabel.text! = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
        
        let sliderValue = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "percentage") as! String
        if sliderValue == "" {
            cell.sliderFdBnk.value = 0
            cell.percentLbl.text! = "0"
        }else{
            cell.sliderFdBnk.value = Float(sliderValue)!
            cell.percentLbl.text! = String(format:"%@%@",sliderValue,"%")
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
        self.navigationController?.pushViewController(myVC!, animated: true)
        
        myVC?.foodbankID = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_id") as! String
        myVC?.percentStr = (self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "percentage") as! String
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
           
            
            strfoodbankid=(self.listArrayFoodBank.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_id") as! String as NSString
            
            
            
            let alert = UIAlertController(title: "Food Bank", message: "Are You Sure Want to Delete Food Bank.", preferredStyle: UIAlertControllerStyle.alert)
            
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
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=deletefoodbank&user_id=\(strUserID)&fbank_id=\(strfoodbankid)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
                    let baseURL: String  = String(format:"%@",Constants.mainURL)
                    let params = "method=get_FoodBanksuser&user_id=\(self.strUserID)&lat=\(self.currentLatitude)&longt=\(self.currentLongitude)"
                    
                    print(params)
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                        
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                            {
                                
                                self.listArrayFoodBank.removeAllObjects()
                                self.listArrayFoodBank = (responceDic.object(forKey: "FoodbankList") as? NSMutableArray)!
                                
                                print(self.listArrayFoodBank)
                                
                                self.FoodBankTableView.reloadData()
                            }
                            else
                            {
                                var Message=String()
                                Message = responceDic.object(forKey: "responseMessage") as! String
                                
                                if Message == "Foodbank list not found."
                                {
                                    self.Stringlab.isHidden=false;
                                    
                                    self.listArrayFoodBank.removeAllObjects()
                                    
                                    self.FoodBankTableView.reloadData()
                                    
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
                        
                    }
                    
                    
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if Message == "Foodbank list not found."
                    {
                        self.Stringlab.isHidden=false;
                        
                        self.listArrayFoodBank.removeAllObjects()
                        
                        self.FoodBankTableView.reloadData()
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
                //  loadLbl.text = "No More List"
                //  actInd.stopAnimating()
            }
            else
            {
                let baseURL: String  = String(format:"%@",Constants.mainURL)
                let params = "method=get_FoodBanksuser&lat=\(currentLatitude)&longt=\(currentLongitude)&user_id=\(strUserID)&page=\(strpage)"
                
                print(params)
                
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
                arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                FoodBankTableView.reloadData()
                
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
                    arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                    FoodBankTableView.reloadData()
                    lastCount = 2
                    
                    
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "FoodbankList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodBank.addObjects(from: arr as [AnyObject])
                FoodBankTableView.reloadData()
                
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
                    FoodBankTableView.tableFooterView = footerview2
                    //  (footerview2.viewWithTag(10) as? UIActivityIndicatorView)?.stopAnimating()
                    //  loadLbl.text = "No More List"
                    //   actInd.stopAnimating()
                }
                else {
                    FoodBankTableView.tableFooterView = footerview2
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

    
    
    @IBAction func backButtonAction(_ sender: Any) {
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
