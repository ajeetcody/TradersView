//
//  SignupViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

import Firebase
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
        
        ref = Database.database().reference()


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
        
        
        self.signupButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        
        self.nameTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        self.userNameTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        self.emailIDTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        self.phoneTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        self.passwordTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        self.confirmPasswordTextfield.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
        
        
        self.nameTextfield.setLeftPaddingPoints(10.0)
        self.nameTextfield.setRightPaddingPoints(10.0)

        
        self.userNameTextfield.setLeftPaddingPoints(10.0)
        self.userNameTextfield.setRightPaddingPoints(10.0)
        
        self.emailIDTextfield.setLeftPaddingPoints(10.0)
        self.emailIDTextfield.setRightPaddingPoints(10.0)

        
        self.phoneTextfield.setLeftPaddingPoints(10.0)
        self.phoneTextfield.setRightPaddingPoints(10.0)
        
        self.passwordTextfield.setLeftPaddingPoints(10.0)
        self.passwordTextfield.setRightPaddingPoints(10.0)

        
        self.confirmPasswordTextfield.setLeftPaddingPoints(10.0)
        self.confirmPasswordTextfield.setRightPaddingPoints(10.0)

        
        
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
    
    //MARK:- Add user entry in firebaes for chatting ---
    
    func addUserForChat(userData:RegisterUserData, successHandler:@escaping()->Void, errorHandler:@escaping(Error)->Void){
        
        
        //create user dictionary to first entery in "user" node firebase --
        
        let channelGroup = [["groupid":"Null"]]
        let privateGroup = [["groupid":"Null"]]
        let publicGroup = [["groupid":"Null"]]
        


        
        let dict:[String:Any] = ["channel_group":channelGroup, "private_group":privateGroup, "public_group":publicGroup,"date":Date.getCurrentDate(), "email":userData.email, "psd":userData.username, "recent_message":"","status":"online", "userId":userData.id,"username":userData.name, "imageURL":"https://spsofttech.com/projects/treader/images/dummy.png"]
        
        
        
        self.ref.child("user").child(userData.id).setValue(dict) { (error, reference) in
            
            
            if let err = error {
                
                errorHandler(err)
                
                
            }
            else{
                
                successHandler()
                
                
            }
        }
        
        
    }
    
    //MARK:- Api call for registration ----
    
    
    func callRegisterApi(){
        
        
        let registerAPIRequest = RegisterRequest(name: self.nameTextfield.text!, username: self.userNameTextfield.text!, email: self.emailIDTextfield.text!, mobile_no: self.phoneTextfield.text!, password: self.passwordTextfield.text!, facebook_id: "", google_id: "", device_token: "", device_type: "iOS")
        
        
        ApiCallManager.shared.apiCall(request: registerAPIRequest, apiType: .REGISTER, responseType: RegisterResponse.self, requestMethod:.POST) { (result) in
            
            
            let registerResponse:RegisterResponse = result
            
            if registerResponse.status == 0  {
                
                self.showAlertPopupWithMessage(msg: registerResponse.messages)
                
            }
            else{
                
                if let userData = registerResponse.userdata?[0]{
                    
                    self.addUserForChat(userData: userData) {
                        
                        
                        self.showAlertPopupWithMessageWithHandler(msg: "Register Successfully") {
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    } errorHandler: { (error) in
                        
                        self.showAlertPopupWithMessageWithHandler(msg: "Error - \(error.localizedDescription)") {
                        
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    }


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


extension SignupViewController{
   
    
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

extension SignupViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}
