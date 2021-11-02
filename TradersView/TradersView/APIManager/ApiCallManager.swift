//
//  ApiCallManager.swift
//  RestApiDemo
//
//  Created by Ajeet Sharma on 02/10/21.
//

import Foundation
import UIKit


enum RequestMethod:String{
    
    case GET = "GET"
    case POST = "POST"
    
    
}

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
    case UNBAN_USER = "unbanuser"
    case CONTACT_US = "contactus"
    case SHARE_POST = "share_post"
    case REPORT_USER = "reportuser"                      // 50
    case UPDATE_USER_NAME = "updateusername"
    
    
    
    
    
    
    case SETMPI_PASS_VERIFY = "setmpinpassverify"
    case MUTE_USER = "muteuser"
    case GET_MUTE_USER = "getmuteuser"
    case GET_PAGE = "getpage"
    case GET_PAGE_BY_ID = "getpagebyid"
    case COMMENT_PER_USER = "comment_per_user"
    case COMMENT_PER_LIST = "comment_per_list"
    case COMMENT_PER_REMOVE = "comment_per_remove"       //  57
    
    
    
    
}

class ApiCallManager{
    
    static let shared:ApiCallManager = ApiCallManager()
    private init(){
        
        
    }
    
    func apiCall<T:Codable>(request:ApiRequestModel, apiType:APIType,responseType:T.Type, requestMethod:RequestMethod , compilationHandler:@escaping(_ results:T)->Void, failureHandler:@escaping(Error)->Void){
        
        
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
            
            
            
            
            urlRequest.httpMethod = requestMethod.rawValue
            
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            

            if requestMethod == .POST{
                
                
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.toObject(), options: [])

            }

            
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                
                guard  error == nil else{
                    
                    
                    failureHandler(error!)
                    return
                    
                }
                
                if data != nil {
                    
                    if(error == nil && data != nil && data?.count != 0){
                        do {
                            
                            let response = try JSONDecoder().decode(T.self, from: data!)
                            compilationHandler(response)
                        }
                        
                        catch let decodingError {
                            debugPrint(decodingError)
                            
                            failureHandler(decodingError as! Error)
                        }
                    }else{
                        
                        failureHandler(error as! Error)
                        
                    }
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
    
    func UploadImage<T:Codable>(request:AddPostRequest, apiType:APIType, uiimagePic:UIImage, responseType:T.Type, compilationHandler:@escaping(_ results:T)->Void, failureHandler:@escaping(Error)->Void){
        
        let username = "admin"
        let password = "123"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // your image from Image picker, as of now I am picking image from the bundle
        let imageData = uiimagePic.jpegData(compressionQuality: 0.7)
        
        let url = "\(Constants.BASE_URL)/\(apiType.rawValue)"
        var urlRequest = URLRequest(url: URL(string: url)!)
        
        urlRequest.httpMethod = "post"
        let bodyBoundary = "--------------------------\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")
        
        //attachmentKey is the api parameter name for your image do ask the API developer for this
        // file name is the name which you want to give to the file
        let requestData = createRequestBody(imageData: imageData!, parameters:request.toObjectString() , boundary: bodyBoundary, attachmentKey: "post", fileName: "post.jpg")
        
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            
            if(error == nil && data != nil && data?.count != 0){
                do {
                    
                    print(String(data: data!, encoding: .utf8))
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    compilationHandler(response)
                    print(response)
                }
                
                catch let decodingError {
                    debugPrint(decodingError)
                    
                    failureHandler(decodingError as! Error)
                }
            }else{
                
                failureHandler(error as! Error)
                
            }
        }.resume()
    }
    
    private func createRequestBody(imageData: Data, parameters:[String:String] , boundary: String, attachmentKey: String, fileName: String) -> Data{
        
        
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        
        parameters.forEach { (key, value) in
            
            requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            requestBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        
        
        requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
        requestBody.append(imageData)
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        return requestBody
    }
}





