//
//  Extensions.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import Foundation
import UIKit


extension UIButton{

    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    
}

extension UITextField{
    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    
}
