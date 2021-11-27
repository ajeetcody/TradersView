//
//  MyChatViewModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 22/11/21.
//

import Foundation
import Firebase

class MyChatViewModel{
    
    var ref:DatabaseReference = Database.database().reference()
    
    var messageList:[Message] = []
    
    var currentUserId:String = ""
    var otherUserId:String = ""
    
    var messageToBeSend:[String:Any] = [:]
    
    var chatType:ChatType = .PERSONAL
    
    var isThisGroupChat:Bool = true
    
    func sendChat(){
        
        let refSendChat:DatabaseReference = Database.database().reference()

        
        switch chatType {
        
        case .PERSONAL:
            
            refSendChat.child("UserMessage").child(self.currentUserId).child(self.otherUserId).childByAutoId().setValue(messageToBeSend)
            refSendChat.child("UserMessage").child(self.otherUserId).child(self.currentUserId).childByAutoId().setValue(messageToBeSend)
            
        case .PUBLIC_GROUP:
            
            refSendChat.child("PublicGroupMessage").child(self.otherUserId).child("\(self.currentUserId)").childByAutoId().setValue(messageToBeSend)
            refSendChat.child("PublicGroupMessage").child(self.otherUserId).child("all chat").childByAutoId().setValue(messageToBeSend)

            
        case .PRIVATE_GROUP:
            
            break
        case .CHANNEL:
            
            refSendChat.child("ChannelMessage").child(self.otherUserId).child("\(self.currentUserId)").childByAutoId().setValue(messageToBeSend)

            refSendChat.child("ChannelMessage").child(self.otherUserId).child("all chat").childByAutoId().setValue(messageToBeSend)
            
            
        }
        
        
        
        
    }
    
    
    
    func fetchAllMessages(completionHandler:@escaping()->Void){
        
        
        switch chatType {
        
        case .PERSONAL:
            
            self.ref =   self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId)
            
        case .PUBLIC_GROUP:
            
            self.ref =    self.ref.child("PublicGroupMessage").child(self.otherUserId).child("all chat")
            
        case .PRIVATE_GROUP:
            
            break
        case .CHANNEL:
            
            self.ref =    self.ref.child("ChannelMessage").child(self.otherUserId).child("all chat")
            
            
        }
        
        self.ref.observe(.value) { (snapshot) in
            
            print("self.currentUserId - \(self.currentUserId)")
            print("self.otherUserId - \(self.otherUserId)")
            
            
            
            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
                
                
                
                
                self.messageList.removeAll()
                print(dictResponse)
                
                let snapshotChildren = snapshot.children
                
                while let child = snapshotChildren.nextObject() as? DataSnapshot {
                    
                    print(child.key)
                    print(child.value)
                    let obj:[String:Any] = child.value as! [String : Any]
                    
                    
                    
                    let msg = Message(dictionary: obj)
                    
                
                    if let message = msg{
                        
                    
                        self.messageList.append(message)
                        
                        
                        
                    }
                    else{
                        
                        print("Message is not working - \(obj)")
                        debugPrint(child.value)
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                debugPrint("messageList list count - \(self.messageList.count)")
                
                
                
                completionHandler()
                
                
            }
            
        }
        
    }
}
