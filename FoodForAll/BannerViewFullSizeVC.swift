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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.imagesArrayFul.count == 0
        {
            self.imagesArrayFul = [ "http://think360.in/food4all//assets/file-upload/uploadedPic-322777181.538.jpeg"]
            self.perform(#selector(BannerViewFullSizeVC.showBannerView), with: nil, afterDelay: 0.02)
        }else{
            self.perform(#selector(BannerViewFullSizeVC.showBannerView), with: nil, afterDelay: 0.02)
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
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: self.imageViewBack.frame.size.height/2-150, width: self.imageViewBack.frame.size.width, height: 300), delegate: self, imageURLs: (imagesArrayFul as NSArray) as! [Any], placeholderImage:"PlaceHolderImageLoading", timerInterval: 5, currentPageIndicatorTintColor: UIColor.red, pageIndicatorTintColor: UIColor.white)
        
        banner?.contentMode = .scaleAspectFit
        imageViewBack.addSubview(banner!)
        
        
    }
    
 
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
