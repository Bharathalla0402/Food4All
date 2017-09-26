//
//  StepOneShareFoodVC.swift
//  FoodForAll
//
//  Created by amit on 5/10/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class StepOneShareFoodVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var categeoryTableview: UITableView!
    
    var expandedSections: IndexSet?
    
    @IBOutlet weak var cookedFDhightconstraint: NSLayoutConstraint!
    @IBOutlet weak var packedFdhightconstraint: NSLayoutConstraint!
    @IBOutlet weak var fruitHightconstraint: NSLayoutConstraint!
    @IBOutlet weak var fishHightconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cookedView: UIView!
    @IBOutlet weak var packedView: UIView!
    @IBOutlet weak var fruitView: UIView!
    @IBOutlet weak var fishMealView: UIView!
    
    @IBOutlet weak var cookedButton: UIButton!
    @IBOutlet weak var packedButton: UIButton!
    @IBOutlet weak var fruitsButton: UIButton!
    @IBOutlet weak var fishMeatButton: UIButton!
    @IBOutlet weak var pulsesButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var joinMeButton: UIButton!
    
    
    
    @IBOutlet weak var cookedFoodOne: UIButton!
    @IBOutlet weak var packedButtonOne: UIButton!
    @IBOutlet weak var fruitsButtonOne: UIButton!
    @IBOutlet weak var fishMeatButtonOne: UIButton!
    @IBOutlet weak var pulsesButtonOne: UIButton!
    @IBOutlet weak var drinkButtonOne: UIButton!
    @IBOutlet weak var joinMeButtonOne: UIButton!
    
    
    
    
    @IBOutlet weak var cookedVegBtn: UIButton!
    @IBOutlet weak var cookedNonVegBtn: UIButton!
    @IBOutlet weak var packedVegBtn: UIButton!
    @IBOutlet weak var packedNonVegBtn: UIButton!
    
    @IBOutlet weak var fruitFreshBtn: UIButton!
    @IBOutlet weak var fruitForenzbtn: UIButton!
    @IBOutlet weak var fishmtFreshBtn: UIButton!
    @IBOutlet weak var fishMtFornzbtn: UIButton!
    
    var listCategeory = NSMutableArray()
    var catrgoryStr = String()
    var subCategoryStr = String()
    var productsList1 = [[AnyHashable: Any]]()
    
    var cell: UITableViewCell?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
      //  catrgoryStr = "Cooked Food"
      //  subCategoryStr = ""
      //  self.hideViews()
     //   cookedFDhightconstraint.constant = 41
     //   cookedView.isHidden = false
        
        
        
    }
//MARK: Cooked Food Button Action:
    @IBAction func cookedButtonAction(_ sender: Any)
    {
        catrgoryStr = "Cooked Food"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        cookedFDhightconstraint.constant = 41
        cookedView.isHidden = false
        self.RadioUncheckButton()
        cookedButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
   //MARK: Packed Food Button Action:
    @IBAction func packedfdButtonAction(_ sender: Any)
    {

        catrgoryStr = "Packed Food"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        packedFdhightconstraint.constant = 41
        packedView.isHidden = false
        self.RadioUncheckButton()
        packedButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)


    }
    //MARK: Fruit & Vegetables Button Action:
    @IBAction func fruitsButtonAction(_ sender: Any)
    {
        
        catrgoryStr = "Fruits"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        fruitHightconstraint.constant = 41
        fruitView.isHidden = false
        self.RadioUncheckButton()
        fruitsButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
    //MARK: Fish Meat Button Action:
    @IBAction func fishMeatButtonAction(_ sender: Any)
    {
        catrgoryStr = "Fish Meat"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        fishHightconstraint.constant = 41
        fishMealView.isHidden = false
        self.RadioUncheckButton()
        fishMeatButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
    
    //MARK: Pulse Spice  Button Action:
    @IBAction func pulsesButtonAction(_ sender: Any)
    {
        catrgoryStr = "Pulses Spices"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        pulsesButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
    
   //MARK: Drink & Beverages Button Action:
    @IBAction func drinkButtonAction(_ sender: Any) {
        catrgoryStr = "Drinks"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        
        drinkButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    //MARK: Join me! Button Action:
    @IBAction func joinmeBtnAction(_ sender: Any) {
        catrgoryStr = "Join Me!"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        joinMeButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    @objc private func hideViews() -> Void
    {
        cookedFDhightconstraint.constant = 0
        cookedView.isHidden = true
        packedFdhightconstraint.constant = 0
        packedView.isHidden = true
        fruitHightconstraint.constant = 0
        fruitView.isHidden = true
        fishHightconstraint.constant = 0
        fishMealView.isHidden = true
    }
    @objc private func RadioUncheckButton() -> Void
    {
        cookedButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        packedButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fruitsButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fishMeatButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        pulsesButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        drinkButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        joinMeButton.setImage(UIImage(named: "radio_unclicked"), for: .normal)
    }
    
    //MARK: Cooked Veg Non-veg Button Action:
    
    @IBAction func vegCookedFoodbtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        cookedVegBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Veg"
    }
    
    @IBAction func nonVegCookedFoodbtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        cookedNonVegBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Non-Veg"
    }
    
    //MARK: Packed Veg Non-veg Button Action:
    @IBAction func vegPackedbtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        packedVegBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Veg"
    }
    
    @IBAction func nonVegPackedbtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        packedNonVegBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Non-Veg"
    }
    
    //MARK: Fruit Fresh  and Frozen Button Action:
    @IBAction func freshFruitsbtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        fruitFreshBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Fresh"
    }
    
    
    @IBAction func frozenFruitsBtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        fruitForenzbtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Frozen"
    }
    //MARK: Fish Meat Fresh and Frozen Button Action:
    @IBAction func freshFishMeatBtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        fishmtFreshBtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Fresh"
    }
    
    @IBAction func frozenFishMeatBtnAction(_ sender: Any) {
        self.subCatgryBtnUnchekMethod()
        fishMtFornzbtn.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
        subCategoryStr = "Frozen"
    }
    
    
    @objc private func subCatgryBtnUnchekMethod() -> Void
    {
        cookedVegBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        cookedNonVegBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        packedVegBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        packedNonVegBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fruitFreshBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fruitForenzbtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fishmtFreshBtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        fishMtFornzbtn.setImage(UIImage(named: "radio_unclicked"), for: .normal)
        subCategoryStr = ""
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        var message = String()
        if (catrgoryStr == "Cooked Food")
        {
            if subCategoryStr == ""
            {
            message = "Please select Veg / Non-Veg"
            }
        }
        
        else if (catrgoryStr == "Packed Food")
        {
            if subCategoryStr == ""
            {
                message = "Please select Veg / Non-Veg"
            }
        }
        else if (catrgoryStr == "Fruits and Vegetables")
        {
            if subCategoryStr == ""
            {
                message = "Please select Fresh / Frozen"
            }
        }
        else if (catrgoryStr == "Fish Meat & Alternatives")
        {
            if subCategoryStr == ""
            {
                message = "Please select Fresh / Frozen"
            }
        }
        
        
        if message.characters.count > 1 {
            
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
            print(catrgoryStr)
            print(subCategoryStr)
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "StepTwoShareFoodVC") as? StepTwoShareFoodVC
            self.navigationController?.pushViewController(myVC!, animated: false)
            myVC?.categoryStr = catrgoryStr
            myVC?.subCategoryStr = subCategoryStr
        }
        
    }
    
    
    
    @IBAction func cookedFoodOneClick(_ sender: Any) {
        catrgoryStr = "Cooked Food"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        cookedFDhightconstraint.constant = 41
        cookedView.isHidden = false
        self.RadioUncheckButton()
        cookedButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
    
    
    @IBAction func packedFoodOneClicked(_ sender: Any) {
        
        catrgoryStr = "Packed Food"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        packedFdhightconstraint.constant = 41
        packedView.isHidden = false
        self.RadioUncheckButton()
        packedButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    @IBAction func fruitAndVegClicked(_ sender: Any) {
        catrgoryStr = "Fruits"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        fruitHightconstraint.constant = 41
        fruitView.isHidden = false
        self.RadioUncheckButton()
        fruitsButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    @IBAction func fishMeatClicked(_ sender: Any) {
        
        catrgoryStr = "Fish Meat"
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        fishHightconstraint.constant = 41
        fishMealView.isHidden = false
        self.RadioUncheckButton()
        fishMeatButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
 
    }
    
    @IBAction func pulseAndSpicesClicked(_ sender: Any) {
        catrgoryStr = "Pulses Spices"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        pulsesButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    @IBAction func drinkAndBeveragesClicked(_ sender: Any) {
        
        catrgoryStr = "Drinks"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        
        drinkButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)

    }
    
    
    @IBAction func joinMeClicked(_ sender: Any) {
        catrgoryStr = "Join Me!"
        subCategoryStr = ""
        self.hideViews()
        self.subCatgryBtnUnchekMethod()
        self.RadioUncheckButton()
        joinMeButton.setImage(UIImage(named: "Radio-clicked copy"), for: .normal)
    }
    
    
    
    
    
    //  MARK: TableView Delegates and Datasource:
    
    func tableView(_ tableView: UITableView, canCollapseSection section: Int) -> Bool
    {
        if tableView == categeoryTableview {
            for i in 0..<listCategeory.count {
                if section == i {
                
                    let strcount: NSInteger = NSInteger((self.listCategeory.object(at: i) as! NSDictionary).value(forKey: "hasChild") as! NSNumber)
                    if strcount == 1
                    {
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
            return false
        }
        return true
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == categeoryTableview
        {
            return listCategeory.count
        }
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categeoryTableview
        {
            if self.tableView(tableView, canCollapseSection: section) {
                if (expandedSections?.contains(section))!
                {
                    let strcount: NSArray = (self.listCategeory[section] as! NSDictionary).value(forKey: "child") as! NSArray
                    let count: NSInteger = strcount.count
                    let i = count+1
                   
                    return i
                    // return rows when expanded
                }
                return 1
            }
            return 1
        }
        return 1
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdetifier: String = "cell"
        cell = UITableViewCell(style: .default, reuseIdentifier: cellIdetifier)
        
        
        if (self.tableView(tableView, canCollapseSection: indexPath.section))
        {
            
            let strcount: String = (self.listCategeory.object(at: indexPath.row) as! NSDictionary).value(forKey: "hasChild") as! String
            
            if strcount == "1"
            {
                print("1")
            }
            else
            {
                print("2")
            }
        }
        else {
            print("3")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    

    
    
    
    
    
 @IBAction func backButtonAction(_ sender: Any) {
      _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
