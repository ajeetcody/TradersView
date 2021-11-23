//
//  ChatUserListViewModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 22/11/21.
//

import Foundation
import Firebase

class ChatUserListViewModel:NSObject{
    
    let ref:DatabaseReference = Database.database().reference()
    
    var chatUserList:[ChatUserModel] = []
    var filterUserList:[ChatUserModel] = []
    
    var selectedUserData: [ChatUserModel] = []

    
    func selectedUserIdList()->[[String:String]]{
        
        
        let idList:[[String:String]] = self.selectedUserData.map { (userModel) -> [String:String] in
            
            return ["memberid":userModel.userID]
        }
        
        return idList
    }
    
    func checkUserIsSelected(userData:ChatUserModel)->Bool{
        
        
        self.selectedUserData.contains { (user) -> Bool in
            
            return user.userID == userData.userID
        }
        
        
        
    }
    
    
    func removeUserFromSelectedList(userData:ChatUserModel){
        
      
        self.selectedUserData.removeAll { (user) -> Bool in
            
            return user.userID == userData.userID
        }
        
        
        
        
    }
    
    
    func fetchChatUserList(completionHandler:@escaping()->Void){
        
        
        
        self.ref.child("user").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            
            
            
            
            
            print(dictResponse)
            
            let snapshotChildren = snapshot.children
            
            while let child = snapshotChildren.nextObject() as? DataSnapshot {
                
                print(child.key)
                
                let obj:[String:Any] = child.value as! [String : Any]
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let objChatUser = try JSONDecoder().decode(ChatUserModel.self, from: jsonData)
                    
                    
                    self.chatUserList.append(objChatUser)
                    self.filterUserList.append(objChatUser)
                    
                    
                    
                }
                catch{
                    
                    print("Eroor ---")
                    
                }
                
                
            }
            
            debugPrint("User list - \(self.chatUserList.count)")
            completionHandler()
            
        }
    }
    
    
    
    
    
    
    
    
    
    
}
