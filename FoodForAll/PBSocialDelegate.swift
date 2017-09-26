//
//  PBSocialDelegate.swift
//  PBSocial
//
//  Created by Peerbits Solution on 30/01/17.
//  Copyright © 2017 Peerbits Solution. All rights reserved.
//

import Foundation

protocol PBSocialDelegate
{
    //MARK: Google
    func getGoogleLoginResponse(userData : [String : AnyObject])
    
    //MARK: Facebook
    func getFacebookLoginResponse(userData : [String : AnyObject])
    
    //MARK: LinkedIn
    func getLinkedinResponse(userData : [String : AnyObject])
    
    //MARK: Twitter
    func getTwitterLoginResponse(userData : [String : AnyObject])
    func getTwitterShareResponse(userData : [String : AnyObject])
    
    //MARK: InstaGram
    func getInstagramLoginResponse(userData : [String : AnyObject])
    
    
}

var pbSocialDelegate : PBSocialDelegate!
