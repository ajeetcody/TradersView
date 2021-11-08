//
//  ContactUsViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 08/11/21.
//

import UIKit

class ContactUsViewController: MasterViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    
    
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    
    @IBOutlet weak var emailIdTextfield: UITextField!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    
    //MARK:- UIViewcontroller lifecycle ---
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.commentTextView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 10.0)
        
        self.commentTextView.leftSpace()
        self.sendButton.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 5.0)
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.nameTextfield.text = userData.name
            self.emailIdTextfield.text = userData.email
            self.phoneNumberTextfield.text = userData.mobileNo
            
            
        }
        
        
    }
    
    
    //MARK:- UIButton action -----
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        if self.isTextfieldEmpty(textFields: [self.emailIdTextfield, self.phoneNumberTextfield, self.emailIdTextfield]){
            
            return
            
        }
        
        if self.commentTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            
            self.showAlertPopupWithMessage(msg: "Please enter message")
            return
            
        }
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            self.contactUsApi(userID: userData.id)
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
        
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Call for contact us -----
    
    func contactUsApi(userID:String){
        
        
        let request = ContactRequest(_user_id: userID, _name: self.nameTextfield.text!, _phone: self.phoneNumberTextfield.text!, _email: self.emailIdTextfield.text!, _msg: self.commentTextView.text!)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .CONTACT_US, responseType: ContactusResponse.self, requestMethod: .POST) { (results) in
            
            
            
            if results.status == 1 {
                
                
                self.showAlertPopupWithMessageWithHandler(msg: results.messages) {
                    
                    DispatchQueue.main.async {
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
            else {
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
            }
            
            
            
        } failureHandler: { (error) in
            
            
            
            
            self.showErrorMessage(error: error)
            
            
            
        }
        
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ContactUsViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
