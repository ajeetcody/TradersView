//
//  ChangePasswordViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 08/11/21.
//

import UIKit

class ChangePasswordViewController: MasterViewController {

    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var currentPasswordTextfield: UITextField!
    
    @IBOutlet weak var newPasswordTextfield: UITextField!
    
    @IBOutlet weak var reenterNewPasswordTextfield: UITextField!
    
    //MARK:- UIViewcontroller lifecycle methods -----
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.changePasswordButton.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 5.0)
        
       

    }
    
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        
        
        if self.isTextfieldEmpty(textFields: [self.currentPasswordTextfield, self.newPasswordTextfield, self.reenterNewPasswordTextfield])
        {
            
            
            return
        }
        
        
        
            
            if  let userData:LoginUserData = self.appDelegate.loginResponseData{
                
                let request = ResetPasswordRequest(_id: userData.id, _old_password: self.currentPasswordTextfield.text!, _new_password: self.newPasswordTextfield.text!, _confirm_password: self.reenterNewPasswordTextfield.text!)
                
                
                ApiCallManager.shared.apiCall(request: request, apiType: .RESET_PASSWORD, responseType: ChangePasswordResponse.self, requestMethod: .POST) { (results) in
                    
                    if results.status == 1{
                        
                        
                        DispatchQueue.main.async {

                        self.showAlertPopupWithMessage(msg: results.messages)
                        self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                    else{
                        
                        self.showAlertPopupWithMessage(msg: results.messages)

                    }
                    
                    
                    
                    
                } failureHandler: { (error) in
                    
                    self.showErrorMessage(error: error)
                }

                
                
                
            }
            else{
                
                self.showAlertPopupWithMessage(msg: "User Data is not available")
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

extension ChangePasswordViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
}
