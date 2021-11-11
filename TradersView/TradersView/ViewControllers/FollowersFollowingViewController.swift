//
//  FollowersFollowingViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 07/11/21.
//

import UIKit

class CellFollowerFollowing:UITableViewCell{
    
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
}

class FollowersFollowingViewController: MasterViewController {
    
    @IBOutlet weak var tableViewFollowerList: UITableView!
    
    @IBOutlet weak var screenHeadingLabel: UILabel!
    
    var userId:String?
    private var currentUserId:String?
    
    var fetchFlag:String? = "0" // 0 = followers,  1 = following

    var arrayListResponse:[FollowersFollowingResponseDatum]?
    
    
    //MARK:- UIViewcontroller lifecycle methods ----
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        if let flag = self.fetchFlag{
            
            
            if flag == "0"{
                
                // - Remove operation (followers)
                
                self.screenHeadingLabel.text = "Followers"
                
            }
            else if flag == "1"{
                
                // - Unfollowe operation (following)
                
                
                self.screenHeadingLabel.text = "Following"
                
            }
            
            
            
        }
        else{
            
            self.screenHeadingLabel.text = ""

            
        }
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.currentUserId = userData.id
            
            self.fetchList()
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    //MARK:- Api call ---
    
    func apiCallRemoveFollower(userID:String){
        
        
        if let currentUserID = self.currentUserId{
            
            let request = RemoveFollowerRequest(_user_id: currentUserID, _follower_id: userID)
            
            ApiCallManager.shared.apiCall(request: request, apiType: .REMOVE_FOLLOWER, responseType: RemoveFollowerResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1{
                    
                    
                    self.fetchList()
                    
                }
                else if results.status == 0 {
                    
                    
                    self.showAlertPopupWithMessage(msg: results.messages)
                }
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
            }

            
        }
        
        
       
        
        
    }
    
    
    func apiCallUnFollow(userID:String){
        
        
        if let currentUserID = self.currentUserId{
            
            let request = FollowRequest(_user_id: currentUserID, _follow_id: userID)
            
            ApiCallManager.shared.apiCall(request: request, apiType: .FOLLOW, responseType: FollowResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1{
                    
                    
                    self.fetchList()
                    
                }
                else if results.status == 0 {
                    
                    
                    self.showAlertPopupWithMessage(msg: results.messages)
                }
                
            } failureHandler: { (error) in
                
                self.showErrorMessage(error: error)
            }

            
        }
        
        
       
        
        
    }
    
    
    func fetchList(){
        
        if let userID = self.userId, let flag = self.fetchFlag{
            
            let request  = FollowwersFollowingListRequest(_user_id: userID, _status: flag, _page: 0)
            
            ApiCallManager.shared.apiCall(request: request, apiType: .FOLLOW_LIST, responseType: FollowersFollowingResponse.self, requestMethod: .POST) { (results) in
                
                
                if results.status == 0 {
                    
                    
                    self.showAlertPopupWithMessage(msg: results.messages)
                    
                    
                }
                else if results.status == 1 {
                    
                    self.arrayListResponse = results.data
                    
                    DispatchQueue.main.async {
                    
                    self.tableViewFollowerList.reloadData()
                    
                    }
                    
                }
                
                
                
            } failureHandler: { (error) in
                
                
                self.showErrorMessage(error: error)
            }
            
            
        }
        
        
       

        
        
    }
    
    //MARK:- Tap gesture method
    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        let userObj = self.arrayListResponse![gesture.view!.tag]
        
        
        
        self.pushUserProfileScreen(userId: userObj.userid, currentUserId:self.currentUserId!)
        
        
        
    }
    
    
    
    //MARK:- UIButton action methods ----
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeButtonAction(sender:UIButton){
        
        print(sender.tag)
        
       
        
        let userObj = self.arrayListResponse![sender.tag]

        
        
        if let flag = self.fetchFlag{
            
            
            if flag == "0"{
                
                // - Remove operation (followers)
                
                self.apiCallRemoveFollower(userID:userObj.userid)
                
            }
            else if flag == "1"{
                
                // - Unfollowe operation (following)
                
                
                self.apiCallUnFollow(userID:userObj.userid)
                
                
            }
            
            
            
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
extension FollowersFollowingViewController:UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:CellFollowerFollowing = tableView.dequeueReusableCell(withIdentifier: "CellFollowerFollowing") as! CellFollowerFollowing
        
        let userObj = self.arrayListResponse![indexPath.row]
        
        print("imageURL - \(userObj.profileImg)")
        cell.profilePictureImageView.sd_setImage(with: URL(string: "\(userObj.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
        cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 65/2.0)
        
        cell.profilePictureImageView.tag = indexPath.row
        
        cell.profilePictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))

        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.removeButtonAction(sender:)), for: .touchUpInside)
        
        
        
        
        if self.userId != self.currentUserId{
            
            cell.removeButton.isHidden = true
            
            
        }
        else{
            
            cell.removeButton.isHidden = false
            
        }
        
        
        if let flag = self.fetchFlag{
            
            
            if flag == "0"{
                
                // - Remove operation (followers)
                
                cell.removeButton.setTitle("Remove", for: .normal)
            }
            else if flag == "1"{
                
                // - Unfollowe operation (following)
                
                cell.removeButton.setTitle("Unfollow", for: .normal)
            }
            
            
            
        }
        else{
            
            cell.removeButton.isHidden = true

            
        }
        
        
        
        cell.nameLabel.text = userObj.name.capitalized
        return cell
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _arrayList = self.arrayListResponse{
        
            return  _arrayList.count
            
        }
        return 0
        
    }
    
}
