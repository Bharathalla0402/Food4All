//
//  StepFourFoodShareVC.swift
//  FoodForAll
//
//  Created by amit on 5/11/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces



class StepFourFoodShareVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,GMSIndoorDisplayDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
 {

    var foodBankCamera = GMSCameraPosition()
    var foodBankMapView = GMSMapView()
    var foodBankMarker = GMSMarker()
    
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var mapView2 = GMSMapView()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var checklat = Double()
    var checklong = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    var searchViewController = ABCGooglePlacesSearchViewController()
    
    
    
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    var popview3 = UIView()
    var footerView3 = UIView()
    var locationlab = UILabel()
    var citylab = UILabel()
    var CancelButton2 = UIButton()
    var DoneButton2 = UIButton()
    var locationButt = UIButton()
    var ValunteerButt = UIButton()
    var ValunteerButt2 = UIButton()
    var TextDescription = UITextView()
    var tablfooter = UIView()
    var frontView = UIView()
    
    
    var switchlab = UISwitch()
    var txtemailfield = UITextField()
    var Headview2 = UIView()
    var foodbanklistbutt = UIButton()
    var foodbankNamelab = UILabel()
    var strFoodbankId = NSString()
    var strChecklist = NSString()
    var strfoodbankname = NSString()
    
    
    @IBOutlet var volunterFbTblView: UITableView!
    var Fbcell: UITableViewCell?
    var arrChildCategory = NSMutableArray()
    var searchResults = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    lazy var geocoder = CLGeocoder()

    
    
    
    

    @IBOutlet weak var fdBnkNearHightConstrnt: NSLayoutConstraint!
    @IBOutlet weak var searchFoodbankHeightconstrnt: NSLayoutConstraint!
    @IBOutlet weak var volunteersConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectfrommylocconstrain: NSLayoutConstraint!
    
   
    
    
   
    
    @IBOutlet weak var foodBankBrn: UIButton!
    @IBOutlet weak var foodbanksubbutt: UIButton!
    @IBOutlet weak var foodbanksubbutt2: UIButton!
    @IBOutlet weak var myLoctnBtn: UIButton!
   
    
    @IBOutlet weak var foodBankView: UIView!
    @IBOutlet weak var myLoctnView: UIView!
    
    
    @IBOutlet weak var searchFDBnkTF: UITextField!
    @IBOutlet weak var searchVolunteerTF: UITextField!
    @IBOutlet weak var searchLoctnTF: UITextField!
    
    var listArrayFoodBank = NSArray()
    
    var mapSrt = String()
    var radioBtnStringChk = String()
    var straddress = NSString()
    var straddress2 = NSString()
    
 
    
    
    var mainArray = NSArray()
    var searchTableView = UITableView()
    var searchCell: StepFourTableCell!
    
    var  cityNameSelected = String()
    
    
    var mealtitle = String()
    var categoryStr = String()
    var subCategoryStr = String()
    var mealDescription = String()
    var mealQuantity = String()
    var hoursHidden = String()
    var imageString = String()
    var strStatus = String()
    var foodbankiID = String()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFDBnkTF.delegate=self
        
        //strStatus="0"
        
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        strUserID=myArray.value(forKey: "id") as! NSString
        
        foodBankBrn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fdBnkNearHightConstrnt.constant = 0
        collectfrommylocconstrain.constant = 0
       
        radioBtnStringChk = "nocheck"
        

        searchViewController.delegate=self
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
        //self.getAllFoodBanksAPImethod ()
        
        self.setUsersClosestCity()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
    }
    
    
    
    @IBAction func nearFoodbankClicked(_ sender: UIButton)
    {
        fdBnkNearHightConstrnt.constant = 112
        searchFoodbankHeightconstrnt.constant  = 0
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 0
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
   
    @IBAction func IamDeliverFoodbankClicked(_ sender: UIButton)
    {
         strStatus="0"
        radioBtnStringChk = "FoodBankNearBy"
        
        fdBnkNearHightConstrnt.constant = 142
        searchFoodbankHeightconstrnt.constant  = 30
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 0
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
    
    @IBAction func VolunteerneedButtClicked(_ sender: Any)
    {
         strStatus="1"
       radioBtnStringChk = "FromMyLocation"
        
        fdBnkNearHightConstrnt.constant = 172
        searchFoodbankHeightconstrnt.constant  = 30
        volunteersConstraint.constant = 30
        collectfrommylocconstrain.constant = 0
        
        foodBankBrn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    
    @IBAction func CollectMylocationClicked(_ sender: UIButton)
    {
        strStatus="2"
       radioBtnStringChk = "FromMyLocation2"
        
        fdBnkNearHightConstrnt.constant = 0
        searchFoodbankHeightconstrnt.constant  = 0
        volunteersConstraint.constant = 0
        collectfrommylocconstrain.constant = 30
        
        foodBankBrn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        foodbanksubbutt2.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        myLoctnBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    
    
    
    
    @IBAction func foodbanklistClicked(_ sender: UIButton)
    {
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=Search_FoodBanks&lat=\(currentLatitude)&longt=\(currentLongitude)&text="
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    self.arrChildCategory = (responceDic.object(forKey: "FoodbankList") as? NSArray)! as! NSMutableArray
                    
                    self.foodbanklistView()
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
    
    
    
    func foodbanklistView ()
    {
        popview2.isHidden=false
        footerView2.isHidden=false
        
        popview2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview2.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview2)
        
        footerView2.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        footerView2.backgroundColor = UIColor.white
        popview2.addSubview(footerView2)
        
        let bglab = UILabel()
        bglab.frame = CGRect(x:0, y:0, width:footerView2.frame.size.width, height:70)
        bglab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView2.addSubview(bglab)
        
        let forgotlab = UILabel()
        forgotlab.frame = CGRect(x:0, y:10, width:footerView2.frame.size.width, height:60)
        forgotlab.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        forgotlab.text="Select FoodBank"
        forgotlab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        forgotlab.textColor=UIColor.white
        forgotlab.textAlignment = .center
        footerView2.addSubview(forgotlab)
        
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:footerView2.frame.size.width-35, y:30, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(SetupFoodBankVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:footerView2.frame.size.width-50, y:20, width:50, height:40)
        crossbutt2.addTarget(self, action: #selector(StepFourFoodShareVC.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        footerView2.addSubview(crossbutt2)
        
        
        volunterFbTblView = UITableView()
        volunterFbTblView.frame = CGRect(x: 0, y: bglab.frame.origin.y+bglab.frame.size.height, width: footerView2.frame.size.width, height: footerView2.frame.size.height-70)
        volunterFbTblView.delegate = self
        volunterFbTblView.dataSource = self
        volunterFbTblView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        volunterFbTblView.backgroundColor = UIColor.clear
        footerView2.addSubview(volunterFbTblView)
        
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search FoodBanks"
        theSearchBar?.showsCancelButton = false
        volunterFbTblView.tableHeaderView = theSearchBar
        theSearchBar?.isUserInteractionEnabled = true
    }
    

    func CloseButtonAction(_ sender: UIButton!)
    {
        popview2.isHidden=true
        footerView2.isHidden=true
        
        self.arrChildCategory.removeAllObjects()
        self.searchResults.removeAllObjects()
        volunterFbTblView.removeFromSuperview()
    }
    
    
    //  MARK: searchbar Delegates and Datasource:
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchResults.count != 0 {
            self.searchResults.removeAllObjects()
            volunterFbTblView.tag = 1
        }
        for i in 0..<arrChildCategory.count {
            // [searchResults removeAllObjects];
            let string: String = (self.arrChildCategory.object(at: i) as! NSDictionary).value(forKey: "fbank_title") as! String
            let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
            if rangeValue.length > 0
            {
                volunterFbTblView.tag = 2
                searchResults.add(arrChildCategory[i])
            }
            else
            {
                
            }
        }
        volunterFbTblView.reloadData()
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
    
    
    
    
    //  MARK: TableView Delegates and Datasource:
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if volunterFbTblView.tag == 2
        {
            return searchResults.count
        }
        else {
            return arrChildCategory.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdetifier: String = "Cell"
        Fbcell = UITableViewCell(style: .default, reuseIdentifier: cellIdetifier)
        
        
        if volunterFbTblView.tag == 2
        {
            let titlelab = UILabel()
            titlelab.frame = CGRect(x:15, y:5, width:((Fbcell?.frame.size.width)!-30), height:20)
            titlelab.text=(self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as? String
            titlelab.font =  UIFont(name:"Helvetica", size: 15)
            titlelab.textColor=UIColor.black
            titlelab.textAlignment = .left
            Fbcell?.addSubview(titlelab)
            
            
            let addresslab = UILabel()
            addresslab.frame = CGRect(x:15, y:titlelab.frame.size.height+titlelab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
            addresslab.text=(self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as? String
            addresslab.font =  UIFont(name:"Helvetica", size: 15)
            addresslab.textColor=UIColor.black
            addresslab.textAlignment = .left
            Fbcell?.addSubview(addresslab)
            
            
            let Distancelab = UILabel()
            Distancelab.frame = CGRect(x:15, y:addresslab.frame.size.height+addresslab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
            Distancelab.text =  String(format: "%@ Kms ",((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? String)!)
            Distancelab.font =  UIFont(name:"Helvetica", size: 15)
            Distancelab.textColor=UIColor.black
            Distancelab.textAlignment = .left
            Fbcell?.addSubview(Distancelab)
        }
        else
        {
            let titlelab = UILabel()
            titlelab.frame = CGRect(x:15, y:5, width:((Fbcell?.frame.size.width)!-30), height:20)
            titlelab.text=(self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as? String
            titlelab.font =  UIFont(name:"Helvetica", size: 15)
            titlelab.textColor=UIColor.black
            titlelab.textAlignment = .left
            Fbcell?.addSubview(titlelab)
            
            let addresslab = UILabel()
            addresslab.frame = CGRect(x:15, y:titlelab.frame.size.height+titlelab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
            addresslab.text=(self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as? String
            addresslab.font =  UIFont(name:"Helvetica", size: 15)
            addresslab.textColor=UIColor.black
            addresslab.textAlignment = .left
            Fbcell?.addSubview(addresslab)
            
            
            let Distancelab = UILabel()
            Distancelab.frame = CGRect(x:15, y:addresslab.frame.size.height+addresslab.frame.origin.y, width:((Fbcell?.frame.size.width)!-30), height:20)
            Distancelab.text =  String(format: "%@ Kms ",((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "distance") as? String)!)
            Distancelab.font =  UIFont(name:"Helvetica", size: 15)
            Distancelab.textColor=UIColor.black
            Distancelab.textAlignment = .left
            Fbcell?.addSubview(Distancelab)
        }
        return Fbcell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if volunterFbTblView.tag == 2
        {
            searchFDBnkTF.text = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as? String
            strfoodbankname = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as! NSString
            strFoodbankId = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_id") as! NSString
            straddress = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as! NSString
            
            currentLatitude = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            currentLongitude = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "longt") as! String)!
            
            checklat = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            checklong = Double((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "longt") as! String)!
            
            popview2.isHidden=true
            footerView2.isHidden=true
            
            self.arrChildCategory.removeAllObjects()
            self.searchResults.removeAllObjects()
            volunterFbTblView.removeFromSuperview()
        }
        else
        {
            searchFDBnkTF.text = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as? String
            strfoodbankname = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_title") as! NSString
            strFoodbankId = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "fbank_id") as! NSString
            straddress = (self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "address") as! NSString
            
            currentLatitude = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            currentLongitude = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "longt") as! String)!
            
            checklat = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "lat") as! String)!
            checklong = Double((self.arrChildCategory.object(at: indexPath.row) as! NSDictionary).value(forKey: "longt") as! String)!
            
            popview2.isHidden=true
            footerView2.isHidden=true
            
            self.arrChildCategory.removeAllObjects()
            self.searchResults.removeAllObjects()
            volunterFbTblView.removeFromSuperview()
        }
        
    }
    

    

    
    
    @IBAction func VolunteersaddressClicked(_ sender: Any)
    {
        
        locationView()
    }
    
    
    
    @IBAction func MylocationClicked(_ sender: UIButton)
    {
       
        locationView()
    }
    
    
    
    
    func locationView()
    {
    
       // tabBarController?.tabBar.isHidden=true
        
        popview3.isHidden=false
        footerView3.isHidden=false
        
        popview3.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview3.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview3)
        
        footerView3.frame = CGRect(x:0, y:0, width:popview3.frame.size.width, height:popview3.frame.size.height)
        footerView3.backgroundColor = UIColor.white
        popview3.addSubview(footerView3)
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView3.frame.size.width, height: footerView3.frame.size.height), camera: camera)
        mapView2.delegate = self
        self.mapView2.settings.compassButton = true
        footerView3.addSubview(mapView2)
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView3.frame.size.width, height:60)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView3.addSubview(Headview)
        
        let titlelab = UILabel()
        titlelab.frame = CGRect(x:Headview.frame.size.width/2-100, y:15, width:200, height:40)
        titlelab.text="Location"
        titlelab.font =  UIFont(name:"Helvetica-Bold", size: 18)
        titlelab.textColor=UIColor.white
        titlelab.textAlignment = .center
        Headview.addSubview(titlelab)
        
        let crossbutt = UIButton()
        crossbutt.frame = CGRect(x:Headview.frame.size.width-35, y:25, width:25, height:25)
        crossbutt.setImage( UIImage.init(named: "cancel-music.png"), for: .normal)
        crossbutt.addTarget(self, action: #selector(StepFourFoodShareVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(StepFourFoodShareVC.CloseButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x:self.view.frame.size.width/2-25, y:self.view.frame.size.height/2-25, width:50, height:50));
        imageView.image = UIImage(named:"map_pin96.png")
        imageView.contentMode = .scaleAspectFit
        footerView3.addSubview(imageView)
        
        
        
        
        let locationView = UIView()
        locationView.frame = CGRect(x:20, y:75, width:footerView3.frame.size.width-40, height:100)
        locationView.backgroundColor=#colorLiteral(red: 0.3215386271, green: 0.3215884566, blue: 0.3215229511, alpha: 1)
        locationView.layer.cornerRadius=8.0
        footerView3.addSubview(locationView)
        
        
        let titlelab2 = UILabel()
        titlelab2.frame = CGRect(x:10, y:5, width:locationView.frame.size.width-20, height:40)
        titlelab2.numberOfLines=0
        titlelab2.text="Move the map to approximate location or search for places below"
        titlelab2.font =  UIFont(name:"Helvetica", size: 14)
        titlelab2.textColor=UIColor.white
        titlelab2.textAlignment = .center
        locationView.addSubview(titlelab2)
        
        
        locationlab.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationlab.numberOfLines=0
        locationlab.backgroundColor=UIColor.white
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.text = self.searchLoctnTF.text!
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(StepFourFoodShareVC.locationButtonAction2(_:)), for: UIControlEvents.touchUpInside)
        locationView.addSubview(locationbutt)
        
        
        
        
        let uselocation = UIView()
        uselocation.frame = CGRect(x:5, y:footerView3.frame.size.height-45, width:footerView3.frame.size.width-10, height:40  )
        uselocation.backgroundColor=#colorLiteral(red: 0.9528647065, green: 0.009665175341, blue: 0.3223749697, alpha: 1)
        uselocation.layer.cornerRadius=4.0
        footerView3.addSubview(uselocation)
        
        let uselab = UILabel()
        uselab.frame = CGRect(x:10, y:0, width:uselocation.frame.size.width-20, height:40)
        uselab.numberOfLines=0
        uselab.text="Use this location"
        uselab.font =  UIFont(name:"Helvetica", size: 16)
        uselab.textColor=UIColor.white
        uselab.textAlignment = .center
        uselocation.addSubview(uselab)
        
        let Uselocationbutt = UIButton()
        Uselocationbutt.frame = CGRect(x:0, y:0, width:uselocation.frame.size.width, height:40)
        Uselocationbutt.addTarget(self, action: #selector(StepFourFoodShareVC.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        uselocation.addSubview(Uselocationbutt)
        
        
        
        let NotifyMe = UIView()
        NotifyMe.frame = CGRect(x:footerView3.frame.size.width/2-55  , y:footerView3.frame.size.height-80, width:110, height:30  )
        NotifyMe.backgroundColor=#colorLiteral(red: 0.2156647146, green: 0.2157005072, blue: 0.2156534195, alpha: 1)
        NotifyMe.layer.cornerRadius=4.0
        footerView3.addSubview(NotifyMe)
        
        var Currentimage : UIImageView
        Currentimage  = UIImageView(frame:CGRect(x:5, y:5, width:20, height:20));
        Currentimage.image = UIImage(named:"ray.png")
        NotifyMe.addSubview(Currentimage)
        
        let Locatemelab = UILabel()
        Locatemelab.frame = CGRect(x:30, y:5, width:75, height:20)
        Locatemelab.numberOfLines=0
        Locatemelab.text="Locate me"
        Locatemelab.font =  UIFont(name:"Helvetica", size: 14)
        Locatemelab.textColor=UIColor.white
        Locatemelab.textAlignment = .center
        NotifyMe.addSubview(Locatemelab)
        
        let locatemebutt = UIButton()
        locatemebutt.frame = CGRect(x:0, y:0, width:NotifyMe.frame.size.width, height:30)
        locatemebutt.addTarget(self, action: #selector(StepFourFoodShareVC.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        NotifyMe.addSubview(locatemebutt)
    }
    
    
    
    func CloseButtonAction2(_ sender: UIButton!)
    {
        //tabBarController?.tabBar.isHidden=false
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    func locationButtonAction2(_ sender: UIButton!)
    {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        present(navigationController, animated: true, completion: { _ in })
    }
    
    
    func UselocationButtonAction(_ sender: UIButton!)
    {
       // tabBarController?.tabBar.isHidden=false
        popview3.isHidden=true
        footerView3.isHidden=true
    }
    
    func locatemeButtonAction(_ sender: UIButton!)
    {
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            currentLatitude = (locationManager.location?.coordinate.latitude)!
            currentLongitude = (locationManager.location?.coordinate.longitude)!
            firstLatitude = (locationManager.location?.coordinate.latitude)!
            firstLongitude = (locationManager.location?.coordinate.longitude)!
        }
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        self.mapView2.animate(to: camera)
        
        
        self.setUsersClosestCity()
    }
    
    
    
    
    
    
    
    // MARK: Finish Button Action:
    @IBAction func finishButtonAction(_ sender: Any)
    {
    
        var message = String()
        if (radioBtnStringChk == "nocheck")
        {
             message = "Please select any one to share your food"
        }
        else if (radioBtnStringChk == "FoodBankNearBy")
        {
            if (searchFDBnkTF.text?.isEmpty)!
            {
                message = "Please Select Foodbank"
            }
        }
        else if (radioBtnStringChk == "FromMyLocation")
        {
            if (searchFDBnkTF.text?.isEmpty)!
            {
                message = "Please Select Foodbank"
            }
            else if (searchVolunteerTF.text?.isEmpty)!
            {
                message = "Please Select location Volunteers need to collect it"
            }
        }
        else if (radioBtnStringChk == "FromMyLocation2")
        {
            if (searchLoctnTF.text?.isEmpty)!
            {
                message = "Please Select location to contact"
            }
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
            if strStatus == "0"
            {
                self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(mealtitle)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(mealDescription)&no_of_meal_hidden=\(mealQuantity)&hours_hidden=\(hoursHidden)&share_meal_image=\(imageString)&lat=\(checklat)&longt=\(checklong)&share_with=\(strStatus)&food_bankid=\(strFoodbankId)&address=\(straddress)")
            }
            else if strStatus == "1"
            {
                self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(mealtitle)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(mealDescription)&no_of_meal_hidden=\(mealQuantity)&hours_hidden=\(hoursHidden)&share_meal_image=\(imageString)&lat=\(currentLatitude)&longt=\(currentLongitude)&share_with=\(strStatus)&food_bankid=\(strFoodbankId)&address=\(straddress2)")
            }
            else
            {
             self.fodbankshareMealMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=shareMeal&user_id=\(strUserID)&meal_title=\(mealtitle)&meal_category=\(categoryStr)&food_type=\(subCategoryStr)&meal_desc=\(mealDescription)&no_of_meal_hidden=\(mealQuantity)&hours_hidden=\(hoursHidden)&share_meal_image=\(imageString)&lat=\(currentLatitude)&longt=\(currentLongitude)&share_with=\(strStatus)&address=\(straddress2)")
            }
        }
    }
    
    
    
    
    @objc private   func fodbankshareMealMethod (baseURL:String , params: String)
    {
        
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                print(responceDic)
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    
//                    let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareFoodVC") as! ShareFoodVC
//                    self.navigationController?.pushViewController(proVC, animated: true)
                    
                     _ = self.navigationController?.popToRootViewController(animated: true)
                    
//                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController
//                    self.navigationController?.pushViewController(myVC!, animated: true)
//                    
//                    myVC?.selectedIndex=2
                    
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
    

    
    
  @IBAction func previousButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)

    }

    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: false)
    }
      
    
    
    // MARK: Get Current location Name And Lat, Long Delegates
    func setUsersClosestCity()
    {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
//        geoCoder.reverseGeocodeLocation(location)
//        {
//            (placemarks, error) -> Void in
//            if ((error) != nil)
//            {
//                self.searchLoctnTF.text! = ""
//                print("Locarion Error :\((error?.localizedDescription)! as String)")
//                //     AFWrapperClass.alert(Constants.applicationName, message: String(format: "+%@",diallingCode), view: self)
//            }
//            else{
//                let placeArray = placemarks as [CLPlacemark]!
//                var placeMark: CLPlacemark!
//                placeMark = placeArray?[0]
//                
//                if placeMark.isoCountryCode != nil
//                {
//                    let locationNameFul =
//                        String(format:"%@, %@",placeMark.subLocality! as String,placeMark.locality! as String)
//                    
//                    self.searchLoctnTF.text! = locationNameFul
//                }
//            }
//        }
        
      
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
                
                self.straddress2 = formattedAddress.joined(separator: ", ") as NSString
                self.searchLoctnTF.text! = formattedAddress.joined(separator: ", ")
                self.searchVolunteerTF.text! =  formattedAddress.joined(separator: ", ")
            }
            
        })

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension StepFourFoodShareVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        searchLoctnTF.text! = place.name as String
      //  geoCodeUsingAddress(address: place.name as NSString)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


extension StepFourFoodShareVC: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView.delegate = self;
        
        currentLatitude=position.target.latitude
        currentLongitude=position.target.longitude
        
        
        self.locationlab.text! = "Featching Address..."
        self.searchLoctnTF.text! = "Featching Address..."
        self.searchVolunteerTF.text! = "Featching Address..."
        
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        self.mapView.animate(to: camera)
        
        
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    
    private func mapView(mapView:GMSMapView!,idleAtCameraPosition position:GMSCameraPosition!)
    {
        print(position)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            self.locationlab.text! = "Unable to Find Address for Location"
            self.searchLoctnTF.text! = "Unable to Find Address for Location"
            self.searchVolunteerTF.text! = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.locationlab.text! = placemark.compactAddress!
                self.searchLoctnTF.text! = placemark.compactAddress!
                 self.searchVolunteerTF.text! = placemark.compactAddress!
                 straddress2 = placemark.compactAddress! as NSString
                
            } else {
                self.locationlab.text! = "No Matching Addresses Found"
                self.searchLoctnTF.text! = "No Matching Addresses Found"
                self.searchVolunteerTF.text! = "No Matching Addresses Found"
            }
        }
    }
}



extension StepFourFoodShareVC: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        locationlab.text = place.formatted_address
        self.searchLoctnTF.text! = place.formatted_address
        self.searchVolunteerTF.text! = place.formatted_address
        straddress2 = place.formatted_address as NSString
        currentLatitude=place.location.coordinate.latitude
        currentLongitude=place.location.coordinate.longitude
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        mapView2.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        self.marker.icon = UIImage(named: "Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.title = place.formatted_address
        mapView.reloadInputViews()
    }
}


