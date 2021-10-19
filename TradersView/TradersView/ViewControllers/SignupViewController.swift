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
        
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
       
        self.dismiss(animated: true, completion: nil)
        
        
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
