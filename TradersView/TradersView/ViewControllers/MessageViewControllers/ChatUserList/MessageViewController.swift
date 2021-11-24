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
        self.fetchChannelList()
        self.fetchPublicGroup()
        self.fetchPrivateGroup()
        
        
        
        
    }
    
    //MARK:- Firebase operations ---
    
    func fetchPrivateGroup(){
        
        self.chatUserList_VM.fetchPrivateGroupList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewGroupPrivate.isHidden = self.chatUserList_VM.privateGroupList.count > 0 ?  false :  true
            
            self.tableViewGroupPrivate.reloadData()
            
            
        }
        
    }
    func fetchPublicGroup(){
        
        self.chatUserList_VM.fetchPublicGroupList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewGroupPublic.isHidden = self.chatUserList_VM.publicGroupList.count > 0 ?  false :  true
            
            self.tableViewGroupPublic.reloadData()
            
            
        }
        
    }
    func fetchChannelList(){
        
        self.chatUserList_VM.fetchChannelList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewChannel.isHidden = self.chatUserList_VM.channelList.count > 0 ?  false :  true
            
            self.tableViewChannel.reloadData()
            
            
        }
        
    }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105.0
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100{
            
            
            let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
            

                let searchUser = self.chatUserList_VM.chatUserList[indexPath.row]

                cell.profilePicture.sd_setImage(with: URL(string: "\(searchUser.imageURL)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
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
        else if tableView.tag == 101 {
            
            
            let cell:GroupAndChannelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupAndChannelTableViewCell") as! GroupAndChannelTableViewCell
            
            
            let publicGroup = self.chatUserList_VM.publicGroupList[indexPath.row]
            
            cell.profilePicture.sd_setImage(with: URL(string: "\(publicGroup.profileImage)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            
            cell.profilePicture.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 10.0)
            
            
            
            cell.groupNameLabel.text = publicGroup.groupName.capitalized
            
            
            
            return cell
            
        }
        else if tableView.tag == 102 {
            
            
            let cell:GroupAndChannelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupAndChannelTableViewCell") as! GroupAndChannelTableViewCell
            
            
            let privateGroupObj = self.chatUserList_VM.privateGroupList[indexPath.row]
            
            cell.profilePicture.sd_setImage(with: URL(string: "\(privateGroupObj.profileImage)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.profilePicture.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 10.0)
            
            
            
            cell.groupNameLabel.text = privateGroupObj.groupName.capitalized
            
            return cell
            
        }
        else if tableView.tag == 103 {
            
            print("tableview tag == 103")
            let cell:GroupAndChannelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupAndChannelTableViewCell") as! GroupAndChannelTableViewCell
            
            
            let channelObj = self.chatUserList_VM.channelList[indexPath.row]
            
            cell.profilePicture.sd_setImage(with: URL(string: "\(channelObj.profileImage)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.profilePicture.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 10.0)
            
            
            
            cell.groupNameLabel.text = channelObj.groupName.capitalized
            
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        if tableView.tag == 100{
          
            return self.chatUserList_VM.chatUserList.count

        }
        else if tableView.tag == 101{
          
            return self.chatUserList_VM.publicGroupList.count

            
        }
        else if tableView.tag == 102{
            
            return self.chatUserList_VM.privateGroupList.count

        }
        else if tableView.tag == 103{
            
            return self.chatUserList_VM.channelList.count

        }
        
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.tag == 100{
           
            
            let selectedUser = self.chatUserList_VM.chatUserList[indexPath.row]

            let chatScreenObj = MyChatScreenModel(currentUserImageUrl: (self.currentUserData?.profileImg)!, currentUserName: (self.currentUserData?.name)!, currentUserId: (self.currentUserData?.id)!, otherUserId: (selectedUser.userID), otherUserName: (selectedUser.username), isGroupChat: false)
            
            self.pushChatScreen(dataObj: chatScreenObj)
            
        }
        else if tableView.tag == 101{

            
        }
        else if tableView.tag == 102{
            

        }
        else if tableView.tag == 103{
            

        }
        
       
        
       
        
    }
    
}
