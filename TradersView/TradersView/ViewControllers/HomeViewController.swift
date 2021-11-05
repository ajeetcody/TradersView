//
//  HomeViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 01/11/21.
//

import UIKit
import SDWebImage

class CellPost:UITableViewCell{
    
    @IBOutlet weak var profilePicImageView: UIImageView!

    
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postCaptionLabel: UILabel!
   
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
   
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var heightPostImageView: NSLayoutConstraint!
    
    @IBOutlet weak var shareCountLabel: UILabel!
    
    
}

class CollectionViewCellMostPopular:UICollectionViewCell{
    
    @IBOutlet weak var popularImageView: UIImageView!
    
    
}


class CollectionViewCellTopProfile:UICollectionViewCell{
    
    @IBOutlet weak var topProfileImageView: UIImageView!
    @IBOutlet weak var topProfileNameLabel: UILabel!
    
    
}



class CellMostPopular:UITableViewCell{
    
    @IBOutlet weak var collectionViewMostPopular: UICollectionView!
    
    
}

class CellTopProfile:UITableViewCell{
    
    
    @IBOutlet weak var collectionViewTopProfile: UICollectionView!
    
    
}

class CellFeedAndCommunity:UITableViewCell{
    
    
    @IBOutlet weak var scrollViewFeedAndCommunity: UIScrollView!
    @IBOutlet weak var tableViewCommunity: UITableView!
    @IBOutlet weak var tableViewMyFeed: UITableView!

    
    
}

class HomeViewController: MasterViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    let sectionTitle:[String] = ["Most Popular", "Top Profile","Post"]
    
    var arrayPopular:[MostPopularDatum] = []
    var topProfile = ["Ajit", "Amit","Rakesh", "Ramesh", "Kapil", "chintoo", "Sourach", "Ravi"]
   
    var arrayCommunity: [CommunityResponseDatum] = []
    var arrayMyPost:[GetPostbyuseridDatum] = []
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewHome.estimatedRowHeight = 88.0
        self.tableViewHome.rowHeight = UITableView.automaticDimension
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.callAllApis()
        
    }
    
    func callAllApis(){
        
        self.apiCallMostPopular()
        
        self.apiCallTopProfile()
        
        self.apiCallCommunity()
        
        self.apiCallMyFeed()
        
        
        
    }
    func apiCallMostPopular(){
        
        
        
        
        ApiCallManager.shared.apiCall(request: ApiRequestModel(), apiType: .MOST_POPULAR, responseType: MostPopularResponse.self, requestMethod: .GET) { (results) in
            
            
            let response:MostPopularResponse = results
            
            if response.status == 0{
                
                
                self.showAlertPopupWithMessage(msg: response.messages)
                
            }
            else{
                
                if let popularList = response.data{
                    
                    self.arrayPopular = popularList
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.tableViewHome.reloadData()
                }
                
                
            }
            
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
        }
        
        
    }
    
    func apiCallTopProfile(){
        
        
       // ApiCallManager.shared.apiCall(request: ApiRequestModel(), apiType: .TOP_PROFILE, responseType: <#T##(Decodable & Encodable).Protocol#>, requestMethod: <#T##RequestMethod#>, compilationHandler: <#T##(Decodable & Encodable) -> Void#>, failureHandler: <#T##(Error) -> Void#>)
        
    }
    
    func apiCallCommunity(){
        
        
        if self.fetchCurrentUserData() == nil {
            
         return
            
        }
        
        
        let userData = self.fetchCurrentUserData()
        
        let request = CommunityRequest(_user_id: userData!.id, _page: 0)
        
        ApiCallManager.shared.apiCall(request: request, apiType: .COMMUNITY, responseType: CommunityResponse.self, requestMethod: .POST) { (results) in
            
            if results.status == 1{
                
                print("\(#function) - \(results.data?.count)")
                
                if let data = results.data{
                    
                    self.arrayCommunity = data
                    
                }
                else{
                    
                    self.arrayCommunity.removeAll()
                    
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.tableViewHome.reloadData()
                }
            }
            else {
                
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
                
            }
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
            
            
        }

        
        
        
    }
    
    func apiCallMyFeed(){
        
        
        if self.fetchCurrentUserData() == nil {
            
            return
            
        }
        
        
        let userData = self.fetchCurrentUserData()
        
        let request = PostListByUserIdRequest(_user_id: userData!.id, _page: 0)
        
        
        ApiCallManager.shared.apiCall(request: request, apiType: .GET_POST_BY_USER_ID, responseType: GetPostbyuserid.self, requestMethod: .POST) { (results) in
            
            
            if results.status == 1{
                
                
                if let data = results.data{
                    
                    self.arrayMyPost = data
                    
                }
                else{
                    
                    self.arrayMyPost.removeAll()
                    
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.tableViewHome.reloadData()
                }
            }
            else {
                
                
                self.showAlertPopupWithMessage(msg: results.messages)
                
                
            }
            
            
        } failureHandler: { (error) in
            
            self.showErrorMessage(error: error)
            
        }
        
    }
    
    @objc func likeImageViewTapGesture(gesture: UITapGestureRecognizer) {

        print("\(gesture.view?.tag)")
        print("\(gesture.view?.superview?.tag)")
        
        if gesture.view!.superview!.tag == 101{
        
            let postObj = self.arrayCommunity[gesture.view!.tag]
            print("post id - \(postObj.postid)")
            
        }
        else if gesture.view!.superview!.tag == 102{
            
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            print("post id - \(postObj.postid)")
        }
        
        
    }
    @objc func commentImageViewTapGesture(gesture: UITapGestureRecognizer) {

        
        print("\(gesture.view?.tag)")
        print("\(gesture.view?.superview?.tag)")

        
        var postID:String = ""
        
        
        if gesture.view!.superview!.tag == 101{
        
            let postObj = self.arrayCommunity[gesture.view!.tag]
            
            postID = postObj.postid
            print("post id - \(postObj.postid)")
            
        }
        else if gesture.view!.superview!.tag == 102{
            
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            postID = postObj.postid
            print("post id - \(postObj.postid)")
        }
        
        self.presentCommentScreen(postId: postID)
        
        
        
    }
    @objc func shareImageViewTapGesture(gesture: UITapGestureRecognizer) {

        
        
        print("\(gesture.view?.tag)")
        print("\(gesture.view?.superview?.tag)")
        
        if gesture.view!.superview!.tag == 101{
        
            let postObj = self.arrayCommunity[gesture.view!.tag]
            print("post id - \(postObj.postid)")
            
        }
        else if gesture.view!.superview!.tag == 102{
            
            
            let postObj = self.arrayMyPost[gesture.view!.tag]
            print("post id - \(postObj.postid)")
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
extension HomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView.tag == 100 {
            
            
            if indexPath.section == 0{
                
                return Constants.screenHeight / 4.0
                
            }
            else if indexPath.section == 1{
                
                
                return Constants.screenHeight / 6.0
            }
            else if indexPath.section == 2{
                
                
                return Constants.screenHeight
            }
            
            
        }
        else if tableView.tag == 101{
            
            return UITableView.automaticDimension
            
            
        }
        else if tableView.tag == 102{
            
            
            return UITableView.automaticDimension
            
        }
        
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           
                
                
                return 40.0
                
            

            
       
    }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
                
                let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 40))
                
                sectionHeaderView.backgroundColor = .white
                let headingLabel = UILabel(frame: CGRect(x: 15, y: 0, width: Constants.screenWidth, height: 40))
                
                headingLabel.text = self.sectionTitle[section]
                headingLabel.textColor = .black
                sectionHeaderView.addSubview(headingLabel)
                
                return sectionHeaderView
                
           
            
            
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            if tableView.tag == 100 {
                
                return self.sectionTitle.count
                
            }
            
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if tableView.tag == 101 {
                
                print("\(#function) - Community - \(self.arrayCommunity.count)")
                return  self.arrayCommunity.count
                
                
            }
            else if tableView.tag == 102 {
                
                print("\(#function) - My Post - \(self.arrayMyPost.count)")
                return  self.arrayMyPost.count
                
                
            }
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if tableView.tag == 100{
                
                
                
                if indexPath.section == 0 {
                    
                    
                    let cell:CellMostPopular = tableView.dequeueReusableCell(withIdentifier: "CellMostPopular") as! CellMostPopular
                    
                    cell.collectionViewMostPopular.tag = 101
                    cell.collectionViewMostPopular.delegate = self
                    cell.collectionViewMostPopular.dataSource = self
                    
                    cell.collectionViewMostPopular.reloadData()
                    
                    return cell
                    
                    
                    
                }
                else if indexPath.section == 1 {
                    
                    
                    
                    
                    let cell:CellTopProfile = tableView.dequeueReusableCell(withIdentifier: "CellTopProfile") as! CellTopProfile
                    cell.collectionViewTopProfile.tag = 102
                    cell.collectionViewTopProfile.delegate = self
                    cell.collectionViewTopProfile.dataSource = self
                    cell.collectionViewTopProfile.reloadData()
                    
                    return cell
                    
                    
                }
                else if indexPath.section == 2 {
                    
                    
                    let cell:CellFeedAndCommunity = tableView.dequeueReusableCell(withIdentifier: "CellFeedAndCommunity") as! CellFeedAndCommunity
                    
                    cell.tableViewCommunity.reloadData()
                    cell.tableViewMyFeed.reloadData()
                    
                    
                    
                    return cell
                    
                    
                }
                
            }
            else if tableView.tag == 101{
                
                let cell:CellPost = tableView.dequeueReusableCell(withIdentifier: "CellPostCommunity") as! CellPost
                
                let obj = self.arrayCommunity[indexPath.row]
                
                cell.nameLabel.text = obj.username
                cell.dateLabel.text = obj.date
                cell.profilePicImageView.sd_setImage(with: URL(string: "\(obj.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
                cell.postCaptionLabel.text = obj.message
                
                cell.heightPostImageView.constant = 0.0
                
                cell.likeCountLabel.text = obj.like
                cell.commentCountLabel.text = obj.comment
                cell.shareCountLabel.text = obj.share
                
                cell.likeImageView.tag = indexPath.row
                cell.commentImageView.tag = indexPath.row
                cell.shareImageView.tag = indexPath.row

                cell.likeImageView.superview!.tag = tableView.tag
                cell.commentImageView.superview!.tag = tableView.tag
                cell.shareImageView.superview!.tag = tableView.tag

                
                cell.likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTapGesture(gesture:))))
                cell.commentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.commentImageViewTapGesture(gesture:))))
                cell.shareImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareImageViewTapGesture(gesture:))))

                
                
                if obj.isLike != 0 {
                    
                    
                    cell.likeImageView.image = UIImage(named: "like-filled")
                }
                else{
                    
                    cell.likeImageView.image = UIImage(named: "like-empty")
                    
                }
                
                
                if let imgVideo = obj.imageVideo{
                    
                    let imgObj = imgVideo[0]
                    
                    let imgUrl = imgObj.image
                    
                    
                    cell.postImageView.sd_setImage(with: URL(string: "https://spsofttech.com/projects/treader/images/post/442601635179441.png"), placeholderImage: UIImage(named: ""))
                    cell.heightPostImageView.constant = 130.0
                    
                    
                }
                return cell
                
                
            }
            else if tableView.tag == 102{
                
                let cell:CellPost = tableView.dequeueReusableCell(withIdentifier: "CellPostMyFeed") as! CellPost
                
                
                
                let obj = self.arrayMyPost[indexPath.row]
                
                cell.nameLabel.text = obj.username
                cell.dateLabel.text = obj.date
                cell.profilePicImageView.sd_setImage(with: URL(string: "\(obj.profileImg)"), placeholderImage: UIImage(named: "placeholder.png"))
                cell.postCaptionLabel.text = obj.message
                
                cell.heightPostImageView.constant = 0.0
                
                cell.likeImageView.tag = indexPath.row
                cell.commentImageView.tag = indexPath.row
                cell.shareImageView.tag = indexPath.row
                
                cell.likeImageView.superview!.tag = tableView.tag
                cell.commentImageView.superview!.tag = tableView.tag
                cell.shareImageView.superview!.tag = tableView.tag

                cell.likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTapGesture(gesture:))))
                cell.commentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.commentImageViewTapGesture(gesture:))))
                cell.shareImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareImageViewTapGesture(gesture:))))

                
                
                if obj.isLike != 0 {
                    
                    
                    cell.likeImageView.image = UIImage(named: "like-filled")
                }
                else{
                    
                    cell.likeImageView.image = UIImage(named: "like-empty")
                    
                }
                if let imgVideo = obj.imageVideo{
                    
                    let imgObj = imgVideo[0]
                    
                    let imgUrl = imgObj.image
                    
                    cell.postImageView.sd_setImage(with: URL(string: "https://spsofttech.com/projects/treader/images/post/442601635179441.png"), placeholderImage: UIImage(named: ""))
                    cell.heightPostImageView.constant = 130.0
                    
                    
                }
                return cell
                
                
                
            }
            
            return UITableViewCell()
        }
        
        
    }
    
    


extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    
        
        return CGSize(width: Constants.screenWidth / 2.8, height: Constants.screenHeight/2.5)
        
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 35
        
    }
    
    //        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //            return 20
    //        }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 101{
            
            return self.arrayPopular.count
            
        }
        else if collectionView.tag == 102{
            
            return self.topProfile.count
            
        }
        
        return 10
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.tag == 101{
            
            
            let cell:CollectionViewCellMostPopular = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellMostPopular", for: indexPath as IndexPath) as! CollectionViewCellMostPopular
            
            
            let popular:MostPopularDatum = self.arrayPopular[indexPath.row]
            
            print(popular.image)
            cell.popularImageView.sd_setImage(with: URL(string: "\(popular.image)"), placeholderImage: UIImage(named: "placeholder.png"))
            
            cell.popularImageView.contentMode = .scaleAspectFit
            cell.popularImageView.changeBorder(width: 1.0, borderColor: .black, cornerRadius: 10.0)
            // popular.
            
            
            return cell
            
        }
        else if collectionView.tag == 102{
            
            let cell:CollectionViewCellTopProfile = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellTopProfile", for: indexPath as IndexPath) as! CollectionViewCellTopProfile
            
            cell.topProfileNameLabel.text  = self.topProfile[indexPath.row]
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            // cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
            // cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
            
            cell.backgroundColor = .systemPink
            
            print("fggfgfg")
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You selected cell #\(indexPath.item)!")
        
        
        
    }
}
