//
//  MasterViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

class MasterViewController: UIViewController {
    
    let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Viewcontroller Navigation ----
    

    
    func showTabbarController(){
        
        
        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        let tbBarController = dashBoardStoryBoard.instantiateViewController(identifier: "MyTabbarController")
        self.appDelegate.mainNavigation?.pushViewController(tbBarController, animated: true)
        
        
    }
    
    
    //MARK:- Textfield Empty Validation
    
    func isTextfieldEmpty(textFields:[UITextField])->Bool{
        
        for textField in textFields{
            
            
            if textField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                
                self.showAlertPopupWithMessage(msg: "Please enter all the fields")
                return true
                
            }
        }
        
        return false
        
    }
    
    //MARK:- Alert popup ----
    
    
    
    func showErrorMessage(error:Error){
        
        
        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription). Please try again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showAlertPopupWithMessage(msg:String){
        
        let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
