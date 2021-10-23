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
