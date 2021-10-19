//
//  FirebaseManager.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import Foundation
import Firebase


class FirebaseManager{
    
    
    //MARK:- Login ----
    
    class func isSignInAnonymously() -> Bool{
        
        guard let currentUser = Auth.auth().currentUser else { return true}
        
        
        return currentUser.isAnonymous
        
        
        
    }
    
    class func signup(emailId:String, password:String, completioHandler:@escaping()->Void, failureHandler:@escaping(Error)->Void){
        
        
        
        Auth.auth().createUser(withEmail: emailId, password: password) { authResult, error in
            
            if let err = error {
                
                failureHandler(err)
                
                
            }
            else{
                
                completioHandler()
                
            }
            
            
        }
        
    }
    
    class func login(emailId:String, password:String, completioHandler:@escaping()->Void, failureHandler:@escaping(Error)->Void){
        
        Auth.auth().signIn(withEmail: emailId, password: password) { (authResult, error) in
            
            
            if let err = error {
                
                failureHandler(err)
                
                
            }
            else{
                
                completioHandler()
                
            }
            
        }
        
        
        
    }
    
}
