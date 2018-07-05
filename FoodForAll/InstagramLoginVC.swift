//
//  InstagramLoginVC.swift
//  InstagramLogin-Swift
//
//  Created by Aman Aggarwal on 2/7/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit
import Alamofire
import InstagramKit

class InstagramLoginVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    var dataDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginWebView.delegate = self
        unSignedRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
//        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
//        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
//        loginWebView.loadRequest(urlRequest)
        
        // load URL
        let authURL = InstagramEngine.shared().authorizationURL()
        loginWebView.loadRequest(URLRequest.init(url: authURL))
    }

    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
       // print("Instagram authentication token ==", authToken)
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        do {
            if let url = request.url {
                
                print(url)
                
                if String(describing: url).range(of: "#access_token") != nil {
                    
                    try InstagramEngine.shared().receivedValidAccessToken(from: url)
                    
                    if let accessToken = InstagramEngine.shared().accessToken {
                      //  print("accessToken: \(accessToken)")
                        //start
                        
                        let URl =  "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)"
                        
                        let parameter = [ "access_token" : accessToken ]
                        
                        //    let URl = "https://api.instagram.com/v1/users/self/"
                        
                        appInstance.showLoader()
                        Alamofire.request(URl, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                            .responseJSON { response in
                               appInstance.hideLoader()
                              //  print(response.result.value!)
                                
                                if response.result.isSuccess {
                                    
                                    let dict = response.result.value!
                                    
                                    do {
                                        
                                        var result : [String : AnyObject] = [String : AnyObject]()
                                        
                                        let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                                        
                                        if let json = NSString(data: data, encoding:  String.Encoding.utf8.rawValue){
                                            
                                          //  print(json)
                                            result["result"] = json
                                            
                                            let responceDic:NSDictionary = ((dict as AnyObject).object(forKey: "meta") as? NSDictionary)!
                                            
                                            
                                            if (((responceDic as AnyObject).object(forKey: "code")) as! NSNumber) == 200
                                            {
                                                self.dataDic = ((dict as AnyObject).object(forKey: "data") as? NSDictionary)!
                                                
                                                //print(self.dataDic)
                                                
                                                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialRegistrationVC") as? SocialRegistrationVC
                                                self.navigationController?.pushViewController(myVC!, animated: true)
                                                
                                                // let number = (self.dataDic as AnyObject).object(forKey: "id") as! NSNumber
                                                
                                                
                                                myVC?.nameGet = self.dataDic.object(forKey: "full_name") as! String
                                                myVC?.socialID = (self.dataDic as AnyObject).object(forKey: "id") as! String
                                                let url: NSString = (self.dataDic.object(forKey: "profile_picture") as? NSString)!
                                                myVC?.imgURL = NSURL(string: url as String)!
                                                myVC?.emailChkStr = "NO"
                                                myVC?.socialRegistaerStr = "Instagram"
                                                
                                                
//                                                let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
//                                                for cookie in cookieJar.cookies! as [HTTPCookie]{
//                                                    NSLog("cookie.domain = %@", cookie.domain)
//                                                    
//                                                    if cookie.domain == "www.instagram.com" ||
//                                                        cookie.domain == "api.instagram.com"{
//                                                        
//                                                        cookieJar.deleteCookie(cookie)
//                                                    }
//                                                }
                                                
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

    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    @IBAction func backClicked(_ sender: Any)
    {
         _ = self.navigationController?.popViewController(animated: true)
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
