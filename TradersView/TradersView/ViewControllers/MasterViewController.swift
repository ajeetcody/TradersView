//
//  MasterViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/10/21.
//

import UIKit

class MasterViewController: UIViewController {
    
    let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    var appVersion:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersion = version
       }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- Viewcontroller Present ----
    
    
    
    func showSearchViewController(){
       
        DispatchQueue.main.async {
        
        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        let vc = dashBoardStoryBoard.instantiateViewController(identifier: "SearchViewController")
            
            print("Show tabbar controller")
        self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
        
        }
        
    }
    
    //MARK:- Viewcontroller Navigation ----
    
    
    func pushCommentScreen(postId:String, notifyUserId:String){
        
        
        print("post id before showing the comment screen - \(postId)")
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:CommentListViewController = dashBoardStoryBoard.instantiateViewController(identifier: "CommentListViewController")
            
            vc.postId = postId
            vc.notifyToUserOfPost = notifyUserId
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)

            
        }
        
    }
    
    func pushUserProfileScreen(userId:String, currentUserId:String){
        
        
        DispatchQueue.main.async {
            
            let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
            let vc:UserProfileViewController = dashBoardStoryBoard.instantiateViewController(identifier: "UserProfileViewController")
            
            vc.currentUserId = currentUserId
            vc.userIDOfProfile = userId
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    func showTabbarController(){
       
        DispatchQueue.main.async {
        
        let dashBoardStoryBoard = UIStoryboard(name: "DashboardFlow", bundle: nil)
        let tbBarController = dashBoardStoryBoard.instantiateViewController(identifier: "MyTabbarController")
            
            print("Show tabbar controller")
        self.appDelegate.mainNavigation?.pushViewController(tbBarController, animated: true)
        
        }
        
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
    
    
    fileprivate func masterAlertPopup(title:String, message:String){
        
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func showErrorMessage(error:Error){
        
        DispatchQueue.main.async {

        
        self.masterAlertPopup(title: "Error", message: "\(error.localizedDescription). Please try again.")
        
        }
        
        
    }
    
    
    func showAlertPopupWithMessage(msg:String){
        
        
        DispatchQueue.main.async {

        self.masterAlertPopup(title: "Message", message: msg)
        
        }
    }
    
    
    func showAlertSomethingWentWrong(){
        
        
        DispatchQueue.main.async {

        self.masterAlertPopup(title: "Message", message: "Something went wrong")
        
        }
        
    }
    
    func showAlertPopupWithMessageWithHandler(msg:String, handler:@escaping()->Void){
        
        
        DispatchQueue.main.async {

       
            
            let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
                handler()
                
                
            }
            alertController.addAction(defaultAction)
        
        
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func areYouSureAlertPopup(title:String, msg:String, yesHandler:@escaping()->Void, noHandler:@escaping()->Void ){
        
        
        DispatchQueue.main.async {

       
            
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                yesHandler()
                
                
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                
                noHandler()
                
                
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)

        
            self.present(alertController, animated: true, completion: nil)
            
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
