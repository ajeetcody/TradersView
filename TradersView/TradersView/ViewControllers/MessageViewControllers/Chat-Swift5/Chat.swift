//
//  Chat.swift
//  Velo-Driver
//
//  Created by Ajeet Sharma on 06/06/21.
//  Copyright © 2021 Webcubator Technologies LLP. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
