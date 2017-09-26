//
//  AddEventsViewController.swift
//  FoodForAll
//
//  Created by think360 on 05/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire

class AddEventsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate
{
    var camera = GMSCameraPosition()
    var lastCameraPosition = GMSCameraPosition()
    var mapView = GMSMapView()
    var mapView2 = GMSMapView()
    var marker = GMSMarker()
    var marker2 = GMSMarker()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var firstLatitude = Double()
    var firstLongitude = Double()
    var myLatitude = Double()
    var myLongitude = Double()
    var locationManager = CLLocationManager()
    var searchViewController = ABCGooglePlacesSearchViewController()
    var locationlab = UILabel()
    
    var popview = UIView()
    var footerView = UIView()
    var popview2 = UIView()
    var footerView2 = UIView()
    
    var DateStart = String()
    var DateEnd = String()
    
    var startdate = DateFormatter()
    var startDate = Date()
    var EndDate = Date()
    
    @IBOutlet weak var txtEventName: ACFloatingTextfield!
    @IBOutlet weak var txtEventAddress: ACFloatingTextfield!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var txtStartDate: ACFloatingTextfield!
    @IBOutlet weak var txtEndDate: ACFloatingTextfield!
    @IBOutlet weak var txtStartTime: ACFloatingTextfield!
    @IBOutlet weak var txtEndTime: ACFloatingTextfield!
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    var imageTakeArray = NSMutableArray()
    var imagPathArray = NSMutableArray()
    var imgFolderAry = NSMutableArray()
    var DeleteFolderAry = NSMutableArray()
    var responseString = String()
    var responseString2 = String()
    var deletePathStr = String()
    
    @IBOutlet weak var collectionViewSetUp: UICollectionView!
    var cell = SetupCVCell()
    @IBOutlet weak var cameraButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    var myArray = NSDictionary()
    var strUserID = NSString()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.text = "Enter your text here.."
        descriptionTextView.textColor = UIColor.lightGray
        
        myArray = UserDefaults.standard.object(forKey: "UserId") as! NSDictionary
        strUserID=myArray.value(forKey: "id") as! NSString
        
        searchViewController.delegate=self
        
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
        
         self.setUsersClosestCity()

    }
    
    
    // MARK: Get Country Code  and Delegates
    func setUsersClosestCity()
    {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
//        geoCoder.reverseGeocodeLocation(location)
//        {
//            (placemarks, error) -> Void in
//            if ((error) != nil)
//            {
//                self.txtEventAddress.text! = ""
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
//                    self.txtEventAddress.text! = locationNameFul
//                    self.locationlab.text=locationNameFul
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
                
                self.txtEventAddress.text! = formattedAddress.joined(separator: ", ")
                self.locationlab.text=formattedAddress.joined(separator: ", ")
                
            }
            
        })
    }

    
    
    
     //MARK: Event Address Clicked:
    
    @IBAction func EventAddressClicked(_ sender: UIButton)
    {
        popview.isHidden=false
        footerView.isHidden=false
        
        popview.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        popview.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1.png")!)
        self.view.addSubview(popview)
        
        footerView.frame = CGRect(x:0, y:0, width:popview.frame.size.width, height:popview.frame.size.height)
        footerView.backgroundColor = UIColor.white
        popview.addSubview(footerView)
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 8.0)
        mapView2 = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: footerView.frame.size.width, height: footerView.frame.size.height), camera: camera)
        mapView2.delegate = self
        self.mapView2.settings.compassButton = true
        footerView.addSubview(mapView2)
        
        
        
        let Headview = UIView()
        Headview.frame = CGRect(x:0, y:0, width:footerView.frame.size.width, height:60)
        Headview.backgroundColor=#colorLiteral(red: 0.5490196078, green: 0.7764705882, blue: 0.2431372549, alpha: 1)
        footerView.addSubview(Headview)
        
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
        crossbutt.addTarget(self, action: #selector(AddEventsViewController.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt)
        
        let crossbutt2 = UIButton()
        crossbutt2.frame = CGRect(x:Headview.frame.size.width-50, y:0, width:50, height:60)
        crossbutt2.addTarget(self, action: #selector(AddEventsViewController.CloseButtonAction(_:)), for: UIControlEvents.touchUpInside)
        Headview.addSubview(crossbutt2)
        
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x:self.view.frame.size.width/2-25, y:self.view.frame.size.height/2-25, width:50, height:50));
        imageView.image = UIImage(named:"map_pin96.png")
        imageView.contentMode = .scaleAspectFit
        footerView.addSubview(imageView)
        
        
        
        
        let locationView = UIView()
        locationView.frame = CGRect(x:20, y:75, width:footerView.frame.size.width-40, height:100)
        locationView.backgroundColor=#colorLiteral(red: 0.3215386271, green: 0.3215884566, blue: 0.3215229511, alpha: 1)
        locationView.layer.cornerRadius=8.0
        footerView.addSubview(locationView)
        
        
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
        locationlab.text = locationlab.text!
        locationlab.font =  UIFont(name:"Helvetica", size: 15)
        locationlab.textColor=UIColor.black
        locationlab.textAlignment = .left
        locationView.addSubview(locationlab)
        
        let locationbutt = UIButton()
        locationbutt.frame = CGRect(x:10, y:52, width:locationView.frame.size.width-20, height:40)
        locationbutt.addTarget(self, action: #selector(AddEventsViewController.locationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        locationView.addSubview(locationbutt)
        
        
        
        
        let uselocation = UIView()
        uselocation.frame = CGRect(x:5, y:footerView.frame.size.height-45, width:footerView.frame.size.width-10, height:40  )
        uselocation.backgroundColor=#colorLiteral(red: 0.9528647065, green: 0.009665175341, blue: 0.3223749697, alpha: 1)
        uselocation.layer.cornerRadius=4.0
        footerView.addSubview(uselocation)
        
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
        Uselocationbutt.addTarget(self, action: #selector(AddEventsViewController.UselocationButtonAction(_:)), for: UIControlEvents.touchUpInside)
        uselocation.addSubview(Uselocationbutt)
        
        
        
        let NotifyMe = UIView()
        NotifyMe.frame = CGRect(x:footerView.frame.size.width/2-55  , y:footerView.frame.size.height-80, width:110, height:30  )
        NotifyMe.backgroundColor=#colorLiteral(red: 0.2156647146, green: 0.2157005072, blue: 0.2156534195, alpha: 1)
        NotifyMe.layer.cornerRadius=4.0
        footerView.addSubview(NotifyMe)
        
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
        locatemebutt.addTarget(self, action: #selector(AddEventsViewController.locatemeButtonAction(_:)), for: UIControlEvents.touchUpInside)
        NotifyMe.addSubview(locatemebutt)
    }
    
    
    func CloseButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
    }
    
    func locationButtonAction(_ sender: UIButton!)
    {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        present(navigationController, animated: true, completion: { _ in })
    }
    
    
    func UselocationButtonAction(_ sender: UIButton!)
    {
        popview.isHidden=true
        footerView.isHidden=true
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
        
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.icon = UIImage(named: "Lmap_pin48.png")!.withRenderingMode(.alwaysTemplate)
        self.marker.map = self.mapView
        mapView.reloadInputViews()
        
        mapView2.delegate = self
        mapView2.camera=camera
        
        self.setUsersClosestCity()
    }

    
    
    
     //MARK: Start Date Clicked:
    
    @IBAction func StartDateClicked(_ sender: UIButton)
    {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 40)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            
              self.startDate = date
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd/MM/YYYY"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "hh:mm aa"
            
            
            print(formatter.string(from: date))
            
            self.txtStartDate.text = formatter1.string(from: date)
            //self.txtStartTime.text = formatter2.string(from: date)
            self.txtStartTime.text =  String(format: "%@", formatter2.string(from: date))
            
            //self.item.title = formatter.string(from: date)
        }

    }
    
    
     //MARK: End Date Clicked:
    
    @IBAction func EndDateClicked(_ sender: UIButton)
    {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 40)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            
            self.EndDate = date
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd/MM/YYYY"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "hh:mm aa"
            
            print(formatter.string(from: date))
            
            self.txtEndDate.text = formatter1.string(from: date)
           // self.txtEndTime.text = formatter2.string(from: date)
            self.txtEndTime.text =  String(format: "%@", formatter2.string(from: date))
            
            //self.item.title = formatter.string(from: date)
        }

    }
    
    
     //MARK: Start Time Clicked:
    
    @IBAction func StartTimeClicked(_ sender: UIButton)
    {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 40)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            
            self.startDate = date
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd/MM/YYYY"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "hh:mm aa"
            
            print(formatter.string(from: date))
            
            self.txtStartDate.text = formatter1.string(from: date)
            self.txtStartTime.text =  String(format: "%@", formatter2.string(from: date))
            
            //self.item.title = formatter.string(from: date)
        }

    }
    
    
     //MARK: End Time Clicked:
    
    @IBAction func EndTimeClicked(_ sender: UIButton)
    {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 40)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            
             self.EndDate = date
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd/MM/YYYY"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "hh:mm aa"
            
            print(formatter.string(from: date))
            
            self.txtEndDate.text = formatter1.string(from: date)
            self.txtEndTime.text =  String(format: "%@", formatter2.string(from: date))
            
            //self.item.title = formatter.string(from: date)
        }
 
    }
    
    
    
    
    
    
     //MARK: Camera butt Clicked:
    

    @IBAction func CameraButtClicked(_ sender: UIButton)
    {
        if self.imagPathArray.count == 5
        {
            AFWrapperClass.alert(Constants.applicationName, message: "You can add up to five images only.", view: self)
        }else{
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
            let pibraryAction = UIAlertAction(title: "From Photo Library", style: .default, handler:
                {(alert: UIAlertAction!) -> Void in
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.present(self.imagePicker, animated: true, completion: nil)
            })
            let cameraction = UIAlertAction(title: "Camera", style: .default, handler:
                {(alert: UIAlertAction!) -> Void in
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                        self.imagePicker.cameraCaptureMode = .photo
                        self.imagePicker.modalPresentationStyle = .fullScreen
                        self.present(self.imagePicker,animated: true,completion: nil)
                        
                    } else {
                        AFWrapperClass.alert(Constants.applicationName, message: "Sorry, this device has no camera", view: self)
                    }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                {
                    (alert: UIAlertAction!) -> Void in
            })
            optionMenu.addAction(pibraryAction)
            optionMenu.addAction(cameraction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
                popOverPresentationController.sourceView                = cameraButton
                popOverPresentationController.sourceRect                = cameraButton.bounds
                popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
            }
        }

    }
    
    
    func image(withReduce imageName: UIImage, scaleTo newsize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newsize, false, 12.0)
        imageName.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newsize.width), height: CGFloat(newsize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: CGFloat(25), height: CGFloat(25)))
        
        self.uploadImageAPIMethod()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
    }

    
    
    //MARK: Upload image Method API:
    
    func uploadImageAPIMethod () -> Void
    {
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 1)
        if imageData == nil {
            //            let imgData: Data? = UIImageJPEGRepresentation(cell.imageViewColctn.image!, 1)
            //            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            
            AFWrapperClass.alert(Constants.applicationName, message: "Please choose images", view: self)
        }
        
        let parameters = ["method":"imageupload"] as [String : String]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let image = self.currentSelectedImage
            multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "img", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    print(Progress())
                    if response.result.isSuccess
                        //print(response.result.value as! NSDictionary)
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        
                        let dataDic : NSDictionary = response.result.value as! NSDictionary
                        if (dataDic.object(forKey: "responseCode") as! NSNumber) == 200
                        {
                            
                            var arrUrl = [Any]()
                            arrUrl.append((dataDic.object(forKey: "imagepath") as? String)!)
                            self.imagPathArray.addObjects(from: arrUrl)
                            
                            var arrPath = [Any]()
                            arrPath.append((dataDic.object(forKey: "imgfolderpath") as? String)!)
                            self.imgFolderAry.addObjects(from: arrPath)
                            
                            var postDict = [AnyHashable: Any]()
                            postDict["locations"] = self.imgFolderAry
                            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
                            self.responseString = String(data: jsonData!, encoding: .utf8)!
                            self.responseString = self.responseString.replacingOccurrences(of: " ", with: "%20")
                            
                            print("Before JsonString: \(self.responseString)")
                            print("Before deleted Array \(self.imgFolderAry)")
                            
                            self.collectionViewSetUp.reloadData()
                            AFWrapperClass.alert(Constants.applicationName, message: "Image Uplaod Successfully", view: self)
                        }
                        else
                        {
                            AFWrapperClass.svprogressHudDismiss(view: self)
                            AFWrapperClass.alert(Constants.applicationName, message: "Image not Uploaded Please try again.", view: self)
                        }
                    }
                    if response.result.isFailure
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError
                        
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                print(error.localizedDescription)
                break
            }
        }
    }
    
    
    //MARK: CollectionView Delegates
    
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imagPathArray.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetupCVCell", for: indexPath) as! SetupCVCell
        
        //        let image:UIImage = self.imageTakeArray.object(at: indexPath.row) as! UIImage
        //        cell.imageViewColctn.image = image
        
        
        let imageURL: String = self.imagPathArray.object(at: indexPath.row) as! String
        print(imageURL)
        let url = NSURL(string:imageURL)
        cell.imageViewColctn.sd_setImage(with: (url) as! URL, placeholderImage: UIImage.init(named: "PlcHldrSmall"))
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(AddEventsViewController.deleteButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    // MARK: Delete Button Action:
    func deleteButtonAction(_ sender: UIButton!) {
        
        let myCell: SetupCVCell? = (sender.superview?.superview as? UICollectionViewCell as! SetupCVCell?)
        let indexPath: IndexPath? = self.collectionViewSetUp.indexPath(for: myCell!)
        if sender.tag == indexPath?.row
        {
            deletePathStr = self.imgFolderAry.object(at: (indexPath?.row)!) as! String
            
            self.imagPathArray.removeObject(at: indexPath?.row ?? Int())
            self.imgFolderAry.removeObject(at: indexPath?.row ?? Int())
            
            var postDict = [AnyHashable: Any]()
            postDict["locations"] = self.imgFolderAry
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.imgFolderAry, options: [])
            self.responseString = String(data: jsonData!, encoding: .utf8)!
            self.responseString = responseString.replacingOccurrences(of: " ", with: "%20")
            
            print("After JsonString: \(self.responseString)")
            //print("after deleted Array \(self.imagPathArray)")
            //print(self.imagPathArray.count)
            
            self.ImageDeleteAPImethod ()
            
            self.collectionViewSetUp.reloadData()
        }
        
    }
    
    
    
    // MARK:  DeleteImageAPImethod
    
    func ImageDeleteAPImethod () -> Void
    {
        var arrPath = [Any]()
        arrPath.append(deletePathStr)
        self.DeleteFolderAry.addObjects(from: arrPath)
        
        var postDict = [AnyHashable: Any]()
        postDict["locations"] = self.DeleteFolderAry
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self.DeleteFolderAry, options: [])
        self.responseString2 = String(data: jsonData!, encoding: .utf8)!
        self.responseString2 = self.responseString.replacingOccurrences(of: " ", with: "%20")
        
        
        let baseURL: String  = String(format:"%@",Constants.mainURL)
        let params = "method=deleteupload&imgfolderpath=\(self.responseString2)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                
                if (responceDic.object(forKey: "responseCode") as! NSNumber) == 200
                {
                    print(responceDic)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    //AFWrapperClass.alert(Constants.applicationName, message: "", view: self)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }
    }
    

    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    
    //MARK: Add Event Clicked:
    
    
    @IBAction func AddEventButtClicked(_ sender: UIButton)
    {
        var message = String()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute]
       // formatter.maximumUnitCount = 2
        
        let stri = formatter.string(from: startDate, to: EndDate)
        
        let fullNameArr = stri?.components(separatedBy: " ")
        let timeVal    = fullNameArr?[0]
       // let s = removeSpecialCharsFromString(text: timeVal!)
        let str = timeVal?.replacingOccurrences(of: ",", with: "")
        let myInt = Int(str!)
        
      //  print(stri! as String)
      //  print(str! as String)
        
        if (txtEventName.text?.isEmpty)!
        {
            message = "Please enter Event name"
        }
        else if (txtEventAddress.text?.isEmpty)!
        {
            message = "Please enter Event Address"
        }
        else if ((descriptionTextView.text?.isEmpty)! || descriptionTextView.text! == "Enter your text here..")
        {
            message = "Please enter description"
        }
        else if (txtStartDate.text?.isEmpty)!
        {
            message = "Please enter Event Start Date"
        }
        else if (txtEndDate.text?.isEmpty)!
        {
            message = "Please enter Event End Date"
        }
        else if (txtStartTime.text?.isEmpty)!
        {
            message = "Please enter Event Start Time"
        }
        else if (txtEndTime.text?.isEmpty)!
        {
            message = "Please enter Event End Time"
        }
        else if (startDate == EndDate)
        {
            message = "End Date&time Must not be equal to Start Date&time"
        }
        else if (startDate > EndDate)
        {
            message = "Start Date&time Must be before End Date&time"
        }
        else if (myInt! <= 58)
        {
            message = "The Start Date&time and End Date&time should be Minimum 1 hour"
        }
        else if (imagPathArray.count == 0)
        {
            message = "Please choose atleast one Event Image"
        }
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }
        else
        {
            let aString = txtStartDate.text
            DateStart = (aString?.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil))!
            
            let aString2 = txtEndDate.text
            DateEnd = (aString2?.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil))!
            
            self.AddEventMethod(baseURL: String(format:"%@",Constants.mainURL) , params: "method=addEvent&user_id=\(strUserID)&event_title=\(txtEventName.text!)&event_desc=\(descriptionTextView.text!)&start_date=\(DateStart)&end_date=\(DateEnd)&start_time=\(txtStartTime.text!)&end_time=\(txtEndTime.text!)&address=\(txtEventAddress.text!)&lat=\(currentLatitude)&lon=\(currentLongitude)&event_image=\(responseString)")
            
        }
    
    }
    
    
    
    
    @objc private  func AddEventMethod(baseURL:String , params: String)
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
                    _ = self.navigationController?.popToRootViewController(animated: true)
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
    

    
    
    
    // MARK: TextView Delegates:
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter your text here.."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK: BackClicked:
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
         _ = self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: DidReceiveMemoryWarning:
    
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



extension AddEventsViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        mapView2.delegate = self;
        
        currentLatitude=position.target.latitude
        currentLongitude=position.target.longitude
        
        self.txtEventAddress.text! = "Featching Address..."
        locationlab.text = "Featching Address..."
        
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
            self.txtEventAddress.text! = "Unable to Find Address for Location"
            locationlab.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.txtEventAddress.text! = placemark.compactAddress!
                locationlab.text = placemark.compactAddress!
                print(self.txtEventAddress.text!)
            } else {
                self.txtEventAddress.text! = "No Matching Addresses Found"
                locationlab.text = "No Matching Addresses Found"
            }
        }
    }
}


extension AddEventsViewController: ABCGooglePlacesSearchViewControllerDelegate {
    
    func searchViewController(_ controller: ABCGooglePlacesSearchViewController, didReturn place: ABCGooglePlace)
    {
        txtEventAddress.text!=place.name
        locationlab.text = place.name
        currentLatitude=place.location.coordinate.latitude
        currentLongitude=place.location.coordinate.longitude
        
        self.marker.map=nil
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView.delegate = self
        mapView.camera=camera
        self.marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        self.marker.map = self.mapView
        self.marker.title = place.formatted_address
        mapView.reloadInputViews()
        
        
        
        camera = GMSCameraPosition.camera(withLatitude: currentLatitude, longitude: currentLongitude, zoom: 10.0)
        mapView2.delegate = self
        mapView2.camera=camera
        
    }
}
