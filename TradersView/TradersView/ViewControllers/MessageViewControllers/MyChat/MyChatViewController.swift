//
//  MyChatViewController.swift
//  TradersView
//
//  Created by Ajeet Sharma on 21/11/21.
//

import UIKit
import AVKit
import Firebase
import FirebaseFirestore


class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}

class ChatTextRightCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: PaddingLabel!
    
    
}
class ChatTextLeftCell: UITableViewCell{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: PaddingLabel!
    
    
}
class ChatImageRightCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var imageChatImageView: UIImageView!
    
}
class ChatImageLeftCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var imageChatImageView: UIImageView!

    
}

class ChatVideoLeftCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    
}
class ChatVideoRightCell: UITableViewCell{
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var videoView: PlayerView!
    
}

struct MyChatScreenModel{
    
    var currentUserImageUrl:String = "https://spsofttech.com/projects/treader/images/dummy.png"

    var currentUserName:String = "Ajeet Sharma"
    var currentUserId:String = "318"
   
    var otherUserId:String = "319"
    var otherUserName:String = "NA"
    var isGroupChat:Bool = false

}

class MyChatViewController:  MasterViewController{


    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var textViewChat: UITextView!
    
    var chat_VM =  MyChatViewModel()
    
    var myChatScreenModelObj:MyChatScreenModel?
    
    //MARK:- UIViewcontroller delegate ----
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.fetchMessages()
        self.fetchNewAddedMessage()
        self.headingLabel.text = "Chat with \(myChatScreenModelObj!.otherUserName)"
        self.tableViewMessages.estimatedRowHeight = 80.0
        self.tableViewMessages.rowHeight = UITableView.automaticDimension
        self.textViewChat.changeBorder(width: 1.0, borderColor: .lightGray, cornerRadius: 5.0)
    }
    
    
    
    //MARK:- View model request for messages --
    
    func fetchMessages(){
        
        self.chat_VM.currentUserId = self.myChatScreenModelObj!.currentUserId
        self.chat_VM.otherUserId = self.myChatScreenModelObj!.otherUserId
        
        self.chat_VM.fetchAllMessages {
            
            
            self.tableViewMessages.reloadData()
            
            
            self.tableViewMessages.scrollToRow(at: IndexPath(row: self.chat_VM.messageList.count - 1, section: 0), at: .bottom, animated: true)
            debugPrint("Crash point ----")
            
        }
    }
    
    func fetchNewAddedMessage(){
        
        
//        self.chat_VM.currentUserId = self.myChatScreenModelObj!.currentUserId
//        self.chat_VM.otherUserId = self.myChatScreenModelObj!.otherUserId
//
//        self.chat_VM.fetchNewAddedMessage {
//
//
//            self.tableViewMessages.reloadData()
//
//
//        }
        
        
    }
    
    //MARK:- Image fetch actions ---
    
    
    
    //MARK:- Image url overriding ---
    
    
    override func sendFileURLAfterUpload(imgUrl: String, mediaType: MediaType) {
        
        print("img url - \(imgUrl)")
        print("media type - \(mediaType)")
        
        switch mediaType {
        case .VIDEO:
            self.sendMessaage(msg: imgUrl, messageType: "Video")

            
        case .IMAGE:
            self.sendMessaage(msg: imgUrl, messageType: "Image")

      
        }
    }
    
    

    
    
    //MARK:- UIButton action methods ------
    
    @IBAction func takePhotoVideoAction(_ sender: Any) {
        
        
        self.openCameraOptionActionsheet(shouldUploadOnFirebase: true, isVideo: true)
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
        if self.textViewChat.text.trimmingCharacters(in: .whitespaces).count != 0 {
            
            self.sendMessaage(msg: self.textViewChat.text, messageType: "text")
            self.textViewChat.text = ""
            
        }
    }
    
    
    
    func sendMessaage(msg:String, messageType:String){
        
        
        let date = Timestamp().dateValue()
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:MM:SS"
        
        
        
        let textMsg:[String:Any] = ["groupId":"This is not group", "message":msg, "message_type":messageType, "profile_image":self.myChatScreenModelObj!.currentUserImageUrl, "sender_id":self.myChatScreenModelObj!.currentUserId, "sender_user_name":self.myChatScreenModelObj!.currentUserName, "timestamp":dateFormatter.string(from: date)]
        
        self.chat_VM.messageToBeSend = textMsg
        
        
        self.chat_VM.sendChat()
        
        
    }
    
//    func fetchMessages(){
//        
//        
//        self.ref.child("UserMessage").child(self.currentUserId).child(otherUserId).queryOrderedByKey().observe(.value) { (snapshot) in
//            
//            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
//                
//                let totalUserKeysInchat = Array(dictResponse.keys)
//                self.messageList.removeAll()
//                print("Response -\(dictResponse)")
//                for key in totalUserKeysInchat{
//                    
//                    print(key)
//                    print(dictResponse[key])
//                    print("Crash point -1")
//                    
//                    let msg = Message(dictionary: dictResponse[key] as! [String : Any])
//                    
//                    //  print(msg?.message)
//                    print(dictResponse[key])
//                    
//                    self.messageList.append(msg!)
//                    
//                    
//                    
//                }
//                
//                self.tableViewMessages.reloadData()
//                
//                
//                
//                
//            }
//            
//        }
//        
//    }
    
    //MARK:- UIButton action methods ----
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
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


extension MyChatViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chat_VM.messageList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let msg = self.chat_VM.messageList[indexPath.row]
        if msg.message_type == "text" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatTextRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextRightCell") as! ChatTextRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)

            
            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatTextLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextLeftCell") as! ChatTextLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)

            return cell
        }
        else  if msg.message_type == "Image" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatImageRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageRightCell") as! ChatImageRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: Constants.DEFAULT_POST_IMAGE))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 8.0)


            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatImageLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageLeftCell") as! ChatImageLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: "addImagePlaceHolder.png"))
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 8.0)
            
            return cell
        }
        else  if msg.message_type == "Video" && msg.sender_id == self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatVideoRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoRightCell") as! ChatVideoRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            
           // cell.videoTitleLabel.text = "Sample Video" ;
            let url = NSURL(string: msg.message);
            let avPlayer = AVPlayer(url: url as! URL);
            cell.videoView?.playerLayer.player = avPlayer;


            return cell
        }
        else if msg.message_type == "Video" && msg.sender_id != self.myChatScreenModelObj?.currentUserId{
            
            let cell:ChatVideoLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoLeftCell") as! ChatVideoLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: Constants.DEFAULT_PROFILE_PIC))
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)
            
            let url = NSURL(string: msg.message);
            let avPlayer = AVPlayer(url: url! as URL);
            cell.videoView?.playerLayer.player = avPlayer;

            
            return cell
        }
        
        
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let videoCell = (tableView.cellForRow(at: indexPath) as? ChatVideoRightCell) else { return }
      //  let visibleCells = tableView.visibleCells
//        let minIndex = visibleCells.startIndex
    
        if videoCell.videoView.player?.timeControlStatus == AVPlayer.TimeControlStatus.playing{
            
            print("PAUSE")

            videoCell.videoView.player?.pause()
            videoCell.videoView.player?.seek(to: CMTime.zero)

        }
        else{
            print("PLAY")
            videoCell.videoView.player?.seek(to: CMTime.zero)

            videoCell.videoView.player?.play()
        }
    
    
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
        
    }
    
    
}
