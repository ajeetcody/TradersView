//
//  SplashViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit


class SplashViewController: MasterViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appDelegate.mainNavigation = self.navigationController
        self.continueButton.changeBorder(width: 1.0, borderColor: .white, cornerRadius: 10.0)
        
        if UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_KEY_USER_DATA) != nil{
            
            let data:Data = UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_KEY_USER_DATA) as! Data
            
            let parseManager:ParseManager = ParseManager()
            parseManager.delegate = self
            parseManager.parse(data: data , apiType: .LOGIN)
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
extension SplashViewController:ParseManagerDelegate{
   
    
    func parseSuccessHandler(response: ResponseModel) {
        
        print("\(#function)")
        
        
        
        let loginResponse:LoginResponse = response as! LoginResponse
        
        if loginResponse.userdata == nil {
            
           // self.showAlertPopupWithMessage(msg: loginResponse.messages)
            
        }
        else{
            
            self.appDelegate.loginResponse = loginResponse
            self.showTabbarController()
            
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
