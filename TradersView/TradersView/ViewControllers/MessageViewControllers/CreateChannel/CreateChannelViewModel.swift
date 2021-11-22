//
//  CreateChannelViewModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/11/21.
//

import Foundation

class CreateChannelViewModel:NSObject{
    
    
    var channelName:String = ""
    var selectedUserList:[ChatUserModel] = []
    var imgUrl:String = ""
    
    
    
    
//    func createChanelInFirebase(){
//        
//        
//        //create user dictionary to first entery in "user" node firebase --
//        
//        let channelGroup = [["groupid":"Null"]]
//        let privateGroup = [["groupid":"Null"]]
//        let publicGroup = [["groupid":"Null"]]
//        
//
//
//        
//        let dict:[String:Any] = ["addminId":self., "private_group":privateGroup, "public_group":publicGroup,"date":Date.getCurrentDate(), "email":userData.email, "psd":userData.username, "recent_message":"","status":"online", "userId":userData.id,"username":userData.name, "imageURL":"https://spsofttech.com/projects/treader/images/dummy.png"]
//        
//        
//        
//        self.ref.child("user").child(userData.id).setValue(dict) { (error, reference) in
//            
//            
//            if let err = error {
//                
//                errorHandler(err)
//                
//                
//            }
//            else{
//                
//                successHandler()
//                
//                
//            }
//        }
//        
//        
//        
//    }
    
    
}
