//
//  MyFoodShareVC.swift
//  FoodForAll
//
//  Created by think360 on 22/05/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MyFoodShareVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate
{
    @IBOutlet weak var foodBnkBackView: UIView!
   
    var FoodShareTableView = UITableView()
    var cell: FoodBankTebelCell!
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    
    var strMealId = NSString()
    
    
    var listArrayFoodShare : NSMutableArray = []
    var listSeconds = NSArray()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var refreshTimer = Timer()
    var timerArr : NSMutableArray = []
    var secondsArr : NSMutableArray  = []
    var expireArr : NSMutableArray  = []
    var dict : NSDictionary  = [:]
    var locationManager = CLLocationManager()
    var value = NSString()
    
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
        strUserID=myArray.value(forKey: "id") as! NSString
        
        perform(#selector(MyFoodBankVC.showTableView), with: nil, afterDelay: 0.02)
        self.getAllFoodBanksAPImethod()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllFoodBanksAPImethod()
    }
    
    func showTableView()
    {
        FoodShareTableView.frame = CGRect(x:0, y:0, width:foodBnkBackView.frame.size.width, height:foodBnkBackView.frame.size.height)
        FoodShareTableView.delegate=self
        FoodShareTableView.dataSource=self
        FoodShareTableView.estimatedRowHeight = 112
        self.FoodShareTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        foodBnkBackView.addSubview(FoodShareTableView)
    }
    
    
    func validateTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableCells), userInfo: nil, repeats: true)
    }
    
    func reloadTableCells(_ timer: Timer) {
        for cell: UITableViewCell in FoodShareTableView.visibleCells {
            let path: IndexPath? = FoodShareTableView.indexPath(for: cell)
            if (path?.row)! < self.listArrayFoodShare.count {
                Timemanager.configureCell(cell, withTimerArr: timerArr, withSecondsArr: secondsArr, forAt: path)
            }
        }
    }

    
    // MARK:  getAllFoodBanksAPImethod
    
    func getAllFoodBanksAPImethod () -> Void
    {
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=mealListing&user_id=\(strUserID)&lat=\(currentLatitude)&longt=\(currentLongitude)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                   // Timer.invalidate(-1)
                    
                    let number = responceDic.object(forKey: "nextPage") as! NSNumber
                    self.strpage = String(describing: number)
                    
                    self.listArrayFoodShare = (responceDic.object(forKey: "mealList") as? NSMutableArray)!
                    print(self.listArrayFoodShare)
                    self.listSeconds=(responceDic.object(forKey: "mealList") as? NSArray)!
                    
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        var newDate: Date?
                        var value = NSNumber()
                        value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                        newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                        
                        
                        self.timerArr.add(newDate!)
                        self.secondsArr.add(newDate!)
                    }
                    
                    print(self.timerArr)
                    print(self.secondsArr)
                    
                    self.validateTimer()

                    
                    self.FoodShareTableView.reloadData()
                }
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if Message == "meal list not found."
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
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listArrayFoodShare.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "FoodBankTebelCell"
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FoodBankTebelCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "FoodBankTebelCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FoodBankTebelCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageURL: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_meal_image") as! String
        let url = NSURL(string:imageURL)
        cell.foodbankImage.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
         cell.foodBankUserName.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "username") as! String
        
        cell.foodbankName.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "meal_title") as! String
        
        cell.foodbankCity.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as! String
        cell.foodbankDistance.text! = String(format:"%@ kms",(self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "distances") as! String)
        cell.subCategeory.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type") as! String
        cell.categeory.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as! String
        cell.Quantity.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "no_of_meal_hidden") as! String
        
        
        let Subcategeory: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_name") as! String
        if Subcategeory == ""
        {
            cell.subCategeory.text! = "Food4All"
        }
        else
        {
            cell.subCategeory.text! = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_name") as! String
        }
        
        
        let categeory: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "food_type_image") as! String
        let url2 = NSURL(string:categeory)
        cell.SubCategeoryImage.sd_setImage(with: (url2) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        
        let categeory2: String = (self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_image") as! String
        let url3 = NSURL(string:categeory2)
        cell.CategeoryImage.sd_setImage(with: (url3) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))

        
        
        Timemanager.configureCell(cell, withTimerArr: timerArr, withSecondsArr: secondsArr, forAt: indexPath)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        value=(self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_meal_id") as! String as NSString
        
        print(value)
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodShareDetailsVC") as? MyFoodShareDetailsVC
        myVC?.SharedMealID=value as String
        myVC?.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(myVC!, animated: true)
        
        //        self.FoodShareDetailsAPIMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=get_sharemeal&share_meal_id=\(value)&lat=\(currentLatitude)&longt=\(currentLongitude)")
    }
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            strMealId=(self.listArrayFoodShare.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_meal_id") as! String as NSString
            
    
            let alert = UIAlertController(title: "Food Share", message: "Are You Sure Want to Delete Food Share.", preferredStyle: UIAlertControllerStyle.alert)
            
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
        let params = "method=deleteMeal&user_id=\(strUserID)&meal_id=\(strMealId)"
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.timerArr.removeAllObjects()
                    self.secondsArr.removeAllObjects()
                    
                    
                    let baseURL: String  = String(format:"%@",Constants.mainURL)
                    let params = "method=mealListing&user_id=\(self.strUserID)&lat=\(self.currentLatitude)&longt=\(self.currentLongitude)"
                    
                    print(params)
                    
                    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                    AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
                        
                        DispatchQueue.main.async {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            let responceDic:NSDictionary = jsonDic as NSDictionary
                            print(responceDic)
                            if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                            {
                                self.listArrayFoodShare.removeAllObjects()
                                let number = responceDic.object(forKey: "nextPage") as! NSNumber
                                self.strpage = String(describing: number)
                                
                                
                                
                                self.listArrayFoodShare = (responceDic.object(forKey: "mealList") as? NSMutableArray)!
                                print(self.listArrayFoodShare)
                                self.listSeconds=(responceDic.object(forKey: "mealList") as? NSArray)!
                                
                                
                                for i in 0..<self.listArrayFoodShare.count
                                {
                                    var newDate: Date?
                                    var value = NSNumber()
                                    value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                                    
                                    
                                    self.timerArr.add(newDate!)
                                    self.secondsArr.add(newDate!)
                                }
                                
                                print(self.timerArr)
                                print(self.secondsArr)
                                
                                self.validateTimer()
                                
                                
                                self.FoodShareTableView.reloadData()
                            }
                            else
                            {
                                var Message=String()
                                Message = responceDic.object(forKey: "responseMessage") as! String
                                
                                if Message == "meal list not found."
                                {
                                    self.Stringlab.isHidden=false;
                                    
                                    self.timerArr.removeAllObjects()
                                    self.secondsArr.removeAllObjects()
                                    self.listArrayFoodShare .removeAllObjects()
                                    
                                    self.FoodShareTableView.reloadData()
                                    
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
                else
                {
                    var Message=String()
                    Message = responceDic.object(forKey: "responseMessage") as! String
                    
                    if Message == "meal list not found."
                    {
                        self.Stringlab.isHidden=false;
                        
                        self.timerArr.removeAllObjects()
                        self.secondsArr.removeAllObjects()
                        self.listArrayFoodShare .removeAllObjects()
                        
                        self.FoodShareTableView.reloadData()
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
                //    loadLbl.text = "No More List"
                //   actInd.stopAnimating()
            }
            else
            {
                
                let baseURL: String  = String(format:"%@",Constants.mainURL)
                let params = "method=mealListing&user_id=\(strUserID)&lat=\(currentLatitude)&longt=\(currentLongitude)&page=\(strpage)"
                
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
                arr = (responseDictionary.value(forKey: "mealList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                
                self.timerArr.removeAllObjects()
                self.secondsArr.removeAllObjects()
                
                
                for i in 0..<self.listArrayFoodShare.count
                {
                    var newDate: Date?
                    var value = NSNumber()
                    value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                    
                    
                    self.timerArr.add(newDate!)
                    self.secondsArr.add(newDate!)
                }
                self.validateTimer()
                
                self.FoodShareTableView.reloadData()
                
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
                    arr = (responseDictionary.value(forKey: "mealList") as? NSMutableArray)!
                    arr=arr as AnyObject as! NSMutableArray
                    self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                    
                    
                    self.timerArr.removeAllObjects()
                    self.secondsArr.removeAllObjects()
                    
                    
                    for i in 0..<self.listArrayFoodShare.count
                    {
                        var newDate: Date?
                        var value = NSNumber()
                        value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                        newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                        
                        
                        self.timerArr.add(newDate!)
                        self.secondsArr.add(newDate!)
                    }
                    self.validateTimer()
                    
                    self.FoodShareTableView.reloadData()
                    
                    
                    
                    lastCount = 2
                }
            }
            else {
                var arr = NSMutableArray()
                arr = (responseDictionary.value(forKey: "mealList") as? NSMutableArray)!
                arr=arr as AnyObject as! NSMutableArray
                self.listArrayFoodShare.addObjects(from: arr as [AnyObject])
                
                self.timerArr.removeAllObjects()
                self.secondsArr.removeAllObjects()
                
                
                for i in 0..<self.listArrayFoodShare.count
                {
                    var newDate: Date?
                    var value = NSNumber()
                    value=(self.listArrayFoodShare.object(at: i) as! NSDictionary).object(forKey: "seconds") as! NSNumber
                    newDate = Date(timeIntervalSinceNow: TimeInterval(value))
                    
                    
                    self.timerArr.add(newDate!)
                    self.secondsArr.add(newDate!)
                }
                self.validateTimer()
                
                self.FoodShareTableView.reloadData()
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
                    FoodShareTableView.tableFooterView = footerview2
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
    
    
    
    
    

    
    
    
    

    @IBAction func backButtonAction(_ sender: Any) {
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
        self.navigationController?.pushViewController(foodVC!, animated: true)
    }
    
    
    
    //MARK: TableView Delegates and Datasource:
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}
