//
//  ApiResponse.swift
//  TradersView
//
//  Created by Ajeet Sharma on 23/10/21.
//



import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let likeComment = try? newJSONDecoder().decode(LikeComment.self, from: jsonData)
//   let getNotification = try? newJSONDecoder().decode(GetNotification.self, from: jsonData)
//   let favProfile = try? newJSONDecoder().decode(FavProfile.self, from: jsonData)
//   let addMute = try? newJSONDecoder().decode(AddMute.self, from: jsonData)
//   let followerFollowinglist = try? newJSONDecoder().decode(FollowerFollowinglist.self, from: jsonData)
//   let removeFollower = try? newJSONDecoder().decode(RemoveFollower.self, from: jsonData)
//   let contactus = try? newJSONDecoder().decode(Contactus.self, from: jsonData)
//   let getPlan = try? newJSONDecoder().decode(GetPlan.self, from: jsonData)
//   let userBanByPolice = try? newJSONDecoder().decode(UserBanByPolice.self, from: jsonData)
//   let getMuteUser = try? newJSONDecoder().decode(GetMuteUser.self, from: jsonData)
//   let login = try? newJSONDecoder().decode(Login.self, from: jsonData)
//   let blockuser = try? newJSONDecoder().decode(Blockuser.self, from: jsonData)
//   let getPostbyuserid = try? newJSONDecoder().decode(GetPostbyuserid.self, from: jsonData)




// MARK: - GetBlockResponse
struct GetBlockAndMuteResponse: Codable {
    let data: [GetBlockAndMuteResponseDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct GetBlockAndMuteResponseDatum: Codable {
    let userid, name, username: String
    let profileImg: String
    let datatime: String

    enum CodingKeys: String, CodingKey {
        case userid, name, username
        case profileImg = "profile_img"
        case datatime
    }
}





// MARK: - Change_Password
struct ChangePasswordResponse: Codable {
    let status: Int
    let messages: String
}
// MARK: - Remove_follower
struct RemoveFollowerResponse: Codable {
    let status: Int
    let messages: String
}


// MARK: - FollowersFollowingResponse
struct FollowersFollowingResponse: Codable {
    let data: [FollowersFollowingResponseDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct FollowersFollowingResponseDatum: Codable {
    let userid, name, username: String
    let profileImg: String

    enum CodingKeys: String, CodingKey {
        case userid, name, username
        case profileImg = "profile_img"
    }
}



// MARK: - FollowResponse
struct FollowResponse: Codable {
    let status: Int
    let messages: String
}

// MARK: - GetProfileByID
struct GetProfileByIDResponse: Codable {
    let data: GetProfileByIDDatum?
    let status: Int
    let messages: String
}

// MARK: - GetProfileByIDDatum
struct GetProfileByIDDatum: Codable {
    let id, name, username, email: String?
    let mobileNo: String?
    let profileImg: String?
    let coverImg: String?
    let planname, planimg, followers, following: String?
    let favouriteProfile, post: Int?
    let accuracy: String?
    let isFollow: Int?
    let isPolice, isPremium: String?
    let isBlock, isMute: Int?
    let acType, commentPerType, tagPerType, mentionPerType: String?
    let dateTime: String?
    let isFavPro: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, username, email
        case mobileNo = "mobile_no"
        case profileImg = "profile_img"
        case coverImg = "cover_img"
        case planname, planimg, followers, following
        case favouriteProfile = "favourite_profile"
        case post, accuracy
        case isFollow = "is_follow"
        case isPolice = "is_police"
        case isPremium = "is_premium"
        case isBlock = "is_block"
        case isMute = "is_mute"
        case acType = "ac_type"
        case commentPerType = "comment_per_type"
        case tagPerType = "tag_per_type"
        case mentionPerType = "mention_per_type"
        case dateTime = "date_time"
        case isFavPro = "is_fav_pro"
    }
}


// MARK: - LikePostResponse
struct LikePostResponse: Codable {
    let status, like: Int
    let messages: String
}



// MARK: - AddCommentResponse
struct AddCommentResponse: Codable {
    let status: Int
    let messages: String
}

// MARK: - LikeCommenActionResponse
struct LikeCommentActionResponse: Codable {
    let status, isLike: Int
    let messages: String

    enum CodingKeys: String, CodingKey {
        case status
        case isLike = "is_like"
        case messages
    }
}


// MARK: - CommentListByPostID
struct CommentListByPostIDResponse: Codable {
    let data: [CommentListByPostIDDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct CommentListByPostIDDatum: Codable {
    let commentid, userID, postID, comment: String
    let commentLike, commentID, name: String
    let profileImg: String
    let date: String
    let isLike: Int

    enum CodingKeys: String, CodingKey {
        case commentid
        case userID = "user_id"
        case postID = "post_id"
        case comment
        case commentLike = "comment_like"
        case commentID = "comment_id"
        case name
        case profileImg = "profile_img"
        case date
        case isLike = "is_like"
    }
}



// MARK: - SearchResponse
struct SearchResponse: Codable {
    let data: [SearchDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct SearchDatum: Codable {
    let userid, name, username: String
    let profileImg: String

    enum CodingKeys: String, CodingKey {
        case userid, name, username
        case profileImg = "profile_img"
    }
}

// MARK: - PostByUserIDResponse
struct PostByUserIDResponse: Codable {
    let data: [PostByUserIDDatum]
    let status: Int
    let messages: String
}

// MARK: - Datum
struct PostByUserIDDatum: Codable {
    
    
    let postid, userID, username: String
    let profileImg: String
    let date, message, like: String
    let isLike: Int
    let comment: String
    let isComment: Int
    let share: String
    let isShare: Int
    let imageVideo: [ImageVideo]?
    let sharelink: String
    let isFollow, isBlock, isMute, commentPer: Int
    let tagPer, mentionPer: Int

    enum CodingKeys: String, CodingKey {
        case postid
        case userID = "user_id"
        case username
        case profileImg = "profile_img"
        case date, message, like
        case isLike = "is_like"
        case comment
        case isComment = "is_comment"
        case share
        case isShare = "is_share"
        case imageVideo = "image_video"
        case sharelink
        case isFollow = "is_follow"
        case isBlock = "is_block"
        case isMute = "is_mute"
        case commentPer = "comment_per"
        case tagPer = "tag_per"
        case mentionPer = "mention_per"
    }
}

// MARK: - CommunityResponse
struct CommunityResponse: Codable {
    let data: [CommunityResponseDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct CommunityResponseDatum: Codable {
    let postid, userID, username: String
    let profileImg: String
    let date, message, like: String
    let isLike: Int
    let comment: String
    let isComment: Int
    let share: String
    let isShare: Int
    let imageVideo: [ImageVideo]?
    let sharelink: String
    let isFollow, isBlock, isMute, commentPer: Int
    let tagPer, mentionPer: Int

    enum CodingKeys: String, CodingKey {
        case postid
        case userID = "user_id"
        case username
        case profileImg = "profile_img"
        case date, message, like
        case isLike = "is_like"
        case comment
        case isComment = "is_comment"
        case share
        case isShare = "is_share"
        case imageVideo = "image_video"
        case sharelink
        case isFollow = "is_follow"
        case isBlock = "is_block"
        case isMute = "is_mute"
        case commentPer = "comment_per"
        case tagPer = "tag_per"
        case mentionPer = "mention_per"
    }
}

// MARK: - ImageVideo
struct ImageVideo: Codable {
    let imgid: Imgid
    let image: Image
}

enum Image: Codable {
    
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Image.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Image"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
//    func getValueInteger()->Int{
//        
//        
//    }
//    
//    func getValueString()->String{
//        
//        
//        
//    }
}

enum Imgid: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Imgid.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Imgid"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


// MARK: - AddPostResponse
struct AddPostResponse: Codable, ResponseModel {
    let status: Int
    let messages: String
}



// MARK: - LikeComment
struct LikeComment: Codable {
    let status, isLike: Int
    let messages: String

    enum CodingKeys: String, CodingKey {
        case status
        case isLike = "is_like"
        case messages
    }
}

/// get_notification
// MARK: - GetNotification
struct GetNotification: Codable {
    let data: [GetNotificationDatum]
    let status: Int
    let messages: String
}

// MARK: - GetNotificationDatum
struct GetNotificationDatum: Codable {
    let title: Int
    let id, name, username, message: String
    let postid: String?
    let postImg: String
    let profileImg: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case title, id, name, username, message, postid
        case postImg = "post_img"
        case profileImg = "profile_img"
        case date
    }
}

/// Fav Profile
// MARK: - FavProfile
struct FavProfile: Codable {
    let status: Int
    let messages: String
}

/// Add Mute
// MARK: - AddMute
struct AddMute: Codable {
    let status: Int
    let messages: String
}

/// follower_followinglist
// MARK: - FollowerFollowinglist
struct FollowerFollowinglist: Codable {
    let data: [FollowerFollowinglistDatum]
    let status: Int
    let messages: String
}

// MARK: - FollowerFollowinglistDatum
struct FollowerFollowinglistDatum: Codable {
    let userid, name, username: String
    let profileImg: String
    let datatime: String?

    enum CodingKeys: String, CodingKey {
        case userid, name, username
        case profileImg = "profile_img"
        case datatime
    }
}



/// Contactus
// MARK: - Contactus
struct Contactus: Codable {
    let status: Int
    let messages: String
}

/// get_plan
// MARK: - GetPlan
struct GetPlan: Codable {
    let data: [GetPlanDatum]
    let status: Int
    let messages: String
}

// MARK: - GetPlanDatum
struct GetPlanDatum: Codable {
    let id: String
    let img: String
    let planName, datumDescription, price, month: String

    enum CodingKeys: String, CodingKey {
        case id, img
        case planName = "plan_name"
        case datumDescription = "description"
        case price, month
    }
}

/// User ban by Police
// MARK: - UserBanByPolice
struct UserBanByPolice: Codable {
    let status, ban: Int
    let messages: String
}

/// Get Mute User
// MARK: - GetMuteUser
struct GetMuteUser: Codable {
    let data: [FollowerFollowinglistDatum]
    let status: Int
    let messages: String
}

/// login
// MARK: - Login
struct Login: Codable {
    let userdata: [Userdatum]
    let status: Int
    let messages: String
}

// MARK: - Userdatum
struct Userdatum: Codable {
    let id, name, username, email: String
    let mobileNo: String
    let googleID, facebookID: JSONNull?
    let profileImg, coverImg: String
    let followers, following, accuracy: String
    let status: JSONNull?
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

/// blockuser
// MARK: - Blockuser
struct Blockuser: Codable {
    let status: Int
    let messages: String
}

/// get_postbyuserid
// MARK: - GetPostbyuserid
struct GetPostListByUserIdResponse: Codable {
    let data: [GetPostListByUserIdResponseDatum]?
    let status: Int
    let messages: String
}

// MARK: - GetPostbyuseridDatum
struct GetPostListByUserIdResponseDatum: Codable {
    let postid, userID, username: String
    let profileImg: String
    var date, message, like: String
    let isLike: Int
    let comment: String
    let isComment: Int
    let share: String
    let isShare: Int
    let imageVideo: [ImageVideo]?
    let sharelink: String
    let isFollow, isBlock, isMute, commentPer: Int
    let tagPer, mentionPer: Int

    enum CodingKeys: String, CodingKey {
        case postid
        case userID = "user_id"
        case username
        case profileImg = "profile_img"
        case date, message, like
        case isLike = "is_like"
        case comment
        case isComment = "is_comment"
        case share
        case isShare = "is_share"
        case imageVideo = "image_video"
        case sharelink
        case isFollow = "is_follow"
        case isBlock = "is_block"
        case isMute = "is_mute"
        case commentPer = "comment_per"
        case tagPer = "tag_per"
        case mentionPer = "mention_per"
    }
}



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


protocol ResponseModel {
    
    
}

//MARK:- Logout response ---

struct LogoutResponse:Codable, ResponseModel {
    
    let status: Int
    let messages: String

    
}

// MARK: - MostPopularResponse
struct MostPopularResponse: Codable {
    let data: [MostPopularDatum]?
    let status: Int
    let messages: String
}

// MARK: - Datum
struct MostPopularDatum: Codable {
    let id, title, msg: String
    let image: String
    let link: String
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



// MARK: - Block-Action-Response
struct BlockActionResponse: Codable, ResponseModel {
    let status: Int
    let messages: String
}


// MARK: - MuteActionResponse
struct MuteActionResponse: Codable, ResponseModel {
    let status: Int
    let messages: String
}
