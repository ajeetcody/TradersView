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

    //GroupDetailModel
    
    
    var publicGroupList:[GroupDetailModel] = []
    var privateGroupList:[GroupDetailModel] = []
    var channelList:[GroupDetailModel] = []
    
    
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
    
    func fetchChannelList(completionHandler:@escaping()->Void){
        
        
        
        self.ref.child("ChannelDetail").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            let snapshotChildren = snapshot.children
            
            while let child = snapshotChildren.nextObject() as? DataSnapshot {
                
                print(child.key)
                
                self.channelList.removeAll()
                
                let obj:[String:Any] = child.value as! [String : Any]
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let groupObj = try JSONDecoder().decode(GroupDetailModel.self, from: jsonData)
                    
                    
                    self.channelList.append(groupObj)
                    
                    
                    
                }
                catch{
                    
                    print("Eroor ---")
                    
                }
                
                
            }
            
            debugPrint("Channel  - \(self.publicGroupList.count)")
            
            completionHandler()
            
        }
    }
    
    func fetchPrivateGroupList(completionHandler:@escaping()->Void){
        
        
        
        self.ref.child("PublicGroupDetail").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            let snapshotChildren = snapshot.children
            self.publicGroupList.removeAll()
            while let child = snapshotChildren.nextObject() as? DataSnapshot {
                
                print(child.key)
                
                let obj:[String:Any] = child.value as! [String : Any]
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let groupObj = try JSONDecoder().decode(GroupDetailModel.self, from: jsonData)
                    
                    
                    self.publicGroupList.append(groupObj)
                    
                    
                    
                }
                catch{
                    
                    print("Eroor ---")
                    
                }
                
                
            }
            
            debugPrint("private GroupList  - \(self.publicGroupList.count)")
            completionHandler()
            
        }
    }
    func fetchPublicGroupList(completionHandler:@escaping()->Void){
        
        
        
        self.ref.child("PublicGroupDetail").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            let snapshotChildren = snapshot.children
            
            while let child = snapshotChildren.nextObject() as? DataSnapshot {
                
                print(child.key)
                
                let obj:[String:Any] = child.value as! [String : Any]
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let groupObj = try JSONDecoder().decode(GroupDetailModel.self, from: jsonData)
                    
                    
                    self.publicGroupList.append(groupObj)
                    
                    
                    
                }
                catch let error{
                    
                    print("Eroor public group --- \(error.localizedDescription)")
                    
                }
                
                
            }
            
            debugPrint("public GroupList  - \(self.publicGroupList.count)")
            completionHandler()
            
        }
    }
    
    func fetchChatUserList(completionHandler:@escaping()->Void){
        
        
        
        self.ref.child("user").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            let snapshotChildren = snapshot.children
            self.filterUserList.removeAll()
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
