//
//  ParseManager.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
//

import Foundation
import UIKit

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
       
        case .LOGOUT:
            
            self.parseLogout(responseData:data)

            print("Logout")
            
        case .FORGOT_PASSWORD:
            print("")
        case .OTP_VERIFY:
            print("")
        case .NEW_PASSWORD:
            print("")
        case .RESET_PASSWORD:
            print("")
        case .UPDATE_PROFILE:
            print("")
        case .ADD_POST:
            print("")
        case .ADD_TRADE:
            print("")
        case .DELETE_POST:
            print("")
        case .LIKE_POST:
            print("")
        case .TRADE_RATING:
            print("")
        case .FOLLOW:
            print("")
        case .FOLLOW_REQUEST_LIST:
            print("")
        case .FOLLOW_ACCEPT_REJECT:
            print("")
        case .FAV_PROFILE:
            print("")
        case .FAV_PROFILE_LIST:
            print("")
        case .GET_PROFILE_BY_ID:
            print("")
        case .GET_POST_BY_USER_ID:
            print("")
        case .GET_POST_BY_ID:
            print("")
        case .GET_TRADE_BY_ID:
            print("")
        case .ADD_COMMENT:
            print("")
        case .GET_COMMENT_BY_ID:
            print("")
        case .LIKE_COMMENT:
            print("")
        case .GET_COMMENT_REPLY_BY_ID:
            print("")
        case .USER_PLAN:
            print("")
        case .DELETE_COMMENT:
            print("")
        case .SEARCH:
            print("")
        case .GET_NOTIFICATION:
            print("")
        case .COMMUNITY:
            print("")
        case .MOST_POPULAR:
            print("")
        case .TOP_PROFILE:
            print("")
        case .BLOCK_USER:
            print("")
        case .GET_BLOCK_USER:
            print("")
        case .GET_SYMBOL:
            print("")
        case .GET_PLAN:
            print("")
        case .DELETE_IMAGE:
            print("")
        case .FOLLOW_LIST:
            print("")
        case .REMOVE_FOLLOWER:
            print("")
        case .USER_BAN_BY_POLICE:
            print("")
        case .REMOVE_POST_BY_POLICE:
            print("")
        case .GET_BAN_USER_BY_POLICE:
            print("")
        case .GET_BAN_POST_BY_POLICE:
            print("")
        case .UNBAN_USER:
            print("")
        case .CONTACT_US:
            print("")
        case .SHARE_POST:
            print("")
        case .REPORT_USER:
            print("")
        case .UPDATE_USER_NAME:
            print("")
        case .SETMPI_PASS_VERIFY:
            print("")
        case .MUTE_USER:
            print("")
        case .GET_MUTE_USER:
            print("")
        case .GET_PAGE:
            print("")
        case .GET_PAGE_BY_ID:
            print("")
        case .COMMENT_PER_USER:
            print("")
        case .COMMENT_PER_LIST:
            print("")
        case .COMMENT_PER_REMOVE:
            print("")
        }
        
        
    }
    
    private func parseLogout(responseData:Data) {
        
        
        let decoder = JSONDecoder()
        
        
            
            do {
                
                
                let logoutResponse:LogoutResponse = try decoder.decode(LogoutResponse.self, from: responseData)
                
                
                print("logoutResponse  - \(logoutResponse.messages)")
                
                self.delegate?.parseSuccessHandler(response: logoutResponse)
                
                
            }
            catch{
                
                self.delegate?.parseErrorHandler(error: error)
            }
      
        
        
        
    }
    
    private func parseLogin(responseData:Data) {
        
        let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

        let decoder = JSONDecoder()
        
        
            
            do {
                
                
                let loginResponse:LoginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                
                
                print("loginResponse  - \(loginResponse.messages)")
                
                appDelegate.loginResponse = loginResponse
                

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
