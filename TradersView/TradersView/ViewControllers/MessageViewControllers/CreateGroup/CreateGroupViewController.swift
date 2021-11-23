//
//  CreateGroupViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 17/11/21.
//

import UIKit

class CreateGroupViewController: MasterViewController {
    
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var groupNameTextfield: UITextField!
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    private var workItemReference:DispatchWorkItem? = nil
    
    
    fileprivate var chatUserList_VM = ChatUserListViewModel()
    
    var profileImage:UIImage?
    
    var profileImageUrl:String = ""
    var profileImageFormate:String = ""

    //MARK:- UIViewcontroller lifecycle methods ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewSearch.isHidden = true
        self.searchView.barTintColor = UIColor.clear
        self.searchView.backgroundColor = UIColor.clear
        self.searchView.isTranslucent = true
        self.searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.searchView.searchTextField.font = UIFont.systemFont(ofSize: 18.0)
        
       
        
        self.groupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.groupImageSelected(gesture:))))
        
        self.groupImageView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 45.0)
        
        self.createGroupButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 8.0)
        self.cancelButton.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 8.0)

        
        self.fetchChatUserList()
        
    }
    
    
    
    @objc func groupImageSelected(gesture:UITapGestureRecognizer){
        
        self.openCameraOptionActionsheet(shouldUploadOnFirebase: false, isVideo: false)

        
    }
    
    //MARK:- Image url overriding ---
    
    override func sendImageOnly(img: UIImage,formate:String) {
        
        self.groupImageView.image = img
        self.profileImage = img
        self.profileImageFormate = formate
        
        
    }
    override func sendFileURLAfterUpload(imgUrl: String, mediaType: MediaType) {
        
        print("img url - \(imgUrl)")
        print("media type - \(mediaType)")
        
        self.profileImageUrl = imgUrl
        
      if  let userData:LoginUserData = self.appDelegate.loginResponseData{

        
        self.createGroupInFirebase(userData: userData, profileImageUrl: imgUrl)
        

      }
      else{
          
          self.showAlertPopupWithMessage(msg: "User Data is not available")
      }
        
    }
    
    
    
    //MARK:- UIButton action methods ----
    
    @IBAction func publicSwitchAction(_ sender: UISwitch) {
        
        print(sender.isOn)
        
    }
    
    @IBAction func createGroupButtonAction(_ sender: Any)
    {
        

        
        if self.groupNameTextfield.text?.trimmingCharacters(in: .whitespaces).count == 0{
            
            self.showAlertPopupWithMessage(msg: "Please select Channel Name")
            
        }
        else if self.chatUserList_VM.selectedUserData.count == 0{
            
            self.showAlertPopupWithMessage(msg: "Please User in Channel")

            
        }
        else if self.groupImageView.image == nil || self.profileImage == nil{
            
            self.showAlertPopupWithMessage(msg: "Please set image of group")

            
        }
        else{
            
            
            self.uploadImageToStorageFirebase(img: self.profileImage!, formate: self.profileImageFormate)

        }
        
        
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //MARK:- Firebase - Create Group ----
    
    
    
    func createGroupInFirebase(userData:LoginUserData, profileImageUrl:String){
        
        //create user dictionary to first entery in "user" node firebase --
        
        let blockUsers = [["memberid":"No id"]]
        let groupIDS = self.chatUserList_VM.selectedUserIdList()
        print("GroupIds:-\(groupIDS)")
        
        let muteNotificationID = [["memberid":"Null"]]

        let muteUsers = [["memberid":"No id"]]
        let semiUsers = [["memberid":"No id"]]


        var dict:[String:Any] = ["addminId":userData.id, "addminname":userData.name, "blockUsers":blockUsers, "cheack":self.publicSwitch.isOn, "groupIDS":groupIDS, "group_name":self.groupNameTextfield.text!, "isCheack":self.publicSwitch.isOn,"mutenotificationusers":muteNotificationID,"muteUsers":muteUsers, "profileImage":profileImageUrl,"recent_iamge":"", "semiusers":semiUsers, "timdate":Date.getCurrentDate()]
        
        
        self.ref.child("PublicGroupDetail").childByAutoId().setValue(dict) { (error, reference) in
            
            
            if error != nil{
                
                self.showErrorMessage(error: error!)
                
            }
            else{
                
                dict["groupID"] = reference.key
                self.ref.child("PublicGroupDetail").child(reference.key!).setValue(dict) { (error, referenceTwo) in
                    
                    
                    if error != nil{
                        
                        self.showErrorMessage(error: error!)
                        
                    }
                    else{
                        
                        self.showAlertPopupWithMessageWithHandler(msg: "Group is created") {
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    }
                }
                
                
            }
            
            
        }
        
       // let dict:[String:Any] = ["channel_group":channelGroup, "private_group":privateGroup, "public_group":publicGroup,"date":Date.getCurrentDate(), "email":userData.email, "psd":userData.username, "recent_message":"","status":"online", "userId":userData.id,"username":userData.name, "imageURL":"https://spsofttech.com/projects/treader/images/dummy.png"]
        
        
        
//        self.ref.child("PublicGroupDetail").
        
        
        
    }
   
    //MARK:- Fetch Chat user list ---
    
    
    func fetchChatUserList(){
        
        self.chatUserList_VM.fetchChatUserList {
            
            
            print("--- Fetch chat user list ---")
            
            self.tableViewSearch.isHidden = self.chatUserList_VM.chatUserList.count > 0 ?  false :  true
            
          
            self.tableViewSearch.reloadData()
            
            
        }
        
        
    }
    
    //MRK:- Call search API --

    
    
    //MARK:- Image fetch actions ---
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CreateGroupViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        

            let searchUser = self.chatUserList_VM.filterUserList[indexPath.row]

            cell.profileImageView.sd_setImage(with: URL(string: "\(searchUser.imageURL)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profileImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)

            cell.profileImageView.tag = indexPath.row


            cell.nameLabel.text = searchUser.username.capitalized
            cell.userNameLabel.text = "@\(searchUser.psd.capitalized)"


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
        
        return self.chatUserList_VM.filterUserList.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let obj = self.chatUserList_VM.filterUserList[indexPath.row]

        if self.chatUserList_VM.checkUserIsSelected(userData: obj){

            self.chatUserList_VM.removeUserFromSelectedList(userData: obj)
        }
        else{

            print("Selected  - \(obj.username)")
            self.chatUserList_VM.selectedUserData.append(obj)

        }


        
        self.tableViewSearch.reloadData()
       
        
    }
    
}
extension CreateGroupViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.trimmingCharacters(in: .whitespaces).count == 0{
            
            
            self.chatUserList_VM.filterUserList = self.chatUserList_VM.chatUserList
            self.tableViewSearch.reloadData()
            return
        }
        
        print("\(#function) - 1 \(searchText)")
        self.chatUserList_VM.filterUserList =   self.chatUserList_VM.chatUserList.filter { (userModel) -> Bool in
            
            print("\(userModel.username) == \(searchText)")
            
            return userModel.username.containsIgnoringCase(find: searchText)
        }
        
        print("\(#function) - 2")
        self.tableViewSearch.reloadData()
        
        
        
    }
    
    
}

extension CreateGroupViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
