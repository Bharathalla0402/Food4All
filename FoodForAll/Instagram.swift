//
//  InstaWebViewcontroller.swift
//  TaxiApp
//
//  Created by Peerbits on 14/12/16.
//  Copyright © 2016 Peerbits. All rights reserved.
//

import UIKit
import InstagramKit
import Alamofire


class Instagram: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
var dataDic = NSDictionary()
    
    // MARK: Set Instagram details
    var KAUTHURL = "https://api.instagram.com/oauth/authorize/"
    var kAPIURl = "https://api.instagram.com/v1/users/"
    var KCLIENTID = "9c4434f3e5754d63a96ae50e692c7f43"
    var KCLIENTSERCRET = "2ac7b1c8b3b148f0819225d6a616ae5b"
    var kREDIRECTURI = "https://www.food4all.org/"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // load URL
        let authURL = InstagramEngine.shared().authorizationURL()
        webView.loadRequest(URLRequest.init(url: authURL))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: WebView Delegate
    func webView(_ webView: UIWebView, shouldStartLoadWithRequest request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        do {
            if let url = request.url {
                
                print(url)
                
                if String(describing: url).range(of: "#access_token") != nil {
                    
                    try InstagramEngine.shared().receivedValidAccessToken(from: url)
                    
                    if let accessToken = InstagramEngine.shared().accessToken {
                        print("accessToken: \(accessToken)")
                        //start
                        
                        let URl =  "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)"
                        
                        let parameter = [ "access_token" : accessToken ]
                        
                        //    let URl = "https://api.instagram.com/v1/users/self/"
                        
                        appInstance.showLoader()
                        Alamofire.request(URl, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                            .responseJSON { response in
                                appInstance.hideLoader()
                                print(response.result.value!)
                                
                                if response.result.isSuccess {
                                    
                                    let dict = response.result.value!
                                    
                                    do {
                                        
                                        var result : [String : AnyObject] = [String : AnyObject]()
                                        
                                        let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                                        
                                        if let json = NSString(data: data, encoding:  String.Encoding.utf8.rawValue){
                                            
                                           print(json)
                                           result["result"] = json
                                            
                                         let responceDic:NSDictionary = ((dict as AnyObject).object(forKey: "meta") as? NSDictionary)!
                                            
                                          
                                            if (((responceDic as AnyObject).object(forKey: "code")) as! NSNumber) == 200
                                            {
                                                self.dataDic = ((dict as AnyObject).object(forKey: "data") as? NSDictionary)!
                                                
                                                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                                                self.navigationController?.pushViewController(myVC!, animated: true)
                                                
                                               // let number = (self.dataDic as AnyObject).object(forKey: "id") as! NSNumber
                                                
                                                
                                                myVC?.nameGet = self.dataDic.object(forKey: "full_name") as! String
                                                myVC?.socialID = (self.dataDic as AnyObject).object(forKey: "id") as! String
                                                myVC?.emailChkStr = "NO"
                                                myVC?.socialRegistaerStr = "Instagram"
                                               
                                            }
                                            else
                                            {
                                             _ =   self.navigationController?.popViewController(animated: true)
                                            }

                                            
                                            if pbSocialDelegate != nil{
                                                
                                            pbSocialDelegate.getInstagramLoginResponse(userData : result)
                                           _ =   self.navigationController?.popViewController(animated: true)
                                    
                                            }
                                        }
                                        
                                    }catch let err as NSError{
                                        print(err.debugDescription)
                                        _ =   self.navigationController?.popViewController(animated: true)
                                    }
                                }
                        }
                    }
                }
            }
        } catch let err as NSError {
            print(err.debugDescription)
            _ =   self.navigationController?.popViewController(animated: true)
        }
        return true
    }
    
    
}


