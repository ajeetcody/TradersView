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
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var emailIDTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.loginButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 25.0)
        
        self.facebookButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 25.0)
        
        self.googleButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 25.0)
        
        self.emailIDTextfield.changeBorder(width: 0.0, borderColor: .lightGray, cornerRadius: 25.0)
        
        self.passwordTextfield.changeBorder(width: 0.0, borderColor: .lightGray, cornerRadius: 25.0)
        
        
        // self.emailIDTextfield.text = "ra168@gmail.com"
        // self.passwordTextfield.text = "qwerty123"
        
        self.emailIDTextfield.setLeftPaddingPoints(10.0)
        self.emailIDTextfield.setRightPaddingPoints(10.0)
        
        
        self.passwordTextfield.setLeftPaddingPoints(10.0)
        self.passwordTextfield.setRightPaddingPoints(10.0)
        
        
        self.emailIDTextfield.clearButtonMode = .always
        self.emailIDTextfield.clearButtonMode = .whileEditing
        
        
        self.emailIDTextfield.text = "a16887@gmail.com"
        self.passwordTextfield.text = "qwerty"
        self.imageLogo.changeBorder(width: 0.0, borderColor: .clear, cornerRadius: (Constants.screenWidth * 0.4)/2)
        
    }
    
    //MARK:- UIButton Action -----
    
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        
        self.showAlertCommingSoon()
        
        
    }
    
    
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
            
            self.showAlertCommingSoon()
            
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
        
        ApiCallManager.shared.apiCall(request: loginApiRequest, apiType: .LOGIN, responseType: LoginResponse.self, requestMethod:.POST) { (results) in
            
            
            
            if results.status == 0{
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
                return
            }
            
            let loginResponse:LoginResponse = results
            
            
            if let userDataLogin = loginResponse.userdata?[0] {
                
                
                
                let userDefaults = UserDefaults.standard
                do {
                    try userDefaults.setObject(userDataLogin, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)
                    self.appDelegate.loginResponseData = userDataLogin
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            else{
                
                self.showAlertPopupWithMessage(msg: loginResponse.messages)
                
            }
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }
        
        
        
    }
    
    
    func archiveObjectLoginData(userDataLogin:LoginUserData){
        
        
        do{
            let objData = try NSKeyedArchiver.archivedData(withRootObject: userDataLogin, requiringSecureCoding: true)
            UserDefaults.standard.set(objData, forKey: Constants.USER_DEFAULT_KEY_USER_DATA)
            UserDefaults.standard.synchronize()
            
            print("Archive Success ----")
            
        }catch (let error){
            #if DEBUG
            print("Failed to convert UIColor to Data : \(error.localizedDescription)")
            #endif
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

extension LoginViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}

