//
//  VolunteerDetailsViewController.swift
//  FoodForAll
//
//  Created by think360 on 27/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class CollectionCell2: UICollectionViewCell {
    
    @IBOutlet weak var foodbankImage: UIImageView!
    @IBOutlet weak var foodbankName: UILabel!
    
}


class VolunteerDetailsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate {

    var VolunteerDetails = NSDictionary()
    var listArrayfoodbanks = NSArray()
    
    
    var Directionlatitude = NSString()
    var Directionlongitude = NSString()
    var Uselocationbutt = UIButton()
    var alertCtrl2: UIAlertController?
    
    var cell: CollectionCell2!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    var searchViewController = ABCGooglePlacesSearchViewController()
    
    var myArray = NSDictionary()
    var strUserID = NSString()
    var status6 = NSString()
    var textlab = UILabel()
    
    @IBOutlet weak var bgImageview: UIImageView!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var VolunteerSince: UILabel!
    @IBOutlet weak var nameVolunteer: UILabel!
    @IBOutlet weak var DescriptionLab: UILabel!
    @IBOutlet weak var EmailPhone: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var MapBgView: UIView!
    @IBOutlet weak var addresslab: UILabel!
    
    @IBOutlet weak var Distancelab: UILabel!
    
    @IBOutlet weak var foodbankCollectionview: UICollectionView!
    
    @IBOutlet weak var connectedFoodbankView: UIView!
    @IBOutlet weak var connectedFBlab: UILabel!
    
    @IBOutlet weak var collectionviewheight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var vollab1: UILabel!
    @IBOutlet weak var vollab2: UILabel!
    @IBOutlet weak var aboutlab1: UILabel!
    @IBOutlet weak var aboutlab2: UILabel!
    @IBOutlet weak var emaillab1: UILabel!
    @IBOutlet weak var emaillab2: UILabel!
    @IBOutlet weak var phonelab1: UILabel!
    @IBOutlet weak var phonelab2: UILabel!
    @IBOutlet weak var addresslab1: UILabel!
    @IBOutlet weak var addresslab2: UILabel!
    @IBOutlet weak var distancelab1: UILabel!
    @IBOutlet weak var distancelab2: UILabel!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        textlab.frame = CGRect(x:connectedFoodbankView.frame.size.width/2-100, y:connectedFoodbankView.frame.size.height/2-20, width:200, height:40)
        textlab.text="No Connected Food Banks"
        textlab.font =  UIFont(name:"Helvetica", size: 16)
        textlab.textColor=UIColor.black
        textlab.textAlignment = .center
        textlab.isHidden=true
        connectedFoodbankView.addSubview(textlab)
        
        
        

       
        userName.text = self.VolunteerDetails.object(forKey: "first_name") as? String
        listArrayfoodbanks = (self.VolunteerDetails.object(forKey: "foodbank") as? NSArray)!
        
        if listArrayfoodbanks.count == 0
        {
            // textlab.isHidden=false
            collectionviewheight.constant = 20
            connectedFBlab.isHidden = true
            
        }
        
        
        let stringUrl = self.VolunteerDetails.value(forKey: "image") as! NSString
        let url = URL.init(string:stringUrl as String)
        ProfilePic.sd_setImage(with: url , placeholderImage: UIImage(named: "applogo.png"))
        
        if UserDefaults.standard.object(forKey: "UserId") != nil
        {
            myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
            strUserID=myArray.value(forKey: "id") as! NSString
        }
        else
        {
            strUserID = ""
        }
        
        
        
        let mutableAttributedString = NSMutableAttributedString()
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        
        let regularAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ] as [String : Any]
        
        
        let boldAttributedString = NSAttributedString(string: "", attributes: boldAttribute)
        var status: NSString = String(format:"%@",(self.VolunteerDetails.object(forKey: "Volunteer_date") as? String)!) as NSString
        if status == ""
        {
            status = "NA"
            //vollab1.isHidden = true
            //vollab2.isHidden = true
        }
        let regularAttributedString = NSAttributedString(string: status as String, attributes: regularAttribute)
        mutableAttributedString.append(boldAttributedString)
        mutableAttributedString.append(regularAttributedString)
        VolunteerSince.attributedText = mutableAttributedString

        
        let mutableAttributedString2 = NSMutableAttributedString()
        let boldAttributedString2 = NSAttributedString(string: "", attributes: boldAttribute)
        var status2: NSString = String(format:"%@",(self.VolunteerDetails.object(forKey: "description") as? String)!) as NSString
        if status2 == ""
        {
            status2 = "NA"
            //aboutlab1.isHidden = true
            //aboutlab2.isHidden = true
        }
        let regularAttributedString2 = NSAttributedString(string: status2 as String, attributes: regularAttribute)
        mutableAttributedString2.append(boldAttributedString2)
        mutableAttributedString2.append(regularAttributedString2)
        DescriptionLab.attributedText = mutableAttributedString2
        
        let mutableAttributedString3 = NSMutableAttributedString()
        let boldAttributedString3 = NSAttributedString(string: "", attributes: boldAttribute)
        var status3: NSString = String(format:"%@",(self.VolunteerDetails.object(forKey: "email") as? String)!) as NSString
        if status3 == ""
        {
            status3 = "NA"
            //emaillab1.isHidden = true
            //emaillab2.isHidden = true
        }
        let regularAttributedString3 = NSAttributedString(string: status3 as String, attributes: regularAttribute)
        mutableAttributedString3.append(boldAttributedString3)
        mutableAttributedString3.append(regularAttributedString3)
        EmailPhone.attributedText = mutableAttributedString3
        
        let mutableAttributedString4 = NSMutableAttributedString()
        let boldAttributedString4 = NSAttributedString(string: "", attributes: boldAttribute)
        var status4: NSString = String(format:"%@",(self.VolunteerDetails.object(forKey: "phone_no") as? String)!) as NSString
        if status4 == ""
        {
             status4 = "NA"
            //phonelab1.isHidden = true
            //phonelab2.isHidden = true
        }
        let regularAttributedString4 = NSAttributedString(string: status4 as String, attributes: regularAttribute)
        mutableAttributedString4.append(boldAttributedString4)
        mutableAttributedString4.append(regularAttributedString4)
        phone.attributedText = mutableAttributedString4
        
        
        let mutableAttributedString5 = NSMutableAttributedString()
        let boldAttributedString5 = NSAttributedString(string: "", attributes: boldAttribute)
        var status5: NSString = String(format:"%@",(self.VolunteerDetails.object(forKey: "address") as? String)!) as NSString
        if status5 == ""
        {
            status5 = "NA"
           // addresslab1.isHidden = true
           // addresslab2.isHidden = true
        }
        let regularAttributedString5 = NSAttributedString(string: status5 as String, attributes: regularAttribute)
        mutableAttributedString5.append(boldAttributedString5)
        mutableAttributedString5.append(regularAttributedString5)
        addresslab.attributedText = mutableAttributedString5
        
        
        let mutableAttributedString6 = NSMutableAttributedString()
        let boldAttributedString6 = NSAttributedString(string: "", attributes: boldAttribute)
        if let quantity = VolunteerDetails.object(forKey: "distance") as? NSNumber
        {
            let strval: NSString = (quantity: quantity.stringValue) as NSString
            
             status6 = String(format:"%@ Kms", strval) as NSString
        }
        else if let quantity = VolunteerDetails.object(forKey: "distance") as? String
        {
             status6 = String(format:"%@ Kms", quantity) as NSString
        }
        if status6 == ""
        {
            status6 = "NA"
           // distancelab1.isHidden = true
          //  distancelab2.isHidden = true
        }
        let regularAttributedString6 = NSAttributedString(string: status6 as String, attributes: regularAttribute)
        mutableAttributedString6.append(boldAttributedString6)
        mutableAttributedString6.append(regularAttributedString6)
        Distancelab.attributedText = mutableAttributedString6
       

        
        
    
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
        

        self.perform(#selector(VolunteerDetailsViewController.showMapView), with: nil, afterDelay: 0.01)

    }
    
    
    
    @objc private  func showMapView()
    {
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.MapBgView.frame.size.width, height: self.MapBgView.frame.size.height), camera: camera)
        mapView.delegate = self
        self.mapView.settings.compassButton = true
        //self.mapView.isMyLocationEnabled = true
        self.mapView.isUserInteractionEnabled = false
        self.MapBgView.addSubview(mapView)
        
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.title = self.VolunteerDetails.value(forKey: "address") as? String
        self.marker.icon = self.image(withReduce: UIImage(named:"map_pin96.png")!, scaleTo: CGSize(width: CGFloat(50), height: CGFloat(50)))
        self.marker.map = self.mapView
        
    }
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }

    
    func multipleParamSelector2()
    {
        let googleMapUrlString: String? = "comgooglemaps://?.saddr=\("")&daddr=\(Directionlatitude),\(Directionlongitude)&directionsmode=driving"
        let trimmedString: String? = googleMapUrlString?.replacingOccurrences(of: " ", with: "")
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: trimmedString!)!, options: [:], completionHandler: nil)
        }
        else {
            alertCtrl2?.popoverPresentationController?.sourceView = view
            present(alertCtrl2!, animated: true, completion: {() -> Void in
            })
        }
    }
    
    
    
   
    
    
    

   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.listArrayfoodbanks.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell2", for: indexPath) as! CollectionCell2
        
        
        
        cell.foodbankName.text! = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_title") as! String
        
        let imageURL: String = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "Foodbank_image") as! String
        let url = NSURL(string:imageURL)
        cell.foodbankImage.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let userID:String = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_id") as! String
        if userID == strUserID as String
        {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MyFoodBankDetailsVC") as? MyFoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_id") as! String
            myVC?.percentStr = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "percentage") as! String
        }
        else{
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodBankDetailsVC") as? FoodBankDetailsVC
            myVC?.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(myVC!, animated: true)
            
            myVC?.foodbankID = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "fbank_id") as! String
            myVC?.percentStr = (self.listArrayfoodbanks.object(at: indexPath.row) as! NSDictionary).object(forKey: "percentage") as! String
        }

    }
    
    
    
    @objc private  func GetVolunteerDetailslistAPIMethod (baseURL:String , params: String)
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
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "VolunteerDetailsViewController") as? VolunteerDetailsViewController
                    myVC?.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
                    myVC?.VolunteerDetails = responceDic.object(forKey: "VolunteerList") as! NSDictionary
                    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return CGSize(width: 142, height: 163)
        }
        return CGSize(width: 142, height: 163)
    }
    

    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
