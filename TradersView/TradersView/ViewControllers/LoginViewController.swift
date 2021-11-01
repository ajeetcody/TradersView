//
//  LoginViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit
import GoogleSignIn


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


        self.emailIDTextfield.text = "ra168@gmail.com"
        self.passwordTextfield.text = "qwerty123"

//        self.emailIDTextfield.text = "kek@gmail.com"
//        self.passwordTextfield.text = "123456"

        
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
    
    @IBAction func googlePlusButtonAction(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: "477146900600-j15835agol5sg82r8j2arur69r2gmd24.apps.googleusercontent.com")
        
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
           guard error == nil else { return }

            guard let user = user else { return }

//                let emailAddress = user.profile?.email
//
//                let fullName = user.profile?.name
//                let givenName = user.profile?.givenName
//                let familyName = user.profile?.familyName
//
//                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//            
//            print("\(fullName ?? "") \(givenName ?? "") \(familyName ?? "") \(profilePicUrl)")
//            print("\(user.userID ?? "")")
//            
//            
           
            
         }
        
        
    }
    
    //MARK:- Api call for registration ----
    
    
    func callLoginApi(){
        
        
        let loginApiRequest = LoginRequest(email: self.emailIDTextfield.text!, password: self.passwordTextfield.text!, device_token: "", device_type: "")

        
        ApiCallManager.shared.apiCall(request: loginApiRequest, apiType: .LOGIN) { (responseString, data) in
            
            
            print("Response : - \(responseString)")
            
            UserDefaults.standard.setValue(data, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)

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
            
            DispatchQueue.main.async {
            
            self.showAlertPopupWithMessageWithHandler(msg: "Login Successfully!!") {
                
                self.showTabbarController()
                self.dismiss(animated: true, completion: nil)
                
            }
                
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
