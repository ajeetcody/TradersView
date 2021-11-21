//
//  Message.swift
//  Velo-Driver
//
//  Created by Ajeet Sharma on 06/06/21.
//  Copyright © 2021 Webcubator Technologies LLP. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import MessageKit


/*
 
 ["groupId":"This is not group", "message":message.content, "message_type":"text", "profile_image":self.otherUserProfilePicUrl, "sender_id":self.currentUser!.id, "sender_user_name":self.currentUser!.name, "timpstamp":dateFormatter.string(from: date)]
 
 */

struct Message {
    
    var groupId: String
    var message: String
    var message_type: String
    var profile_image: String
    var sender_id: String
    var sender_user_name:String
    var timpstamp:String
    
    var dictionary: [String: Any] {
        
        return [
            "groupId": groupId,
            "message": message,
            "message_type": message_type,
            "profile_image": profile_image,
            "sender_id":sender_id,
            "sender_user_name":sender_user_name,
            "timpstamp":timpstamp]
    }
    
    
}

extension Message {
    init?(dictionary: [String: Any]) {
        
        guard let _groupId = dictionary["groupId"] as? String,
              let _message = dictionary["message"] as? String,
              let _message_type = dictionary["message_type"] as? String,
              let _profile_image = dictionary["profile_image"] as? String,
              let _sender_id = dictionary["sender_id"] as? String,
              let _sender_user_name = dictionary["sender_user_name"] as? String,
              let _timpstamp = dictionary["timestamp"] as? String
        else {return nil}

        self.init(groupId: _groupId, message: _message, message_type: _message_type, profile_image: _profile_image, sender_id: _sender_id, sender_user_name: _sender_user_name, timpstamp: _timpstamp)
        
    }
}

//extension Message: MessageType {
//    
//    var sender: SenderType {
//        return ChatUser(senderId: sender_id, displayName: sender_user_name)
//    }
//    
//    var messageId: String {
//        return "1"
//    }
//    var sentDate: Date {
//        
//        return Date()
//        //return timpstamp.toDate()!
//    }
//    var kind: MessageKind {
//        
//        return .text(message)
//    }
//}
