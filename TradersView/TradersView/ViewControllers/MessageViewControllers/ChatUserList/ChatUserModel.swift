//
//  ChatUserModel.swift
//  TradersView
//
//  Created by Ajeet Sharma on 22/11/21.
//

import Foundation


// MARK: - ChatUserModel
struct ChatUserModel: Codable {

    let channelGroup: [Group]
    let date, email: String
    let imageURL: String
    let privateGroup: [Group]
    let psd: String
    let publicGroup: [Group]
    let recentMessage, status, userID, username: String

    enum CodingKeys: String, CodingKey {
        case channelGroup = "channel_group"
        case date, email, imageURL
        case privateGroup = "private_group"
        case psd
        case publicGroup = "public_group"
        case recentMessage = "recent_message"
        case status
        case userID = "userId"
        case username
    }
}

// MARK: - Group
struct Group: Codable {
    let groupid: String
}


// MARK: - ChatUserModel
struct GroupDetailModel: Codable {

    let addminId, addminName: String
    let cheack: Bool
    let isCheack: Bool
    let groupID: String
    let groupName: String
    let profileImage: String
    let recentMessage: String
    let timeDate: String

    
    
    let blockUsers: [IDList]
    let groupIDS: [IDList]
    let muteNotificationUsers: [IDList]
    let muteUsers: [IDList]
    let semiUsers: [IDList]
    

    enum CodingKeys: String, CodingKey {
        
        case cheack
        case isCheack
        case groupID
        case addminId
        case profileImage
        case groupIDS

        case addminName = "addminname"
        case groupName = "group_name"
        case recentMessage = "recent_message"
        case timeDate = "timedate"
        case muteNotificationUsers = "mutenotificationusers"
        case muteUsers = "muteusers"
        case semiUsers = "semiusers"
        case blockUsers = "blockusers"


    }
}

// MARK: - Group
struct IDList: Codable {
    let memberid: String
}
