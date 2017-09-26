//
//  StepTwoShareFoodVC.swift
//  FoodForAll
//
//  Created by amit on 5/11/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class StepTwoShareFoodVC: UIViewController {

    
    @IBOutlet weak var preparationBtn: UIButton!
    @IBOutlet weak var storageBtn: UIButton!
    @IBOutlet weak var packedFdBtn: UIButton!
    @IBOutlet weak var preparatnImage: UIImageView!
    @IBOutlet weak var storageImageVw: UIImageView!
    @IBOutlet weak var packedImageVw: UIImageView!
    
    
    @IBOutlet weak var preHightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var storageLblHightConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var packedLblHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var preparatioLbl: UILabel!
    @IBOutlet weak var starageLabel: UILabel!
    @IBOutlet weak var packedFdLabel: UILabel!
    
    
    @IBOutlet weak var preparationView: UIView!
    @IBOutlet weak var storageView: UIView!
    @IBOutlet weak var packedView: UIView!
    
    
    @IBOutlet weak var preparationNameLbl: UILabel!
    @IBOutlet weak var srotageNameLbl: UILabel!
    @IBOutlet weak var packedNameLbl: UILabel!
    var saftyString = String()
    
    var categoryStr = String()
    var subCategoryStr = String()
    
    
    
    @IBOutlet weak var saftyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "cat1") != nil
        {
            categoryStr = (UserDefaults.standard.object(forKey: "cat1") as! NSString) as String
        }
        
        if UserDefaults.standard.object(forKey: "cat2") != nil
        {
            subCategoryStr = (UserDefaults.standard.object(forKey: "cat2") as! NSString) as String
        }
        else
        {
            subCategoryStr = ""
        }
        
        print(categoryStr)
        print(subCategoryStr)
        
        
        saftyString = "0"
        saftyBtn.isSelected = true
        saftyBtn.setImage(UIImage(named: "UncheckBox"), for: .normal)
        
       // self.hideLabels()
      //  preHightConstrain.constant = 80
      //  preparatioLbl.isHidden = false
       // preparationView.backgroundColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
      //  preparationNameLbl.textColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
       
    }

    @IBAction func preparationbrnAction(_ sender: Any) {
        self.hideLabels()
        preHightConstrain.constant = 80
        preparatioLbl.isHidden = false
        preparationView.backgroundColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        preparationNameLbl.textColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
    }
    
    
    @IBAction func stotageBtnAction(_ sender: Any) {
        self.hideLabels()
        storageLblHightConstrant.constant = 80
        starageLabel.isHidden = false
        storageView.backgroundColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        srotageNameLbl.textColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
    }
    
    @IBAction func packedbtnAction(_ sender: Any) {
        self.hideLabels()
        packedLblHightConstraint.constant = 140
        packedFdLabel.isHidden = false
        packedView.backgroundColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
        packedNameLbl.textColor = #colorLiteral(red: 0.5520249009, green: 0.773814857, blue: 0.2442161441, alpha: 1)
    }
    
    
    
    @objc private func hideLabels() -> Void
    {
        preHightConstrain.constant = 0
        preparatioLbl.isHidden = true
        storageLblHightConstrant.constant = 0
        starageLabel.isHidden = true
        packedLblHightConstraint.constant = 0
        packedFdLabel.isHidden = true
        preparationView.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        preparationNameLbl.textColor = #colorLiteral(red: 0.2627187967, green: 0.2627618909, blue: 0.2627093196, alpha: 1)
        storageView.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        srotageNameLbl.textColor = #colorLiteral(red: 0.2627187967, green: 0.2627618909, blue: 0.2627093196, alpha: 1)
        packedView.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        packedNameLbl.textColor = #colorLiteral(red: 0.2627187967, green: 0.2627618909, blue: 0.2627093196, alpha: 1)
    }
    
 
    @IBAction func safetyQualityBtnAction(_ sender: UIButton)
    {
        if sender.isSelected {
            
            saftyBtn.setImage(UIImage(named: "CheckRightbox"), for: .normal)
            sender.isSelected = false
            saftyString = "1"
            
            print("select 1")
        } else {
            
            print("Un select 0")
            saftyBtn.setImage(UIImage(named: "UncheckBox"), for: .normal)
            sender.isSelected = true
            saftyString = "0"
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any)
    {
        if saftyString == "1" {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "StepThreeShareFoodVC") as? StepThreeShareFoodVC
            self.navigationController?.pushViewController(myVC!, animated: false)
            
            myVC?.categoryStr = categoryStr
            myVC?.subCategoryStr = subCategoryStr
        }else{
            AFWrapperClass.alert(Constants.applicationName, message: "Please accept I assure food safety and quality", view: self)
        }
    }
    
    
    
    
    
    
    @IBAction func previousBtnAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
