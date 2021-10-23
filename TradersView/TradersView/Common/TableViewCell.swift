//
//  TableViewCell.swift
//  TradersView
//
//  Created by Ajeet Sharma on 20/10/21.
//

import Foundation
import UIKit
import SDWebImage


class MessageTableViewCell:UITableViewCell{
    
    @IBOutlet var profilePicture:UIImage!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var onlineStatusLabel:UILabel!
    
    
}

class GroupTableViewCell:UITableViewCell{
    
    @IBOutlet var profilePicture:UIImage!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    
    
    
}

class ChannelTableViewCell:UITableViewCell{
    
    
    @IBOutlet var profilePicture:UIImage!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    
    
    
}

