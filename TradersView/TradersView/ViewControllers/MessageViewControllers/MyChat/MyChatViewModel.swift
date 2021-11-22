//
//  MyChatViewModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 22/11/21.
//

import Foundation
import Firebase

class MyChatViewModel{
    
    let ref:DatabaseReference = Database.database().reference()
    
    var messageList:[Message] = []

    var currentUserId:String = ""
    var otherUserId:String = ""
    
    var messageToBeSend:[String:Any] = [:]
    
    
    func sendChat(){
        
        self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId).childByAutoId().setValue(messageToBeSend)
        self.ref.child("UserMessage").child(self.otherUserId).child(self.currentUserId).childByAutoId().setValue(messageToBeSend)
        
        
    }
    
    func fetchNewAddedMessage(completionHandler:@escaping()->Void){
        
        self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId).observe(.childAdded) { (snapshot) in
            
            
            
            
            
            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
                
                
                
                
                print(dictResponse)
                
             //   let snapshotChildren = snapshot.children
                
             //   while let child = snapshotChildren.nextObject() as? DataSnapshot {
                    
                 //   print(child.key)
                    
                    let obj:[String:Any] = dictResponse
                    
                    do{
                        
                        let msg = Message(dictionary: obj)
                        
                        self.messageList.append(msg!)
                        
                        
                        
                    }
                    catch{
                        
                        print("Eroor ---")
                        
                    }
                    
                    
              //  }
                
                debugPrint("User list - \(self.messageList.count)")
                
                
                
                completionHandler()
                
                
            }
            
        }
        
        
    }
    
    func fetchAllMessages(completionHandler:@escaping()->Void){
        
       
//        self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId).getData { (error, snapshot) in
//            print("self.currentUserId - \(self.currentUserId)")
//            print("self.otherUserId - \(self.otherUserId)")
//
//
//
//            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
//
//
//
//
//                self.messageList.removeAll()
//                print(dictResponse)
//
//                let snapshotChildren = snapshot.children
//
//                while let child = snapshotChildren.nextObject() as? DataSnapshot {
//
//                    print(child.key)
//
//                    let obj:[String:Any] = child.value as! [String : Any]
//
//
//
//                        let msg = Message(dictionary: obj)
//
//
//                        self.messageList.append(msg!)
//
//
//
//
//                }
//
//                debugPrint("messageList list count - \(self.messageList.count)")
//
//
//
//                completionHandler()
//
//
//            }
//
//
//
//        }
        
        
        self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId).queryOrderedByKey().observe(.value) { (snapshot) in

            print("self.currentUserId - \(self.currentUserId)")
            print("self.otherUserId - \(self.otherUserId)")



            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{




                self.messageList.removeAll()
                print(dictResponse)

                let snapshotChildren = snapshot.children

                while let child = snapshotChildren.nextObject() as? DataSnapshot {

                    print(child.key)

                    let obj:[String:Any] = child.value as! [String : Any]



                        let msg = Message(dictionary: obj)


                        self.messageList.append(msg!)




                }

                debugPrint("messageList list count - \(self.messageList.count)")



                completionHandler()


            }

        }
        
    }
    
    
    
    
    
    
    
    
    
    
}
