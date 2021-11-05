//
//  UserProfileViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 06/11/21.
//

import UIKit

class UserProfileViewController: MasterViewController {

    
    
    @IBOutlet weak var userNameHeaderLabel: UILabel!
   
    var userIDOfProfile:String = ""
    var currentUserId:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.callApiToFetchUserProfile()
        
        
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    func callApiToFetchUserProfile(){
        
        
        let request = GetprofileByIdRequest(_user_id: self.userIDOfProfile, _id: self.currentUserId)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .GET_PROFILE_BY_ID, responseType: GetProfileByIDResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1 {
                
                
                if let userData = results.data{
                    
                    DispatchQueue.main.async {
                    
                        self.userNameHeaderLabel.text = userData.name?.capitalized
                        
                    }
                    
                    
                    
                }
                else{
                    
                    
                    self.showAlertPopupWithMessageWithHandler(msg: "Data is not available for this user") {
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                
                
            }
            else {
                
                self.showAlertPopupWithMessageWithHandler(msg: results.messages) {
                    
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    
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
