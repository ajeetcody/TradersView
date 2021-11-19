//
//  Extensions.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import Foundation
import UIKit

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}

extension UILabel{
    
    
    func createLink(text:String, linkText:String, _tag:Int){
        
        
         self.text = text
         self.textColor =  UIColor.black
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (linkText as NSString).range(of: "linkText")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Arial", size: 15.0)!, range: range1)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
        
        self.attributedText = underlineAttriString
        self.isUserInteractionEnabled = true
        self.tag = _tag
        
    }
    
    
}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "YYYY/mm/dd"

        return dateFormatter.string(from: Date())

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

extension String {

    func toDate(withFormat format: String = "dd MMM yyyy HH:MM:SS")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}



extension UIView{
    func dropShadow() {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: -1, height: 1)
            layer.shadowRadius = 15
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    
    func changeBorder(width:CGFloat, borderColor:UIColor, cornerRadius:CGFloat){
        
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
       // self.clipsToBounds = true
        self.layer.masksToBounds =  true
    }
    
}

extension UISearchBar {

    func change(textFont : UIFont?, textColor:UIColor) {

    for view : UIView in (self.subviews[0]).subviews {

        if let textField = view as? UITextField {
            textField.font = textFont
            textField.textColor = textColor
        }
    }
} }



extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension UITextView{
    
   
    
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension UIButton{

    
  
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


