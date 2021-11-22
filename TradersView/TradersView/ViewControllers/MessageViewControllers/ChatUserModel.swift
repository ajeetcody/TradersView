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
