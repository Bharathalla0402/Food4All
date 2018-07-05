//
//  VideoPlayViewController.swift
//  FoodForAll
//
//  Created by think360 on 31/03/18.
//  Copyright © 2018 Think360Solutions. All rights reserved.
//

import UIKit

class VideoPlayViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var DataWebView: UIWebView!
    var strwebUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataWebView.loadRequest(URLRequest(url: URL(string: strwebUrl)!))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // web Delegate methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (error.localizedDescription == "The Internet connection appears to be offline.") {
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert("NetWork Error!", message: "Please check your mobile data/WiFi Connection", view: self)
        }
        if (error.localizedDescription == "The request timed out.") {
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
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
