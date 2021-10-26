//
//  ApiResponse.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
//

import Foundation

protocol ResponseModel {
    
    
}

//MARK:- Logout response ---

struct LogoutResponse:Codable, ResponseModel {
    
    let status: Int
    let messages: String

    
}


// MARK: - RegisterResponse

struct RegisterResponse: Codable, ResponseModel {
    var userdata: [RegisterUserData]?
    let status: Int
    let messages: String
}

struct RegisterUserData: Codable {
    let id, name, username, email: String
    let mobileNo: String
    let googleID, facebookID: String?
    let profileImg, coverImg: String
    let followers, following, accuracy: String
    let status, deviceType, deviceToken, otp: String?
    let emailVerify, isPolice, isBan, isPlan: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, username, email
        case mobileNo = "mobile_no"
        case googleID = "google_id"
        case facebookID = "facebook_id"
        case profileImg = "profile_img"
        case coverImg = "cover_img"
        case followers, following, accuracy, status
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case otp
        case emailVerify = "email_verify"
        case isPolice = "is_police"
        case isBan = "is_ban"
        case isPlan = "is_plan"
    }
}

//MARK:- Login Response ---


// MARK: - alphaTwoCodeLogin
struct LoginResponse: Codable, ResponseModel {
    let userdata: [LoginUserData]?
    let status: Int
    let messages: String
}

// MARK: - alphaTwoCodeUserdatum
struct LoginUserData: Codable {
    let id, name, username, email: String
    let mobileNo: String
    let googleID, facebookID: String?
    let profileImg, coverImg: String
    let followers, following, accuracy: String
    let status: String?
    let deviceType, deviceToken, emailVerify, isPolice: String
    let isPremium, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, username, email
        case mobileNo = "mobile_no"
        case googleID = "google_id"
        case facebookID = "facebook_id"
        case profileImg = "profile_img"
        case coverImg = "cover_img"
        case followers, following, accuracy, status
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case emailVerify = "email_verify"
        case isPolice = "is_police"
        case isPremium = "is_premium"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
