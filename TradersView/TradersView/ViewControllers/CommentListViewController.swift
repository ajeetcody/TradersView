//
//  CommentListViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 05/11/21.
//

import UIKit

class CellComment:UITableViewCell{
    
    
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    
}

class CommentListViewController: MasterViewController {
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentBaseView: UIView!
    
    @IBOutlet weak var tableViewComment: UITableView!
    
    
    private var arrayCommentList:[CommentListByPostIDDatum]?
    
    var postId:String?
    var notifyToUserOfPost:String?
    
    
    
    private var userID:String?
    
    
    //MARK:- UIViewcontroller lifecycle methods -----
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.commentTextView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 5.0)
        self.commentTextView.leftSpace()
        
        self.tableViewComment.isHidden = true
        
        if  let userData:LoginUserData = self.appDelegate.loginResponseData{
            
            
            self.userID = userData.id
            self.getCommentByPostId()
            
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "User Data is not available")
        }
        
    }
    
   
    
    //MARK:- API call methods -----
    
    
    func getCommentByPostId(){
        
        if let _postId = self.postId{
            
            
            let getCommentRequest = GetCommentByPostIdRequest(_user_id: self.userID!, _postid: _postId, _page: 0)
            
            ApiCallManager.shared.apiCall(request: getCommentRequest, apiType: .GET_COMMENT_BY_ID, responseType: CommentListByPostIDResponse.self, requestMethod: .POST) { (results) in
                
                if results.status == 1 {
                    
                    
                    if let commentList = results.data{
                        
                        
                        self.arrayCommentList = commentList
                        
                        DispatchQueue.main.async {
                            
                            self.tableViewComment.isHidden = false
                            self.tableViewComment.reloadData()
                            
                        }
                        
                    }
                    else{
                        
                        self.tableViewComment.isHidden = true
                        //self.showAlertPopupWithMessage(msg: results.messages)
                        
                        
                    }
                    
                    
                    
                }
                else{
                    
                   // self.showAlertPopupWithMessage(msg: results.messages)
                    
                    
                }
                
                
                
            } failureHandler: { (error) in
                
                
                self.showErrorMessage(error: error)
            }
            
            
            
            
        }
        else {
            
            self.showAlertPopupWithMessage(msg: "Post id not available")
            
            
        }
        
        
        
        
    }
    
    func likeCommentByUserId(commentID:String, notifyUserId:String, imgViewObj:UIImageView){
        
        
        if commentID.count == 0 {
            
            self.showAlertPopupWithMessage(msg: "Wrong comment ID")
            
            return
        }
        
        
        
        let requestLikeComment = LikeCommentRequest(_user_id: self.userID!, _notify_user_id: notifyUserId, _comment_id: commentID)
        
        ApiCallManager.shared.apiCall(request: requestLikeComment, apiType: .LIKE_COMMENT, responseType: LikeCommentActionResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1 {
                
                
                if results.isLike == 0 {
                    
                    print("Dislike comment action")
                    
                    DispatchQueue.main.async {
                    imgViewObj.image = UIImage(named: "like-empty")
                    }
                    
                }
                else {
                    
                    print("Like comment action")
                    
                    DispatchQueue.main.async {
                    
                        imgViewObj.image = UIImage(named: "like-filled")
                    }
                    
                    
                    
                }
                
                
            }
            else{
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
                
            }
            
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }
        
        
    }
    
    func addCommentByUserId(_commentStr:String, _notifyUserId:String, _postId:String){
        
        let request =  AddCommentRequest(_user_id: self.userID!, _notify_user_id: _notifyUserId, _post_id: _postId, _comment: _commentStr)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .ADD_COMMENT, responseType: AddCommentResponse.self, requestMethod: .POST) { (results) in
            
            
            if results.status == 1 {
                DispatchQueue.main.async {
                    
                
                self.commentTextView.text = ""
                self.commentTextView.resignFirstResponder()
                    
                }
                self.getCommentByPostId()
                    
                    
                
            }
            else {
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
            }
            
            
        } failureHandler: { (error) in
            
            
            self.showErrorMessage(error: error)
            
            
        }
        
    }
    
    
    
    //MARK:- Tap gesture action -----
    
    
    
    @objc func likeImageTapGestureAction(gesture: UITapGestureRecognizer) {
        
        print("\(gesture.view?.tag ?? 0)")
        
        let obj = self.arrayCommentList![gesture.view!.tag]
        
        self.likeCommentByUserId(commentID: obj.commentid, notifyUserId: obj.userID, imgViewObj: (gesture.view as! UIImageView))
        
        
    }
    
    
    @objc func userImageTapGestureAction(gesture: UITapGestureRecognizer) {
        
        print("\(gesture.view?.tag ?? 0)")

        let obj = self.arrayCommentList![gesture.view!.tag]

        
        self.pushUserProfileScreen(userId: obj.userID, currentUserId:self.userID!)
        
        
        
    }
    
    //MARK:- UIButton action methods ------
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        if self.commentTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 {

            return
            
        }
        
        
        if let _postId = self.postId, let _notifyUserId = self.notifyToUserOfPost{

            self.addCommentByUserId(_commentStr: self.commentTextView.text, _notifyUserId: _notifyUserId, _postId: _postId)
        
        }
        else{
            
            self.showAlertPopupWithMessage(msg: "Important data is not available")
            
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

extension CommentListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:CellComment = tableView.dequeueReusableCell(withIdentifier: "CellComment") as! CellComment
        
        let obj = self.arrayCommentList![indexPath.row]
        
        
        cell.userNamelabel.text = obj.name.capitalized
        cell.commentLabel.text = obj.comment
        cell.userProfileImageView.sd_setImage(with: URL(string: "\(obj.profileImg)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
        
        cell.likeImageView.tag = indexPath.row
        
        if obj.isLike == 0 {
            
            
            cell.likeImageView.image = UIImage(named: "like-empty")
            
        }
        else {
            
            
            cell.likeImageView.image = UIImage(named: "like-filled")
            
            
        }
        
        
        cell.userProfileImageView.tag = indexPath.row
        
        cell.likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.likeImageTapGestureAction(gesture:))))
        
        cell.userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.userImageTapGestureAction(gesture:))))
        
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _commentResult = self.arrayCommentList{
            
            return  _commentResult.count
            
        }
        return 0
        
    }
    
}
