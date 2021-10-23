//
//  ApiRequestManager.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
//

import Foundation

class ApiRequestModel{
    
    func toObject() -> [String:Any]{
     
        return [:]
    }
    
    
}

class RegisterRequest:ApiRequestModel{
    
    var name:String?
    var username:String?
    var email:String?
    var mobile_no:String?
    var password:String?
    var facebook_id:String?
    var google_id:String?
    var device_type:String?
    var device_token:String?
    
    init(name:String, username:String, email:String, mobile_no:String, password:String, facebook_id:String, google_id:String, device_token:String, device_type:String) {
        
        self.name = name
        self.username = username
        self.email = email
        self.mobile_no = mobile_no
        self.password = password
        self.facebook_id = facebook_id
        self.google_id = google_id
        self.device_type = device_type
        self.device_token = device_token
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["name":self.name ?? "",
                "username":self.username ?? "",
                "email":self.email ?? "",
                "mobile_no":self.mobile_no ?? "",
                "password":self.password ?? "",
                "facebook_id":self.facebook_id ?? "",
                "google_id":self.google_id ?? "",
                "device_type":self.device_type ?? "",
                "device_token":self.device_token ?? ""]
        
    }
    
}



class LoginRequest:ApiRequestModel {
    
    var email:String?
    var password:String?
    var device_type:String?
    var device_token:String?
    
    init(email:String, password:String, device_token:String, device_type:String) {
        
        self.email = email
        self.password = password
        self.device_type = device_type
        self.device_token = device_token
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return [ "email":self.email ?? "",
                "password":self.password ?? "",
                "device_type":self.device_type ?? "",
                "device_token":self.device_token ?? ""]
        
    }
    
}