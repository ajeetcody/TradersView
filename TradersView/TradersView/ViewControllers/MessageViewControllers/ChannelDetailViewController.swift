//
//  ChannelDetailViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 27/11/21.
//

import UIKit
import Firebase
import AVKit

class CollectionViewCellImage:UICollectionViewCell{
    
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    @IBOutlet weak var widthImage: NSLayoutConstraint!
}

class CollectionViewCellVideo:UICollectionViewCell{
    
    @IBOutlet weak var mediaVideoView: PlayerView!
    
    
}

class CellMember:UITableViewCell{
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var optionButtonLabel: UIButton!
    
}

class ChannelDetailViewController: MasterViewController {
    
    
    @IBOutlet weak var collectionViewMedia: UICollectionView!
    
    @IBOutlet weak var scrollViewPagination: UIScrollView!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var groupProfilePicture: UIImageView!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var leadingOptionSelectConsraints: NSLayoutConstraint!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var tableViewMemberList: UITableView!
    
    var totalSection = 0
    
    var groupNameString = ""
    var groupId = ""
    var currentPage = 0
    var chatType:ChatType = .PERSONAL
    var messageList:[Message] = []
    let xPoint = Constants.screenWidth/4
    
    var groupDetail:GroupDetailModel?
    var memberList:[ChatUserModel] = []
    fileprivate var chatUserList_VM = ChatUserListViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // self.coverImageView.roundUpCorners(UIRectCorner.bottomLeft, radius: 50.0)
        // self.coverImageView.roundUpCorners(UIRectCorner.bottomRight, radius: 50.0)
        
        self.groupProfilePicture.changeBorder(width: 3.0, borderColor: .lightGray, cornerRadius: 50.0)
        
        self.groupNameLabel.text = self.groupNameString
        
        self.fetchGroupDetails()
        
        self.collectionViewMedia.reloadData()
    }
    
    
    //MARK:- UIButton action methods ---------
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func memberOptionButtonAction(sender:UIButton){
        
        
        debugPrint("\(sender.tag)")
        self.showAlertCommingSoon()
        
        
    }
    
    
    
    
    @IBAction func optionButtonSelectAction(_ sender: Any) {
        
        
        
        debugPrint("\((sender as! UIButton).tag)")
        
        
        
        self.changeUIAfterSelectingOption(optionNumber: ((sender as! UIButton).tag))
        
    }
    
    
    //MARK:- UIChanges ----
    
    func changeUIAfterSelectingOption(optionNumber:Int){
        
        
        let selectedFont = UIFont.boldSystemFont(ofSize: 15.0)
        
        let deSelectFont = UIFont.systemFont(ofSize: 15.0)
        
        let selectedColor = UIColor.darkGray
        let deselectColor = UIColor.lightGray
        
        
        if optionNumber == 0 {
            
            self.memberButton.titleLabel?.font = selectedFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            self.memberButton.setTitleColor(selectedColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)
            
            
            
        }
        else if optionNumber == 1{
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = selectedFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(selectedColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)
            
        }
        else if optionNumber == 2{
            
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = selectedFont
            self.gifButton.titleLabel?.font = deSelectFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(selectedColor, for: .normal)
            self.gifButton.setTitleColor(deselectColor, for: .normal)
            
        }
        else if optionNumber == 3{
            
            self.memberButton.titleLabel?.font = deSelectFont
            self.mediaButton.titleLabel?.font = deSelectFont
            self.linkButton.titleLabel?.font = deSelectFont
            self.gifButton.titleLabel?.font = selectedFont
            
            
            self.memberButton.setTitleColor(deselectColor, for: .normal)
            self.mediaButton.setTitleColor(deselectColor, for: .normal)
            self.linkButton.setTitleColor(deselectColor, for: .normal)
            self.gifButton.setTitleColor(selectedColor, for: .normal)
            
        }
        
        
        
        self.scrollViewPagination.scrollTo(horizontalPage: optionNumber, verticalPage: 0, animated: true)
        
        
        UIView.animate(withDuration: 0.5) {
            
            self.leadingOptionSelectConsraints.constant = self.xPoint * CGFloat(optionNumber)
            
            
            
            //self.scrollViewPagination.contentOffset.x = CGFloat(self.currentPage) * Constants.screenWidth
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK:- Firebase realtime methods ----
    
    func fetchGroupDetails(){
        
        switch self.chatType {
        
        case .PERSONAL:
            
            print("Personal chat")
            break
        case .PUBLIC_GROUP:
            
            self.fetchPublicGroupDetails {
                
                //Handle response ---
                
                if let groupDetailObj = self.groupDetail{
                    
                    
                    print("Name - \(groupDetailObj.groupName)")
                    print("Admin - \(groupDetailObj.addminName)")
                   
                    self.groupProfilePicture.sd_setImage(with: URL(string: "\(groupDetailObj.profileImage)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))

                    
                    self.fetchMemberList()
                    
                }
                
                
            } errorHandler: { (error) in
                
                //Handle Error -----
                
            }
            
            
        case .PRIVATE_GROUP:
            
            self.fetchPrivateGroupDetails()
            
            
            
        case .CHANNEL:
            self.fetchChannelDetails {
                
                //Handle response ---
                
                if let groupDetailObj = self.groupDetail{
                    
                    
                    print("Name - \(groupDetailObj.groupName)")
                    print("Admin - \(groupDetailObj.addminName)")
                   
                    self.groupProfilePicture.sd_setImage(with: URL(string: "\(groupDetailObj.profileImage)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))

                    
                    self.fetchMemberList()
                    
                }
                
                
            } errorHandler: { (error) in
                
                //Handle Error -----
                
            }
            
            
            
        }
        
        
    }
    
    func fetchPublicGroupDetails(completionHandler:@escaping()->Void, errorHandler:@escaping(Error)->Void){
        
        
        self.ref.child("PublicGroupDetail").child(self.groupId).observe(DataEventType.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: dictResponse, options: .prettyPrinted)
                
                let groupObj = try JSONDecoder().decode(GroupDetailModel.self, from: jsonData)
                
                self.groupDetail = groupObj
                
                
                completionHandler()
                
                
            }
            catch let error{
                
                print("Error --- \(error)")
                
                errorHandler(error)
                
            }
            
            
            
        }
        
    }
    
    func fetchPrivateGroupDetails(){
        
        
    }
    
    func fetchChannelDetails(completionHandler:@escaping()->Void, errorHandler:@escaping(Error)->Void){
        
        
        self.ref.child("ChannelDetail").child(self.groupId).observe(DataEventType.value) { (snapshot) in
            
            let dictResponse:[String:Any] = snapshot.value as! [String : Any]
            
            print("\(#function)")
            print(dictResponse)
            
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: dictResponse, options: .prettyPrinted)
                
                let groupObj = try JSONDecoder().decode(GroupDetailModel.self, from: jsonData)
                
                self.groupDetail = groupObj
                
                
                completionHandler()
                
                
            }
            catch let error{
                
                print("Error --- \(error)")
                
                errorHandler(error)
                
            }
            
        }
        
    }
    
    
    func fetchMemberList(){
        
        
        self.chatUserList_VM.fetchChatUserList {
            
            
            
            let memberListIdsString = self.groupDetail?.groupIDS.map({ (idList) -> String in
                
                return idList.memberid
            })
            
            
            self.chatUserList_VM.chatUserList =   self.chatUserList_VM.chatUserList.filter { (chatUserModel) -> Bool in
                
                return (memberListIdsString?.contains(chatUserModel.userID))!
                
            }
            
            self.tableViewMemberList.isHidden = self.chatUserList_VM.chatUserList.count > 0 ?  false :  true
            
            self.tableViewMemberList.reloadData()
            
            
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

extension ChannelDetailViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width
        self.currentPage = Int(round(scrollView.contentOffset.x/width))
        print("CurrentPage:\(self.currentPage)")
        self.changeUIAfterSelectingOption(optionNumber: self.currentPage)
        
    }
    
}

extension ChannelDetailViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 100{
        
            return 100.0

        }
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 100{
        
            return self.chatUserList_VM.chatUserList.count
            
        }
        
        
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100{

            let cell:CellMember =  tableView.dequeueReusableCell(withIdentifier: "CellMember") as! CellMember

        let memberObj = self.chatUserList_VM.chatUserList[indexPath.row]
        
    
        cell.memberNameLabel.text = memberObj.username.capitalized
        cell.profileImageView.sd_setImage(with: URL(string: "\(memberObj.imageURL)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
        cell.profileImageView.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 55/2.0)
        cell.optionButtonLabel.tag = indexPath.row
            
            cell.optionButtonLabel.addTarget(self, action: #selector(memberOptionButtonAction), for: .touchUpInside)
            

        
        return cell
            
        }
        
        return UITableViewCell()
        
        
        
    }
    
}


extension ChannelDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        totalSection = self.messageList.count/3
        
        if self.messageList.count%3 != 0{
            
            totalSection = totalSection + 1
        }
        
        return totalSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let lastSectionIndex = totalSection - 1
        let reminder = self.messageList.count % 3
        
        if  reminder != 0 && lastSectionIndex == section {
            
            return reminder
        }
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let message:Message = self.messageList[indexPath.row]

        
        if message.message_type == "Image"{
            
            
            let cell:CollectionViewCellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellImage", for: indexPath as IndexPath) as! CollectionViewCellImage
            
            cell.widthImage.constant = Constants.screenWidth/3 - 10
            cell.heightImage.constant = Constants.screenWidth/3 - 10
            
            cell.mediaImageView.sd_setImage(with: URL(string: "\(message.message)"), placeholderImage: UIImage(named: Constants.DEFAULT_POST_IMAGE))
            
           
            
            
            return cell
            
        }
        else  if message.message_type == "Video"{
            
            let cell:CollectionViewCellVideo = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellVideo", for: indexPath as IndexPath) as! CollectionViewCellVideo
            
            
            let url = NSURL(string: message.message);
            let avPlayer = AVPlayer(url: url as! URL);
            cell.mediaVideoView?.playerLayer.player = avPlayer;
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          print("\(#function) - \(collectionView.tag)")
         
        return CGSize(width: Constants.screenWidth/3 - 4, height: Constants.screenWidth/3 - 4)
        
        
    }
    
    
    
}
