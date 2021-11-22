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
    
    fileprivate var chatUserList_VM = ChatUserListViewModel()


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
        
        self.chatUserList_VM.fetchChatUserList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewMessage.isHidden = self.chatUserList_VM.chatUserList.count > 0 ?  false :  true
            
            self.tableViewMessage.reloadData()
            
            
        }
        
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        

            let searchUser = self.chatUserList_VM.chatUserList[indexPath.row]

            cell.profilePicture.sd_setImage(with: URL(string: "\(searchUser.imageURL)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profilePicture.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)

            cell.profilePicture.tag = indexPath.row


            cell.userNameLabel.text = searchUser.username.capitalized
           // cell.userNameLabel.text = "@\(searchUser.psd.capitalized)"


            if self.chatUserList_VM.checkUserIsSelected(userData: searchUser){

                cell.accessoryType = .checkmark

            }
            else{

                cell.accessoryType = .none

            }




        
        
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatUserList_VM.chatUserList.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedUser = self.chatUserList_VM.chatUserList[indexPath.row]
       
       // let obj = MyChatScreenModel()
        
        
        let chatScreenObj = MyChatScreenModel(currentUserImageUrl: (self.currentUserData?.profileImg)!, currentUserName: (self.currentUserData?.name)!, currentUserId: (self.currentUserData?.id)!, otherUserId: (selectedUser.userID), otherUserName: (selectedUser.username), isGroupChat: false)
        
        self.pushChatScreen(dataObj: chatScreenObj)
        
        
       
        
    }
    
}
