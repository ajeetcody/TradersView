//
//  ApiRequestManager.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
// 338

//319

// 349

import Foundation

class ApiRequestModel{
    
    func toObject() -> [String:Any]{
     
        return [:]
    }
    
    
}

class GetprofileByIdRequest:ApiRequestModel{
   
    var user_id:String?
    var id:String?
    
    
    init(_user_id:String, _id:String) {
        
        self.user_id = _user_id
        self.id = _id
        
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "id":self.id ?? ""]
        
        
    }
    
}

class LikePostRequest:ApiRequestModel{
   
    var user_id:String?
    var notify_user_id:String?
    var post_id:String?
    
    init(_user_id:String, _notify_user_id:String, _post_id:String) {
        
        self.user_id = _user_id
        self.notify_user_id = _notify_user_id
        self.post_id = _post_id
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "notify_user_id":self.notify_user_id ?? "",
                "post_id":self.post_id ?? ""]
        
        
    }
    
}

class AddCommentRequest:ApiRequestModel{
   
    var user_id:String?
    var notify_user_id:String?
    var post_id:String?
    var comment:String?
    
    init(_user_id:String, _notify_user_id:String, _post_id:String, _comment:String) {
        
        self.user_id = _user_id
        self.notify_user_id = _notify_user_id
        self.post_id = _post_id
        self.comment = _comment
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "notify_user_id":self.notify_user_id ?? "",
                "post_id":self.post_id ?? "", "comment":self.comment ?? ""]
        
        
    }
    
}

class LikeCommentRequest:ApiRequestModel{
   
    var user_id:String?
    var notify_user_id:String?
    var comment_id:String?
    
    
    init(_user_id:String, _notify_user_id:String, _comment_id:String) {
        
        self.user_id = _user_id
        self.notify_user_id = _notify_user_id
        self.comment_id = _comment_id
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "notify_user_id":self.notify_user_id ?? "",
                "comment_id":self.comment_id ?? 0]
        
    }
    
}

class GetCommentByPostIdRequest:ApiRequestModel{
   
    var userid:String?
    var postid:String?
    var page:Int?
    
    
    init(_user_id:String, _postid:String, _page:Int) {
        
        self.userid = _user_id
        self.postid = _postid
        self.page = _page
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["userid":self.userid ?? "",
                "postid":self.postid ?? "",
                "page":self.page ?? 0]
        
    }
    
}

class GetPostListByUserIdRequest:ApiRequestModel{
   
    var id:String?
    var page:Int?
    
    
    init(_id:String, _page:Int) {
        
        self.id = _id
        self.page = _page
        
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["id":self.id ?? "",
                "page":self.page ?? 0]
        
    }
    
}
class CommunityRequest:ApiRequestModel{
   
    var userid:String?
    var page:Int?
    
    
    init(_user_id:String, _page:Int) {
        
        self.userid = _user_id
        self.page = _page
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["userid":self.userid ?? "",
                "page":self.page ?? 0]
        
    }
    
}


class TopProfileRequest:ApiRequestModel{
   
    var user_id:String?
    var page:Int?
    
    
    init(_user_id:String, _page:Int) {
        
        self.user_id = _user_id
        self.page = _page
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "page":self.page ?? 0]
        
    }
    
}


class SearchRequest:ApiRequestModel{
   
    var user_id:String?
    var search:String?
    var page:Int?
    
    
    init(_user_id:String, _search:String, _page:Int) {
        
        self.user_id = _user_id
        self.search = _search
        self.page = _page
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return ["user_id":self.user_id ?? "",
                "search":self.search ?? "",
                "page":self.page ?? 0]
        
    }
    
}

class AddPostRequest:ApiRequestModel{
   
    var id:String?
    var user_id:String?
    var message:String?
    var location:String?
    var latitude:String?
    var longitude:String?
    
    
    init(_id:String, _user_id:String, _message:String, _location:String, _latitude:String, _longitude:String) {
        
        self.id = _id
        self.user_id = _user_id
        self.message = _message
        self.location = _location
        self.latitude = _latitude
        self.longitude = _longitude
        
    }
    
    
  override   func toObject() -> [String:Any]{
        
        return ["id":self.id ?? "",
                "user_id":self.user_id ?? "",
                "message":self.message ?? "",
                "location":self.location ?? "",
                "latitude":self.latitude ?? "",
                "longitude":self.longitude ?? ""]
        
    }
    func toObjectString() -> [String:String]{
         
         return ["id":self.id ?? "",
                 "user_id":self.user_id ?? "",
                 "message":self.message ?? "",
                 "location":self.location ?? "",
                 "latitude":self.latitude ?? "",
                 "longitude":self.longitude ?? ""]
         
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

class LogoutRequest:ApiRequestModel {
    
    var _id:String?
    
    init(id:String) {
        
        self._id = id
    }
    
    
    override func toObject() -> [String:Any]{
        
        return [ "_id":self._id ?? ""]
    }
    
}
class BlockActionRequest:ApiRequestModel {
    
    var user_id:String?
    var block_user_id:String?
    
    init(id:String, blockUserId:String) {
        
        self.user_id = id
        self.block_user_id = blockUserId
        
    }
    
    
    override func toObject() -> [String:Any]{
        
        return [ "user_id":self.user_id ?? "",
        
                 "block_user_id":self.block_user_id ?? ""
        ]
    }
    
}
