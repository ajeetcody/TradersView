//
//  ParseManager.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
//

import Foundation

protocol ParseManagerDelegate {
    
    
    func parseSuccessHandler(response:ResponseModel)
    func parseErrorHandler(error:Error)
    func parseSomethingWentWrong()
    
}


class ParseManager{
    
    var delegate:ParseManagerDelegate?
    
    init() {
        
        
    }
    
    func parse(data:Data, apiType:APIType){
        
        switch apiType {
        
        case .LOGIN:
            
            self.parseLogin(responseData:data)
            
            break
        case .REGISTER:
            
             self.parseRegister(responseData:data)
            
            break
       
        }
        
        
    }
    
    private func parseLogin(responseData:Data) {
        
        
        let decoder = JSONDecoder()
        
        
            
            do {
                
                
                let loginResponse:LoginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                
                
                print("loginResponse  - \(loginResponse.messages)")
                
                self.delegate?.parseSuccessHandler(response: loginResponse)
                
                
            }
            catch{
                
                self.delegate?.parseErrorHandler(error: error)
            }
      
        
        
        
    }
    
    
    private func parseRegister(responseData:Data) {
        
        
        let decoder = JSONDecoder()
        
        
            
            do {
                
                
                let registerResponse:RegisterResponse = try decoder.decode(RegisterResponse.self, from: responseData)
                
                
                print("registerResponse  - \(registerResponse.messages)")
                
                self.delegate?.parseSuccessHandler(response: registerResponse)
                
                
            }
            catch{
                
                self.delegate?.parseErrorHandler(error: error)
            }
      
        
        
        
    }
    
}
