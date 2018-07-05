//
//  BannerViewFullSizeVC.swift
//  FoodForAll
//
//  Created by amit on 5/9/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import LCBannerView
import SDWebImage
class BannerViewFullSizeVC: UIViewController,LCBannerViewDelegate
{

    
    
    @IBOutlet weak var imageViewBack: UIImageView!
    
    var imagesArrayFul = NSArray()
    var x: Int = 0
    var pagecontrol = UIPageControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if self.imagesArrayFul.count == 0
//        {
//            self.imagesArrayFul = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
//            self.perform(#selector(BannerViewFullSizeVC.showBannerView), with: nil, afterDelay: 0.02)
//        }else{
//            self.perform(#selector(BannerViewFullSizeVC.showBannerView), with: nil, afterDelay: 0.02)
//        }
        
        
        pagecontrol.frame = CGRect(x:self.view.frame.size.width/2-75, y:self.view.frame.size.height-80, width:150, height:30)
        pagecontrol.numberOfPages = imagesArrayFul.count
        pagecontrol.tintColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        pagecontrol.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pagecontrol)
        
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewRightSwipped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CollectionViewLeftSwipped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        imageViewBack.addGestureRecognizer(swipeLeft)
        imageViewBack.addGestureRecognizer(swipeRight)
        imageViewBack.contentMode = .scaleAspectFit
        imageViewBack.clipsToBounds = true
        
        if imagesArrayFul.count == 0
        {
            imageViewBack.image = UIImage(named: "Logo")
            pagecontrol.currentPage = self.x
        }
        else
        {
            let imageURL: String = imagesArrayFul.object(at: self.x) as! String
            let url = NSURL(string:imageURL)
            imageViewBack.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
            pagecontrol.currentPage = self.x
        }
    }
    
    
    func CollectionViewLeftSwipped()
    {
        if self.x == 0
        {
            
        }
        else if self.x > 0
        {
            self.x = self.x - 1
            let imageURL: String = imagesArrayFul.object(at: self.x) as! String
            let url = NSURL(string:imageURL)
            imageViewBack.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
            pagecontrol.currentPage = self.x
        }
    }
    
    func CollectionViewRightSwipped()
    {
        if self.x < self.imagesArrayFul.count
        {
            let count: Int = self.imagesArrayFul.count-1
            
            if self.x == count
            {
                
            }
            else
            {
                self.x = self.x + 1
                let imageURL: String = imagesArrayFul.object(at: self.x) as! String
                let url = NSURL(string:imageURL)
                imageViewBack.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
                pagecontrol.currentPage = self.x
            }
            
        } else {
            self.x = 0
            let imageURL: String = imagesArrayFul.object(at: self.x) as! String
            let url = NSURL(string:imageURL)
            imageViewBack.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "Logo"))
            pagecontrol.currentPage = self.x
        }
    }

    
    
    
    func showBannerView()
    {
        let imagesDataArray = NSMutableArray()
        for i in 0..<imagesArrayFul.count
        {
            let image: String = imagesArrayFul.object(at: i) as! String
            //as! NSDictionary).object(forKey: "link") as! String
            let image1 = image.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
            imagesDataArray.add(image1 as Any)
        }
        
        if imagesDataArray.count == 1
        {
             let bannerview = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: self.imageViewBack.frame.size.width, height: self.view.frame.size.height-64), delegate: self, imageURLs: (imagesArrayFul as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 500, currentPageIndicatorTintColor: UIColor.clear, pageIndicatorTintColor: UIColor.clear)
            bannerview?.clipsToBounds = true
            bannerview?.notScrolling = true
            bannerview?.contentMode = .scaleAspectFit
            imageViewBack.addSubview(bannerview!)
        }
        else
        {
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 64, width: self.imageViewBack.frame.size.width, height: self.view.frame.size.height-64), delegate: self, imageURLs: (imagesArrayFul as NSArray) as! [Any], placeholderImage:"Logo", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
         banner?.clipsToBounds = true
        banner?.contentMode = .scaleAspectFit
        imageViewBack.addSubview(banner!)
        }
        
        
    }
    
 
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
