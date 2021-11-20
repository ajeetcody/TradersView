//
//  MessageTabViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 19/10/21.
//

import UIKit
import Firebase

import SDWebImage
class MessageTabViewController: MasterViewController {

    //MARK:- Autolayout declaration -----

    
    @IBOutlet weak var leadingScrollIndicator: NSLayoutConstraint!
    @IBOutlet weak var leadingGroupScrollIndicator: NSLayoutConstraint!

    //MARK:- UI Object declaration -----
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var groupButton: UIButton!
    
    @IBOutlet weak var channelButton: UIButton!
    
    private var currentUserId:String?
    
    @IBOutlet weak var tableViewChannel: UITableView!
    @IBOutlet weak var tableViewGroupPrivate: UITableView!
    @IBOutlet weak var tableViewGroupPublic: UITableView!
    @IBOutlet weak var tableViewMessage: UITableView!
    var ref: DatabaseReference!
    
    var currentUserData:LoginUserData?
    
    private var totalUserKeysInchat:[String] = []
    private var messageUsers:[String:Any] = [:]
    //MARK:- UIViewcontroller lifecycle -----
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.ref = Database.database().reference()

        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            self.currentUserData = userData
            
            self.currentUserId = userData.id
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }

        self.view.layoutIfNeeded()

        
        self.fetchUserList()
        
        
        
        
    }
    
    //MARK:- Firebase operations ---
    
    func fetchUserList(){
        
        self.ref.child("user").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            self.totalUserKeysInchat = Array(dictResponse.keys)
            
            self.messageUsers = dictResponse
            print(dictResponse)
            self.tableViewMessage.reloadData()
            
        }
        
        
//        self.ref.child("user").observe(.value) { (snapshot) in
//            
//            
//            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
//            
//            self.totalUserKeysInchat = Array(dictResponse.keys)
//            
//            self.messageUsers = dictResponse
//            print(dictResponse)
//            self.tableViewMessage.reloadData()
//        }
        
        
    }
    
    //MARK:- UIButton action methods ----
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        if let userID = self.currentUserId{
        
            self.pushScreenWithScreenName(screenName: "SearchViewController", currentUserId: userID)
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User id is not available")
            
        }
        
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        
        if let userID = self.currentUserId{
        
            self.pushScreenWithScreenName(screenName: "NotificationViewController", currentUserId: userID)
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User id is not available")
            
        }
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func groupButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func channelButtonAction(_ sender: Any) {
        
        
        
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

extension MessageTabViewController:UIScrollViewDelegate{
    
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        print(scrollView.currentPage)
        
        if scrollView.tag == 0 {
        
            UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                
               
                
                self.leadingScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/3))

                self.view.layoutIfNeeded()
                
            } completion: { (isComplete) in
                print("Complete animation")
            }

            
        }
        else if scrollView.tag == 1{

            UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                
               
                
                self.leadingGroupScrollIndicator.constant = CGFloat(scrollView.currentPage * (Int(self.view.frame.size.width)/2))

                self.view.layoutIfNeeded()
                
            } completion: { (isComplete) in
                print("Complete animation")
            }

            
        }
        
     
        
    }
    
    
}
extension MessageTabViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView.tag == 100 {
            
            
            return self.totalUserKeysInchat.count
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            
            let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
            
            let key:String = self.totalUserKeysInchat[indexPath.row]
            let dict:[String:Any] = messageUsers[key] as! [String:Any]
            
            /*
             
             {
                 "channel_group" =     (
                             {
                         groupid = Null;
                     }
                 );
                 date = "2021/30/18";
                 email = "a1688887@gmail.com";
                 imageURL = "https://spsofttech.com/projects/treader/images/dummy.png";
                 "private_group" =     (
                             {
                         groupid = Null;
                     }
                 );
                 psd = a1688887;
                 "public_group" =     (
                             {
                         groupid = Null;
                     }
                 );
                 "recent_message" = "";
                 status = online;
                 userId = 356;
                 username = a1688887;
             }
             
             */
            
            cell.userNameLabel.text = (dict["username"] as! String).capitalized
            
            cell.profilePicture.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 30.0)
            
            if let urlString:String = dict["imageURL"] as? String{
            
                cell.profilePicture.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
                
            }
            else{
                
                
                print("Image is not available")
            }
            
            
            
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView.tag == 100 {
            
            return 87.0
            
        }
        
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.tag == 100 {
        
            let storyBoard:UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            
            let vc:MyChatViewController = storyBoard.instantiateViewController(identifier: "MyChatViewController") as! MyChatViewController
//            let key:String = self.totalUserKeysInchat[indexPath.row]
//            let dict:[String:Any] = messageUsers[key] as! [String:Any]
//
//            vc.otherUserId = dict["userId"] as! String
//            vc.otherUserName = dict["username"] as! String
//            vc.currentUser = self.currentUserData!
//            vc.otherUserProfilePicUrl = dict["imageURL"] as! String
//           
//            print("Current userid - \(self.currentUserData?.id ?? "")")
//            print("Other user id - \(dict["userId"] as! String)")
            
            
            self.appDelegate.mainNavigation?.pushViewController(vc, animated: true)
            
            
            
            
        }
        
    }
}
