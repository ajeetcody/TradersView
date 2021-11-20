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
class MyChatViewController:  MasterViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var currentUserImageUrl:String = "318"

    var currentUserName:String = "318"
    var currentUserId:String = "318"
    var otherUserId:String = "319"
    var otherUserName:String = "NA"
    
    var isGroupChat:Bool = false
    
    var messageList:[Message] = []
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var tableViewMessages: UITableView!
    var ref: DatabaseReference!
    
    @IBOutlet weak var textViewChat: UITextView!
    
    
    //MARK:- UIViewcontroller delegate ----
    
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        ref = Database.database().reference()
        self.fetchMessages()
        
        self.headingLabel.text = "Chat with \(otherUserName)"
        self.tableViewMessages.estimatedRowHeight = 80.0
        self.tableViewMessages.rowHeight = UITableView.automaticDimension

    }
    
    
    
    //MARK:- Image fetch actions ---
    
    
    
    func fetchImages(sourceType:UIImagePickerController.SourceType){
        
        let imgPickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            imgPickerController.sourceType = sourceType
            imgPickerController.allowsEditing = true
            imgPickerController.delegate = self
            imgPickerController.modalPresentationStyle = .fullScreen
            self.present(imgPickerController, animated: true, completion: nil)
            
        }
        
        else{
            
            self.showAlertPopupWithMessage(msg: sourceType == .camera ?  "Camera is not available" :  "Photo library is not available")
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("\(#function)")
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            
            self.uploadImageToStorageFirebase(img: image)
            
            //self.channelImageView.image = image
        }
        
        //print("Testtttt")
        picker.dismiss(animated: true, completion: nil);
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
        
        
        print("\(#function)")
    }
    
    //MARK:- UIButton action methods ------
    
    @IBAction func takePhotoVideoAction(_ sender: Any) {
        
        
        let actionSheet = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        
        let actionLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.fetchImages(sourceType: .photoLibrary)
            
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            
            self.fetchImages(sourceType: .camera)
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            debugPrint("Cancel the photo options")
            
            
        }
        
        
        actionSheet.addAction(actionLibrary)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
    
        if self.textViewChat.text.trimmingCharacters(in: .whitespaces).count != 0 {
            
            self.sendTextMessaage(msg: self.textViewChat.text)
            
        }
    }
    
    //MARK:- Firebase call ---
    
    func uploadImageToStorageFirebase(img:UIImage){
        
      //  let storageRef = FIRStorage.storage().reference().child("myImage.png")

        do {
            // Create file name
            let fileExtension = fileUrl.pathExtension
            let fileName = "testing123.\(fileExtension)"

            let storageReference = Storage.storage().reference().child("uploads2").child(fileName)
            let currentUploadTask = storageReference.putFile(from: fileUrl, metadata: metaData) { (storageMetaData, error) in
              if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
              }
                                                                                        
              // Show UIAlertController here
              print("Image file: \(fileName) is uploaded! View it at Firebase console!")
                                                                                        
              storageReference.downloadURL { (url, error) in
                if let error = error  {
                  printLog("Error on getting download url: \(error.localizedDescription)")
                  return
                }
                print("Download url of \(fileName) is \(url!.absoluteString)")
              }
            }
          } catch {
            print("Error on extracting data from url: \(error.localizedDescription)")
          }
        
        
    }
    
    func sendTextMessaage(msg:String){
        
        
        let date = Timestamp().dateValue()
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:MM:SS"
        
        
        let textMsg = ["groupId":"This is not group", "message":msg, "message_type":"text", "profile_image":self.currentUserImageUrl, "sender_id":self.currentUserId, "sender_user_name":self.currentUserName, "timpstamp":dateFormatter.string(from: date)]
        
        self.ref.child("UserMessage").child(self.currentUserId).child(self.otherUserId).setValue(textMsg)
        self.ref.child("UserMessage").child(self.otherUserId).child(self.currentUserId).setValue(textMsg)
        
        
    }
    
    func fetchMessages(){
        
        
        self.ref.child("UserMessage").child(self.currentUserId).child(otherUserId).queryOrderedByKey().observe(.value) { (snapshot) in
            
            if  let dictResponse:[String:Any] = snapshot.value as? [String : Any]{
                
                let totalUserKeysInchat = Array(dictResponse.keys)
                
                for key in totalUserKeysInchat{
                    
                     print(key)
                      print(dictResponse[key])
                    
                    let msg = Message(dictionary: dictResponse[key] as! [String : Any])
                    
                  //  print(msg?.message)
                    
                    self.messageList.append(msg!)
                    
                    
                    
                }
                
                self.tableViewMessages.reloadData()
                
                
                
                
            }
            
        }
        
    }
    
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
        
        return self.messageList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let msg = self.messageList[indexPath.row]
        if msg.message_type == "text" && msg.sender_id == self.currentUserId{
            
            let cell:ChatTextRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextRightCell") as! ChatTextRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)

            
            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.currentUserId{
            
            let cell:ChatTextLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTextLeftCell") as! ChatTextLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.messageLabel.text = msg.message
            cell.messageLabel.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 15.0)
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)

            return cell
        }
        else  if msg.message_type == "Image" && msg.sender_id == self.currentUserId{
            
            let cell:ChatImageRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageRightCell") as! ChatImageRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 20.0)


            return cell
        }
        else if msg.message_type == "text" && msg.sender_id != self.currentUserId{
            
            let cell:ChatImageLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatImageLeftCell") as! ChatImageLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.imageChatImageView.sd_setImage(with: URL(string: "\(msg.message)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))
            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemRed, cornerRadius: 12.5)
            cell.imageChatImageView.changeBorder(width: 1.0, borderColor: .darkGray, cornerRadius: 20.0)
            
            return cell
        }
        else  if msg.message_type == "Video" && msg.sender_id == self.currentUserId{
            
            let cell:ChatVideoRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoRightCell") as! ChatVideoRightCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: "placeHolderProfileImage.jpeg"))

            cell.profilePictureImageView.changeBorder(width: 1.0, borderColor: .systemGreen, cornerRadius: 12.5)
            
           // cell.videoTitleLabel.text = "Sample Video" ;
            let url = NSURL(string: msg.message);
            let avPlayer = AVPlayer(url: url as! URL);
            cell.videoView?.playerLayer.player = avPlayer;


            return cell
        }
        else if msg.message_type == "Video" && msg.sender_id != self.currentUserId{
            
            let cell:ChatVideoLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoLeftCell") as! ChatVideoLeftCell
            
            cell.dateLabel.text = msg.timpstamp
            cell.userNameLabel.text = msg.sender_user_name.capitalized
            cell.profilePictureImageView.sd_setImage(with: URL(string: "\(msg.profile_image)"), placeholderImage: UIImage(named: msg.message))
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
