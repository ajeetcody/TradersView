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


        self.emailIDTextfield.text = "ajeet.cody@gmail.com"
        self.passwordTextfield.text = "qwerty"

    }
    
    //MARK:- UIButton Action -----

    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if !self.isTextfieldEmpty(textFields: [self.emailIDTextfield, self.passwordTextfield]){
            
                
            FirebaseManager.login(emailId: self.emailIDTextfield.text!, password: self.passwordTextfield.text!) {
                

                
                self.showTabbarController()
                
                self.dismiss(animated: true, completion: nil)
                
                
                
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
                
                
            }

            
        }
        
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

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
