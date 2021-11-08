//
//  SplashViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit


class SplashViewController: MasterViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    //MARK:- UIViewcontroller lifecycle ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appDelegate.mainNavigation = self.navigationController
        self.continueButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        if UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_KEY_USER_DATA) != nil{
            
            print("Login data response ----")
            
            let userDefaults = UserDefaults.standard
            do {
                let loginData = try userDefaults.getObject(forKey: Constants.USER_DEFAULT_KEY_USER_DATA, castTo: LoginUserData.self)
                
                self.appDelegate.loginResponseData = loginData
                self.showTabbarController(animated: false)
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    //MARK:- UIButton action -----
    
    @IBAction func privacyButtonAction(_ sender: Any) {
        
        self.showAlertCommingSoon()
        
        
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

