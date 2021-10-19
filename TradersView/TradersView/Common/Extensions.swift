//
//  Extensions.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import Foundation
import UIKit

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}

extension UIColor{
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        let alpha = alpha
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

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
