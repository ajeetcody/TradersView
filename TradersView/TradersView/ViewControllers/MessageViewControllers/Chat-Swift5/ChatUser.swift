//
//  ChatUser.swift
//  Velo-Driver
//
//  Created by Ajeet Sharma on 06/06/21.
//  Copyright © 2021 Webcubator Technologies LLP. All rights reserved.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
