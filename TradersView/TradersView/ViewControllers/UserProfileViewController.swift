//
//  UserProfileViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 06/11/21.
//

import UIKit

import SDWebImage
import Cosmos

class TradesCell:UITableViewCell{
    
    @IBOutlet weak var curruncyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    @IBOutlet weak var contentViewWithShadow: UIView!
    
    @IBOutlet weak var tradPriceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tradeProfitLabel: UILabel!
    
    @IBOutlet weak var stopLessLabel: UILabel!
    @IBOutlet weak var takeProfitButton: UIButton!
    
    @IBOutlet weak var starView: CosmosView!
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
}



class CellUserProfileDetails:UITableViewCell{
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var accuracyLabel: UILabel!
    
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    
    @IBOutlet weak var followingView: UIView!
    
    @IBOutlet weak var followersView: UIView!
    
    
    @IBOutlet weak var postLabel: UILabel!
    
    
    @IBOutlet weak var crownView: UIView!
    
    @IBOutlet weak var premiumButton: UIButton!
    
}
class UserProfileViewController: MasterViewController {
    
    
    @IBOutlet weak var favImageView: UIImageView!
    
    @IBOutlet weak var userNameHeaderLabel: UILabel!
    
    var userIDOfProfile:String = ""
    private var currentUserId:String = ""
    
    
    var arrayMyPost:[GetPostListByUserIdResponseDatum] = []
    var arrayMyTreds:[GetPostListByUserIdResponseDatum] = []
    
    
    var scrollViewIndicatorLabel: UILabel!
    var userProfileObj:GetProfileByIDDatum?
    
    private var myPostPageNumber:Int = 0
    
    private var shouldStopMyPostLoadMore:Bool = false
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableViewUserProfile: UITableView!
    
    //MARK:- UIViewcontroller lifecycle ---
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewUserProfile.estimatedRowHeight = 88.0
        self.tableViewUserProfile.rowHeight = UITableView.automaticDimension
        
        self.tableViewUserProfile.contentInset = .zero
        print("Current user id - \(self.currentUserId)")
        print("Profile id - \(self.userIDOfProfile)")
        
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData {
            
            if self.navigationController?.viewControllers.count == 1{
                
                self.currentUserId = userData.id
                self.userIDOfProfile = userData.id
                
                
            }
            else{
                
                self.currentUserId = userData.id
                
                
            }
            
            self.callApiToFetchUserProfile()
            self.apiCallMyPost()
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
        
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableViewUserProfile.addSubview(refreshControl) 
        
        
        self.apiCall()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableViewUserProfile.reloadData()
    }
    
    
    //MARK:- Refresh apiCall ----
    
    @objc func refresh(_ sender: AnyObject) {
        
        self.myPostPageNumber = 0
        
        self.apiCall()
        
        
    }
    
    func apiCall(){
        
        
        
        self.callApiToFetchUserProfile()
        self.apiCallMyPost()
        
        
        
        
    }
    
    //MARK:- UIButton action methods ---
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        
            self.pushScreenWithScreenName(screenName: "SearchViewController", currentUserId: self.currentUserId)
       
        
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        
        
            self.pushScreenWithScreenName(screenName: "NotificationViewController", currentUserId: self.currentUserId)
            
    }
    
    @objc func shareTradeButtonAction(sender:UIButton){
        
        self.showAlertCommingSoon()
        
        
    }
    
    @objc func backButtonAction(sender:UIButton){
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    //MARK:- API call methods -----
    
    
    func likePostApi(_notifyUserId:String, _postId:String, imgLike:UIImageView, countLabel:UILabel){
        
        
        let requestObj = LikePostRequest(_user_id: self.currentUserId, _notify_user_id: self.userIDOfProfile, _post_id: _postId)
        
        
        
        ApiCallManager.shared.apiCall(request: requestObj, apiType: .LIKE_POST, responseType: LikePostResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1 {
                print("like response - \(results.like)")
                
                
                
                self.changeLikeButtonIconAndCount(results: results, imgViewLike: imgLike, likeCountLabel: countLabel)
                
            }
            else{
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
                
            }
            
            
            
        } failureHandler: { (error) in
            
            
            self.showErrorMessage(error: error)
            
        }
        
        
        
    }
    func callApiToFetchUserProfile(){
        
        
        let request = GetprofileByIdRequest(_user_id: self.userIDOfProfile, _id: self.currentUserId)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .GET_PROFILE_BY_ID, responseType: GetProfileByIDResponse.self, requestMethod: .POST) { (results) in
            
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
            }
            
            
            if results.status == 1 {
                
                
                if let userData = results.data{
                    
                    self.userProfileObj = userData
                    
                    if (self.userIDOfProfile != self.currentUserId) {
                        
                        DispatchQueue.main.async {
                            self.favImageView.isHidden = false
                            
                        }
                        if (self.userProfileObj?.favouriteProfile == 1)
                        {
                            
                            DispatchQueue.main.async {
                                
                                self.favImageView.image = UIImage(named: "fav-profile-filled")
                            }
                            
                            
                        }
                        else {
                            DispatchQueue.main.async {
                                self.favImageView.image = UIImage(named: "fav-profile-empty")
                            }
                        }
                        
                    }
                    else{
                        DispatchQueue.main.async {
                            self.favImageView.isHidden = true
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.favImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favProfileTapGestureAction(gesture:))))
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.tableViewUserProfile.reloadData()
                        
                        // self.userNameHeaderLabel.text = userData.name?.capitalized
                        
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
            
            
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
            }
            self.showErrorMessage(error: error)
            
        }
        
        
        
    }
    
    func apiCallMyPost(){
        
        
        
        
        
        
        
        let request = GetPostListByUserIdRequest(_id: self.userIDOfProfile, _page: self.myPostPageNumber)
        
        print("self.myPostPageNumber - \(self.myPostPageNumber)")
        
        ApiCallManager.shared.apiCall(request: request, apiType: .GET_POST_BY_USER_ID, responseType: GetPostListByUserIdResponse.self, requestMethod: .POST) { (results) in
            
            
            
            
            if results.status == 1{
                
                
                if let data = results.data{
                    
                    if self.myPostPageNumber == 0 {
                        
                        self.shouldStopMyPostLoadMore = false
                        self.arrayMyPost = data
                    }
                    else{
                        
                        self.arrayMyPost.append(contentsOf: data)
                        
                    }
                    
                    
                    
                }
                
                
                DispatchQueue.main.async {
                    
                    print("post count - 1 - \(self.arrayMyPost.count)")
                    self.tableViewUserProfile.reloadData()
                    
                }
                
                
                
                
            }
            else {
                
                //                if self.myPostPageNumber == 0 {
                //
                //
                //
                //                    DispatchQueue.main.async {
                //                        self.tableViewUserProfile.reloadData()
                //                    }
                //                    self.showAlertPopupWithMessage(msg: results.messages)
                //
                //                }
                //                else{
                
                self.shouldStopMyPostLoadMore = true
                //}
                
            }
            
            
        } failureHandler: { (error) in
            
            
            self.showErrorMessage(error: error)
            
        }
        
        
        
    }
    
    //MARK:- UITapgesture ----
    
    @objc func likeImageViewTapGesture(gesture: UITapGestureRecognizer) {
        
        
        var postID:String = ""
        var notifyUserId:String = ""
        
        if gesture.view!.superview!.tag == 101{
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            postID = postObj.postid
            notifyUserId = postObj.userID
            
            print("post id - \(postObj.postid)")
            
        }
        
        
        let label = gesture.view!.superview!.subviews.compactMap({$0 as? UILabel})
        
        // print("label[0].text - \(label[0].text)")
        
        
        
        self.likePostApi(_notifyUserId: notifyUserId, _postId: postID, imgLike: (gesture.view as! UIImageView?)!,countLabel:label[0])
        
        
        
    }
    @objc func commentImageViewTapGesture(gesture: UITapGestureRecognizer) {
        
        
        var postID:String = ""
        var notifyUserId:String = ""
        
        
        if gesture.view!.superview!.tag == 101{
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            
            postID = postObj.postid
            notifyUserId = postObj.userID
            
            print("post id - \(postObj.postid)")
            
        }
        
        
        self.pushCommentScreen(postId: postID, notifyUserId: notifyUserId)
        
        
        
    }
    @objc func favProfileTapGestureAction(gesture: UITapGestureRecognizer){
        
        let request = FavProfileActionRequest(_id: self.currentUserId, _fav_id: self.userIDOfProfile)
        
        ApiCallManager.shared.apiCall(request: request, apiType: .FAV_PROFILE, responseType: FavProfileActionResponse.self, requestMethod: .POST) { (results) in
            
            
            if results.status == 0{
                
                self.showAlertPopupWithMessage(msg: results.messages)
            }
            else{
                
                self.callApiToFetchUserProfile()
            }
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }
        
        
        
    }
    @objc func shareImageViewTapGesture(gesture: UITapGestureRecognizer) {
        
        
        if gesture.view!.superview!.tag == 101{
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            print("post id - \(postObj.postid)")
            
        }
        
        
    }
    
    @objc func profilePicImageViewTapGesture(gesture:UITapGestureRecognizer){
        
        
        var profileUserId:String = ""
        
        
        if gesture.view!.superview!.tag == 101{
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            
            profileUserId = postObj.userID
            
            print("post id - \(postObj.postid)")
            
        }
        
        
        if profileUserId != self.userIDOfProfile{
            
            self.pushUserProfileScreen(userId: profileUserId, currentUserId:self.currentUserId)
            
            
        }
        
        
    }
    
    @objc func followersViewTapGesture(gesture:UITapGestureRecognizer){
        
        print("\(#function)")
        
        self.pushFollowerFollowingList(userId: self.currentUserId, currentUserId: self.userIDOfProfile, flag: "0")
        
        
    }
    
    @objc func followingViewTapGesture(gesture:UITapGestureRecognizer){
        
        print("\(#function)")
        
        self.pushFollowerFollowingList(userId: self.currentUserId, currentUserId: self.userIDOfProfile, flag: "1")
        
        
        
    }
    
    @objc func moreInfoButtonAction(_sender:UIButton){
        
        
        print("\(_sender.tag)")
        print("\(_sender.superview?.tag ?? 0)")
        self.showAlertCommingSoon()
        
        
    }
    
    @objc func followButtonAction(_sender:UIButton){
        
        
        
        let request = FollowRequest(_user_id: self.currentUserId, _follow_id: self.userIDOfProfile)
        
        ApiCallManager.shared.apiCall(request: request, apiType: .FOLLOW, responseType: FollowResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1{
                
                if results.messages == "Follow"{
                    
                    DispatchQueue.main.async {
                        
                        _sender.setTitle("Following", for: .normal)
                    }
                    
                    
                    
                }
                else if results.messages == "Unfollow"{
                    
                    DispatchQueue.main.async {
                        
                        _sender.setTitle("Follow", for: .normal)
                    }
                }
                self.callApiToFetchUserProfile()
                
            }
            else if results.status == 0 {
                
                
                self.showAlertPopupWithMessage(msg: results.messages)
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
extension UserProfileViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if section == 1 {
            
            return 40.0
        }
        
        return 0.0
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let sectionHeaderView = UIView(frame: CGRect(x: 20, y: 0, width: Constants.screenWidth - 40, height: 40))
        
        sectionHeaderView.backgroundColor = .clear
        let headingLabel = UILabel(frame: CGRect(x: 25, y: 0, width: Constants.screenWidth, height: 40))
        
        headingLabel.text = "POST"
        headingLabel.textColor = .black
        sectionHeaderView.addSubview(headingLabel)
        
        return sectionHeaderView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == 100 && self.userProfileObj != nil{
            
            return 2
            
        }
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 100 {
            
            
            if section == 0 {
                
                
                if self.userProfileObj != nil {
                    
                    return 1
                }
                
                return 0
            }
            else if section == 1 {
                
                
                return 1
                
                
            }
            
        }
        else if tableView.tag == 101 {
            
            print("\(#function) - arrayMyPost - \(self.arrayMyPost.count)")
            return  self.arrayMyPost.count
            
            
        }
        else if tableView.tag == 102 {
            
            print("\(#function) - arrayMyTreds - \(self.arrayMyTreds.count)")
            
            return 10
            //return  self.arrayMyTreds.count
            
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100{
            
            
            
            if indexPath.section == 0 {
                
                
                let cell:CellUserProfileDetails = tableView.dequeueReusableCell(withIdentifier: "CellUserProfileDetails") as! CellUserProfileDetails
                
                if self.currentUserId == self.userIDOfProfile {
                    
                    cell.followButton.isHidden = true
                }
                else{
                    
                    cell.followButton.isHidden = false
                    
                }
                
                if self.userProfileObj?.isFollow == 1 {
                    
                    cell.followButton.setTitle("Following", for: .normal)
                    
                }
                else {
                    
                    
                    cell.followButton.setTitle("Follow", for: .normal)
                    
                }
                
                cell.nameLabel.text = self.userProfileObj?.name?.capitalized
                
                cell.accuracyLabel.text = self.userProfileObj?.accuracy
                cell.followingLabel.text = self.userProfileObj?.following
                cell.followersLabel.text = self.userProfileObj?.followers
                cell.postLabel.text =  "\(self.userProfileObj?.post ?? 0)"
                
                
                
                
                
                cell.profileImageView.sd_setImage(with: URL(string: (self.userProfileObj?.profileImg)!), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
                
                cell.profileImageView.changeBorder(width: 2.0, borderColor: UIColor.init(hexString: "#474571"), cornerRadius: 45.0)
                
                cell.coverImageView.sd_setImage(with: URL(string: (self.userProfileObj?.coverImg)!), placeholderImage: UIImage(named: Constants.DEFAULT_POST_IMAGE))
                
                cell.coverImageView.contentMode = .scaleToFill
                
                
                cell.followersView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followersViewTapGesture(gesture:))))
                cell.followingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followingViewTapGesture(gesture:))))
                
                cell.followButton.addTarget(self, action: #selector(self.followButtonAction(_sender:)), for: .touchUpInside)
                
                
                cell.premiumButton.changeBorder(width: 0.0, borderColor: .clear, cornerRadius: 5.0)
                cell.crownView.changeBorder(width: 0, borderColor: .clear, cornerRadius: 20.0)
                
                if (self.navigationController?.viewControllers.count)! > 1 {
                    
                    
                    cell.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
                    
                    cell.backButton.isHidden = false
                }
                else{
                    
                    
                    cell.backButton.isHidden = true
                    
                }
                
                
                return cell
                
                
                
            }
            
            else if indexPath.section == 1 {
                
                
                let cell:CellFeedAndCommunity = tableView.dequeueReusableCell(withIdentifier: "CellFeedAndCommunity") as! CellFeedAndCommunity
                
                
                if self.arrayMyPost.count == 0 {
                    
                    cell.tableViewCommunity.isHidden = true
                }
                else{
                    
                    cell.tableViewCommunity.isHidden = false
                    
                }
                
                if self.arrayMyPost.count == 0 {
                    
                    cell.tableViewMyFeed.isHidden = true
                    
                }
                else{
                    
                    cell.tableViewMyFeed.isHidden = false
                    
                    
                }
                cell.tableViewCommunity.reloadData()
                cell.tableViewMyFeed.reloadData()
                
                cell.tableViewCommunity.estimatedRowHeight = 88.0
                cell.tableViewCommunity.rowHeight = UITableView.automaticDimension
                
                
                cell.tableViewMyFeed.estimatedRowHeight = 88.0
                cell.tableViewMyFeed.rowHeight = UITableView.automaticDimension
                
                
                
                return cell
                
                
            }
            
        }
        else if tableView.tag == 101{
            
            let cell:CellPost = tableView.dequeueReusableCell(withIdentifier: "CellMyPost") as! CellPost
            
            print("Row - \(indexPath.row)  array size - \(self.arrayMyPost.count)")
            
            
            if indexPath.row >= self.arrayMyPost.count{
                
                return UITableViewCell()
                
            }
            let obj = self.arrayMyPost[indexPath.row]
            
            cell.nameLabel.text = obj.username.capitalized
            cell.dateLabel.text = self.changeDateFormateToDisplay(dateString: obj.date)
            cell.profilePicImageView.sd_setImage(with: URL(string: "\(obj.profileImg)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.postCaptionLabel.text = obj.message
            
            cell.heightPostImageView.constant = 0.0
            
            cell.likeCountLabel.text = obj.like
            cell.commentCountLabel.text = obj.comment
            cell.shareCountLabel.text = obj.share
            
            cell.likeImageView.tag = indexPath.row
            cell.commentImageView.tag = indexPath.row
            cell.shareImageView.tag = indexPath.row
            cell.moreInfoButton.tag = indexPath.row
            
            
            
            cell.likeImageView.superview!.tag = tableView.tag
            cell.commentImageView.superview!.tag = tableView.tag
            cell.shareImageView.superview!.tag = tableView.tag
            cell.moreInfoButton.superview!.tag = tableView.tag
            
            cell.profilePicImageView.tag = indexPath.row
            
            cell.profilePicImageView.superview!.tag = tableView.tag
            
            cell.likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTapGesture(gesture:))))
            cell.commentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.commentImageViewTapGesture(gesture:))))
            cell.shareImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareImageViewTapGesture(gesture:))))
            
            cell.postImageView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 10.0)
            
            
            cell.profilePicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profilePicImageViewTapGesture(gesture:))))
            cell.moreInfoButton.addTarget(self, action: #selector(self.moreInfoButtonAction(_sender:)), for: .touchUpInside)
            
            
            print("Obj.like - \(obj.isLike)")
            if obj.isLike == 1 {
                
                
                cell.likeImageView.image = UIImage(named: "like-filled")
            }
            else{
                
                cell.likeImageView.image = UIImage(named: "like-empty")
                
            }
            
            
            if let imgVideo = obj.imageVideo{
                
                let imgObj = imgVideo[0]
                
                let imgUrl = imgObj.image
                
                // print("imgUrl - \(imgUrl)")
                
                switch imgUrl {
                case .integer(let intValue):
                    //  print("Integer value -- \(intValue)")
                    cell.heightPostImageView.constant = 0.0
                    
                    
                case .string(let strUrl):
                    // print("String value -- \(strUrl)")
                    
                    // cell.postImageView.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
                    cell.heightPostImageView.constant = Constants.screenWidth - 70

                    cell.postImageView.sd_setImage(with: URL(string: strUrl)) { (img, error, cacheType, url) in
                        
                        if img != nil{
                            
                            let ratio = img!.size.width / img!.size.height
                            let newHeight = (Constants.screenWidth - 80) / ratio
                            cell.heightPostImageView.constant = newHeight
                            self.view.layoutIfNeeded()
                            
                        }
                        else{
                            
                            cell.heightPostImageView.constant = 0.0
                            
                        }
                    }
                    
                }
                
                
                
            }
            else{
                
                cell.heightPostImageView.constant = 0.0
                
                
                
            }
            
            if self.arrayMyPost.count - 1 == indexPath.row{
                
                
                
                if !self.shouldStopMyPostLoadMore{
                    
                    self.myPostPageNumber = self.myPostPageNumber + 1
                    
                    
                    
                    self.apiCallMyPost()
                    
                    
                    
                    
                }
                
                
            }
            
            return cell
            
            
        }
        else if tableView.tag == 102{
            
            let cell:TradesCell = tableView.dequeueReusableCell(withIdentifier: "TradesCell") as! TradesCell
            
            cell.shareButton.addTarget(self, action: #selector(shareTradeButtonAction), for: .touchUpInside)
            
            
            
            cell.contentViewWithShadow.changeBorder(width: 0.0, borderColor: .darkGray, cornerRadius: 10.0)
            
            cell.contentViewWithShadow.dropShadow(opacity: 0.5, radius: 15.0)
            
            
            
            return cell
            
            
        }
        
        return UITableViewCell()
    }
    
    
    
    
}


