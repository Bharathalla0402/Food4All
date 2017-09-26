//
//  Constants.swift
//  Naples Pizza
//
//  Created by Kanwar Sierah on 14/12/16.
//  Copyright © 2016 Kanwar Sierah. All rights reserved.
//

import Foundation
import UIKit

//MARK: Base URL:

class Constants {
   // static let mainURL = "https://www.food4all.org/webservices1/Api.php"
    static let mainURL = "https://www.food4all.org/demo/webservices/Api.php"
    static let applicationName = "Food4All"
}

func szBadgeCount() -> String
{
    if UserDefaults.standard.object(forKey: "badgeCount") != nil
    {
        let badge = UserDefaults.standard.object(forKey: "badgeCount") as! String
        return badge
    }else
    {
        return ""
    }
}
extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}


func szSetBadgeCount(badge:NSInteger)
{
    UserDefaults.standard.removeObject(forKey: "badgeCount")
    UserDefaults.standard.synchronize()
    if badge != 0 {
        let str:String = String(format:"%lu",badge)
        UserDefaults.standard.set(str, forKey: "badgeCount")
        UserDefaults.standard.synchronize()
    }
}


func szAddBadgeCount()
{
    if UserDefaults.standard.object(forKey: "badgeCount") != nil {
        var count:NSInteger = NSInteger(UserDefaults.standard.object(forKey: "badgeCount") as! String)!
        count = count + 1
        UserDefaults.standard.removeObject(forKey: "badgeCount")
        UserDefaults.standard.synchronize()
        let str:String = String(format:"%lu",count)
        UserDefaults.standard.set(str, forKey: "badgeCount")
        UserDefaults.standard.synchronize()
    }else
    {
        UserDefaults.standard.set("1", forKey: "badgeCount")
        UserDefaults.standard.synchronize()
    }
}


func szUserID() -> NSInteger
{
    if UserDefaults.standard.object(forKey: "userID") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "userID") as! NSInteger
        return kDeviceToken
    }
    else
    {
        return 0
    }
}


func szAddUserID(userid:NSInteger) {
    UserDefaults.standard.removeObject(forKey: "userID")
    UserDefaults.standard.synchronize()
    if userid != 0 {
        UserDefaults.standard.set(userid, forKey: "userID")
        UserDefaults.standard.synchronize()
    }
}


func szUserName() -> String
{
    if UserDefaults.standard.object(forKey: "UserName") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "UserName") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}


func szAddUserName(username:String)
{
    UserDefaults.standard.removeObject(forKey: "UserName")
    UserDefaults.standard.synchronize()
    if username != "" {
        UserDefaults.standard.set(username, forKey: "UserName")
        UserDefaults.standard.synchronize()
    }
}


func szDateOfBirth() -> String
{
    if UserDefaults.standard.object(forKey: "DateOfBirth") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "DateOfBirth") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}


func szAddDateOfBirth(DateOfBirth:String)
{
    UserDefaults.standard.removeObject(forKey: "DateOfBirth")
    UserDefaults.standard.synchronize()
    if DateOfBirth != "" {
        UserDefaults.standard.set(DateOfBirth, forKey: "DateOfBirth")
        UserDefaults.standard.synchronize()
    }
}


func szMobileNumber() -> String
{
    if UserDefaults.standard.object(forKey: "MobileNumber") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "MobileNumber") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}


func szAddMobileNumber(MobileNumber:String)
{
    UserDefaults.standard.removeObject(forKey: "MobileNumber")
    UserDefaults.standard.synchronize()
    if MobileNumber != "" {
        UserDefaults.standard.set(MobileNumber, forKey: "MobileNumber")
        UserDefaults.standard.synchronize()
    }
}

func szlogInCheck() -> String
{
    if UserDefaults.standard.object(forKey: "LogInCheck") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "LogInCheck") as! String
        return kDeviceToken
    }
    else
    {
        return "UnSuccess"
    }
}


func szAddlogInCheck(logInCheck:String)
{
    UserDefaults.standard.removeObject(forKey: "LogInCheck")
    UserDefaults.standard.synchronize()
    if logInCheck != "" {
        UserDefaults.standard.set(logInCheck, forKey: "LogInCheck")
        UserDefaults.standard.synchronize()
    }
}

func szEmailId() -> String
{
    if UserDefaults.standard.object(forKey: "emailID") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "emailID") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddEmailId(EmailId:String)
{
    UserDefaults.standard.removeObject(forKey: "emailID")
    UserDefaults.standard.synchronize()
    if EmailId != "" {
        UserDefaults.standard.set(EmailId, forKey: "emailID")
        UserDefaults.standard.synchronize()
    }
}

func szPassword() -> String
{
    if UserDefaults.standard.object(forKey: "Password") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "Password") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddPassword(Password:String)
{
    UserDefaults.standard.removeObject(forKey: "Password")
    UserDefaults.standard.synchronize()
    if Password != ""
    {
        UserDefaults.standard.set(Password, forKey: "Password")
        UserDefaults.standard.synchronize()
    }
    
}

func szAddress() -> String
{
    if UserDefaults.standard.object(forKey: "Address") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "Address") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddAddress(Address:String)
{
    UserDefaults.standard.removeObject(forKey: "Address")
    UserDefaults.standard.synchronize()
    if Address != ""
    {
        UserDefaults.standard.set(Address, forKey: "Address")
        UserDefaults.standard.synchronize()
    }
}

func szloyaltyCardNo() -> String
{
    if UserDefaults.standard.object(forKey: "loyaltyCardNo") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "loyaltyCardNo") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddloyaltyCardNo(loyaltyCardNo:String)
{
    UserDefaults.standard.removeObject(forKey: "loyaltyCardNo")
    UserDefaults.standard.synchronize()
    if loyaltyCardNo != ""
    {
        UserDefaults.standard.set(loyaltyCardNo, forKey: "loyaltyCardNo")
        UserDefaults.standard.synchronize()
    }
}

func szPincode() -> String
{
    if UserDefaults.standard.object(forKey: "Pincode") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "Pincode") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddPincode(Pincode:String)
{
    UserDefaults.standard.removeObject(forKey: "Pincode")
    UserDefaults.standard.synchronize()
    if Pincode != ""
    {
        UserDefaults.standard.set(Pincode, forKey: "Pincode")
        UserDefaults.standard.synchronize()
    }
}

func szRefNo() -> String
{
    if UserDefaults.standard.object(forKey: "RefNo") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "RefNo") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddRefNo(RefNo:String)
{
    UserDefaults.standard.removeObject(forKey: "RefNo")
    UserDefaults.standard.synchronize()
    if RefNo != ""
    {
        UserDefaults.standard.set(RefNo, forKey: "RefNo")
        UserDefaults.standard.synchronize()
    }
}

func szUserImage() -> String
{
    if UserDefaults.standard.object(forKey: "UserImage") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "UserImage") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func szAddUserImage(UserImage:String)
{
    UserDefaults.standard.removeObject(forKey: "UserImage")
    UserDefaults.standard.synchronize()
    if UserImage != ""
    {
        UserDefaults.standard.set(UserImage, forKey: "UserImage")
        UserDefaults.standard.synchronize()
    }
}



// MARK: Extension Classes

extension UITextField{
    @IBInspectable var placeHolderColorO: UIColor? {
        get {
            return self.placeHolderColorO
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    @IBInspectable var leftPaddingPoints: CGFloat
        {
        get {
            return self.leftPaddingPoints
        }
        set {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftViewMode = .always
        }
         }
    @IBInspectable var rightPaddingPoints: CGFloat
        {
        get {
            return self.rightPaddingPoints
        }
        set {
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightViewMode = .always
        }
    }
    
    
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

@IBDesignable extension UIView {
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
}
