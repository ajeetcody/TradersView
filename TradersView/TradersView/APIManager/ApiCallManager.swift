//
//  ApiCallManager.swift
//  RestApiDemo
//
//  Created by Ajeet Sharma on 02/10/21.
//

import Foundation




enum APIType:String{
    
    
    
    
    case REGISTER = "register"
    case LOGIN = "login"
    case LOGOUT = "logout"
    case FORGOT_PASSWORD = "forgot"
    case OTP_VERIFY = "otpverify"
    case NEW_PASSWORD = "newpassword"
    case RESET_PASSWORD = "resetpassword"
    case UPDATE_PROFILE = "updateprofile"
    case ADD_POST = "addpost"
    case ADD_TRADE = "addtrade"                         //  10
    
    
    
    
    
    
    case DELETE_POST = "deletepost"
    case LIKE_POST = "likepost"
    case TRADE_RATING = "traderating"
    case FOLLOW = "follow"
    case FOLLOW_REQUEST_LIST = "follow_reqlist"
    case FOLLOW_ACCEPT_REJECT = "follow_accept_reject"
    case FAV_PROFILE = "fav_profile"
    case FAV_PROFILE_LIST = "fav_profile_list"
    case GET_PROFILE_BY_ID = "getprofilebyid"
    case GET_POST_BY_USER_ID = "getpostbyuserid"        //  20
    
    
    
    
    
    
    case GET_POST_BY_ID = "getpostbyid"
    case GET_TRADE_BY_ID = "gettradebyid"
    case ADD_COMMENT = "addcomment"
    case GET_COMMENT_BY_ID = "getcommentbyid"
    case LIKE_COMMENT = "likecomment"
    case GET_COMMENT_REPLY_BY_ID = "getcommentreplybyid"
    case USER_PLAN = "userplan"
    case DELETE_COMMENT = "deletecomment"
    case SEARCH = "search"
    case GET_NOTIFICATION = "getnotification"           //  30
    
    
    
    
    
    
    case COMMUNITY = "community"
    case MOST_POPULAR = "mostpopular"                   // POST
    case TOP_PROFILE = "topprofile"                     // POST
    case BLOCK_USER = "blockuser"
    case GET_BLOCK_USER = "getblockuser"
    case GET_SYMBOL = "getsymbol"
    case GET_PLAN = "getplan"
    case DELETE_IMAGE = "deleteimg"
    case FOLLOW_LIST = "followlist"
    case REMOVE_FOLLOWER = "remove_follower"            //  40
    
    
    
    
    
    case USER_BAN_BY_POLICE = "userbanbypolice"
    case REMOVE_POST_BY_POLICE = "removepostbypolice"
    case GET_BAN_USER_BY_POLICE = "getbanuserbypolice"
    case GET_BAN_POST_BY_POLICE = "getbanpostbypolice"
    case GET_PROFILE_BY_ID = "getprofilebyid"
    case UNBAN_USER = "unbanuser"
    case CONTACT_US = "contactus"
    case SHARE_POST = "share_post"
    case REPORT_USER = "reportuser"
    case UPDATE_USER_NAME = "updateusername"             //  50
    
    
    
    
    
    
    case SETMPI_PASS_VERIFY = "setmpinpassverify"
    case MUTE_USER = "muteuser"
    case GET_MUTE_USER = "getmuteuser"
    case GET_PAGE = "getpage"
    case GET_PAGE_BY_ID = "getpagebyid"
    case COMMENT_PER_USER = "comment_per_user"
    case COMMENT_PER_LIST = "comment_per_list"
    case COMMENT_PER_REMOVE = "comment_per_remove"       //  58

    
    

}

class ApiCallManager{
    
    
    class func apiCall(request:ApiRequestModel, apiType:APIType,successHandler:@escaping(String, Data)->Void, failureHandler:@escaping(Error)->Void, somethingWentWrong:@escaping()->Void){
        
        
        let urlStr = "\(Constants.BASE_URL)/\(apiType.rawValue)"
        
        print(urlStr)
        
        let url = URL(string: urlStr)
        
        let session = URLSession.shared
        
        guard url != nil else{
            
            return
        }
        
        var urlRequest = URLRequest(url: url!)
        
        do {
            
            print("--- Request json ---")
            
            print(request.toObject())
            
            
            
            let username = "admin"
            let password = "123"
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            
            
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.toObject(), options: [])
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                
                guard  error == nil else{
                    
                    
                    failureHandler(error!)
                    return
                    
                }
                
                if data != nil {
                    
                    print(String(data: data!, encoding: .utf8)!, data!)
                    successHandler(String(data: data!, encoding: .utf8)!, data!)
                    
                }
                else{
                    
                }
                
            }
            
            dataTask.resume()
            
            
        }
        catch{
            
            
            print(error)
            
            
        }
        
        
        
    }
    
}
