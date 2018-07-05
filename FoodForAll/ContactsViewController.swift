//
//  ContactsViewController.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import Contacts
import MessageUI


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@available(iOS 9.0, *)
class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UISearchBarDelegate {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactlab: UILabel!
    
    @IBOutlet weak var gmailview: UIView!
    @IBOutlet weak var gmailImage: UIImageView!
    @IBOutlet weak var gmaillab: UILabel!
    
    @IBOutlet weak var shareview: UIView!
    @IBOutlet weak var shareimage: UIImageView!
    @IBOutlet weak var sharelab: UILabel!
    
    var arryDatalistids = NSMutableArray()
    var arryDatalistids2 = NSMutableArray()
    var ContactId = NSMutableArray()
    var EmailId = NSMutableArray()
    var strCheck = NSString()
    
    var searchResults = NSMutableArray()
    var searchResults2 = NSMutableArray()
    var theSearchBar: UISearchBar?
    
    var ContactList = NSMutableArray()
    var EmailList = NSMutableArray()
    var UserImage = UIImage()
    
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strCheck = "1"

        tableView.tag=4
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        
        theSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        theSearchBar?.delegate = self
        theSearchBar?.placeholder = "Search Contact Number"
        theSearchBar?.showsCancelButton = false
        tableView.tableHeaderView = theSearchBar
        theSearchBar?.tag=1
        theSearchBar?.isUserInteractionEnabled = true
        
        self.addDoneButtonOnKeyboard3()
    }
    
    func addDoneButtonOnKeyboard3()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.theSearchBar?.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        noContactsLabel.isHidden = false
        noContactsLabel.text = "Retrieving contacts..."
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    self.tableView.isHidden = !success
                    self.noContactsLabel.isHidden = success
                    if success && contacts?.count > 0 {
                        
                        self.contacts = contacts!
                        
                        self.ContactList.removeAllObjects()
                        self.EmailList.removeAllObjects()
                        
                        for i in 0..<self.contacts.count
                        {
                            let entry = contacts?[i]
                            let strname: String = entry!.name
                            let strphone: String = entry!.phone ?? ""
                           
                            self.UserImage = entry?.image ?? UIImage(named: "defaultUser")!
                            
                            if strphone == ""
                            {
                                
                            }
                            else
                            {
                                let arrDic = NSMutableDictionary()
                                let strna: String = strname
                                arrDic["name"] = strna
                                let strph: String = strphone
                                arrDic["phone"] = strph
                                let strpic: UIImage = self.UserImage
                                arrDic["pic"] = strpic
                                
                                self.ContactList.add(arrDic)
                            }
                            
                        }
                        
                        
                        for i in 0..<self.contacts.count
                        {
                            let entry = contacts?[i]
                            let strname: String = entry!.name
                            let stremail: String = entry!.email ?? ""
                            
                            self.UserImage = entry?.image ?? UIImage(named: "defaultUser")!
                            
                            if stremail == ""
                            {
                                
                            }
                            else
                            {
                                let arrDic = NSMutableDictionary()
                                let strna: String = strname
                                arrDic["name"] = strna
                                let strem: String = stremail
                                arrDic["email"] = strem
                                let strpic: UIImage = self.UserImage
                                arrDic["pic"] = strpic
                                
                                self.EmailList.add(arrDic)
                            }
                            
                        }

                        
                        
                        self.tableView.reloadData()
                    } else {
                        self.noContactsLabel.text = "Unable to get contacts..."
                    }
                })
            }
        }
    }

    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ContactsClicked(_ sender: UIButton)
    {
        theSearchBar?.text = ""
        theSearchBar?.resignFirstResponder()
        strCheck = "1"
        
        theSearchBar?.delegate=self
        tableView.tag = 4
        theSearchBar?.placeholder = "Search Contact Number"
        theSearchBar?.tag=1
        
        contactImage.image = UIImage(named:"user-2.png")
        contactlab.textColor = #colorLiteral(red: 0.5803921569, green: 0.7529411765, blue: 0.8588235294, alpha: 1)
        
        gmailImage.image = UIImage(named:"contact.png")
        gmaillab.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
        
        shareimage.image = UIImage(named:"upload.png")
        sharelab.textColor = #colorLiteral(red: 0.6940580606, green: 0.6941571832, blue: 0.6940267682, alpha: 1)
        
       print(ContactId)
        
         self.tableView.reloadData()
    }
    @IBAction func GmailClicked(_ sender: UIButton)
    {
         theSearchBar?.text = ""
        theSearchBar?.resignFirstResponder()
        strCheck = "2"
        
        tableView.tag = 2
        theSearchBar?.placeholder = "Search Email Id"
        theSearchBar?.tag=2
        
        contactImage.image = UIImage(named:"user.png")
        contactlab.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
        
        gmailImage.image = UIImage(named:"contact-2.png")
        gmaillab.textColor = #colorLiteral(red: 0.5803921569, green: 0.7529411765, blue: 0.8588235294, alpha: 1)
        
        shareimage.image = UIImage(named:"upload.png")
        sharelab.textColor = #colorLiteral(red: 0.6940580606, green: 0.6941571832, blue: 0.6940267682, alpha: 1)
        
       print(EmailId)
        
         self.tableView.reloadData()
 
    }
    @IBAction func ShareClicked(_ sender: UIButton)
    {
//        contactImage.image = UIImage(named:"user.png")
//        contactlab.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
//        
//        gmailImage.image = UIImage(named:"contact.png")
//        gmaillab.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
//        
//        shareimage.image = UIImage(named:"upload-2.png")
//        sharelab.textColor = #colorLiteral(red: 0.5803921569, green: 0.7529411765, blue: 0.8588235294, alpha: 1)
        
         theSearchBar?.text = ""
         theSearchBar?.resignFirstResponder()
        
      // let text = "https://itunes.apple.com/tw/app/id1242021232"
        
        let text = "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
        //  let text = "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
   
    @IBAction func backButtClicked(_ sender: UIButton)
    {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createNewContact(_ sender: AnyObject)
    {
        if strCheck == "1"
        {
            if (MFMessageComposeViewController.canSendText())
            {
                let controller = MFMessageComposeViewController()
                controller.body = "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all"
              //  controller.body = "Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All"
                controller.recipients = ContactId.copy() as? [String]
                controller.messageComposeDelegate = self
                present(controller, animated: true, completion: nil)
            }
            else
            {
                print("Error")
            }
        }
        else
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
       
        mailComposerVC.setToRecipients(EmailId.copy() as? [String])
        mailComposerVC.setSubject("Food4All")
        mailComposerVC.setMessageBody("Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4all", isHTML: false)
      //   mailComposerVC.setMessageBody("Download for iOS:  " + "https://itunes.apple.com/us/app/food4all/id1242021232?mt=8" + "\n" + "Download for Android:  " + "https://play.google.com/store/apps/details?id=org.food4All", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           }
    
    
    
    
    
    
    //  MARK: searchbar Delegates and Datasource:
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if (searchBar.tag==2)
        {
            if searchResults.count != 0 {
                self.searchResults.removeAllObjects()
                tableView.tag = 2
            }
            for i in 0..<EmailList.count {
                // [searchResults removeAllObjects];
                let string: String = (self.EmailList.object(at: i) as! NSDictionary).value(forKey: "email") as! String
                let stringname: String = (self.EmailList.object(at: i) as! NSDictionary).value(forKey: "name") as! String
                let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
                let rangeValue2: NSRange = (stringname as NSString).range(of: searchText, options: .caseInsensitive)
                if rangeValue.length > 0 || rangeValue2.length > 0
                {
                    tableView.tag = 1
                    searchResults.add(EmailList[i])
                }
                else
                {
                    
                }
            }
            tableView.reloadData()
        }
        else
        {
            if searchResults2.count != 0 {
                self.searchResults2.removeAllObjects()
                tableView.tag = 4
            }
            for i in 0..<ContactList.count {
                // [searchResults removeAllObjects];
                let string: String = (self.ContactList.object(at: i) as! NSDictionary).value(forKey: "phone") as! String
                let stringname: String = (self.ContactList.object(at: i) as! NSDictionary).value(forKey: "name") as! String
                let rangeValue: NSRange = (string as NSString).range(of: searchText, options: .caseInsensitive)
                let rangeValue2: NSRange = (stringname as NSString).range(of: searchText, options: .caseInsensitive)
                if rangeValue.length > 0 || rangeValue2.length > 0
                {
                    tableView.tag = 3
                    searchResults2.add(ContactList[i])
                }
                else
                {
                    
                }
            }
            tableView.reloadData()
        }
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
    

    
    
    
    
    // UITableViewDataSource && Delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 2
        {
            return EmailList.count
        }
        else if tableView.tag == 1
        {
            return searchResults.count
        }
        else if tableView.tag == 4
        {
            return ContactList.count
        }
        else
        {
            return searchResults2.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
       // let entry = contacts[(indexPath as NSIndexPath).row]
       // cell.configureWithContactEntry(entry)
       // cell.layoutIfNeeded()
        
        
        
        
        if tableView.tag == 2
        {
            cell.contactNameLabel.text = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            let ima: UIImage = (self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.EmailList.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            if arryDatalistids2.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }
            
        }
        else if tableView.tag == 1
        {
            cell.contactNameLabel.text = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            let ima: UIImage = (self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.searchResults.object(at: indexPath.row) as! NSDictionary).value(forKey: "email") as! String)
            if arryDatalistids2.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }
            
        }
        else if tableView.tag == 4
        {
            cell.contactNameLabel.text = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            let ima: UIImage = (self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            let VolunteerID:String = ((self.ContactList.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            if arryDatalistids.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }
            
        }
        else
        {
            cell.contactNameLabel.text = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.contactPhoneLabel.text = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            let ima: UIImage = (self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "pic") as! UIImage
            cell.contactImageView.image = ima
            
            
            let VolunteerID:String = ((self.searchResults2.object(at: indexPath.row) as! NSDictionary).value(forKey: "phone") as! String)
            if arryDatalistids.contains(VolunteerID)
            {
                cell.SelectButt.setImage(UIImage(named: "selected-radio.png"), for: .normal)
            }
            else
            {
                cell.SelectButt.setImage(UIImage(named: "unselected-radio.png"), for: .normal)
            }
            
        }
        
        
        
        cell.SelectButt.tag = indexPath.row
        cell.SelectButt.addTarget(self, action: #selector(self.favoritelistClicked), for: .touchUpInside)
        
        cell.SelectButt2.tag = indexPath.row
        cell.SelectButt2.addTarget(self, action: #selector(self.favoritelistClicked), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
    
    
    func favoritelistClicked(_ sender: UIButton!)
    {
        
        if strCheck == "2"
        {
            let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
            let tappedIP: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
            
            if tableView.tag == 2
            {
                let VolunteerID:String = ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                if arryDatalistids2.contains(VolunteerID)
                {
                    arryDatalistids2.remove(VolunteerID)
                    
                    let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids2.add(VolunteerID)
                    
                    let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    
                    EmailId.add(str)
                }
                
            }
            else
            {
                let VolunteerID:String = ((self.searchResults.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                if arryDatalistids2.contains(VolunteerID)
                {
                    arryDatalistids2.remove(VolunteerID)
                    
                    let str: String =  ((self.searchResults.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    EmailId.remove(str)
                }
                else
                {
                    arryDatalistids2.add(VolunteerID)
                    
                    let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
                    
                    EmailId.add(str)
                }
            }
            
            tableView.reloadData()
        }
        else
        {
            let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
            let tappedIP: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
            
            if tableView.tag == 4
            {
                let VolunteerID:String = ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                if arryDatalistids.contains(VolunteerID)
                {
                    arryDatalistids.remove(VolunteerID)
                    
                    let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    ContactId.remove(str)
                }
                else
                {
                    arryDatalistids.add(VolunteerID)
                    
                    let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    
                    ContactId.add(str)
                }
                
            }
            else
            {
                let VolunteerID:String = ((self.searchResults2.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                if arryDatalistids.contains(VolunteerID)
                {
                    arryDatalistids.remove(VolunteerID)
                    
                    let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    ContactId.remove(str)
                }
                else
                {
                    arryDatalistids.add(VolunteerID)
                    
                    let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
                    
                    ContactId.add(str)
                }
            }
            tableView.reloadData()
        }
        
        
    }

    
    
    
    
    
//    
//    func favoritelistClicked(_ sender: UIButton!)
//    {
//        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
//        let tappedIP: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
//        
//        if strCheck == "2"
//        {
//            if arryDatalistids2.contains(tappedIP as Any)
//            {
//                arryDatalistids2.remove(tappedIP as Any)
//                
//                let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
//                EmailId.remove(str)
//            }
//            else
//            {
//                arryDatalistids2.add(tappedIP!)
//                
//                let str: String =  ((self.EmailList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "email") as! String)
//                
//                EmailId.add(str)
//            }
//        }
//        else
//        {
//            if arryDatalistids.contains(tappedIP as Any)
//            {
//                arryDatalistids.remove(tappedIP as Any)
//                
//                let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
//                ContactId.remove(str)
//            }
//            else
//            {
//                arryDatalistids.add(tappedIP!)
//                
//                let str: String =  ((self.ContactList.object(at: (tappedIP?.row)!) as! NSDictionary).value(forKey: "phone") as! String)
//                
//                ContactId.add(str)
//            }
//        }
//        
//        tableView.reloadData()
//    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

}
