//
//  LoginViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

class LoginViewController: MasterViewController {

    
    //MARK:- UI Object declarations ---
    
    @IBOutlet weak var emailIDTextfield: UITextField!
 
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        self.loginButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)

        self.facebookButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)

        self.googleButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        
        self.emailIDTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)

        self.passwordTextfield.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)


        self.emailIDTextfield.text = "a168@gmail.com"
        self.passwordTextfield.text = "qwerty123"

    }
    
    //MARK:- UIButton Action -----

    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if !self.isTextfieldEmpty(textFields: [self.emailIDTextfield, self.passwordTextfield]){
            
                
            self.callLoginApi()
            
        }
        
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
    //MARK:- Api call for registration ----
    
    
    func callLoginApi(){
        
        
        let loginApiRequest = LoginRequest(email: self.emailIDTextfield.text!, password: self.passwordTextfield.text!, device_token: "", device_type: "")

        
        ApiCallManager.apiCall(request: loginApiRequest, apiType: .LOGIN) { (responseString, data) in
            
            
            print("Response : - \(responseString)")
            
            let parseManager:ParseManager = ParseManager()
            
            parseManager.delegate = self
            parseManager.parse(data: data, apiType: .LOGIN)
            
            
        } failureHandler: { (error) in
            
            
            self.showErrorMessage(error: error)
            
            
        } somethingWentWrong: {
            
            self.showAlertSomethingWentWrong()
            
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


extension LoginViewController:ParseManagerDelegate{
   
    
    func parseSuccessHandler(response: ResponseModel) {
        
        print("\(#function)")
        
        
        
        let registerResponse:LoginResponse = response as! LoginResponse
        
        if registerResponse.userdata == nil {
            
            self.showAlertPopupWithMessage(msg: registerResponse.messages)
            
        }
        else{
            
            self.showAlertPopupWithMessageWithHandler(msg: "Login Successfully!!") {
                
                self.showTabbarController()
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
