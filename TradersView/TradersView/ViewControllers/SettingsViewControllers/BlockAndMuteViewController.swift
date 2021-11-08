//
//  BlockAndMuteViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 08/11/21.
//

import UIKit

class CellBlockUser:UITableViewCell{
    
    
    @IBOutlet weak var unblockButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
}


class BlockAndMuteViewController: MasterViewController {
    
    @IBOutlet weak var tableViewBlockUsers: UITableView!
    
    @IBOutlet weak var screenHeadingLabel: UILabel!
    
    var currentUserId:String?
    
    var isBlockUserList:Bool = false // true - blockUseList, false - MuteUserList

    var arrayBlockUsers:[GetBlockAndMuteResponseDatum]?
    
    
    //MARK:- UIViewcontroller lifecycle methods ----
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        if self.isBlockUserList{
            
        
            
            self.screenHeadingLabel.text = "Block User List"
            
        }
        else {
            
        
            
            
            self.screenHeadingLabel.text = "Mute User List"
            
        }
        

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.currentUserId = userData.id
            self.fetchUserId()

        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
        
     
        
        
    }
    
    func fetchUserId(){
        
        
        if self.isBlockUserList{
            
            

            self.fetchBlockAndMuteUserId(_apiType: .GET_BLOCK_USER)
        }
        else {
            
            
            self.fetchBlockAndMuteUserId(_apiType: .GET_MUTE_USER)
            
        }
        
        
      
        
    }
    
    
    //MARK:- Api call ---
    
    func apiCallToUnblockUser(userID:String){
        
        
        if let currentUserID = self.currentUserId{
            
            let request = BlockActionRequest(id: currentUserID, blockUserId: userID)
            
            ApiCallManager.shared.apiCall(request: request, apiType: .BLOCK_USER, responseType: BlockActionResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1{
                    
                    
                    self.fetchUserId()
                    
                }
                else if results.status == 0 {
                    
                    
                    self.showAlertPopupWithMessage(msg: results.messages)
                }
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
            }

            
        }
        
        
       
        
        
    }
    
    
    func apiCallToUnmute(userID:String){
        
        
        if let currentUserID = self.currentUserId{
            
            let request = MuteActionRequest(_user_id: currentUserID, _mute_user_id: userID)
            
            ApiCallManager.shared.apiCall(request: request, apiType: .MUTE_USER, responseType: MuteActionResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1{
                    
                    
                    self.fetchUserId()
                    
                }
                else if results.status == 0 {
                    
                    
                    self.showAlertPopupWithMessage(msg: results.messages)
                }
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
            }

            
        }
        
        
       
        
        
    }
    
    
    func fetchBlockAndMuteUserId(_apiType:APIType){
        
        if let currentUserID = self.currentUserId{
            
            let request  = GetBlockAndMuteUserRequest(_user_id: currentUserID, _page: 0)
            
            ApiCallManager.shared.apiCall(request: request, apiType: _apiType, responseType: GetBlockAndMuteResponse.self, requestMethod: .POST) { (results) in
                
                
                if results.status == 0 {
                    
                    self.arrayBlockUsers?.removeAll()
                    DispatchQueue.main.async {
                    
                    self.tableViewBlockUsers.reloadData()
                    
                    }
                    self.showAlertPopupWithMessage(msg: results.messages)
                    
                    
                }
                else if results.status == 1 {
                    
                    self.arrayBlockUsers = results.data
                    
                    DispatchQueue.main.async {
                    
                    self.tableViewBlockUsers.reloadData()
                    
                    }
                    
                }
                
                
                
            } failureHandler: { (error) in
                
                
                self.showErrorMessage(error: error)
                
                self.arrayBlockUsers?.removeAll()
                DispatchQueue.main.async {
                
                self.tableViewBlockUsers.reloadData()
                
                }
            }
            
            
        }
        
        
       

        
        
    }
    
    //MARK:- Tap gesture method
    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        let userObj = self.arrayBlockUsers![gesture.view!.tag]
        
        
        
        self.pushUserProfileScreen(userId: userObj.userid, currentUserId:self.currentUserId!)
        
        
        
    }
    
    
    
    //MARK:- UIButton action methods ----
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func unblockButtonAction(sender:UIButton){
        
        print(sender.tag)
        
       
        
        let userObj = self.arrayBlockUsers![sender.tag]

        if self.isBlockUserList{
            
        
            
            self.apiCallToUnblockUser(userID: userObj.userid)

        }
        else {
            

            self.apiCallToUnmute(userID: userObj.userid)
            
            
            
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
extension BlockAndMuteViewController:UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:CellBlockUser = tableView.dequeueReusableCell(withIdentifier: "CellBlockUser") as! CellBlockUser
        
        let userObj = self.arrayBlockUsers![indexPath.row]
        
        print("imageURL - \(userObj.profileImg)")
        
        
        cell.profilePictureImageView.sd_setImage(with: URL(string: "\(userObj.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
        
        cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
        
        cell.profilePictureImageView.tag = indexPath.row
        
        cell.profilePictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

        cell.unblockButton.tag = indexPath.row
        
        cell.unblockButton.addTarget(self, action: #selector(self.unblockButtonAction(sender:)), for: .touchUpInside)
        
     
        
        if self.isBlockUserList{
            
        
            
            cell.unblockButton.setTitle("Unblock", for: .normal)
            

        }
        else {
            
            cell.unblockButton.setTitle("Unmute", for: .normal)

            
            
            
        }
            
        
        cell.nameLabel.text = userObj.name.capitalized
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _arrayList = self.arrayBlockUsers{
        
            return  _arrayList.count
            
        }
        return 0
        
    }
    
}

