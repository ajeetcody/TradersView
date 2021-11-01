//
//  SignupViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

class SignupViewController: MasterViewController {

    
    //MARK:- UI Object declarations ---
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailIDTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    //MARK:- UIViewcontroller lifecycle methods ---
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.uiChanges()
        
        self.nameTextfield.text = "ajeet sharma"
        self.userNameTextfield.text = "a168"
        self.emailIDTextfield.text = "a168@gmail.com"
        self.phoneTextfield.text = "+919009241741"
        self.passwordTextfield.text = "qwerty123"
        self.confirmPasswordTextfield.text = "qwerty123"

    }
    
    //MARK:- UI Changes -----
    
    
    func uiChanges(){
        
        
        self.signupButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.nameTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.userNameTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.emailIDTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.phoneTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.passwordTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        self.confirmPasswordTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)

        
        
    }
    
    //MARK:- UIButton Action -----
    
    @IBAction func signupButtonAction(_ sender: Any) {
        
        
        if !self.isTextfieldEmpty(textFields: [self.nameTextfield, self.userNameTextfield, self.emailIDTextfield, self.phoneTextfield, self.passwordTextfield, self.confirmPasswordTextfield]){
            
            if self.passwordTextfield.text == self.confirmPasswordTextfield.text {
                
                
                self.callRegisterApi()
                
                
            }
            else{
                
                
                self.showAlertPopupWithMessage(msg: "Both password should be same.")
                
            }
           
            
        }
        
        
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
       
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
    //MARK:- Api call for registration ----
    
    
    func callRegisterApi(){
        
        
        let registerAPIRequest = RegisterRequest(name: self.nameTextfield.text!, username: self.userNameTextfield.text!, email: self.emailIDTextfield.text!, mobile_no: self.phoneTextfield.text!, password: self.passwordTextfield.text!, facebook_id: "", google_id: "", device_token: "", device_type: "iOS")
        
        
        ApiCallManager.shared.apiCall(request: registerAPIRequest, apiType: .REGISTER, responseType: RegisterResponse.self, requestMethod:.POST) { (result) in
            
            
            let registerResponse:RegisterResponse = result as! RegisterResponse
            
            if registerResponse.userdata == nil {
                
                self.showAlertPopupWithMessage(msg: registerResponse.messages)
                
            }
            else{
                
                self.showAlertPopupWithMessageWithHandler(msg: "Register Successfully!!") {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
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


extension SignupViewController:ParseManagerDelegate{
   
    
    func parseSuccessHandler(response: ResponseModel) {
        
        print("\(#function)")
        
        let registerResponse:RegisterResponse = response as! RegisterResponse
        
        if registerResponse.userdata == nil {
            
            self.showAlertPopupWithMessage(msg: registerResponse.messages)
            
        }
        else{
            
            self.showAlertPopupWithMessageWithHandler(msg: "Register Successfully!!") {
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    func parseErrorHandler(error: Error) {
        print("\(#function)")
        self.showErrorMessage(error: error)
    }
    
    func parseSomethingWentWrong() {
        print("\(#function)")
        self.showAlertSomethingWentWrong()
        
    }
}
