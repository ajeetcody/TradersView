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

extension UITextView{
    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension UIButton{

    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    func underlineTextButton(title: String?, forState state: UIControl.State)
       {
           self.setTitle(title, for: .normal)
           self.setAttributedTitle(self.attributedString(), for: .normal)
       }

       private func attributedString() -> NSAttributedString? {
           let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
           ] as [NSAttributedString.Key : Any] 
           let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
           return attributedString
       }
    
}

extension UITextField{
    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        
    }
    
}
